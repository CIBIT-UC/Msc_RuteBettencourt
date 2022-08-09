%% plot BOLD denoised signal and correlations with effect block
clear, clc, close all

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs.mat'); % Correlation time courses (windowed)

%% Define stuff

load('ROIs_BOLD_timecourse.mat','ROIs_clean');
nROIs = length(ROIs_clean);

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

nVols = 21-1; %31.5/1.5 -1o volume

subs = 1:25;

windowSize = 5; % in volumes

subjects = cell(1,25);
nSubs = length(subjects);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

comb = combnk(1:7,2);

nCombinations = length(comb(:,1));

% X axis data
xx_condition = 1:21;
xx_corr = 1:17;

clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
nEffects = length(effects);
markers = {'v','+','o','s'}; % one for each effect (neg hyst, pos hyst, null, undefined)

%% Adjust effect blocks
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt < 5) = 5;
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt > 17) = 17;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp < 5) = 5;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp > 17) = 17;

%% Count number of runs per effect
nRunsPerEffect_CompPatt = histcounts(KeypressData.Effect_CompPatt);
nRunsPerEffect_PattComp = histcounts(KeypressData.Effect_PattComp);

%% Initialize correlation matrices for all ROI pairs per effect
corrPerEffect = struct();

for cc = 1:nCombinations
    
    for ee = 1:nEffects
        
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson = zeros(nRunsPerEffect_CompPatt(ee),3); %3 columns - pre-effect block, effect block, pos-effect block
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson = zeros(nRunsPerEffect_PattComp(ee),3); %3 columns - pre-effect block, effect block, pos-effect block
        
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman = zeros(nRunsPerEffect_CompPatt(ee),3); %3 columns - pre-effect block, effect block, pos-effect block
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman = zeros(nRunsPerEffect_PattComp(ee),3); %3 columns - pre-effect block, effect block, pos-effect block
        
    end
    
end
        
%% Iterate on the ROI combinations to fetch correlations
for cc = 1:nCombinations
    
        %% Start counters
        subrunidx = 1; % index to iterate in the 100x1 matrix
        counterPerEffect_CompPatt = ones(1,nEffects);
        counterPerEffect_PattComp = ones(1,nEffects);

        %% Iterate on the subjects and runs
        for ss = 1:nSubs
            
            for rr = 1:4
                
                auxEffect_CompPatt = KeypressData.Effect_CompPatt(subrunidx); % effect in this run for CompPatt condition
                auxEffect_PattComp = KeypressData.Effect_PattComp(subrunidx); % effect in this run for CompPatt condition
                
                corrIdxBlock_CompPatt = KeypressData.EffectBlockIndex_CompPatt(subrunidx)-(windowSize-1); % index of correlation TC that corresponds to the effect block
                corrIdxBlock_PattComp = KeypressData.EffectBlockIndex_PattComp(subrunidx)-(windowSize-1); % index of correlation TC that corresponds to the effect block
                
%                 corrIdxPre_CompPatt = KeypressData.EffectBlockIndex_CompPatt(subrunidx)-(windowSize-1)-5; % index of correlation TC before the effect block
%                 corrIdxPre_PattComp = KeypressData.EffectBlockIndex_PattComp(subrunidx)-(windowSize-1)-5; % index of correlation TC before the effect block
%                 
%                 corrIdxPos_CompPatt = KeypressData.EffectBlockIndex_CompPatt(subrunidx)+1; % index of correlation TC after the effect block
%                 corrIdxPos_PattComp = KeypressData.EffectBlockIndex_PattComp(subrunidx)+1; % index of correlation TC after the effect block
                
                
                %%
                % fetch Correlations
%                 %Pre-effect block CompPatt
%                 if corrIdxPre_CompPatt < 1
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1) = NaN; %Pearson
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1) = NaN; %Spearman
%                 
%                 else
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1) = ... %Pearson
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxPre_CompPatt,rr);
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1) = ... %Spearman
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxPre_CompPatt,rr);
%                 
%                 end
%                 
%                 %Pre-effect block PattComp
%                 if corrIdxPre_PattComp < 1
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1) = NaN; %Pearson
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1) = NaN; %Spearman
%                 
%                 else
%                     corrIdxPre_CompPatt
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1) = ... %Pearson
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxPre_PattComp,rr);
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1) = ... %Spearman
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxPre_PattComp,rr);
%                 
%                 end
                
                                
                %Effect block 
  
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 6) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt,rr);
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 6) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp,rr);
               
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 6) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt,rr);
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 6) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp,rr);
                
