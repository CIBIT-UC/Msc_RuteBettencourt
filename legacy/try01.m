%% Calculate the correlation TCs for the whole run

clear all, close all, clc

data = load('ROIs_BOLD_timecourse_p2.mat');
datavols = load('volume_onset.mat'); %if needed

%% Define variables

ROIs = data.ROIs_clean;
nROIs = data.nROIs;

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

%subs = 1:25;
subs = 1:3;

subjects = cell(1,25);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

correlationTCs = struct();

comb = combnk(1:8,2);
nCombinations = length(comb(:,1));

vols = 3:262; %Remove the discard blocks 
szWindow = 20;

corrVols = 3:length(vols) -szWindow;

%% Calculate the correlation TCs

for combIDX = 1:nCombinations
    
    for sub = subs
        
        for run = 1:nRuns
            
            corrVect = zeros(length(corrVols),1);
            pvalVect = zeros(length(corrVols),1);
            window = corrVols(1):szWindow; %Initialize window for each run
            auxIDX = 1; %For indexing in corrVect
            
            while window(end)<=vols(end)
                
                [rhoSpearman, pvalSpearman] = corr(...
                    data.BOLD_denoised_timecourse.(ROIs{comb(combIDX,1)}).(runNames{run})(window,sub),...
                    data.BOLD_denoised_timecourse.(ROIs{comb(combIDX,2)}).(runNames{run})(window,sub),...
                    'Type', 'Spearman');
                
                corrVect(auxIDX) = rhoSpearman; 
                pvalVect(auxIDX) = pvalSpearman;
                % Prepare next iteration
                auxIDX = auxIDX +1;
                window = window +1;
                
            end % while
            
            correlationTCs.Spearman.(ROIs{comb(combIDX, 2)}).(ROIs{comb(combIDX,1)}).(runNames{run})(:,sub) = corrVect;
            correlationTCs.Spearmanpval.(ROIs{comb(combIDX, 2)}).(ROIs{comb(combIDX,1)}).(runNames{run})(:,sub) = pvalVect;
            
            
            
            
        end %run iteration
    end %sub iteration
end %ROI combination iteration

