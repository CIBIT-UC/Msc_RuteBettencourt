marsbar;

%% Convert VOI .nii to marsbar roi.mat
ROI = {'IPS', 'SPL', 'V3A', 'hMT', 'insula', 'FEF'};

for sub = 1:25
    ROIpath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/',sub);
    for rr = 6
        if rr == 5 %insula - only right sided
            %Check if file exists
            if isfile(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_insula_right_mask.nii', sub))
                
                VOI = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_insula_right_mask.nii', sub);
                ROIname = 'VOI_insula_right';
                %converts .nii to roi.mat
                mars_img2rois(VOI, ROIpath ,ROIname, 'c') 
            else %file does not exist
                fprintf('sub-%02d right insula VOI file does not exist in the path \n', sub)                
            end
        elseif rr == 4 %hMT
                        % Check if right VOI files exist
            if isfile(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_right_%s_mask.nii', sub, ROI{rr}))
                VOIright = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_right_%s_mask.nii', sub, ROI{rr});
                ROInameright = sprintf('VOI_%s_right', ROI{rr});
                mars_img2rois(VOIright, ROIpath ,ROInameright, 'c')
            else
                fprintf('sub-%02d %s right VOI file does not exist in the path\n', sub, ROI{rr})
                
            end
            
            %Check if left VOI files exist
            if isfile(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_left_%s_mask.nii', sub, ROI{rr}))
                VOIleft = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_left_%s_mask.nii', sub, ROI{rr});
                ROInameleft = sprintf('VOI_%s_left', ROI{rr});
                mars_img2rois(VOIleft, ROIpath ,ROInameleft, 'c')
            else
                fprintf('sub-%02d %s left VOI file does not exist in the path \n', sub, ROI{rr})
                
            end
        else %other ROIs
            % Check if right VOI files exist
            if isfile(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_%s_right_mask.nii', sub, ROI{rr}))
                VOIright = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_%s_right_mask.nii', sub, ROI{rr});
                ROInameright = sprintf('VOI_%s_right', ROI{rr});
                mars_img2rois(VOIright, ROIpath ,ROInameright, 'c')
            else
                fprintf('sub-%02d %s right VOI file does not exist in the path\n', sub, ROI{rr})
                
            end
            
            %Check if left VOI files exist
            if isfile(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_%s_left_mask.nii', sub, ROI{rr}))
                VOIleft = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_%s_left_mask.nii', sub, ROI{rr});
                ROInameleft = sprintf('VOI_%s_left', ROI{rr});
                mars_img2rois(VOIleft, ROIpath ,ROInameleft, 'c')
            else
                fprintf('sub-%02d %s left VOI file does not exist in the path \n', sub, ROI{rr})
                
            end
            
% %VOI = "/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_FEF_right_mask.nii,1"; %error in spm_read_vols.m
% VOI = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_SPL_right_mask.nii', sub);
% %VOI = "VOI_FEF_right_mask.nii";
% %ROIname = erase(VOI, '_mask.nii');
% ROIname = 'newbatchVOI_SPL_right';
% ROIpath = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/VOIs/',sub);
% mars_img2rois(VOI, ROIpath ,ROIname, 'c')

        end
    end
    
end

%% Convert WM and CSF .nii from segmentation to roi.mat
marsbar;
for sub = 2:25
    
    ROIpath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/anat/', sub);
    
    %White matter
    VOI = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/anat/c2sub-%02d_run-01_T1w.nii', sub, sub);
    %VOI = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/anat/c2sub-%02d_run-01_T1w.nii', sub, sub);
    ROIname = 'WM';
    %converts .nii to roi.mat
    mars_img2rois(VOI, ROIpath ,ROIname, 'c') 
    
    
    %CSF
    VOI2 = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/anat/c3sub-%02d_run-01_T1w.nii', sub, sub);
    %VOI2 = sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/anat/c3sub-%02d_run-01_T1w.nii', sub, sub);
    ROIname = 'CSF';
    %converts .nii to roi.mat
    mars_img2rois(VOI2, ROIpath ,ROIname, 'c')     
    

end
