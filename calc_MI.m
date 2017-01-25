%% Function to calculate MI from Fieldtrip data

% Inputs: 
% - virtsens = MEG data (1 channel)
% - toi = times of interest in seconds e.g. [0.3 1.5]
% - phases of interest e.g. [4 22] currently increasing in 1Hz steps
% - amplitudes of interest e.g. [30 80] currently increasing in 2Hz steps
% - diag = 'yes' or 'no' to turn on or off diagrams during computation

function [MI_matrix] = calc_MI(virtsens,toi,phase,amp,diag)

if diag == 'no'
    disp('NOT producing any images during the computation of MI')
end

% Determine size of final matrix
phase_length = length(phase(1):1:phase(2));
amp_length = length(amp(1):2:amp(2));

% Create matrix to hold comod
MI_matrix = zeros(amp_length,phase_length);
clear phase_length amp_length

row1 = 1;
row2 = 1;

for k = phase(1):1:phase(2) 
    for p = amp(1):2:amp(2) 
        %% Concatenate, bandpass filter the data and resegment
        % Concatenate all data
        virtsens_concat = horzcat(virtsens.trial{1,:});
        
        % Specifiy bandwith = +- 1/3 of center frequency
        Pf1 = k -(k/3); Pf2 = k +(k/3);
        Af1 = p -(p/3); Af2 = p +(p/3);
        
        % Filter concat data at phase frequency using Butterworth filter
        
        [PhaseFreq] = ft_preproc_bandpassfilter(virtsens_concat, 1000, [Pf1 Pf2]);
        
        % Filter concat data at amp frequency using Butterworth filter
        
        [AmpFreq] = ft_preproc_bandpassfilter(virtsens_concat, 1000, [Af1 Af2]);
        
        % Put the filtered data back into FT structure
        virtsens_amp = virtsens;
        count = 1;
        for d = 1:length(virtsens.trial)
            virtsens_amp.trial{1,d} = AmpFreq(count:count+(length(virtsens.trial{1,1})-1));
            count = count+length(virtsens.trial{1,1});
        end
        
        virtsens_phase = virtsens;
        count = 1;
        for d = 1:length(virtsens.trial)
            virtsens_phase.trial{1,d} = PhaseFreq(count:count+(length(virtsens.trial{1,1})-1));
            count = length(virtsens.trial{1,1});
        end
        
        % Cut out window of interest (phase)
        cfg = [];
        cfg.toilim = toi;
        cfg.showcallinfo = 'no';
        post_grating_phase = ft_redefinetrial(cfg,virtsens_phase);
        
        % Cut out window of interest (amp)
        cfg = [];
        cfg.toilim = toi;
        cfg.showcallinfo = 'no';
        post_grating_amp = ft_redefinetrial(cfg,virtsens_amp);
        
        % Variable to hold MI for all trials
        MI_comb = 0;
        
        % For median uncomment these lines
        %MI_array = [];
        %trial_count = 1;
        
        % For each trial...
        for trial_num = 1:length(virtsens.trial)
            
            % Extract phase and amp info using hilbert transform
            Phase=angle(hilbert(post_grating_phase.trial{1, trial_num}));
            Amp=abs(hilbert(post_grating_amp.trial{1, trial_num})); % getting the amplitude envelope
            
            nbin=18; % % we are breaking 0-360o in 18 bins, ie, each bin has 20o
            position=zeros(1,nbin); % this variable will get the beginning (not the center) of each bin (in rads)
            winsize = 2*pi/nbin;
            for j=1:nbin
                position(j) = -pi+(j-1)*winsize;
            end
            
            % now we compute the mean amplitude in each phase:
            MeanAmp=zeros(1,nbin);
            for j=1:nbin
                I = find(Phase <  position(j)+winsize & Phase >=  position(j));
                MeanAmp(j)=mean(Amp(I));
            end
            
            % so note that the center of each bin (for plotting purposes) is
            % position+winsize/2
            
            % at this point you might want to plot the result to see if there's any
            % amplitude modulation
            if strcmp(diag, 'yes')
                bar(10:20:720,[MeanAmp,MeanAmp]/sum(MeanAmp),'k')
                xlim([0 720])
                set(gca,'xtick',0:360:720)
                xlabel('Phase (Deg)')
                ylabel('Amplitude')
            end
            
            % and next you quantify the amount of amp modulation by means of a
            % normalized entropy index (Tort et al PNAS 2008):
            
            MI=(log(nbin)-(-sum((MeanAmp/sum(MeanAmp)).*log((MeanAmp/sum(MeanAmp))))))/log(nbin);
            
            % Add this value to all other all other values
            MI_comb = MI + MI_comb;
            % For median uncomment these lines
            %MI_array(trial_count) = MI;
            %trial_count = trial_count+1;
            
        end
        
        % Calculate average MI over trials
        MI_comb = MI_comb./length(virtsens.trial);
        
        % For median uncomment these lines
        %MI_median = median(MI_array); disp(MI_median)
        
        % Add to Matrix
        MI_matrix(row1,row2) = MI_comb;
        
        % Show progress of the comodulogram
        if strcmp(diag, 'yes')
            figure(2)
            pcolor(phase(1):1:phase(2),amp(1):2:amp(2),MI_matrix)
            colormap(jet)
            ylabel('Amplitude (Hz)')
            xlabel('Phase (Hz)')
            colorbar
            drawnow
        end

        % Go to next Amplitude
        row1 = row1 + 1;
        
        disp(sprintf('Phase: %d Amplitude: %d  MI: %d',k,p,MI_comb));
    end
    % Go to next Phase
    row1 = 1;
    row2 = row2 + 1;
end
end