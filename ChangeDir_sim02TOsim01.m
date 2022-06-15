%% Change directory from sim02 to sim 01 in the SPM.mat files for each subject

clear all, close all, clc

for sub = 1:25 %iterate on subjects
    
    %Go to the subject-specific 1st level control directory
    cd(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/1st_level_control', sub))
    
    old = '/media/disk4tb/'; %directory in sim02 that needs changing
    new = '/DATAPOOL/VPHYSTERESIS/Backupsim02/'; %direcotry to change in sim01

    spm_changepath('SPM.mat', old, new) %Gives new SPM.mat with the changed directories and saves the old SPM.mat as SPM.mat.old

end
