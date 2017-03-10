%% Surrogate Stats - test script to test out surrogate stats using the Ozkurt method

% Currently the analysis is working but the comods are very weird and
% "speckly"

%% Put all data into one FT structure
subject = sort({'RS','DB','MP','GR','DS','EC','VS','LA','AE','SY','GW',...
    'SW','DK','LH','KM','FL','AN'});

% Get all data concatenated together
for sub = 1:length(subject)
    % Load in data
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{sub}))
    load('virtsensV1.mat');
    
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{sub}))
    
    if sub == 1
        virtsensV1_concat = virtsensV1
    else
        cfg = [];
        virtsensV1_concat = ft_appenddata(cfg,virtsensV1_concat,virtsensV1);
    end
end

%% Calculate group PAC

addpath('D://scripts//PAC_aliens'); cd('D:\pilot\Group\PAC');

[MI_matrix] = calc_MI_ozkurt(virtsensV1_concat,[0.0 1.5],[6 20],[30 80],'no');
matrix_post = MI_matrix; save matrix_post_ozkurt matrix_post;
clear MI_matrix

% Plot for sanity
figure('color', 'w'); subplot(2,1,1);
pcolor(6:1:20,30:2:80,matrix_post)
shading interp; colormap(jet)
ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
title('Comod post-grating ALL')
pbaspect([1.5,1,1])

[MI_matrix] = calc_MI_ozkurt(virtsensV1_concat,[-1.5 -0.0],[6 20],[30 80],'no')
matrix_pre = MI_matrix; save matrix_pre_ozkurt matrix_pre;

% Plot for sanity
subplot(2,1,2); pcolor(6:1:20,30:2:80,matrix_pre)
shading interp; colormap(jet);
ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)');
title('Comod pre-grating ALL');
pbaspect([1.5,1,1])

% Compare MI matrix for pre-grating to post-grating
comb = (matrix_post - matrix_pre);%./(matrix_post + matrix_pre);

figure('color', 'w');
pcolor(6:1:20,30:2:80,comb)
shading interp; colormap(jet)
ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
title('Comod post-grating vs pre-grating ALL');
colorbar
saveas(gcf,'comod_ozkurt_MI.png');

%% Surrogate Analysis

load('matrix_post_ozkurt');
[zvalues_group] = surrogate_ozkurt(virtsensV1_concat,[0.3 1.5],[6 20],[30 80],matrix_post);
zvalues_post = zvalues_group; save zvalues_post zvalues_post;
clear zvalues_group

load('matrix_pre_ozkurt');
[zvalues_group] = surrogate_ozkurt(virtsensV1_concat,[-1.5 -0.3],[6 20],[30 80],matrix_pre);
zvalues_pre = zvalues_group; save zvalues_pre zvalues_pre;
clear zvalues_group

comb_zvalue = zvalues_post-zvalues_pre;

figure('color', 'w');
pcolor(6:1:20,30:2:80,zvalues_post)
shading interp; 
colormap(jet)
ylabel('Frequency (Hz)'); xlabel('Phase (Hz)')
title('Comod post-grating vs pre-grating ALL');
colorbar





