%-----------------------------------------------------------------------
% Job saved on 18-Jul-2022 14:18:50 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
clear all, close all, clc

for sub = 1:3
    for run = 1:4
        contrast = 1

        %SPM.mat selection
        matlabbatch{1}.spm.util.voi.spmmat = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat',sub, run)};
        matlabbatch{1}.spm.util.voi.adjust = contrast; %Change
        matlabbatch{1}.spm.util.voi.session = 1; %Run number
        matlabbatch{1}.spm.util.voi.name = sprintf('right_hMT_contrast_%d', contrast); %Name the ROI

        % Mask image from the control VOI analysis
        matlabbatch{1}.spm.util.voi.roi{1}.mask.image = {sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_right_hMT_mask.nii,1', sub)};
        matlabbatch{1}.spm.util.voi.roi{1}.mask.threshold = 0.5;

        % SPM threshold
%         matlabbatch{1}.spm.util.voi.roi{2}.spm.spmmat = {''}; %Same SPM.mat matrix defined above
%         matlabbatch{1}.spm.util.voi.roi{2}.spm.contrast = contrast; %Change
        matlabbatch{1}.spm.util.voi.roi{2}.spm.conjunction = 1;
        matlabbatch{1}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
        matlabbatch{1}.spm.util.voi.roi{2}.spm.thresh = 0.001;
        matlabbatch{1}.spm.util.voi.roi{2}.spm.extent = 0;
        matlabbatch{1}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
        matlabbatch{1}.spm.util.voi.expression = 'i1';

        % Run
        spm_jobman('run', matlabbatch);
       
    end
end
