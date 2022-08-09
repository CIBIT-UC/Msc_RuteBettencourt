%-----------------------------------------------------------------------
% Job saved on 20-Jul-2022 13:16:46 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
clear all, close all, clc

for sub = 3:4
    for run = 1:4
        contrast = 1;
        matlabbatch{1}.spm.util.voi.spmmat = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat',sub, run)};
        matlabbatch{1}.spm.util.voi.adjust = contrast;
        matlabbatch{1}.spm.util.voi.session = 1; % como os runs estão em SPM.mat diferentes, a session e sempre 1
        matlabbatch{1}.spm.util.voi.name = 'right_hMT';
        
        
        matlabbatch{1}.spm.util.voi.roi{1}.mask.image = {sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control/VOI_right_hMT_mask.nii,1', sub)};
        matlabbatch{1}.spm.util.voi.roi{1}.mask.threshold = 0.5;
        
        
        matlabbatch{1}.spm.util.voi.expression = 'i1';

        spm_jobman('run', matlabbatch);
        
    end
end