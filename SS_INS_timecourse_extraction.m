%% Extract aINS 10 mm timecourses

clear all, close all, clc

marsbar

%% Automated

for sub = 1:25
    
    cd(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs10mm', sub)) %goes to each subject directory where ROIS are saved
    path = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs10mm', sub);
    files = dir(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs10mm', sub))
    
    if length(files) == 2 % There is no ROI defined in the VOI method - use group level ROI
        
        roi = '/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/insula_roi.mat';
        
    elseif length(files) == 4 % Adjusted ROI due to cluster mislabelling
        
        roi = dir('insula_right_*');
        roi = roi.name;
    elseif length(files) == 3 % VOI volume is correct
        
        roi = dir('VOI_insula_right_*');
        roi = roi.name;
    elseif length(files) == 5
        
        roi = dir('Insula_peak_*');
        roi = roi.name;
    end

    for run = 1:4

        des_path = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat', sub, run); % SPM.mat file
        rois = maroi('load', roi); % make maroi ROI objects
        des = mardo(des_path); % make mardo design object
        mY = get_marsy(rois, des, 'mean'); % extract data into marsy data object
        y = summary_data(mY); % get summary time course(s)

        save(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/INSpeak_run%d.mat', sub, run), 'y'); % save the time course of the ROI
    end
end
