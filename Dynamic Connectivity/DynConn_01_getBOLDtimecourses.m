%% get denoised BOLD timecourses from the CONN project
clear,clc

dataFolder = '/DATAPOOL/VPHYSTERESIS/CONN_Projects/conn_project_task-main/results/preprocessing';
%dataFolder = '/home/alexandresayal/media-sim01/DATAPOOL/VPHYSTERESIS/CONN_Projects/conn_project_task-main/results/preprocessing';

subjects = 1:25;

BOLD_denoised_timecourse = struct();

% Run volume indexes
run1Volumes = 1:266;
run2Volumes = 267:532;
run3Volumes = 533:798;
run4Volumes = 799:1064; %from data_sessions

ROIs = {'FEF_bilateral_roi','IPS_bilateral_roi','Insula_right_roi','SPL_bilateral_roi','V3A_bilateral_roi','hMT+_bilateral_roi','SS_hMT+_bilateral', 'Sph_hMT_SS_bilateral'};
aux = strrep(ROIs, '_roi', '');
ROIs_clean = strrep(aux,'+',''); % remove '+' from strings - invalid struct fieldname


nROIs = length(ROIs);

for sub = subjects
    
    % Load data
    load(fullfile(dataFolder, ...
        sprintf('ROI_Subject%03d_Condition000.mat',sub)));
    
    for rr = 1:nROIs
        
        idx = strcmp(names,ROIs{rr});
        
        BOLD_denoised_timecourse.(ROIs_clean{rr}).all(:,sub) = data{1,idx};
        BOLD_denoised_timecourse.(ROIs_clean{rr}).run1(:,sub) = data{1,idx}(run1Volumes);
        BOLD_denoised_timecourse.(ROIs_clean{rr}).run2(:,sub) = data{1,idx}(run2Volumes);
        BOLD_denoised_timecourse.(ROIs_clean{rr}).run3(:,sub) = data{1,idx}(run3Volumes);
        BOLD_denoised_timecourse.(ROIs_clean{rr}).run4(:,sub) = data{1,idx}(run4Volumes);
        
    end
    
end

%% save

save('ROIs_BOLD_timecourse_p2.mat','BOLD_denoised_timecourse','ROIs_clean','nROIs')
