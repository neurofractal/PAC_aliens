subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE','SY','GW',...
    'SW','DK','LH','KM','FL','AN'});

combined_matrix_all = zeros(26,15);

for i = 1:length(subject)
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_post_canolty.mat'); load('matrix_pre_canolty.mat') 
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    %comb = (matrix_post - matrix_pre)
    
    combined_matrix_all = combined_matrix_all + comb;
end

combined_matrix_all= combined_matrix_all./ length(subject);

% combined_matrix_pre = zeros(26,15);
% clear i;
% 
% for i = 1:length(subject)
%     cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
%     load('matrix_pre.mat')
%     combined_matrix_pre = matrix_pre + combined_matrix_pre;
% end
% 
% combined_matrix_pre = combined_matrix_pre./ length(subject);
% 
% comb = (combined_matrix_post - combined_matrix_pre)./(combined_matrix_post + combined_matrix_pre);
% 
figure('color', 'w');
pcolor(6:1:20,30:2:80,combined_matrix_all);colorbar;shading interp;
colormap(jet); ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)')
title(sprintf('Group N = %d', length(subject))) 

%%
subject = {'0401','0402','0403','0404','0405','0406','0407','0409','0411',...
    '0413','0414','0415','0416'};%,'1401','1402','1403'};

combined_matrix_all = zeros(26,15);

for i = 1:length(subject)
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_post_canolty.mat'); load('matrix_pre_canolty.mat') 
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    %comb = (matrix_post - matrix_pre)
    
    combined_matrix_all = combined_matrix_all + comb;
end

figure('color', 'w');
pcolor(6:1:20,30:2:80,comb);colorbar;shading interp;
colormap(jet); ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)')
title(sprintf('ASD Group N = %d', length(subject))) 

%% Align to alpha peak freq
subject = sort({'RS','DB','MP','GW','GR','SY','DS','EC','VS','LA','AE','SW','DK','LH','FL','KM'});

alpha_peak = [];

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
    
    % Collapse Across Time
    collapsed_time = mean(han_taper_diff,3);
    
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC',subject{i}));
    
    % Display Peak (minimum) Alpha Freq
    max_ABP = find(collapsed_time == min(collapsed_time(7:14))); alpha_peak{i} = max_ABP;
    disp(['Alpha Peak is at ' num2str(max_ABP) 'Hz for subject ' num2str(subject{i}) ]);
end

% Now load PAC comodulograms aligning based on this peak freq

clear i; combined_matrix_post = zeros(26,11);

for i = 1:length(subject)
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_post.mat')
    matrix_post = matrix_post(:,alpha_peak{i}-6:alpha_peak{i}+4);
    combined_matrix_post = matrix_post + combined_matrix_post;
    
end

combined_matrix_pre = zeros(26,11);
clear i;

for i = 1:length(subject)
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_pre.mat')
    matrix_pre = matrix_pre(:,alpha_peak{i}-6:alpha_peak{i}+4);
    combined_matrix_pre = matrix_pre + combined_matrix_pre;
end

comb = (combined_matrix_post./combined_matrix_pre);% + combined_matrix_pre)./(combined_matrix_post - combined_matrix_pre);

figure('color', 'w');
pcolor(-4:1:6,30:2:80,comb);colorbar;shading interp;
colormap(jet); ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)')
title(sprintf('Contol Group N = %d', length(subject))) 
