%%
for sub = 4:25
    for run = 1:4

        matlabbatch{1}.spm.stats.fmri_spec.dir = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/1st_level-run-%02d', sub, run)}; %Directory for first-level analysis
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.5;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 27;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

    %% Create cell with all volumes from run 1
        idx1 = 1;
        img_run1 = cell([266 1]);

        for vols = 1:266
            img_run1{idx1,1} = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/swasub-%02d_task-main_run-%02d_bold.nii,%d', sub, sub, run, vols);
            idx1 = idx1+1;
        end

        matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = img_run1;
    %% Conditions - discard run1
        Discard = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Discard_run-%02d.txt', sub, run));
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Discard';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = Discard(:,1);
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = [6
                                                                       6];
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;

    %% Conditions - ComPatt run1
        CompPatt = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/CompPatt_run-%02d.txt', sub, run));
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'CompPatt';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = CompPatt(:,1);
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 31.5;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;

    %% Conditions - PattComp run1
        PattComp = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/PattComp_run-%02d.txt', sub, run));
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'PattComp';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = PattComp(:,1);
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 31.5;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;

    %% Conditions - Static run1
        Static = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Static_run-%02d.txt', sub, run));
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'Static';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = Static(:,1);
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 7.5;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;

    %% Conditions - MAE run1
        MAE = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/MAE_run-%02d.txt', sub, run));
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'MAE';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = MAE(:,1);
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = 7.5;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    %%
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/rp_sub-%02d_task-main_run-%02d_bold.txt', sub, sub, run)};
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

    % %% RUN 2
    % %% Create cell with all volumes from run 2
    %     idx2 = 1;
    %     img_run2 = cell([266 1]);
    %     
    %     for vols = 1:266
    %         img_run2{idx2,1} = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/swasub-%02d_task-main_run-02_bold.nii,%d', sub, sub, vols);
    %         idx2 = idx2+1;
    %     end
    % 
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = img_run2;
    %     
    % %% Conditions - Discard run2
    %     Discard_run2 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Discard_run-02.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'Discard';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = Discard_run2(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 6;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
    %     
    % %% Conditions - CompPatt run2
    %     CompPatt_run2 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/CompPatt_run-02.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'CompPatt';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = CompPatt_run2(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 31.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
    %     
    % %% Conditions - PattComp run2    
    %     PattComp_run2 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/PattComp_run-02.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'PattComp';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = PattComp_run2(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = 31.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;
    %     
    % %% Conditions - Static run2
    %     Static_run2 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Static_run-02.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = 'Static';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = Static_run2(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = 7.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;
    %     
    % %% Conditions - MAE run2
    %     MAE_run2 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/MAE_run-02.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).name = 'MAE';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).onset = MAE_run2(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).duration = 7.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).orth = 1;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/rp_sub-%02d_task-main_run-02_bold.txt', sub, sub)};
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    % 
    % %% RUN 3
    % %% Create cell of all volumes run 3
    % 
    %     idx3 = 1;
    %     img_run3 = cell([266 1]);
    %     
    %     for vols = 1:266
    %         img_run3{idx3,1} = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/swasub-%02d_task-main_run-03_bold.nii,%d', sub, sub, vols);
    %         idx3 = idx3+1;
    %     end
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = img_run3;
    % 
    % %% Conditions - Discard run3
    %     Discard_run3 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Discard_run-03.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).name = 'Discard';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = Discard_run3(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).duration = 6;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).orth = 1;
    %     
    % %% Conditions - CompPatt run3
    %     CompPatt_run3 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/CompPatt_run-03.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = 'CompPatt';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = CompPatt_run3(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = 31.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).orth = 1;
    %     
    % %% Conditions - PattComp run3 
    %     PattComp_run3 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/PattComp_run-03.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).name = 'PattComp';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).onset = PattComp_run3(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).duration = 31.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).orth = 1;
    % 
    % %% Conditions - Static run3
    %     Static_run3 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Static_run-03.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).name = 'Static';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).onset = Static_run3(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).duration = 7.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).orth = 1;
    %     
    % %% Conditions - MAE run4
    %     MAE_run3 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/MAE_run-03.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).name = 'MAE';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).onset = MAE_run3(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).duration = 7.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).orth = 1;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {''};
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/rp_sub-%02d_task-main_run-03_bold.txt', sub, sub)};
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;
    % 
    % %% Create cell with all volumes from run 4
    %     idx4 = 1;
    %     img_run4 = cell([266 1]);
    %     
    %     for vols = 1:266
    %         img_run4{idx4,1} = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/swasub-%02d_task-main_run-04_bold.nii,%d', sub, sub, vols);
    %         idx4 = idx4+1;
    %     end
    % 
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = img_run4;
    % %% RUN 4
    % %% Conditions - Discard run4
    %     Discard_run4 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Discard_run-04.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).name = 'Discard';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).onset = Discard_run4(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).duration = 6;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).orth = 1;
    % 
    % %% Conditions - CompPatt run4
    %     CompPatt_run4 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/CompPatt_run-04.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).name = 'CompPatt';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = CompPatt_run4(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).duration = 31.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).orth = 1;
    %     
    % %% Conditions - PattComp run4
    %     PattComp_run4 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/PattComp_run-04.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).name = 'PattComp';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).onset = PattComp_run4(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).duration = 31.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).orth = 1;
    %     
    % %% Conditions - Static run4
    %     Static_run4 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/Static_run-04.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).name = 'Static';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).onset = Static_run4(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).duration = 7.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).orth = 1;
    %     
    % %% Conditions - MAE run4
    %     MAE_run4 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/MAE_run-04.txt', sub));
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).name = 'MAE';
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).onset = MAE_run4(:,1);
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).duration = 7.5;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).tmod = 0;
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).orth = 1;
    %     
    % %%    
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = {''};
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = {sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/rp_sub-%02d_task-main_run-04_bold.txt', sub, sub)};
    %     matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;

        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    %%
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    %%
        %% Run
        spm_jobman('run', matlabbatch);
    end
end