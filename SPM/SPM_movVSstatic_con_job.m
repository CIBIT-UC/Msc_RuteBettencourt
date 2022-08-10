%-----------------------------------------------------------------------
% Job saved on 29-Jul-2022 10:56:01 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
clear all, close all, clc
for sub = 1:25
    matlabbatch{1}.spm.stats.con.spmmat = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level/SPM.mat', sub)};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Moving > Static';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 1 1 -2 0];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
    matlabbatch{1}.spm.stats.con.delete = 0;
    spm_jobman('run', matlabbatch);
end