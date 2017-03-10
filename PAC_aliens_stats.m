%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This scripts performs statistical analyis on the matrix of modulation 
% index (MI) values computed for PAC analysis on RS alien data.
%
% The script loads matrix_post (grating) adds the necessary info to make 
% into a FT data structure and adds to a meta-matrix. This is repeated for
% the matrix_pre (grating) data computed earlier.
%
% Group statistics are then computed using cluster-based permutation tests 
% based on the Montercarlo method (Maris & Oostenveld, 2007).

% Written by Robert Seymour (ABC) - January 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE',...
%     'SW','DK','LH','KM','AN','GW','SY','FL'});

 subject = {'0401','0402','0403','0404','0405','0406','0407','0409','0411',...
      '0413','0414','0415','0416','0417'};
 
grandavgA = [];

for i =1:length(subject)
    % cd to PAC directory
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}))
    % load matrix_post
    load('matrix_post.mat');
    % Add FT-related data structure information
    MI_post = [];
    MI_post.label = {'MI'};
    MI_post.dimord = 'chan_freq_time';
    MI_post.freq = [30:2:80];
    MI_post.time = [6:1:20];
    MI_post.powspctrm = [matrix_post];
    MI_post.powspctrm = reshape(MI_post.powspctrm,[1,26,15]);
    % Add to meta-matrix
    grandavgA{i} = MI_post;
end

grandavgB = [];

% Repeat for matrix_pre
for i =1:length(subject)
    % cd to PAC directory
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}))
    % load matrix_pre
    load('matrix_pre.mat');
    % Add FT-related data structure information
    MI_pre = [];
    MI_pre.label = {'MI'};
    MI_pre.dimord = 'chan_freq_time';
    MI_pre.freq = [30:2:80];
    MI_pre.time = [6:1:20];
    MI_pre.powspctrm = [matrix_pre];
    MI_pre.powspctrm = reshape(MI_pre.powspctrm,[1,26,15]);
    % Add to meta-matrix
    grandavgB{i} = MI_pre;
end

%% Perform Stats
cfg=[];
cfg.latency = 'all';
cfg.frequency = 'all';
cfg.dim         = grandavgA{1}.dimord;
cfg.method      = 'montecarlo';
cfg.statistic   = 'ft_statfun_depsamplesT';
cfg.parameter   = 'powspctrm';
cfg.correctm    = 'cluster';
cfg.computecritval = 'yes'
cfg.numrandomization = 1000;
cfg.alpha       = 0.05; % Set alpha level
cfg.clusteralpha = 0.05;
cfg.tail        = 1;    % Two sided testing

% Design Matrix
nsubj=numel(grandavgA);
cfg.design(1,:) = [1:nsubj 1:nsubj];
cfg.design(2,:) = [ones(1,nsubj) ones(1,nsubj)*2];
cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
cfg.ivar        = 2; % row of design matrix that contains independent variable (the conditions)

stat = ft_freqstatistics(cfg,grandavgA{:}, grandavgB{:});

%% Compute group difference between matrix_post and matrix_pre
cfg = [];
post_MI = ft_freqgrandaverage(cfg,grandavgA{:})
pre_MI = ft_freqgrandaverage(cfg,grandavgB{:})

cfg = [];
cfg.parameter = 'powspctrm';
cfg.operation = 'subtract';
diff_MI = ft_math(cfg,post_MI,pre_MI)

cfg = [];
cfg.zlim = 'maxabs';
cfg.ylim = [30 80];
cfg.xlim    = [6 16];
ft_singleplotTFR(cfg,diff_MI); colormap(jet);

%% Display results of stats (more work needed)
cfg=[];
cfg.parameter = 'stat';
cfg.maskparameter = 'mask';
cfg.maskstyle     = 'outline';
cfg.zlim = [-4 5];
cfg.ylim = [30 80];
cfg.xlim    = [6 14];
% cfg.ylim = [30 100]
fig = figure; 
ft_singleplotTFR(cfg,stat); colormap('jet');
xlabel('Phase (Hz)'); ylabel('Amplitude (Hz)');