%                 %Pos-effect block CompPatt
%                 if corrIdxPos_CompPatt > 13
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = NaN;
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = NaN;
%                     
%                 else
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxPos_CompPatt,rr);
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxPos_CompPatt,rr);
%                 end
% 
%                 %Pos-effect block PattComp
%                 if corrIdxPos_PattComp > 13
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = NaN;
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 11) = NaN;
%                     
%                 else
%                                         
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxPos_PattComp,rr);
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_CompPatt(auxEffect_PattComp), 11) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxPos_PattComp,rr);
%                 
%                 end
               
                
                % add to counters
                subrunidx = subrunidx + 1;
                
                counterPerEffect_CompPatt(auxEffect_CompPatt) = counterPerEffect_CompPatt(auxEffect_CompPatt) + 1;
                counterPerEffect_PattComp(auxEffect_PattComp) = counterPerEffect_PattComp(auxEffect_PattComp) + 1;
                
            end
            
        end
    
end

%% Plot average correlations in the Effect block
xx_CompPatt = 1:2:8;
xx_PattComp = 2:2:8;

% Iterate on the ROI combinations
for cc = 1:nCombinations

    idx = 1;
    meanCorrBlock = zeros(1,8);
    semCorrBlock = zeros(1,8);
    
    % calculate means and SEM for each effect
    for ee = 1:nEffects
        
        %Before effect block
        meanCorrPre(idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,1), 'omitnan');
        meanCorrPre(idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,1), 'omitnan');
        
        semCorrPre(idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPre(idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        
        %During effect block
        meanCorrBlock(idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,2));
        meanCorrBlock(idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,2));
        
        semCorrBlock(idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,2)) / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrBlock(idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,2)) / sqrt(nRunsPerEffect_PattComp(ee));
        
        %After effect block
        meanCorrPos(idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,3), 'omitnan');
        meanCorrPos(idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,3), 'omitnan');
        
        semCorrPos(idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,3), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPos(idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,3), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        
        idx = idx+2;
        
    end

    %% PLOT Spearman CompPatt
   
     figure('position',[50 50 700 400])
     hold on
     line([0 16],[0 0],'linestyle',':','color','k')
     e1 = errorbar([1,5,9,13], meanCorrPre(xx_CompPatt), semCorrPre(xx_CompPatt),'color',clrMap(6,:),'linestyle','none','markersize',10,'marker','.');
     e2 = errorbar([2,6,10,14], meanCorrBlock(xx_CompPatt), semCorrBlock(xx_CompPatt),'color',clrMap(7,:),'linestyle','none','markersize',10,'marker','.');
     e3 = errorbar([3,7,11,15], meanCorrPos(xx_CompPatt), semCorrPos(xx_CompPatt),'color',clrMap(11,:),'linestyle','none','markersize',10,'marker','.');

     hold off
   
     xlim([0 16]); xlabel('Effects')
     ylim([-1 1]); ylabel('Spearman correlation')
 
     xticks([2 6 10 14]); xticklabels(effects);
     
     title(sprintf('%s <--> %s \n CompPatt',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
     
     legend([e1 e2 e3],{'Before effect block','Effect block', 'After effect block'},'location','best')

     %% PLOT Spearman PattComp
     
     figure('position',[50 50 700 400])
     hold on
     line([0 16],[0 0],'linestyle',':','color','k')
     e1 = errorbar([1,5,9,13], meanCorrPre(xx_PattComp), semCorrPre(xx_PattComp),'color',clrMap(6,:),'linestyle','none','markersize',10,'marker','.');
     e2 = errorbar([2,6,10,14], meanCorrBlock(xx_PattComp), semCorrBlock(xx_PattComp),'color',clrMap(7,:),'linestyle','none','markersize',10,'marker','.');
     e3 = errorbar([3,7,11,15], meanCorrPos(xx_PattComp), semCorrPos(xx_PattComp),'color',clrMap(11,:),'linestyle','none','markersize',10,'marker','.');

     hold off
   
     xlim([0 16]); xlabel('Effects')
     ylim([-1 1]); ylabel('Spearman correlation')
 
     xticks([2 6 10 14]); xticklabels(effects);
     
     title(sprintf('%s <--> %s \n PattComp',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
     
     legend([e1 e2 e3],{'Before effect block','Effect block', 'After effect block'},'location','best')
     
     
end