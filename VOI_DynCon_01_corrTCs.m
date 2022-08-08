%% Create trialvol and block metrics

%% Create struct with the BOLD signal from the PattComp, CompPatt,


clear all, close all, clc

data = load('VOIs_BOLD_timecourse_INSpeak.mat'); % BOLD time courses

%data = load('VOIs_BOLD_timecourse_INScorrected.mat'); % BOLD time courses

datavols = load('volume_onset.mat');

%% Define stuff

ROIs = data.ROI_clean;
nROIs = length(data.ROI_clean);

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

nVols = 21-1; %31.5/1.5 -1o volume

subs = 1:25;

subjects = cell(1,25);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

%%
for sub = subs
    
    for run = 1:nRuns
                 
        for rr = 1:nROIs
                       
            for trial = 1:nTrials
                
                %Uses the onset volume for the CompPatt condition for the trial
                volmin_CompPatt = datavols.volumes.(runNames{run}).CompPatt(trial);
                
                xx_CompPatt = volmin_CompPatt:(volmin_CompPatt+nVols); % block indexes
                
                CompPatt = data.BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_CompPatt,sub); % time course during the CompPatt block
                
                
                %Uses the onset volume for the PattComp condition for the
                %trial
                volmin_PattComp = datavols.volumes.(runNames{run}).PattComp(trial);
                
                xx_PattComp = volmin_PattComp:(volmin_PattComp+nVols);
                
                PattComp = data.BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_PattComp,sub);
                
                %Save the trial BOLD denoised signal in a struct
                trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run})(:,trial) = CompPatt;
                
                trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run})(:,trial) = PattComp;      
                
            end %end trial iteration
            
            %% Calculate trial averages and sem
            meanCompPatt = mean(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run}),2);
            meanPattComp = mean(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run}),2);
            
            semCompPatt = std(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run}),[],2) / sqrt(nTrials);
            semPattComp = std(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run}),[],2) / sqrt(nTrials);
            
            %Save in struct
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).mean(:,run) = meanCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).mean(:,run) = meanPattComp;
            
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).sem(:,run) = semCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).sem(:,run) = semPattComp;
            
            
        end % end ROI iteration
        
    end % end run iteration
    
end % end subject iteration

save('VOIs_trialvolumes_INSpeak.mat', 'trialvol')
%save('VOIs_trialvolumes_INScorrected.mat', 'trialvol')

%% Calculate the correlations and corresponding p-values

% Structure to save correlation time courses
correlationTCs = struct();

comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));

for idx = 1:nCombinations
    
    for ss = subs
        
        pvalsCompPatt = []; pvalsPattComp = [];
        rhosCompPatt = []; rhosPattComp = [];

        pvalsSpearmanCompPatt = []; pvalsSpearmanPattComp = [];
        SpearmanCompPatt = []; SpearmanPattComp = [];

        
        
        window1 = 1:5;
                
        while window1(end) < 22
            
            % estimate correlation and p-value for all runs
            [rhoCompPatt, pvalCompPatt] = corr(...
                trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:)  );
            
            rhoCompPatt = diag(rhoCompPatt); % extract values per run
            pvalCompPatt = diag(pvalCompPatt); % extract values per run
            
            rhosCompPatt = [rhosCompPatt rhoCompPatt];
            pvalsCompPatt = [pvalsCompPatt pvalCompPatt];
            
            
            [rhoPattComp, pvalPattComp] = corr(...
                trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:) );
            
            rhoPattComp = diag(rhoPattComp);
            pvalPattComp = diag(pvalPattComp);
            rhosPattComp = [rhosPattComp rhoPattComp];
            pvalsPattComp =  [pvalsPattComp pvalPattComp];
            
            [rSpearmanCompPatt, pvalSpearmanCompPatt] = corr(...
                trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:), ...
                'Type', 'Spearman');
            
            rSpearmanCompPatt = diag(rSpearmanCompPatt);
            pvalSpearmanCompPatt = diag(pvalSpearmanCompPatt);
            SpearmanCompPatt = [SpearmanCompPatt rSpearmanCompPatt];
            pvalsSpearmanCompPatt = [pvalsSpearmanCompPatt pvalSpearmanCompPatt];
            
            [rSpearmanPattComp, pvalSpearmanPattComp] = corr(...
                trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:), ...
                'Type', 'Spearman');
            
            rSpearmanPattComp = diag(rSpearmanPattComp);
            pvalSpearmanPattComp = diag(pvalSpearmanPattComp);
            SpearmanPattComp = [SpearmanPattComp rSpearmanPattComp];
            pvalsSpearmanPattComp = [pvalsSpearmanPattComp pvalSpearmanPattComp];
            
            window1 = window1+1;
            
        end %while

        
        % rhos
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{ss}) = rhosCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{ss}) = rhosPattComp';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{ss})= SpearmanCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{ss})= SpearmanPattComp';
        
        %p-values
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_CompPatt.(subjects{ss}) = pvalsCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_PattComp.(subjects{ss}) = pvalsPattComp';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_CompPatt.(subjects{ss})= pvalsSpearmanCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_PattComp.(subjects{ss})= pvalsSpearmanPattComp';
        
              
    end %subjects iteration
    
    
end %ROIs combination iteration
save('VOI_correlationTCs_INSpeak.mat', 'correlationTCs')
%save('VOI_correlationTCs_INScorrected.mat', 'correlationTCs')