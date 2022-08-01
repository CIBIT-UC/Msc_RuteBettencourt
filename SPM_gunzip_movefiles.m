%% Make func directory in derivatives and gunzip the functional main task files

for sub = 1:1
    
    %Path to where we want to move the files (newDir)
    workpath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func', sub);
    
    %Check if path exists, if not creates it
    if ~exist(workpath, 'dir')
        mkdir(workpath);
    end
    
    %Path where original files reside
    getFilesPath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/sub-%02d/func', sub);
    cd(getFilesPath) %Change to path where .gz files are
    
    %Run iteration, gunzip the file in the same path of the .gz files,
    %moves unzipped file to workpath
    for run = 1:4
        
        gunzip(fullfile(getFilesPath, sprintf('sub-%02d_task-main_run-%02d_bold.nii.gz', sub, run)))
        
        movefile(fullfile(getFilesPath, sprintf('sub-%02d_task-main_run-%02d_bold.nii', sub, run)), workpath)
    
    end
end

%% Move anatomical unzipped images to derivatives anat folder

for sub = 1:1
    
    workpath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/anat', sub);
    
    cd(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/sub-%02d/anat', sub));
    movefile(sprintf('sub-%02d_run-01_T1w.nii', sub), workpath);
    
    
end

%% Copy json anatomical files to derevatived anat folder

for sub = 1:1
    
    workpath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/anat', sub);
    
    cd(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/sub-%02d/anat', sub));
    copyfile(sprintf('sub-%02d_run-01_T1w.json', sub), workpath);
    
    
end
