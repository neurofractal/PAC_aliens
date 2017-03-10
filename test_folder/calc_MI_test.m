function [MeanAmpAllMean] = calc_MI_test(virtsens,toi,phase,amp)

%% Bandpass filter individual trials usign a two-way Butterworth Filter

% Specifiy bandwith = +- 1/3 of center frequency
Pf1 = round(phase -(phase/3)); Pf2 = round(phase +(phase/3));
Af1 = round(amp -(amp/3)); Af2 = round(amp +(amp/3));

% Filter data at phase frequency using Butterworth filter
cfg = [];
cfg.showcallinfo = 'no';
cfg.bpfilter = 'yes';
cfg.bpfreq = [Pf1 Pf2];
cfg.padding = 2;
[virtsens_phase] = ft_preprocessing(cfg, virtsens);

% Filter data at amp frequency using Butterworth filter
cfg = [];
cfg.showcallinfo = 'no';
cfg.bpfilter = 'yes';
cfg.bpfreq = [Af1 Af2];
cfg.padding = 2;
[virtsens_amp] = ft_preprocessing(cfg, virtsens);

% Cut out window of interest (phase) - should exlude phase-locked
% responses (e.g. ERPs)
cfg = [];
cfg.toilim = toi; %specfied in function calls
cfg.showcallinfo = 'no';
post_grating_phase = ft_redefinetrial(cfg,virtsens_phase);

% Cut out window of interest (amp) - should exlude phase-locked
% responses (e.g. ERPs)
cfg = [];
cfg.toilim = toi;
cfg.showcallinfo = 'no'; %specfied in function calls
post_grating_amp = ft_redefinetrial(cfg,virtsens_amp);

% Variable to hold distribution of amps over bins
MeanAmpAll = [];

% For each trial...
for trial_num = 1:length(virtsens.trial)
    
    % Extract phase and amp info using hilbert transform
    Phase=angle(hilbert(post_grating_phase.trial{1, trial_num})); % getting the phase
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
    
    MeanAmpAll(trial_num,:) = MeanAmp;
end

MeanAmpAllMean = mean(MeanAmpAll);
end