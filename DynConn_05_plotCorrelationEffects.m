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
        
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson = zeros(nRunsPerEffect_CompPatt(ee),11); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson = zeros(nRunsPerEffect_PattComp(ee),11); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman = zeros(nRunsPerEffect_CompPatt(ee),11); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman = zeros(nRunsPerEffect_PattComp(ee),11); 
        
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
                
             
                %%
                % fetch Correlations                
                                
                %Effect block 
  
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 6:10) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+4,rr);
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 6:10) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+4,rr);
               
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 6:10) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+4,rr);
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 6:10) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+4,rr);
                
                %Before effect block CompPatt
                
                if corrIdxBlock_CompPatt < 6
                    
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) = NaN;
                   
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) = NaN;
                
                else
                    
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) =...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-5:corrIdxBlock_CompPatt-1,rr);
                
                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) =...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-5:corrIdxBlock_CompPatt-1,rr);
             
                end
                
                %After effect block CompPatt
                
                if corrIdxBlock_CompPatt > 12
                    
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = NaN;
                    
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = NaN;
                else
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = ...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
               
                    corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = ...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
                
                    
                end
                
                %Before effect block PattComp
                
                if corrIdxBlock_PattComp < 6
                    
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) = NaN;
                   
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) = NaN;
                
                else
                    
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) =...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp-5:corrIdxBlock_PattComp-1,rr);
                
                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) =...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-5:corrIdxBlock_PattComp-1,rr);
             
                end
                
                %After effect block PattComp
                
                if corrIdxBlock_PattComp > 12
                    
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = NaN;
                    
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = NaN;
                else
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = ...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp+5,rr);
               
                    corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 11) = ...
                        datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp+5,rr);
                
                    
                end                  
                
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
        meanCorrBlock(idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,6));
        meanCorrBlock(idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,6));
        
        semCorrBlock(idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrBlock(idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,6)) / sqrt(nRunsPerEffect_PattComp(ee));
        
        %After effect block
        meanCorrPos(idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,11), 'omitnan');
        meanCorrPos(idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,11), 'omitnan');
        
        semCorrPos(idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPos(idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        
        %The 11 correlation volumes
        meanCorrVols = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman, 'omitnan');
        idx = idx+2;
         
        figure('position',[50 50 700 400]);
        hold on
        line([0 16],[0 0],'linestyle',':','color','k')
        e1 = errorbar([1], meanCorrPre(2*ee-1), semCorrPre(2*ee-1),'color',clrMap(6,:),'linestyle','none','markersize',10,'marker','.');
        e2 = errorbar([6], meanCorrBlock(2*ee-1), semCorrBlock(2*ee-1),'color',clrMap(7,:),'linestyle','none','markersize',10,'marker','.');
        e3 = errorbar([11], meanCorrPos(2*ee-1), semCorrPos(2*ee-1),'color',clrMap(11,:),'linestyle','none','markersize',10,'marker','.');
        e4 = plot(1:11, meanCorrVols(1:11))
        hold off
         
        legend([e1 e2 e3 e4], {'Before effect block','Effect block', 'After effect block', 'Correlation timecourse'},'location','best')
        xlabel('tbd'); xlim = [0 12];
        ylabel('Spearman correlation'); ylim = [-1.1 1.1];
        title(sprintf('%s <--> %s \n CompPatt %s',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}, effects{ee}),'interpreter','none')
        
    end

    %% PLOT Spearman CompPatt
%    
%      figure('position',[50 50 700 400])
%      hold on
%      line([0 16],[0 0],'linestyle',':','color','k')
%      e1 = errorbar([1,5,9,13], meanCorrPre(xx_CompPatt), semCorrPre(xx_CompPatt),'color',clrMap(6,:),'linestyle','none','markersize',10,'marker','.');
%      e2 = errorbar([2,6,10,14], meanCorrBlock(xx_CompPatt), semCorrBlock(xx_CompPatt),'color',clrMap(7,:),'linestyle','none','markersize',10,'marker','.');
%      e3 = errorbar([3,7,11,15], meanCorrPos(xx_CompPatt), semCorrPos(xx_CompPatt),'color',clrMap(11,:),'linestyle','none','markersize',10,'marker','.');
%      e4 = plot(xx_CompPatt, meanCorrVols(xx_CompPatt))
%      hold off
%    
%      xlim([0 16]); xlabel('Effects')
%      ylim([-1 1]); ylabel('Spearman correlation')
%  
%      xticks([2 6 10 14]); xticklabels(effects);
%      
%      title(sprintf('%s <--> %s \n CompPatt',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
%      
%      legend([e1 e2 e3],{'Before effect block','Effect block', 'After effect block'},'location','best')
% 
%      %% PLOT Spearman PattComp
%      
%      figure('position',[50 50 700 400])
%      hold on
%      line([0 16],[0 0],'linestyle',':','color','k')
%      e1 = errorbar([1,5,9,13], meanCorrPre(xx_PattComp), semCorrPre(xx_PattComp),'color',clrMap(6,:),'linestyle','none','markersize',10,'marker','.');
%      e2 = errorbar([2,6,10,14], meanCorrBlock(xx_PattComp), semCorrBlock(xx_PattComp),'color',clrMap(7,:),'linestyle','none','markersize',10,'marker','.');
%      e3 = errorbar([3,7,11,15], meanCorrPos(xx_PattComp), semCorrPos(xx_PattComp),'color',clrMap(11,:),'linestyle','none','markersize',10,'marker','.');
% 
%      hold off
%    
%      xlim([0 16]); xlabel('Effects')
%      ylim([-1 1]); ylabel('Spearman correlation')
%  
%      xticks([2 6 10 14]); xticklabels(effects);
%      
%      title(sprintf('%s <--> %s \n PattComp',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
%      
%      legend([e1 e2 e3],{'Before effect block','Effect block', 'After effect block'},'location','best')
     
     
end