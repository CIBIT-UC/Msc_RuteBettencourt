%% Get VOI timecourse in marsbar
clear all, clc
%
marsbar;


%% Automated
ROI = {'IPS', 'SPL', 'V3A', 'hMT', 'insula', 'FEF'};

for sub = [8 13 16]
    
    cd(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs', sub)) %goes to each subject directory where ROIS are saved
    
    for rr = 5 % 1:6 ROI iteration 
       
        %rois = '/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/insula_roi.mat'
        rois = dir(sprintf('VOI_%s*.mat', ROI{rr})); % gets the ROIs files that exist in that directory
        
%        for run = 1:4
% 
%             des_path = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat', sub, run); % SPM.mat file
%             rois = maroi('load', rois); % make maroi ROI objects
%             des = mardo(des_path); % make mardo design object
%             mY = get_marsy(rois, des, 'mean'); % extract data into marsy data object
%             y = summary_data(mY); % get summary time course(s)
% 
%             save(sprintf('%s_run%d.mat', ROI{rr}, run), 'y'); % save the time course of the ROI
%         end
        if length(rois) ~= 0 % There are ROIs with that name
            
            roi_files = {rois(:).name}; % gets the ROIs names in a 1xn cell
            roi_files = roi_files'; % changes to nx1 cell
        
            % Get timecourse for each run
            for run = 1:4

                des_path = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat', sub, run); % SPM.mat file
                rois = maroi('load_cell', roi_files); % make maroi ROI objects
                des = mardo(des_path); % make mardo design object
                mY = get_marsy(rois{:}, des, 'mean'); % extract data into marsy data object
                y = summary_data(mY); % get summary time course(s)
            
                save(sprintf('%s_run%d.mat', ROI{rr}, run), 'y'); % save the time course of the ROI
            end
            
        else
            
            fprintf('File VOI_%s*.mat does not exist for sub-%02d\n', ROI{rr}, sub)
            
        end
    end
end


%% Needs input for each ROI and SPM.mat 
% ROI = {'IPS', 'SPL', 'V3A', 'hMT', 'insula', 'FEF'};
% 
% 
% % %roi_files = spm_get(Inf, '*roi.nii', 'Select ROI files');
% roi_files = spm_get(Inf, '*roi.mat', 'Select ROI files');
% des_path = spm_get(1, 'SPM.mat', 'Select SPM.mat');
% rois = maroi('load_cell', roi_files); % make maroi ROI objects
% des = mardo(des_path); % make mardo design object
% mY = get_marsy(rois{:}, des, 'mean'); % extract data into marsy data object
% y = summary_data(mY); % get summary time course(s)

%save('IPS_run4.mat', 'y');
