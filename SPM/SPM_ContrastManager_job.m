%-----------------------------------------------------------------------
% Job saved on 18-Jul-2022 13:36:10 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
clear all, close all, clc
for sub = 1:25
    for run = 1:4
        matlabbatch{1}.spm.stats.con.spmmat = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d/SPM.mat', sub, run)};
        matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = 'Conditions only';
        %%
        matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [1 0 0 0 0 0 0 0 0 0 0
                                                                0 1 0 0 0 0 0 0 0 0 0
                                                                0 0 1 0 0 0 0 0 0 0 0
                                                                0 0 0 1 0 0 0 0 0 0 0
                                                                0 0 0 0 1 0 0 0 0 0 0
                                                                0 0 0 0 0 0 0 0 0 0 0
                                                                0 0 0 0 0 0 0 0 0 0 0
                                                                0 0 0 0 0 0 0 0 0 0 0
                                                                0 0 0 0 0 0 0 0 0 0 0
                                                                0 0 0 0 0 0 0 0 0 0 0
                                                                0 0 0 0 0 0 0 0 0 0 0];
        %%
        matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
        matlabbatch{1}.spm.stats.con.consess{2}.fcon.name = 'Discard only';
        %%
    %    matlabbatch{1}.spm.stats.con.consess{2}.fcon.weights = [0 0 0 0 0 0 0 0 0 0 0
    %                                                             0 0 0 0 0 0 0 0 0 0 0
    %                                                             0 0 0 0 0 0 0 0 0 0 0
    %                                                             0 0 0 0 0 0 0 0 0 0 0
    %                                                             0 0 0 0 0 0 0 0 0 0 0
    %                                                             0 0 0 0 0 1 0 0 0 0 0
    %                                                             0 0 0 0 0 0 1 0 0 0 0
    %                                                             0 0 0 0 0 0 0 1 0 0 0
    %                                                             0 0 0 0 0 0 0 0 1 0 0
    %                                                             0 0 0 0 0 0 0 0 0 1 0
    %                                                             0 0 0 0 0 0 0 0 0 0 1];
        matlabbatch{1}.spm.stats.con.consess{2}.fcon.weights = zeros(11);
        matlabbatch{1}.spm.stats.con.consess{2}.fcon.weights(1,1) = 1;
        %%
        matlabbatch{1}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
        matlabbatch{1}.spm.stats.con.consess{3}.fcon.name = 'Effects';
        %%
        matlabbatch{1}.spm.stats.con.consess{3}.fcon.weights = [1 0 0 0 0 0 0 0 0 0 0
                                                                0 1 0 0 0 0 0 0 0 0 0
                                                                0 0 1 0 0 0 0 0 0 0 0
                                                                0 0 0 1 0 0 0 0 0 0 0
                                                                0 0 0 0 1 0 0 0 0 0 0
                                                                0 0 0 0 0 1 0 0 0 0 0
                                                                0 0 0 0 0 0 1 0 0 0 0
                                                                0 0 0 0 0 0 0 1 0 0 0
                                                                0 0 0 0 0 0 0 0 1 0 0
                                                                0 0 0 0 0 0 0 0 0 1 0
                                                                0 0 0 0 0 0 0 0 0 0 1];
        %%
        matlabbatch{1}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
        matlabbatch{1}.spm.stats.con.delete = 1;

        %% Run
        spm_jobman('run', matlabbatch);
    end
    
end