%% Make a nicer figure

% Reshape the necessary data
stats_reshaped = reshape(stat.stat,[26 15]);
mask_reshaped = reshape(stat.mask,[26 15]);
v = [1];

% Create the figure
figure('color', 'w');
pcolor(6:1:16,30:2:80,stats_reshaped(:,1:11)); % colormap
caxis([-4 5]) %threshold
shading interp; colormap(jet);hold on; colorbar; %shading, colorbar
contour(6:1:16,30:2:80,mask_reshaped(:,1:11),v,'--','Color','black','LineWidth',3) %stats mask
ylabel('Frequency (Hz)'); xlabel('Phase (Hz)') %axis labels




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Between Groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE',...
     'SW','DK','LH','KM','AN','GW','SY','FL'});

grandavg_pilot_data = [];

for i =1:length(subject)
    % cd to PAC directory
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
    % load matrix_post
    load('matrix_post.mat'); load('matrix_pre.mat');
    
    post_minus_pre = matrix_post - matrix_pre;

    % Add FT-related data structure information
    MI = [];
    MI.label = {'MI'};
    MI.dimord = 'chan_freq_time';
    MI.freq = [30:2:80];
    MI.time = [6:1:20];
    MI.powspctrm = [post_minus_pre];
    MI.powspctrm = reshape(MI.powspctrm,[1,26,15]);
    % Add to meta-matrix
    grandavg_pilot_data{i} = MI;
end

clear subject

 subject = {'0401','0402','0403','0404','0405','0406','0407','0409','0411',...
     '0413','0414','0415','0416'};
 
 grandavg_ASD = [];

for i =1:length(subject)
    % cd to PAC directory
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}))
    % load matrix_post
    load('matrix_post.mat'); load('matrix_pre.mat');
    
    post_minus_pre = matrix_post - matrix_pre;

    % Add FT-related data structure information
    MI = [];
    MI.label = {'MI'};
    MI.dimord = 'chan_freq_time';
    MI.freq = [30:2:80];
    MI.time = [6:1:20];
    MI.powspctrm = [post_minus_pre];
    MI.powspctrm = reshape(MI.powspctrm,[1,26,15]);
    % Add to meta-matrix
    grandavg_ASD{i} = MI;
end

cfg = [];
post_MI = ft_freqgrandaverage(cfg,grandavg_pilot_data{:})
pre_MI = ft_freqgrandaverage(cfg,grandavg_ASD{:})

cfg = [];
cfg.parameter = 'powspctrm';
cfg.operation = 'subtract';
diff_MI = ft_math(cfg,post_MI,pre_MI)

cfg = [];
cfg.zlim = 'maxabs';
cfg.ylim = [30 80];
cfg.xlim    = [6 16];
ft_singleplotTFR(cfg,diff_MI); colormap(jet);

%% Stats 
cfg=[];
cfg.latency = 'all';
cfg.frequency = 'all';
cfg.dim         = grandavg_ASD{1}.dimord;
cfg.method      = 'montecarlo';
cfg.statistic   = 'ft_statfun_indepsamplesT';
cfg.parameter   = 'powspctrm';
cfg.correctm    = 'cluster';
cfg.computecritval = 'yes'
cfg.numrandomization = 1000;
cfg.alpha       = 0.1; % Set alpha level
cfg.clusteralpha = 0.05;
cfg.tail        = 1;    % Two sided testing

% Design Matrix
nsubj_ASD=numel(grandavg_ASD); nsubj_ASD_Data = numel(grandavg_pilot_data);
cfg.design(1,:) = [1:nsubj_ASD_Data 1:nsubj_ASD];
cfg.design(2,:) = [ones(1,nsubj_ASD_Data) ones(1,nsubj_ASD)*2];
%cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
cfg.ivar        = 2; % row of design matrix that contains independent variable (the conditions)

