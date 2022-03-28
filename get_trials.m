%% Create trialvol and block metrics

%% Create struct with the BOLD signal from the PattComp, CompPatt, 
%PattComp-->Static-->CompPatt and CompPatt-->Static-->PattComp
clear all, close all, clc

effects_data = strip(fullfile(' ', 'DATAPOOL', 'home', 'rutebettencourt',...
    'Documents', 'GitHub', 'Msc_RuteBettencourt', 'Hysteresis-keypress-label-data.mat'));
load(effects_data)

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'ROIs_BOLD_timecourse.mat');
datacon = fullfile(path, 'dynCon_metrics.mat');
datavols = fullfile(path, 'volume_onset.mat');
load(data); load(datacon); load(datavols);

ROIs = fieldnames(BOLD_denoised_timecourse);
aux1 = strrep(ROIs,'_roi','');
ROIs_clean = strrep(aux1, '_','-');
nROIs = length(ROIs);

runs = fieldnames(BOLD_denoised_timecourse.SS_hMT_bilateral);
nruns =2:length(runs); %Ignore the concatenated runs
trials = 1:4;

effectBlock_sz = 5;
window = 1:effectBlock_sz;
nvols = 21-1; %31.5/1.5 -1o volume
runsnames = fieldnames(volumes);

subs = 1:25;
subjects = {};
for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

for sub=subs
    for run = nruns
        for rr = 1:nROIs
            trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1}) = zeros(52, 2); %52=2*nvols+tstatic/1.5
            trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1}) = zeros(52, 2);
            for trial = trials
            
                effect_list_idx = 4*(sub-1)+run-1;
                lastEffect_CompPatt = EffectBlockIndex_CompPatt(effect_list_idx);
                lastEffect_PattComp = EffectBlockIndex_PattComp(effect_list_idx);
                
                %Uses the onset volume for the CompPatt condition for the trial
                volmin_CompPatt = volumes.(runsnames{run-1}).CompPatt(trial);
                xx_CompPatt = volmin_CompPatt:(volmin_CompPatt+nvols);
                CompPatt = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_CompPatt,sub);
                
                %Uses the onset volume for the PattComp condition for the
                %trial
                volmin_PattComp = volumes.(runsnames{run-1}).PattComp(trial);
                xx_PattComp = volmin_PattComp:(volmin_PattComp+nvols);
                PattComp = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_PattComp,sub);
                
                %Save the trial BOLD denoised signal in a struct
                trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,trial) = CompPatt;
                trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,trial) = PattComp;
                
                
                %Creates the trajectory Compatt-->Static -->PattComp
                if xx_PattComp(end)>xx_CompPatt(end)
                    xx_full = volmin_CompPatt:(volmin_PattComp+nvols);
                    CompPatt2PattComp = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_full,sub);
                    
                    if trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,1)==0
                        trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,1) = CompPatt2PattComp;
                    else
                        trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,2) = CompPatt2PattComp;
                        
                    end
                else %Creates the opposite trajectory
                    xx_full = volmin_PattComp:(volmin_CompPatt+nvols);
                    PattComp2CompPatt = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_full,sub);
                    
                    if trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,1)==0
                        trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,1) = PattComp2CompPatt;
                    else
                        trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,2) = PattComp2CompPatt;
                    end
                        
                end
                
            end
            meanCompPatt = mean(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1}),2);
            meanPattComp = mean(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1}),2);
            meanCompPatt2PattComp = mean(trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1}),2);
            meanPattComp2CompPatt = mean(trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1}),2);
            
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).mean(:,run-1) = meanCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).mean(:,run-1) = meanPattComp;
            trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).mean(:,run-1) = meanCompPatt2PattComp;
            trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).mean(:,run-1) = meanPattComp2CompPatt;
            
        end
    end
end

save(fullfile(path,'new_trialvolumes.mat'), 'trialvol')


%% Calculate the correlations and corresponding p-values
comb = combnk(1:7,2);
idxs = 1:length(comb(:,1));

