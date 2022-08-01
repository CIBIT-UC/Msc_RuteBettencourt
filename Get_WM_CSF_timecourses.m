%%
marsbar;

ROI = {'WM', 'CSF'};

for sub = 1:25
    
    cd(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/anat', sub)) %goes to each subject directory where ROIS are saved
    
    for rr = 1:2 % 1:6 ROI iteration 
        
        rois = dir(sprintf('%s*.mat', ROI{rr})); % gets the ROIs files that exist in that directory
        %roi_files = 'WM_-0_-27_6_roi.mat';
        if length(rois) ~= 0 % There are ROIs with that name
            
            roi_files = {rois(:).name}; % gets the ROIs names in a 1xn cell
            roi_files = roi_files'; % changes to nx1 cell
        
            % Get timecourse for each run
            for run = 1:4

                des_path = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat', sub, run); % SPM.mat file
                rois = maroi('load_cell', roi_files); % make maroi ROI objects
                des = mardo(des_path); % make mardo design object
                
                y = []; % to save the timecourses of the ROIs with enough volume
                
                for ii = 1:length(roi_files) %iteration in ROI list
                    
                    rois_struct = struct(rois{ii}); %to access the size of the ROIS
                        
                    if length(rois_struct.XYZ) > 100 % minimal size of ROI
                
                        mY = get_marsy(rois{ii}, des, 'mean'); % extract data into marsy data object
                        y = [y summary_data(mY)]; % get summary time course(s)
%                         
%                     else
%                         fprintf('%s', sub);
                    end
                    
                end
            
                save(fullfile(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs', sub), sprintf('%s_run%d.mat', ROI{rr}, run)), 'y'); % save the time course of the ROI
            end
            
        else
            
            fprintf('File VOI_%s*.mat does not exist for sub-%02d\n', ROI{rr}, sub)
            
        end
    end
end