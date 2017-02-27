%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to compute PAC comodulograms for the pre and post grating period,
% using V1 VE data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Specify Subjects
subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE','SY','GW',...
    'SW','DK','LH','KM','FL','AN'});

% subject = {'0401','0402','0403','0404','0405','0406','0407','0409','0411',...
%     '0413','0414','0415','0416','1401','1402','1403'};

%% Start loop for all subjects
for sub = 1:length(subject)
    % Load in data
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{sub}))
    load('VE_V1.mat');
    
    % Add path to PAC functions
    addpath('D://scripts//PAC_aliens')

    %% Get comod for post grating (0.3 to 1.5s) period
    [MI_matrix] = calc_MI(VE_V1,[0.3 1.5],[6 20],[30 80],'no');
    matrix_post = MI_matrix; save matrix_post matrix_post; clear MI_matrix
    
    % Plot for sanity
    figure('color', 'w'); subplot(2,1,1);
    pcolor(6:1:20,30:2:80,matrix_post)
    shading interp; colormap(jet)
    ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
    title(sprintf('Comod post-grating Subject %s',subject{sub}))
    pbaspect([1.5,1,1])    

    %% Get comod for pre grating (-1.5 to -0.3s) period
    [MI_matrix] = calc_MI(VE_V1,[-1.5 -0.3],[6 20],[30 80],'no')
    matrix_pre = MI_matrix; save matrix_pre matrix_pre;
    
    % Plot for sanity
    subplot(2,1,2); pcolor(6:1:20,30:2:80,matrix_pre)
    shading interp; colormap(jet);
    ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)');
    title(sprintf('Comod pre-grating Subject %s',subject{sub}))
    pbaspect([1.5,1,1])    
    
    %% Compare MI matrix for pre-grating to post-grating
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    % Plot and save
    figure('color', 'w');
    pcolor(6:1:20,30:2:80,comb)
    shading interp; colormap(jet)
    ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
    title(sprintf('%s',subject{sub}))
    colorbar
    saveas(gcf,'comod_canolty_MI.png')
end