for runi = nruns
    for idx = idxs
        for ss=1:25
            pvalsCompPatt = []; pvalsPattComp = [];
            rhosCompPatt = []; rhosPattComp = [];
            rhosCompPatt2PattComp = []; rhosPattComp2CompPatt = [];
            pvalsSpearmanCompPatt = []; pvalsSpearmanPattComp = [];
            SpearmanCompPatt = []; SpearmanPattComp = [];
            SpearmanCompPatt2PattComp = []; SpearmanPattComp2CompPatt = [];
            window1 = 1:5;
            window2 = 1:5;
            
                while window1(end)<22
                    [rhoCompPatt, pvalCompPatt] = corr(trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:),...
                        trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:));
                    rhoCompPatt = diag(rhoCompPatt);
                    pvalCompPatt = diag(pvalCompPatt);
                    rhosCompPatt = [rhosCompPatt rhoCompPatt];
                    pvalsCompPatt = [pvalsCompPatt pvalCompPatt];

                    [rhoPattComp, pvalPattComp] = corr(trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:),...
                        trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:));
                    rhoPattComp = diag(rhoPattComp);
                    pvalPattComp = diag(pvalPattComp);
                    rhosPattComp = [rhosPattComp rhoPattComp];
                    pvalsPattComp =  [pvalsPattComp pvalPattComp];

                    [rSpearmanCompPatt, pvalSpearmanCompPatt] = corr(trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:),...
                        trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:), 'Type', 'Spearman');
                    rSpearmanCompPatt = diag(rSpearmanCompPatt);
                    pvalSpearmanCompPatt = diag(pvalSpearmanCompPatt);
                    SpearmanCompPatt = [SpearmanCompPatt rSpearmanCompPatt];
                    pvalsSpearmanCompPatt = [pvalsSpearmanCompPatt pvalSpearmanCompPatt];

                    [rSpearmanPattComp, pvalSpearmanPattComp] = corr(trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:),...
                        trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:), 'Type', 'Spearman');
                    rSpearmanPattComp = diag(rSpearmanPattComp);
                    pvalSpearmanPattComp = diag(pvalSpearmanPattComp);
                    SpearmanPattComp = [SpearmanPattComp rSpearmanPattComp];
                    pvalsSpearmanPattComp = [pvalsSpearmanPattComp pvalSpearmanPattComp];

                    window1 = window1+1;

                end

                while window2(end)<53
                    rhoCompPatt2PattComp = corr(trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
                        trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:));
                    rhoCompPatt2PattComp = diag(rhoCompPatt2PattComp);
                    rhosCompPatt2PattComp = [rhosCompPatt2PattComp rhoCompPatt2PattComp];

                    rhoPattComp2CompPatt = corr(trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
                        trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:));
                    rhoPattComp2CompPatt = diag(rhoPattComp2CompPatt);
                    rhosPattComp2CompPatt = [rhosPattComp2CompPatt rhoPattComp2CompPatt];
                    
                    rSpearmanCompPatt2PattComp = corr(trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
                        trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:), 'Type', 'Spearman');
                    rSpearmanCompPatt2PattComp = diag(rSpearmanCompPatt2PattComp);
                    SpearmanCompPatt2PattComp = [SpearmanCompPatt2PattComp rSpearmanCompPatt2PattComp];

                    rSpearmanPattComp2CompPatt = corr(trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
                        trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:), 'Type', 'Spearman');
                    rSpearmanPattComp2CompPatt = diag(rSpearmanPattComp2CompPatt);
                    SpearmanPattComp2CompPatt = [SpearmanPattComp2CompPatt rSpearmanPattComp2CompPatt];
                    window2= window2+1;

                end
                
            %Block - rhos
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{ss})= rhosCompPatt';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{ss})= rhosPattComp';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{ss})= SpearmanCompPatt';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{ss})= SpearmanPattComp';            
            
            %p-values
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_CompPatt.(subjects{ss})= pvalsCompPatt';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_PattComp.(subjects{ss})= pvalsPattComp';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_CompPatt.(subjects{ss})= pvalsSpearmanCompPatt';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_PattComp.(subjects{ss})= pvalsSpearmanPattComp';               
            
            
            %Trajectory1 -->Static -->Trajectory2
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{ss})= rhosCompPatt2PattComp';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{ss})= rhosPattComp2CompPatt';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{ss})= SpearmanCompPatt2PattComp';
            blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{ss})= SpearmanPattComp2CompPatt';

        end
         
        
    end

end

save(fullfile(path,'new_blockmetrics.mat'), 'blockmetrics')
