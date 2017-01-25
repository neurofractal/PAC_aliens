subject = sort({'RS','DB','MP','GW','GR','SY','DS','EC','VS','LA','AE','SW','DK','LH','KM'});

combined_matrix_post = zeros(26,19);

for i = 1:length(subject)
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_post.mat')
    combined_matrix_post = matrix_post + combined_matrix_post;
end

combined_matrix_post = combined_matrix_post./ length(subject);

combined_matrix_pre = zeros(26,19);
clear i;

for i = 1:length(subject)
    cd(sprintf('D:\\pilot\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_pre.mat')
    combined_matrix_pre = matrix_post + combined_matrix_pre;
end

combined_matrix_pre = combined_matrix_pre./ length(subject);

comb = (combined_matrix_post - combined_matrix_pre)./(combined_matrix_post + combined_matrix_pre);

figure('color', 'w');
pcolor(6:1:18,30:2:80,comb(:,3:15));colorbar;shading interp;
colormap(jet); ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)')
title(sprintf('Group N = %d', length(subject))) 




%%
subject = {'0401','0402','0403','0404','0405','0406','0407','0409','0413','0414'}

combined_matrix_post = zeros(26,19);

for i = 1:length(subject)
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_post.mat')
    combined_matrix_post = matrix_post + combined_matrix_post;
end

combined_matrix_post = combined_matrix_post./ length(subject);

combined_matrix_pre = zeros(26,19);
clear i;

for i = 1:length(subject)
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}))
    load('matrix_pre.mat')
    combined_matrix_pre = matrix_post + combined_matrix_pre;
end

combined_matrix_pre = combined_matrix_pre./ length(subject);

comb = (combined_matrix_post - combined_matrix_pre)./(combined_matrix_post + combined_matrix_pre);

figure('color', 'w');
pcolor(6:1:18,30:2:80,comb(:,3:15));colorbar;shading interp;
colormap(jet); ylabel('Amplitude (Hz)'); xlabel('Phase (Hz)')
title(sprintf('ASD Group N = %d', length(subject))) 

