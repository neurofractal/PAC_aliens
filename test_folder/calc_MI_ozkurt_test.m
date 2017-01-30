%% Function to calculate PAC from Fieldtrip data using (Özkurt & Schnitzler)

%% THIS IS A TEST FUNCTION WHERE I TRY OUT VARIOUS THINGS - DO NOT USE THIS
%% FOR ANY ANALYSIS OR COMPUTATIO OF PAC. 

% Inputs: 
% - virtsens = MEG data (1 channel)
% - toi = times of interest in seconds e.g. [0.3 1.5]
% - phases of interest e.g. [4 22] currently increasing in 1Hz steps
% - amplitudes of interest e.g. [30 80] currently increasing in 2Hz steps
% - diag = 'yes' or 'no' to turn on or off diagrams during computation

% For details of the PAC method go to: https://goo.gl/xONGEs

function [MI_matrix] = calc_MI_ozkurt_test(virtsens,toi,phase,amp,diag)

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
        %% Bandpass filter the data and resegment
        
        % Specifiy bandwith = +- 1/3 of center frequency
        Pf1 = round(k -(k/3)); Pf2 = round(k +(k/3));
        Af1 = round(p -(p/3)); Af2 = round(p +(p/3));
        
%         % Filter concat data at phase frequency using Butterworth filter
%         
%         [PhaseFreq] = ft_preproc_bandpassfilter(virtsens_concat, 1000, [Pf1 Pf2]);
%         
%         % Filter concat data at amp frequency using Butterworth filter
%         
%         [AmpFreq] = ft_preproc_bandpassfilter(virtsens_concat, 1000, [Af1 Af2]);
        
        % Filter concat data at phase frequency using Butterworth filter
        cfg = [];
        cfg.feedback = 'none';
        cfg.showcallinfo = 'no';
        cfg.bpfilter = 'yes';
        cfg.bpfreq = [Pf1 Pf2];
        cfg.padding = 2;
        [virtsens_phase] = ft_preprocessing(cfg, virtsens);
        
        % Filter concat data at amp frequency using Butterworth filter
        
        cfg = [];
        cfg.feedback = 'none';
        cfg.showcallinfo = 'no';
        cfg.bpfilter = 'yes';
        cfg.bpfreq = [Af1 Af2];
        cfg.padding = 2;
        [virtsens_amp] = ft_preprocessing(cfg, virtsens);
        
%         % Put the filtered data back into FT structure
%         virtsens_amp = virtsens;
%         count = 1;
%         for d = 1:length(virtsens.trial)
%             virtsens_amp.trial{1,d} = AmpFreq(count:count+(length(virtsens.trial{1,1})-1));
%             count = count+length(virtsens.trial{1,1});
%         end
%         
%         virtsens_phase = virtsens;
%         count = 1;
%         for d = 1:length(virtsens.trial)
%             virtsens_phase.trial{1,d} = PhaseFreq(count:count+(length(virtsens.trial{1,1})-1));
%             count = length(virtsens.trial{1,1});
%         end
        
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
            
            % Calculate PAC value using the formula from Özkurt paper.
            % Function for this is modulation_index_ozkurt_nostats
            
            [m_raw1 m_raw2] = modulation_index_ozkurt_nostats(Amp, Phase);
            MI = m_raw2; % m_raw2 is the Özkurt method
            
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