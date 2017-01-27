subject = sort({'RS','DB','MP','GW','GR','SY','DS','EC','VS','LA','AE',...
    'SW','DK','LH','KM'});

for sub = 1:length(subject)
    
    % Load in data
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{sub}))
    load('virtsensV1.mat')
    
    %% Redefine to trial periods of interest
    % cfg = [];
    % cfg.toilim = [0.3 1.5];
    % post_grating = ft_redefinetrial(cfg,virtsensV1)
    %
    % cfg = [];
    % cfg.toilim = [-1.5 -0.3];
    % pre_grating = ft_redefinetrial(cfg,virtsensV1);
    %
    % post_grating_concat = horzcat(post_grating.trial{1,:});
    % pre_grating_concat = horzcat(pre_grating.trial{1,:});
    
    %% Produce TFR plot
    cfg = [];
    cfg.method = 'mtmconvol';
    cfg.output = 'pow';
    cfg.foi = 1:1:100;
    cfg.toi = -2.0:0.02:2.0;
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;
    cfg.tapsmofrq  = ones(length(cfg.foi),1).*8;
    multitaper = ft_freqanalysis(cfg, virtsensV1);
    
    cfg                 = [];
    cfg.baselinetype    = 'relative';
    cfg.ylim            = [30 100];
    cfg.baseline        = [-1.5 0];
    cfg.xlim            = [-0.5 1.5]
    figure; ft_singleplotTFR(cfg, multitaper);
    colormap(jet);
    xlabel('Time (sec)'); ylabel('Freq (Hz)');
    drawnow
    
    addpath('D://scripts//CFC')
    
    [MI_matrix] = calc_MI_ozkurt_test(virtsensV1,[0.0 1.5],[6 20],[30 80],'no')
    matrix_post = MI_matrix; %save matrix_post matrix_post;
    clear MI_matrix
    
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,matrix_post)
    shading interp
    colormap(jet)
    ylabel('Frequency (Hz)')
    xlabel('Phase (Hz)')
    title(sprintf('Comod post-grating Subject %s',subject{sub}))
    
    [MI_matrix] = calc_MI_ozkurt_test(virtsensV1,[-1.5 -0.0],[6 20],[30 80],'no')
    matrix_pre = MI_matrix; %save matrix_pre matrix_pre;
    
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,matrix_pre)
    shading interp
    colormap(jet)
    ylabel('Amplitude (Hz)')
    xlabel('Phase (Hz)')
    title(sprintf('Comod pre-grating Subject %s',subject{sub}))
    
    % Compare MI matrix for pre-grating to post-grating
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,comb)
    shading interp
    colormap(jet)
    ylabel('Frequency (Hz)')
    xlabel('Phase (Hz)')
    title(sprintf('%s',subject{sub}))
    colorbar
    %saveas(gcf,'comod_ozkurt_MI.png')
end