stat = ft_freqstatistics(cfg,grandavg_pilot_data{:}, grandavg_ASD{:});

% Display stats

cfg=[];
cfg.parameter = 'stat';
cfg.maskparameter = 'mask';
cfg.maskstyle     = 'outline';
%cfg.zlim = 'maxabs';
cfg.ylim = [30 80];
cfg.xlim    = [6 16];
% cfg.ylim = [30 100]
figure;
ft_singleplotTFR(cfg,stat); colormap('jet');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Bootstrap

num_bootstraps = 100; p_value_cluster = [];

for j =1:num_bootstraps
    
    subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE',...
        'SW','DK','LH','KM','AN','GW','SY','FL'});
    
    subject = subject(randi(17,14,1));
    
    grandavgA = [];
    
    for i =1:length(subject)
        % cd to PAC directory
        cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
        % load matrix_post
        load('matrix_post.mat');
        % Add FT-related data structure information
        MI_post = [];
        MI_post.label = {'MI'};
        MI_post.dimord = 'chan_freq_time';
        MI_post.freq = [30:2:80];
        MI_post.time = [6:1:20];
        MI_post.powspctrm = [matrix_post];
        MI_post.powspctrm = reshape(MI_post.powspctrm,[1,26,15]);
        % Add to meta-matrix
        grandavgA{i} = MI_post;
    end
    
    grandavgB = [];
    
    % Repeat for matrix_pre
    for i =1:length(subject)
        % cd to PAC directory
        cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
        % load matrix_pre
        load('matrix_pre.mat');
        % Add FT-related data structure information
        MI_pre = [];
        MI_pre.label = {'MI'};
        MI_pre.dimord = 'chan_freq_time';
        MI_pre.freq = [30:2:80];
        MI_pre.time = [6:1:20];
        MI_pre.powspctrm = [matrix_pre];
        MI_pre.powspctrm = reshape(MI_pre.powspctrm,[1,26,15]);
        % Add to meta-matrix
        grandavgB{i} = MI_pre;
    end
    
    %% Perform Stats
    cfg=[];
    cfg.latency = 'all';
    cfg.frequency = 'all';
    cfg.dim         = grandavgA{1}.dimord;
    cfg.method      = 'montecarlo';
    cfg.statistic   = 'ft_statfun_depsamplesT';
    cfg.parameter   = 'powspctrm';
    cfg.correctm    = 'cluster';
    cfg.computecritval = 'yes'
    cfg.numrandomization = 1000;
    cfg.alpha       = 0.05; % Set alpha level
    cfg.clusteralpha = 0.05;
    cfg.tail        = 1;    % Two sided testing
    
    % Design Matrix
    nsubj=numel(grandavgA);
    cfg.design(1,:) = [1:nsubj 1:nsubj];
    cfg.design(2,:) = [ones(1,nsubj) ones(1,nsubj)*2];
    cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
    cfg.ivar        = 2; % row of design matrix that contains independent variable (the conditions)
    
    stat = ft_freqstatistics(cfg,grandavgA{:}, grandavgB{:});
    
    p_value_cluster{j} = stat.posclusters(1).prob;
    
    %% Make a nicer figure
    
%     % Reshape the necessary data
%     stats_reshaped = reshape(stat.stat,[26 15]);
%     mask_reshaped = reshape(stat.mask,[26 15]);
%     v = [1];
%     
%     % Create the figure
%     figure('color', 'w');
%     pcolor(6:1:16,30:2:80,stats_reshaped(:,1:11)); % colormap
%     caxis([-4 5]) %threshold
%     shading interp; colormap(jet);hold on; colorbar; %shading, colorbar
%     contour(6:1:16,30:2:80,mask_reshaped(:,1:11),v,'--','Color','black','LineWidth',3) %stats mask
%     ylabel('Frequency (Hz)'); xlabel('Phase (Hz)') %axis labels
%     drawnow;
end

