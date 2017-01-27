%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script calculates the peak gamma-band power in the post grating
% period from V1 Virtual Electrode defined using the HCP MMP1.0
%
% N.B. Make sure to run VE_for_PAC.m or use updated granger_visual_ASD.m
% script to obtain virtsensV1
%
% Written by Robert Seymour January 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject = sort({'RS','DB','MP','GW','GR','SY','DS','EC','VS','LA','AE','SW','DK','LH','FL'});

for i = 1:length(subject)
    
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC',subject{i}))
    try
        load('virtsensV1')
    catch
        disp(['Could not load virtsensV1 for subject ' num2str(subject{i})])
    end
    
    cfg = [];
    cfg.output       = 'pow';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 0:1:30;                         % analysis 1 to 30 Hz in steps of 1 Hz
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
    cfg.toi = [0.3:0.02:1.5];
    han_taper_post = ft_freqanalysis(cfg, virtsensV1);
    cfg.toi = [-1.5:0.02:-0.3];
    han_taper_pre = ft_freqanalysis(cfg, virtsensV1);
    
    % Calculate Difference
    han_taper_diff = han_taper_post.powspctrm - han_taper_pre.powspctrm;
    
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC',subject{i}));
    
    % Plot
    collapsed_time = mean(han_taper_diff,3);
    %collapsed_time = reshape(collapsed_time,[1,61]);
    figure;
    x = [1:1:30];plot(x,collapsed_time,'LineWidth',3);
    xlabel('Freq (Hz)');ylabel('Power'); title(subject{i});
    saveas(gcf,'alpha_peak.png')
    
    % Display Maximum Gamma Freq
    max_ABP = find(collapsed_time == min(collapsed_time(6:16)));
    disp(['Alpha Peak is at ' num2str(max_ABP) 'Hz for subject ' num2str(subject{i}) ]);
end