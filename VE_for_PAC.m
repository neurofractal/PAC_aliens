subject = {'0411'};
%% Start Loop
for i=1:length(subject)
    %% Load variables required for source analysis
    load(sprintf('D:\\ASD_Data\\%s\\visual\\data_clean_noICA.mat',subject{i}))
    load(sprintf('D:\\ASD_Data\\%s\\visual\\sourceloc\\mri_realigned.mat',subject{i}))
    load(sprintf('D:\\ASD_Data\\%s\\visual\\sourceloc\\sens.mat',subject{i}))
    load(sprintf('D:\\ASD_Data\\%s\\visual\\sourceloc\\seg.mat',subject{i}))
    %load(sprintf('D:\\ASD_Data\\%s\\visual\\sourceloc\\sourcepstS1.mat',subject{i}))
    data_filtered = data_clean_noICA;
    
    %% Set the current directory
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\granger',subject{i}))
    
    % Left Hemisphere
    
    sourcespace = ft_read_headshape(['Subject' subject{i} '.R.midthickness.4k_fs_LR.surf.gii']);
   
    % Right Hemisphere
    
    %sourcespace = ft_read_headshape(['Subject' subject{i} '.R.midthickness_orig.4k_fs_LR.surf.gii']);
    
    %% Load in source model & plot
%      load('sourcespace.mat')
%      sourcespace = ft_convert_units(sourcespace, 'mm');
%     figure
%     ft_plot_mesh(sourcespace); camlight;
    
    %% Load Atlas
    %cifti = ft_read_cifti('D:\visual_atlas\Human_Retinotopy_Myelin_ReferenceData\Orban12.Probabilistic_Retinotopic_Areas_MSMAll_164k_fs_LR.dscalar.nii');
    
