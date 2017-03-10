%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Script to compute PAC comodulograms for the pre and post grating period,
% using V1 VE data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Specify Subjects
subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE','SY','GW',...
    'SW','DK','LH','KM','FL','AN'});

% subject = {'0401','0402','0403','0404','0405','0406','0407','0409','0411',...
%     '0413','0414','0415','0416'};

%% Start loop for all subjects
for sub = 1:length(subject)
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Tort et al., (2008)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Load in data
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{sub}))
    load('VE_V1.mat');
    
    % Add path to PAC functions
    addpath('D://scripts//PAC_aliens')

    %% Get comod for post grating (0.3 to 1.5s) period
    [MI_matrix] = calc_MI(VE_V1,[0.3 1.5],[6 20],[30 80],'no');
    matrix_post = MI_matrix; save matrix_post matrix_post; clear MI_matrix  

    % Get comod for pre grating (-1.5 to -0.3s) period
    [MI_matrix] = calc_MI(VE_V1,[-1.5 -0.3],[6 20],[30 80],'no')
    matrix_pre = MI_matrix; save matrix_pre matrix_pre;
    
    % Compare MI matrix for pre-grating to post-grating
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    % Plot and save
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,comb)
    shading interp; colormap(jet)
    ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
    title(sprintf('%s Tort',subject{sub}))
    colorbar
    saveas(gcf,'comod_tort_MI.png')
    
    clear MI_matrix matrix_post matrix_pre comb
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ozkurt et al., (2010)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [MI_matrix] = calc_MI_ozkurt(VE_V1,[0.3 1.5],[6 20],[30 80],'no');
    matrix_post = MI_matrix; save matrix_post_ozkurt matrix_post; clear MI_matrix  

    % Get comod for pre grating (-1.5 to -0.3s) period
    [MI_matrix] = calc_MI_ozkurt(VE_V1,[-1.5 -0.3],[6 20],[30 80],'no')
    matrix_pre = MI_matrix; save matrix_pre_ozkurt matrix_pre;  
    
    % Compare MI matrix for pre-grating to post-grating
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    % Plot and save
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,comb)
    shading interp; colormap(jet)
    ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
    title(sprintf('%s Ozkurt',subject{sub}))
    colorbar
    saveas(gcf,'comod_ozkurt_MI.png')
    
    clear MI_matrix matrix_post matrix_pre comb
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Canolty et al., (2006)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [MI_matrix] = calc_MI_canolty(VE_V1,[0.3 1.5],[6 20],[30 80],'no');
    matrix_post = MI_matrix; save matrix_post_canolty matrix_post; clear MI_matrix  

    % Get comod for pre grating (-1.5 to -0.3s) period
    [MI_matrix] = calc_MI_canolty(VE_V1,[-1.5 -0.3],[6 20],[30 80],'no')
    matrix_pre = MI_matrix; save matrix_pre_canolty matrix_pre;  
    
    %% Compare MI matrix for pre-grating to post-grating
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    % Plot and save
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,comb)
    shading interp; colormap(jet)
    ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
    title(sprintf('%s Canolty',subject{sub}))
    colorbar
    saveas(gcf,'comod_canolty_MI.png')
    
    clear MI_matrix matrix_post matrix_pre comb
end

