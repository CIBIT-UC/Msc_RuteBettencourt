%%
clear all, close all, clc


data = load('ROIs_BOLD_timecourse_p2.mat'); % BOLD time courses

datavols = load('volume_onset.mat');

datatrials = load('new_trialvolumes_p2.mat');

%% Define variables

ROIs = data.ROIs_clean;
nROIs = data.nROIs;

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

nVols = 21-1; %31.5/1.5 -1o volume

subs = 1:25;

subjects = cell(1,25);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

%% Correlation timecourses

% Structure to save correlation time courses
correlationTCs = struct();

comb = combnk(1:8,2);

nCombinations = length(comb(:,1));

for idx = 1:nCombinations
    
    for ss = subs
        
        pvalsCompPatt = []; pvalsPattComp = [];
        rhosCompPatt = []; rhosPattComp = [];

        pvalsSpearmanCompPatt = []; pvalsSpearmanPattComp = [];
        SpearmanCompPatt = []; SpearmanPattComp = [];

        
        
        window = 1:10;
                
        while window(end) < 22
            
            % estimate correlation and p-value for all runs
            [rhoCompPatt, pvalCompPatt] = corr(...
                datatrials.trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
                datatrials.trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:)  );
            
            rhoCompPatt = diag(rhoCompPatt); % extract values per run
            pvalCompPatt = diag(pvalCompPatt); % extract values per run
            
            rhosCompPatt = [rhosCompPatt rhoCompPatt];
            pvalsCompPatt = [pvalsCompPatt pvalCompPatt];
            
            
            [rhoPattComp, pvalPattComp] = corr(...
                datatrials.trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
                datatrials.trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:) );
            
            rhoPattComp = diag(rhoPattComp);
            pvalPattComp = diag(pvalPattComp);
            rhosPattComp = [rhosPattComp rhoPattComp];
            pvalsPattComp =  [pvalsPattComp pvalPattComp];
            
            [rSpearmanCompPatt, pvalSpearmanCompPatt] = corr(...
                datatrials.trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
                datatrials.trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:), ...
                'Type', 'Spearman');
            
            rSpearmanCompPatt = diag(rSpearmanCompPatt);
            pvalSpearmanCompPatt = diag(pvalSpearmanCompPatt);
            SpearmanCompPatt = [SpearmanCompPatt rSpearmanCompPatt];
            pvalsSpearmanCompPatt = [pvalsSpearmanCompPatt pvalSpearmanCompPatt];
            
            [rSpearmanPattComp, pvalSpearmanPattComp] = corr(...
                datatrials.trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
                datatrials.trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:), ...
                'Type', 'Spearman');
            
            rSpearmanPattComp = diag(rSpearmanPattComp);
            pvalSpearmanPattComp = diag(pvalSpearmanPattComp);
            SpearmanPattComp = [SpearmanPattComp rSpearmanPattComp];
            pvalsSpearmanPattComp = [pvalsSpearmanPattComp pvalSpearmanPattComp];
            
            window = window+1;
            
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

save('CorrelationTCs_windowSz10.mat', 'correlationTCs')