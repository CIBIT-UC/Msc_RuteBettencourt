%% plot BOLD denoised signal and correlations with effect block
clear, clc, close all

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes_plus_static.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs_wdSz15.mat'); % Correlation time courses (windowed)

%%
load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');
nROIs = length(ROIs_clean);

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

nVols = 21-1; %(31.5 trial + 7.5 MAE +7.5 Static)/1.5 -1o volume
nMvmt = 21; % in volumes
nStatic = 10; % in volumes
subs = 1:25;

windowSize = 15; % in volumes

subjects = cell(1,25);
nSubs = length(subjects);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

comb = combnk(1:8,2); %to iterate through ROI pairs

nCombinations = length(comb(:,1));

% X axis data
xx_condition = 1:21;
xx_corr = 1:17;

clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
nEffects = length(effects);

%% Adjust effect blocks
% KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt < 5) = 5;
% % KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt > 18) = 18;
% KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp < 5) = 5;
% KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp > 16) = 16;

%% Count number of runs per effect
nRunsPerEffect_CompPatt = histcounts(KeypressData.Effect_CompPatt);
nRunsPerEffect_PattComp = histcounts(KeypressData.Effect_PattComp);

%% Initialize correlation matrices for all ROI pairs per effect
corrPerEffect = struct();

for cc = 1:nCombinations
    
    for ee = 1:nEffects
        
        %corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson = zeros(nRunsPerEffect_CompPatt(ee),21); 
        %corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson = zeros(nRunsPerEffect_PattComp(ee),21); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman = zeros(nRunsPerEffect_CompPatt(ee),27); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman = zeros(nRunsPerEffect_PattComp(ee),27); 
        
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
                
%                 corrIdxBlock_CompPatt = KeypressData.EffectBlockIndex_CompPatt(subrunidx) +nStatic -(5-1); % index of correlation TC that corresponds to the effect block
%                 corrIdxBlock_PattComp = KeypressData.EffectBlockIndex_PattComp(subrunidx) +nStatic -(5-1); % index of correlation TC that corresponds to the effect block
                
                
                %%
                % fetch Correlations                
                                
                %Effect block 
  
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11:20) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+9,rr);
%                 
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11:20) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+9,rr);
               
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:27) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(:,rr);

                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:27) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(:,rr);
                
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 11:15) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+9,rr);
                
                %Before effect block CompPatt
                
%                 if corrIdxBlock_CompPatt < 11
%                     
% %                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:10) = NaN;
%                    
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:10) = NaN;
%                 
%                 else
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:10) =...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-10:corrIdxBlock_CompPatt-1,rr);
%                 
%                      corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:10) =...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-10:corrIdxBlock_CompPatt-1,rr);
%              
%                 end
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:10) =...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-nStatic:corrIdxBlock_CompPatt-1,rr);
% 
%                  corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:10) =...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-nStatic:corrIdxBlock_PattComp-1,rr);
%                
                %After effect block CompPatt
%                 
%                 if corrIdxBlock_CompPatt > 21
%                     
%                     %corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 21) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 16:21) = NaN;
%                 else
% %                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 21) = ...
% %                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
% %                
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 16:21) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5:corrIdxBlock_CompPatt+5+5,rr);
%                end  
% %                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 16:21) = ...
% %                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5:corrIdxBlock_CompPatt+5+5,rr);
% 
%                 if corrIdxBlock_PattComp > 21
%                     
%                     %corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 21) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 16:21) = NaN;
%                 else
% %                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_PattComp), 21) = ...
% %                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
% %                
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 16:21) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp+5:corrIdxBlock_PattComp+5+5,rr);
%                end  

