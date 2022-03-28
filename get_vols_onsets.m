%% Onset of the effect volume
clear all, close all, clc

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BIDS-VP-HYSTERESIS',...
    'sub-01','func'));
runs = {'run1' 'run2' 'run3' 'run4'};
for r = 1:4
    run = fullfile(path, sprintf('sub-01_task-main_run-0%d_events.tsv',r));
    tdfread(run, '\t');

    run_onsetidx_CompPatt = []; run_vols_CompPatt = [];
    run_onsetidx_PattComp = []; run_vols_PattComp = [];

    for n = 1:28
        if strcmp(trial_type(n,:), 'Comp_Patt')
            run_onsetidx_CompPatt =[run_onsetidx_CompPatt n];
        elseif strcmp(trial_type(n,:), 'Patt_Comp')
            run_onsetidx_PattComp = [run_onsetidx_PattComp n];   
        end

    end

    for trial = 1:4
        run_vols_CompPatt = [run_vols_CompPatt (onset(run_onsetidx_CompPatt(trial))/1.5)+1];
        run_vols_PattComp = [run_vols_PattComp (onset(run_onsetidx_PattComp(trial))/1.5)+1];
    end

    run_vols_CompPatt = run_vols_CompPatt';
    run_vols_PattComp = run_vols_PattComp';
    
    volumes.(runs{r}).CompPatt = run_vols_CompPatt;
    volumes.(runs{r}).PattComp = run_vols_PattComp;
end
path2 = strip(fullfile(' ', 'DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
save(fullfile(path2,'volume_onset.mat'), 'volumes');