% Load in virtualchannel_raw
subject = {'AE','DB','DS','EC','GW','KM','LH','SY'};
addpath('D:\\scripts\CFC')

for k = 1:length(subject)
    
    load(sprintf('D:\\pilot\\%s\\PS\\VE\\virtualchannel_raw_LR_hard.mat',subject{k}));
    cd(sprintf('D:\\pilot\\%s\\PS\\VE',subject{k}));
    [MI_matrix] = calc_MI(virtualchannel_raw_LR_hard,[0.3 1.3],[4 8],[40 80],'no');
    matrix_post = MI_matrix; save('matrix_post','matrix_post','-v7.3');
    clear MI_matrix;
    
    [MI_matrix] = calc_MI(virtualchannel_raw_LR_hard,[-1 0],[4 8],[40 80],'no');
    matrix_pre = MI_matrix; save('matrix_pre','matrix_pre','-v7.3');
    
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    figure('color', 'w');
    pcolor(4:1:8,40:2:80,comb)
    shading interp
    colormap(jet)
    ylabel('Frequency (Hz)')
    xlabel('Phase (Hz)')
    title(sprintf('%s',subject{k}))
    saveas(gcf,'comod_tort_MI.png')
    
    clear virtualchannel_raw_LR_hard matrix_post matrix_pre
end

%% 

%%
subject = {'AE','DB','DS','EC','GW','SY'}

combined_matrix = zeros(21,5);

for i = 1:length(subject)
    cd(sprintf('D:\\pilot\\%s\\PS\\VE\\',subject{i}))
    load('matrix_post.mat'); load('matrix_post.mat'); 
    
    comb = (matrix_post - matrix_pre)./(matrix_post + matrix_pre);
    
    combined_matrix = comb + combined_matrix;
end

combined_matrix = combined_matrix./ length(subject);

figure('color', 'w');
pcolor(4:1:8,40:2:80,combined_matrix)
shading interp
colormap(jet)
ylabel('Frequency (Hz)')
xlabel('Phase (Hz)')













