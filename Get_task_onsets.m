%% Onset of the effect volume
clear all, close all, clc

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BIDS-VP-HYSTERESIS',...
     'sub-01','func'));

runs = {'run1' 'run2' 'run3' 'run4'};

for r = 1:4
    
    tsvFilePath = fullfile(path, sprintf('sub-01_task-main_run-0%d_events.tsv',r));
    tsvFile = tdfread(tsvFilePath, '\t');

    run_onsetidx_CompPatt = []; run_vols_CompPatt = [];
    run_onsetidx_PattComp = []; run_vols_PattComp = [];
    run_onsetidx_Discard = []; run_vols_Discard = [];
    run_onsetidx_Static = []; run_vols_Static = [];
    run_onsetidx_MAE = []; run_vols_MAE = [];
    
    % fetch idx of CompPatt and PattComp in tsvFile
    for n = 1:28
        
        if strcmp(tsvFile.trial_type(n,:), 'Comp_Patt')
            run_onsetidx_CompPatt = [run_onsetidx_CompPatt n];
        elseif strcmp(tsvFile.trial_type(n,:), 'Patt_Comp')
            run_onsetidx_PattComp = [run_onsetidx_PattComp n];
        elseif strcmp(tsvFile.trial_type(n,:), 'Discard  ')
            run_onsetidx_Discard = [run_onsetidx_Discard n];
        elseif strcmp(tsvFile.trial_type(n,:), 'Static   ')
            run_onsetidx_Static = [run_onsetidx_Static n];
        elseif strcmp(tsvFile.trial_type(n,:), 'MAE      ')
            run_onsetidx_MAE = [run_onsetidx_MAE n];
        end

    end
    
    for d = 1:2
        run_vols_Discard = [run_vols_Discard (tsvFile.onset(run_onsetidx_Discard(d))/1.5)+1 ];
    end
    
    for mm = 1:8
        run_vols_MAE = [run_vols_MAE (tsvFile.onset(run_onsetidx_MAE(mm))/1.5)+1 ];
    end
    
    for ss = 1:10
        run_vols_Static = [run_vols_Static (tsvFile.onset(run_onsetidx_Static(ss))/1.5)+1 ];
    end
    
    % onset volume for each condition/trial
    for trial = 1:4
        run_vols_CompPatt = [run_vols_CompPatt (tsvFile.onset(run_onsetidx_CompPatt(trial))/1.5)+1 ];
        run_vols_PattComp = [run_vols_PattComp (tsvFile.onset(run_onsetidx_PattComp(trial))/1.5)+1 ];
        
    end

    run_vols_CompPatt = run_vols_CompPatt';
    run_vols_PattComp = run_vols_PattComp';
    run_vols_Discard = run_vols_Discard';
    run_vols_Static = run_vols_Static';
    run_vols_MAE = run_vols_MAE';
    
    volumes.(runs{r}).CompPatt = run_vols_CompPatt;
    volumes.(runs{r}).PattComp = run_vols_PattComp;
    volumes.(runs{r}).Discard = run_vols_Discard;
    volumes.(runs{r}).Static = run_vols_Static;
    volumes.(runs{r}).MAE = run_vols_MAE;
end

save('task_onsets.mat', 'volumes')