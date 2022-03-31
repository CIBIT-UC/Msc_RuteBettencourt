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
                
                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) =...
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
    
    %% Spearman
    idx = 1;
    meanCorrBlock = zeros(2,8); % lines 1 Spearman, 2 Pearson, columns odds CompPatt, evens PattComp
    semCorrBlock = zeros(2,8);
    meanCorrPre = zeros(2,8);
    semCorrPre = zeros(2,8);
    meanCorrPos = zeros(2,8);
    semCorrPos = zeros(2,8);
    meanCorrVols_Spearman = zeros(8,11); %lines odds CompPatt, evens PattComp, 1,2 Neg, 3,4 Pos, 5,6, Null, 7,8 Undefined
    meanCorrVols_Pearson = zeros(8,11);
%%    
    figure('position',[50 50 700 400]);
    %figure('position', [50 50 900 900]);
    % calculate means and SEM for each effect
    for ee = 1:nEffects
        
        %Before effect block
        meanCorrPre(1,idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,1), 'omitnan');
        meanCorrPre(1,idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,1), 'omitnan');
        meanCorrPre(2,idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(:,1), 'omitnan');
        meanCorrPre(2,idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(:,1), 'omitnan');
        
        semCorrPre(1,idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPre(1,idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        semCorrPre(2,idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPre(2,idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        
        %During effect block
        meanCorrBlock(1,idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,6));
        meanCorrBlock(1,idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,6));
        meanCorrBlock(2,idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(:,6));
        meanCorrBlock(2,idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(:,6));
        
        semCorrBlock(1,idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrBlock(1,idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,6)) / sqrt(nRunsPerEffect_PattComp(ee));
        semCorrBlock(2,idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrBlock(2,idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(:,6)) / sqrt(nRunsPerEffect_PattComp(ee));
       
        %After effect block
        meanCorrPos(1,idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,11), 'omitnan');
        meanCorrPos(1,idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,11), 'omitnan');
        meanCorrPos(2,idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(:,11), 'omitnan');
        meanCorrPos(2,idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(:,11), 'omitnan');
        
        semCorrPos(1,idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPos(1,idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        semCorrPos(2,idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorrPos(2,idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(:,11), 'omitnan') / sqrt(nRunsPerEffect_PattComp(ee));
        
        %The 11 correlation volumes
        meanCorrVols_Spearman(idx,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman, 'omitnan');
        meanCorrVols_Spearman(idx+1,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman, 'omitnan');
        meanCorrVols_Pearson(idx,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson, 'omitnan');
        meanCorrVols_Pearson(idx+1,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson, 'omitnan');
        idx = idx+2;
         
        %% Plot CompPatt Effects (figure opened above) 
        %subplot 211
        hold on
        line([0 16],[0 0],'linestyle',':','color','k')
        e1 = errorbar([1], meanCorrPre(1,xx_CompPatt(ee)), semCorrPre(1,xx_CompPatt(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e2 = errorbar([6], meanCorrBlock(1,xx_CompPatt(ee)), semCorrBlock(1,xx_CompPatt(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e3 = errorbar([11], meanCorrPos(1,xx_CompPatt(ee)), semCorrPos(1,xx_CompPatt(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e4 = plot(1:11, meanCorrVols_Spearman(2*ee-1,:), 'color',clrMap(6+3*ee,:));
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = effects{ee};
    end

    hold off
    legend(LH, H,'location','best')
    xlabel('Time ???'); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation'); ylim([-1.1 1.1]);
    title(sprintf('%s <--> %s \n CompPatt ',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
    
    %% Plot PattComp effects - Spearman
    figure('position',[570 50 700 400])
    %subplot 212
    for ee = 1:nEffects
                
        hold on
        line([0 16],[0 0],'linestyle',':','color','k')
        e1 = errorbar([1], meanCorrPre(1,xx_PattComp(ee)), semCorrPre(1,xx_PattComp(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e2 = errorbar([6], meanCorrBlock(1,xx_PattComp(ee)), semCorrBlock(1,xx_PattComp(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e3 = errorbar([11], meanCorrPos(1,xx_PattComp(ee)), semCorrPos(1,xx_PattComp(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e4 = plot(1:11, meanCorrVols_Spearman(2*ee,:), 'color',clrMap(6+3*ee,:));
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = effects{ee};
    end
    
    hold off
    legend(LH, H,'location','best')
    xlabel('Time ???'); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation'); ylim([-1.1 1.1]);
    title(sprintf('%s <--> %s \n PattComp ',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
    
    
    %% Plot CompPatt Effects Pearson 
    figure('Position', [50 550 700 400])    
    %subplot 121
    for ee = 1:nEffects
        
        hold on
        line([0 16],[0 0],'linestyle',':','color','k')
        e1 = errorbar([1], meanCorrPre(2,xx_CompPatt(ee)), semCorrPre(2,xx_CompPatt(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e2 = errorbar([6], meanCorrBlock(2,xx_CompPatt(ee)), semCorrBlock(2,xx_CompPatt(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e3 = errorbar([11], meanCorrPos(2,xx_CompPatt(ee)), semCorrPos(2,xx_CompPatt(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e4 = plot(1:11, meanCorrVols_Pearson(2*ee-1,:), 'color',clrMap(6+3*ee,:));
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = effects{ee};
    end
    
    hold off
    legend(LH, H,'location','best')
    xlabel('Time ???'); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Pearson correlation'); ylim([-1.1 1.1]);
    title(sprintf('%s <--> %s \n CompPatt ',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
    
    %% Plot PattComp effects - Pearson
    figure('position',[570 550 700 400])
    %subplot 122
    for ee = 1:nEffects
                
        hold on
        line([0 16],[0 0],'linestyle',':','color','k')
        e1 = errorbar([1], meanCorrPre(2,xx_PattComp(ee)), semCorrPre(2,xx_PattComp(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e2 = errorbar([6], meanCorrBlock(2,xx_PattComp(ee)), semCorrBlock(2,xx_PattComp(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e3 = errorbar([11], meanCorrPos(2,xx_PattComp(ee)), semCorrPos(2,xx_PattComp(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',10,'marker','.');
        e4 = plot(1:11, meanCorrVols_Pearson(2*ee,:), 'color',clrMap(6+3*ee,:));
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = effects{ee};
    end

    hold off
    legend(LH, H,'location','best')
    xlabel('Time ???'); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Pearson correlation'); ylim([-1.1 1.1]);
    title(sprintf('%s <--> %s \n PattComp ',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
    
    
end