%                     
%                 end
%                 
%                 %Before effect block PattComp
%                 
%                 if corrIdxBlock_PattComp < 11
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:10) = NaN;
%                    
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:10) = NaN;
%                 
%                 else
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:10) =...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp-10:corrIdxBlock_PattComp-1,rr);
%                 
%                      corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:10) =...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-10:corrIdxBlock_PattComp-1,rr);
%              
%                 end
%                 
%                 %After effect block PattComp
%                 
%                 if corrIdxBlock_PattComp > 21
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 21) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 21) = NaN;
%                 else
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 21) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp+10,rr);
%                
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 21) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp+10,rr);
%                 
%                     
%                 end
                                     
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:21) =...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-nStatic+1:corrIdxBlock_CompPatt+nStatic+1,rr);
                                
                % add to counters
                subrunidx = subrunidx + 1;
                
                counterPerEffect_CompPatt(auxEffect_CompPatt) = counterPerEffect_CompPatt(auxEffect_CompPatt) + 1;
                counterPerEffect_PattComp(auxEffect_PattComp) = counterPerEffect_PattComp(auxEffect_PattComp) + 1;
                
            end %runs
            
        end %subjects
    %% Concatenate the CompPatt and PattComp correlation values for each effect in the struct field with size
    %((NCompPatt+NPattComp) x 11)
        for ee = 1:nEffects
%             corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson = ...
%                 [corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson;...
%                 corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson];
            
            corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman = ...
                [corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman;...
                corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman];
            
        end %effects
        
        
end %ROIs

%%
xx = 1:3;


% Iterate on the ROI combinations
for cc = 1:nCombinations
    
    %% Spearman
    %idx = 1;
    meanCorrBlock = zeros(2,4); % lines 1 Spearman, 2 Pearson, columns effects
    semCorrBlock = zeros(2,4);
    meanCorrPre = zeros(2,4);
    semCorrPre = zeros(2,4);
    meanCorrPos = zeros(2,4);
    semCorrPos = zeros(2,4);
    meanCorrVols_Spearman = zeros(4,27);
    semCorrVols_Spearman = zeros(4,27);%lines effects, column correlations TCs
    meanCorrVols_Pearson = zeros(4,16);
    semCorrVols_Pearson = zeros(4,16);
%%    
    
    % calculate means and SEM for each effect
    for ee = 1:nEffects
        
%         %Before effect block
%         meanCorrPre(1,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1), 'omitnan');
%         meanCorrPre(2,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,1), 'omitnan');
%         
%         semCorrPre(1,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%         semCorrPre(2,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%         
%         %During effect block
%         meanCorrBlock(1,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11));
%         meanCorrBlock(2,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,11));
%         
%         semCorrBlock(1,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%         semCorrBlock(2,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,11)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%        
%         %After effect block
%         meanCorrPos(1,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,21), 'omitnan');
%         meanCorrPos(2,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,21), 'omitnan');
%         
%         semCorrPos(1,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,21), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%         semCorrPos(2,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,21), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

        %The 11 correlation volumes
        meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman, 'omitnan');