%     %% Get Atlas Points of interest
%     
%     % Here we are basically seeing which vertices are common to both the
%     % downsampled sourcemodel AND the visual atlas (V1,V2,hV4,MT,TEO,V7)
%     
%     % For LH use k = 1::163841 and y = 0
%     % For RH use k = 163841::327684 and y = 4098
%     
%     % V1
%     indxV1 = []; %variable to hold vertex number(s)
%     x = 1;
%     y = 0;
%     for k = 1:163841       % 1:163841 for LH ; 1:163841 for RH
%         if sourcespace.orig.inuse(k) > 0.5
%             y = y+1;
%             if cifti.v1_msmall(k) > 0.5
%                 indxV1(x) = y;
%                 x = x+1;
%             end
%         end
%     end
%     
%     indxV1pnt = zeros(length(indxV1),3);
%     for j = 1:length(indxV1)
%         indxV1pnt(j,:) = sourcespace.pnt(indxV1(j),:);
%     end
%     
%     % V2
%     indxV2 = []; %variable to hold vertex number(s)
%     x = 1;
%     y = 0;
%     for k = 1:163841       % 1:163841 for LH ; 1:163841 for RH
%         if sourcespace.orig.inuse(k) == 1
%             y = y+1;
%             if cifti.v2_msmall(k) > 0.5
%                 indxV2(x) = y;
%                 x = x+1;
%             end
%         end
%     end
%     
%     indxV2pnt = zeros(length(indxV2),3);
%     for j = 1:length(indxV2)
%         indxV2pnt(j,:) = sourcespace.pnt(indxV2(j),:);
%     end
%     
%     %hV4
%     indxV4 = []; %variable to hold vertex number(s)
%     x = 1;
%     y = 0;
%     for k = 1:163841       % 1:163841 for LH ; 1:163841 for RH
%         if sourcespace.orig.inuse(k) == 1
%             y = y+1;
%             if cifti.hv4_msmall(k) > 0.5
%                 indxV4(x) = y;
%                 x = x+1;
%             end
%         end
%     end
%     
%     indxV4pnt = zeros(length(indxV4),3);
%     for j = 1:length(indxV4)
%         indxV4pnt(j,:) = sourcespace.pnt(indxV4(j),:);
%     end
%     
%     %MT
%     indxMT = []; %variable to hold vertex number(s)
%     x = 1;
%     y = 0;
%     for k = 1:163841       % 1:163841 for LH ; 1:163841 for RH
%         if sourcespace.orig.inuse(k) == 1
%             y = y+1;
%             if cifti.mt_msmall(k) > 0.8
%                 indxMT(x) = y;
%                 x = x+1;
%             end
%         end
%     end
%     
%     indxMTpnt = zeros(length(indxMT),3);
%     for j = 1:length(indxMT)
%         indxMTpnt(j,:) = sourcespace.pnt(indxMT(j),:);
%     end
%     
%     %TEO
%     indxTEO = []; %variable to hold vertex number(s)
%     x = 1;
%     y = 0;
%     for k = 1:163841       % 1:163841 for LH ; 1:163841 for RH
%         if sourcespace.orig.inuse(k) == 1
%             y = y+1;
%             if cifti.phpitd_msmall(k) >0.5 || cifti.phpitv_msmall(k) > 0.5
%                 indxTEO(x) = y;
%                 x = x+1;
%             end
%         end
%     end
%     
%     indxTEOpnt = zeros(length(indxTEO),3);
%     for j = 1:length(indxTEO)
%         indxTEOpnt(j,:) = sourcespace.pnt(indxTEO(j),:);
%     end
%     
%     % V7
%     indxV7 = []; %variable to hold vertex mumber(s) f
%     x = 1; y = 0; clear k;
%     for k = 1:163841
%         if sourcespace.orig.inuse(k) == 1
%             y = y+1;
%             if cifti.v7_msmall(k) > 0.7
%                 indxV7(x) = y;
%                 x = x+1;
%             end
%         end
%     end
%     
%     indxV7pnt = zeros(length(indxV7),3); clear j;
%     for j = 1:length(indxV7)
%         indxV7pnt(j,:) = sourcespace.pnt(indxV7(j),:);
%     end
%     
    %% cd
    
    cd(sprintf('D:\\ASD_Data\\%s\\visual\\PAC\\',subject{i}'));

%% Atlas Points of Interest on the HCP atlas
     
     % Here we are using the 32k HCP atlas mesh to define visual ROIs from the subject-specific 32k cortical mesh 
     
     % Left Hemisphere
     cifti_atlas = ft_read_cifti('D:\HCP_atlas\HCP_atlas_downsampled_4k.dlabel.nii');
     
     % Right Hemisphere
     %cifti_atlas = ft_read_cifti('D:\HCP_atlas\Q1-Q6_RelatedValidation210.R.CorticalAreas_dil_Final_Final_Areas.32k_fs_LR.dscalar.nii');
     
     % To switch from L <--> R hemisphere find & repace cifti_atlas.l to .r
     
     % LH
     V1 = 1; 
    
     
     % V1
     
     indxV1 = find(cifti_atlas.x1 == V1); indxV1(1:4) = []; indxV1(50:end) = [];
     indxV1pnt = zeros(length(indxV1),3);
     clear k;
     for k = 1:length(indxV1)
         indxV1pnt(k,:) = sourcespace.pos(indxV1(k),:);
     end
    
    %% Do your timelock analysis on the data & compute covariance
    
    covar = zeros(numel(data_clean_noICA.label));
    for itrial = 1:numel(data_clean_noICA.trial)
        currtrial = data_clean_noICA.trial{itrial};
        covar = covar + currtrial*currtrial.';
    end
    [V, D] = eig(covar);
    D = sort(diag(D),'descend');
    D = D ./ sum(D);
    Dcum = cumsum(D);
    numcomponent = find(Dcum>.99,1,'first');
    
    disp(sprintf('\n Reducing the data to %d components \n',numcomponent));
    
    cfg = [];
    cfg.method = 'pca';
    cfg.updatesens = 'yes';
    cfg.channel = 'MEG';
    comp = ft_componentanalysis(cfg, data_clean_noICA);
    
    cfg = [];
    cfg.updatesens = 'no';
    cfg.component = comp.label(numcomponent:end);
    data_fix = ft_rejectcomponent(cfg, comp);
    
    cfg = [];
    cfg.channel = 'MEG';
    cfg.covariance = 'yes'; % compute the covariance for single trials, then averFEFe
    cfg.preproc.baselinewindow = [-inf 0];  % reapply the baseline correction
    cfg.keeptrials = 'yes';
    timelock1 = ft_timelockanalysis(cfg, data_fix);
    
    cfg = [];
    cfg.covariance = 'yes'; % compute the covariance of the averFEFed ERF
    timelock2 = ft_timelockanalysis(cfg, timelock1);
    
    figure
    plot(timelock2.time, timelock2.avg)
    
    %% Setup pre-requisites for source localisation
    %Create headmodel
    cfg        = [];
    cfg.method = 'singleshell';
    headmodel  = ft_prepare_headmodel(cfg, seg);
    
    % Load headshape
    headshape = ft_read_headshape(sprintf('D:\\ASD_Data\\raw_alien_data\\rs_asd_%s_aliens_quat_tsss.fif',lower(subject{i})))
    headshape = ft_convert_units(headshape,'mm');
    
    %% Create leadfields for visual areas
    cfg=[];
    cfg.vol=headmodel;
    cfg.channel= {'MEG', '-MEG0322', '-MEG2542'};
    cfg.grid.pos=[indxV1pnt];
    cfg.grid.unit      ='mm';
    cfg.grad=sens;
    cfg.grid.inside = [1:1:length(cfg.grid.pos)]; %always inside - check manually
    %cfg.normalize = 'yes';
    sourcemodel_virt=ft_prepare_leadfield(cfg);
    
    figure; hold on;
    %ft_plot_vol(headmodel, 'facecolor', 'g', 'facealpha', 0.1);
    ft_plot_headshape(headshape)
    ft_plot_mesh(sourcemodel_virt.pos(sourcemodel_virt.inside,:),'white','none');
    %ft_plot_mesh(sourcespace,'ecolor','none');camlight;
    ft_plot_sens(sens, 'style', 'black*')
    
    %% perform source analysis for visual areas
    cfg=[];
    cfg.channel= {'MEG', '-MEG0322', '-MEG2542'};
    cfg.grad = sens;
    cfg.senstype = 'MEG';
    cfg.method='lcmv';
    cfg.grid = sourcemodel_virt;
    cfg.grid.unit      ='mm';
    cfg.headmodel=headmodel;
    cfg.lcmv.lamda='20%';
    cfg.lcmv.keepfilter = 'yes';
    cfg.lcmv.projectmom = 'yes';
    %cfg.normalize = 'yes';
    source=ft_sourceanalysis(cfg, timelock2);
    
    cfg = [];
    cfg.channel= {'MEG', '-MEG0322', '-MEG2542'};
    data_filtered = ft_preprocessing(cfg,data_fix);
    
    figure
    plot(source.time, source.avg.mom{1})
    %% Extract VE timeseries from visual areas
    spatialfilter=cat(1,source.avg.filter{:});
    virtsens=[];
    for nnn=1:length(data_filtered.trial)
        virtsens.trial{nnn}=spatialfilter*data_filtered.trial{nnn};
    end;
    
    virtsens.time=data_filtered.time;
    virtsens.fsample=data_filtered.fsample;
    indx=[indxV1pnt]
    for nnn=1:length(virtsens.trial{1}(:,1))
        virtsens.label{nnn}=[num2str(nnn)];
    end;
    
    %% Extract each gridpoint and averFEFe over the corresponding area
    cfg = [];
    chan_number = length(indxV1pnt);
    cfg.channel = virtsens.label(1:chan_number);
    cfg.avgoverchan = 'yes';
    virtsensV1 = ft_selectdata(cfg,virtsens);
    virtsensV1.label = {'V1'};
    
    
    %% Append the data & show TFR plots & averFEFed timeseries
    
    cfg = [];
    cfg.channel = virtsensV1.label;
    cfg.method = 'mtmconvol';
    cfg.output = 'pow';
    cfg.foi = 0:2:120;
    cfg.toi = -2.0:0.02:2.0;
    cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;
    cfg.tapsmofrq  = ones(length(cfg.foi),1).*8;
    multitaper = ft_freqanalysis(cfg, virtsensV1);
    
    
    cfg=[];
    cfg.channel = multitaper.label;
    
    cfg.baselinetype    = 'absolute';
    cfg.ylim            = [40 100];
    cfg.baseline        = [-1.5 0];
    cfg.xlim            = [-1.5 1.5];
    
    ft_singleplotTFR(cfg,multitaper);
    xlabel('Time (sec)'); ylabel('Freq (Hz)'); title(sprintf('%s',subject{i}));
    colormap(jet)
    set(gcf, 'Position', get(0,'Screensize')); %saveas(gcf,'TF_areas.png');
    
    cfg=[];
    tlkvc=ft_timelockanalysis(cfg, virtsensV1);
    figure;
    cfg=[];
    cfg.channel = tlkvc.label;
    cfg.parameter = 'avg';
    cfg.xlim    = [-2 2];
    
    ft_singleplotER(cfg,tlkvc);
    
    save virtsensV1 virtsensV1
end
    