%         meanCorrVols_Pearson(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson, 'omitnan');
        
        semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%        semCorrVols_Pearson(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

    end  
    %% Plot Effects 
    fig1 = figure('position',[50 50 1100 900]);
    for ee = xx   
        %subplot 211
        hold on
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([18 18], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 28],[0 0],'linestyle',':','color','k') %y=0
%        e1 = errorbar([1], meanCorrPre(1,xx(ee)), semCorrPre(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
 %       e2 = errorbar([11], meanCorrBlock(1,xx(ee)), semCorrBlock(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
 %       e3 = errorbar([21], meanCorrPos(1,xx(ee)), semCorrPos(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
        e4 = errorbar(1:27, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
    end

    hold off
    legend(LH(xx), H(xx),'location','southeast', 'FontSize', 14)
    xlabel('Sliding window (N=15)', 'FontSize', 16); xlim([0 28]);
    xticks([1 11 18]); xticklabels({'Baseline + trial', 'Trial start', 'Trial + baseline'});
    ylabel('Spearman correlation', 'FontSize', 16); 
    
    if cc == 26 || cc == 27 || cc == 28 %Correlation between different type of MTs
        ylim([0.2 1]);
    else
        ylim([-0.4 0.7]); %Different ROIs
    end
    
    title(sprintf('%s <--> %s',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
end

%% hMT comparison plots
xx = 1:3; %four effect
saveFig3Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'ROI_SELECTION_FULL_RUN', 'WdSz15', 'SPEARMAN');
if ~exist(saveFig3Path, 'dir')
    mkdir(saveFig3Path);
end

for rr = 1:5 %ROI indexes that aren't hMT
    
    %% Define matrixes
%     meanCorrBlock = zeros(3,4); % lines: 1 hMT_bilateral, 2 SS_hMT_bilateral, 3 Sph_hMT_SS_bilateral, columns effects
%     semCorrBlock = zeros(3,4);
%     meanCorrPre = zeros(3,4);
%     semCorrPre = zeros(3,4);
%     meanCorrPos = zeros(3,4);
%     semCorrPos = zeros(3,4);
    meanCorrVols_Spearman = zeros(12,27);
    semCorrVols_Spearman = zeros(12,27);%lines effects (1st 4 group, 5-8 SS hMT cluster, 9-12 spherical, column correlations TCs
    deltaCorrVols_Spearman = zeros(3,27);
    
    %Preprare iteration
    idx = 1; %matrix index
    aux = 1; %subplot index
    
    %Open figure
    fig3 = figure('position',[50 50 1100 900]);
      
    for mt = 6:8 %ROI indexes that are hMT
            
    % calculate means and SEM for each effect
        for ee = xx

%             %Before effect block
%             meanCorrPre(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan');
%             semCorrPre(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%             %During effect block
%             meanCorrBlock(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11));
%             semCorrBlock(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%             %After effect block
%             meanCorrPos(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,21), 'omitnan');
%             semCorrPos(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,21), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

            %The 11 correlation volumes
            meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan');
            semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

        end %end ee iteration
        
        deltaCorrVols_Spearman(mt-5,:) = meanCorrVols_Spearman(1,:) -meanCorrVols_Spearman(2,:);
    
   
        %% Plot Spearman effects 
        subplot(2,2,aux) %Open subplot

        for ee = xx 

            hold on
            line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
            line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
            line([18 18], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
            line([0 28],[0 0],'linestyle',':','color','k') %y=0
%             e1 = errorbar([1], meanCorrPre(idx,xx(ee)), semCorrPre(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e2 = errorbar([11], meanCorrBlock(idx,xx(ee)), semCorrBlock(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e3 = errorbar([21], meanCorrPos(idx,xx(ee)), semCorrPos(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
            e4 = errorbar(1:27, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
            LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
            H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
            
        end

        hold off
        %Subplot properties
        xlabel('Sliding window (N=15)', 'FontSize', 16); xlim([0 28]);
        xticks([1 11 18]); xticklabels({'Baseline + trial', 'Trial', 'Trial + baseline'});
        ylabel('Spearman correlation', 'FontSize', 16); 
        
        if rr == 4 || rr == 5
            ylim([0.1 0.6]);
        else
            ylim([-0.05 0.45]);
        end
        


        title(sprintf('%s <--> %s',ROIs_clean{rr},ROIs_clean{mt}),'interpreter','none')
        
        %Prepare next iteration
        idx = idx + 1;
        aux = aux+1;
        
    end %end mt iteration
    
%     %Figure properties
    legend(LH(xx), H(xx),'Position', [0.7 0.4 0.001 0.001], 'FontSize', 14);
    saveas(fig3, fullfile(saveFig3Path,sprintf('WdSz15 %s.png',ROIs_clean{rr})))
%     
%     figX = figure();
%     
%     hold on
%     
%     plot(1:21, deltaCorrVols_Spearman(1,:),'color',clrMap(1,:),'linewidth', 2) %group
%     plot(1:21, deltaCorrVols_Spearman(2,:),'color',clrMap(2,:),'linewidth', 2) %cluster
%     plot(1:21, deltaCorrVols_Spearman(3,:),'color',clrMap(5,:),'linewidth', 2) %spherical
%     
%     %Auxiliar lines
%     line([0 22],[0 0],'linestyle',':','color','k') %y=00
%     line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
%     line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
%     line([21 21], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
%     
%     hold off
%     
%     legend('Spherical group hMT+', 'Cluster SS hMT+', 'Spherical SS hMT+', 'location', 'southeast')
%     title(sprintf('NegativeHyst - PositiveHyst in %s', string(ROIs_clean(rr))), 'interpreter', 'none')
%     xlim([0 22]); ylim([-0.33 0.4])
%     xlabel('Sliding window'); ylabel('\DeltaHyst Spearman Correlation')
%     xticks([1 11 21]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
%     
    
end
