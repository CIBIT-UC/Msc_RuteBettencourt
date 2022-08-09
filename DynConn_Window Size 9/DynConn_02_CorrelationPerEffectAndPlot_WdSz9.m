%%

clear all, close all, clc

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes_plus_static.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs_wdSz9.mat'); % Correlation time courses (windowed)

%%
load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');
nROIs = length(ROIs_clean);
ROIs_titles  = {'FEF', 'IPS', 'Anterior Insula', 'SPL', 'V3A', 'Group hMT+',...
    'Subject-specific cluster-based hMT+','Subject-specific spherical hMT+'};

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

nVols = 21-1; %(31.5 trial + 7.5 MAE +7.5 Static)/1.5 -1o volume
nMvmt = 21; % in volumes
nStatic = 10; % in volumes
subs = 1:25;

windowSize = 9; % in volumes

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
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
%% Adjust effect blocks
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt < 6) = 6;
% KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt > 18) = 18;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp < 6) = 6;
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
                
                corrIdxBlock_CompPatt = KeypressData.EffectBlockIndex_CompPatt(subrunidx) +nStatic -(5-1); % index of correlation TC that corresponds to the effect block start
                corrIdxBlock_PattComp = KeypressData.EffectBlockIndex_PattComp(subrunidx) +nStatic -(5-1); % index of correlation TC that corresponds to the effect block start
                
                
                %%
                % fetch Correlations                
                                
                %Effect block 
  
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11:20) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+9,rr);
%                 
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11:20) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+9,rr);
               
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 6) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-2,rr);

                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 6) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-2,rr);
                
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
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) =...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-7:corrIdxBlock_CompPatt-3,rr);

                 corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) =...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-7:corrIdxBlock_PattComp-3,rr);
               
                %After effect block CompPatt
                
%                 if corrIdxBlock_CompPatt > 21
%                     
%                     %corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 21) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 7:11) = NaN;
%                 else
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 21) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
%                
                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 7:11) = ...
                      datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-1:corrIdxBlock_CompPatt+3,rr);
%                end  
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 16:21) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5:corrIdxBlock_CompPatt+5+5,rr);

%                 if corrIdxBlock_PattComp > 21
%                     
%                     %corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 21) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 7:11) = NaN;
%                 else
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_PattComp), 21) = ...
%                         datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
%                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 7:11) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-1:corrIdxBlock_PattComp+3,rr);
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
saveFig1Path = '/DATAPOOL/VPHYSTERESIS/DynConn_wd9';

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end
%%
xx = 1:3;


% Iterate on the ROI combinations
for cc = 1:nCombinations-3
    
    %% Spearman
    %idx = 1;
    meanCorrBlock = nan(2,4); % lines 1 Spearman, 2 Pearson, columns effects
    semCorrBlock = nan(2,4);
    meanCorrPre = nan(2,4);
    semCorrPre = nan(2,4);
    meanCorrPos = nan(2,4);
    semCorrPos = nan(2,4);
    meanCorrVols_Spearman = nan(4,11);
    semCorrVols_Spearman = nan(4,11);%lines effects, column correlations TCs
    meanCorrVols_Pearson = nan(4,11);
    semCorrVols_Pearson = nan(4,11);
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
    
    hold on
    errorbar(1:11,...
            meanCorrVols_Spearman(3,:), semCorrVols_Spearman(3,:),...
            'color',[.7 .7 .7],'linestyle','-','linewidth', 1,'markersize',20,'marker','.');
    
    for ee = 1:2   
        %subplot 211
        %hold on
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 22],[0 0],'linestyle',':','color','k') %y=0
%        e1 = errorbar([1], meanCorrPre(1,xx(ee)), semCorrPre(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
 %       e2 = errorbar([11], meanCorrBlock(1,xx(ee)), semCorrBlock(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
 %       e3 = errorbar([21], meanCorrPos(1,xx(ee)), semCorrPos(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
        e4 = errorbar(1:11, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
%         LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
%         H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
    end
    
    LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',3);
    H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
        length(corrPerEffect.(effects{1}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',3);
    H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
        length(corrPerEffect.(effects{2}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(3) = plot(nan, nan, '-' , 'color',[.7 .7 .7],'linewidth',2);
    H{3} = sprintf('%s (N=%d)',effects_plot{3}, ...
        length(corrPerEffect.(effects{3}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    hold off
    
    legend(LH(xx), H(xx),'location','southoutside', 'FontSize', 24)
    xlabel('Sliding window (L = 9)', 'FontSize', 22); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 22); 
    
    ax = gca(fig1);
    ax.XAxis.FontSize = 18;
    ax.YAxis.FontSize = 18;
    
    if length(ROIs_titles{comb(cc,2)}) > 4
        title(sprintf('%s \x2194 \n %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    else
        title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    end
    
    if cc == 26 || cc == 27 || cc == 28 %Correlation between different type of MTs
        ylim([0.2 1]);
    else
        ylim([-0.4 0.7]); %Different ROIs
    end
    
    title(sprintf('%s <--> %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}),'interpreter','none', 'FontSize', 25)
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end

%% hMT comparison plots
% xx = 1:3; %four effect
% saveFig3Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'ROI_SELECTION_FULL_RUN', 'WdSz9', 'SPEARMAN');
% 
% if ~exist(saveFig3Path, 'dir')
%     mkdir(saveFig3Path);
% end
% 
% for rr = 2 %1:5 %ROI indexes that aren't hMT
%     
%     %% Define matrixes
% %     meanCorrBlock = zeros(3,4); % lines: 1 hMT_bilateral, 2 SS_hMT_bilateral, 3 Sph_hMT_SS_bilateral, columns effects
% %     semCorrBlock = zeros(3,4);
% %     meanCorrPre = zeros(3,4);
% %     semCorrPre = zeros(3,4);
% %     meanCorrPos = zeros(3,4);
% %     semCorrPos = zeros(3,4);
%     meanCorrVols_Spearman = zeros(12,11);
%     semCorrVols_Spearman = zeros(12,11);%lines effects (1st 4 group, 5-8 SS hMT cluster, 9-12 spherical, column correlations TCs
%     deltaCorrVols_Spearman = zeros(3,11);
%     
%     %Preprare iteration
%     idx = 1; %matrix index
%     aux = 1; %subplot index
%     
%     %Open figure
%     fig3 = figure('position',[50 50 1100 900]);
%       
%     for mt = 6:8 %ROI indexes that are hMT
%             
%     % calculate means and SEM for each effect
%         for ee = xx
% 
% %             %Before effect block
% %             meanCorrPre(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan');
% %             semCorrPre(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% % 
% %             %During effect block
% %             meanCorrBlock(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11));
% %             semCorrBlock(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% % 
% %             %After effect block
% %             meanCorrPos(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,21), 'omitnan');
% %             semCorrPos(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,21), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%             %The 11 correlation volumes
%             meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan');
%             semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%         end %end ee iteration
%         
%         deltaCorrVols_Spearman(mt-5,:) = meanCorrVols_Spearman(1,:) -meanCorrVols_Spearman(2,:);
%     
%    
%         %% Plot Spearman effects 
%         subplot(2,2,aux) %Open subplot
% 
%         for ee = xx 
% 
%             hold on
%             line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
%             line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
%             line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
%             line([0 12],[0 0],'linestyle',':','color','k') %y=0
% %             e1 = errorbar([1], meanCorrPre(idx,xx(ee)), semCorrPre(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
% %             e2 = errorbar([11], meanCorrBlock(idx,xx(ee)), semCorrBlock(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
% %             e3 = errorbar([21], meanCorrPos(idx,xx(ee)), semCorrPos(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e4 = errorbar(1:11, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
%             LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
%             H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%             
%         end
% 
%         hold off
%         %Subplot properties
%         xlabel('Sliding window (N=9)', 'FontSize', 16); xlim([0 12]);
%         xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
%         ylabel('Spearman correlation', 'FontSize', 16); 
%         
%         if rr == 4 || rr == 5
%             ylim([0.1 0.6]);
%         else
%             %ylim([-0.05 0.45]);
%             ylim([-0.25 0.6]);
%         end
%         
% 
% 
%         title(sprintf('%s <--> %s',ROIs_clean{rr},ROIs_clean{mt}),'interpreter','none')
%         
%         %Prepare next iteration
%         idx = idx + 1;
%         aux = aux+1;
%         
%     end %end mt iteration
%     
% %     %Figure properties
%      legend(LH(xx), H(xx),'Position', [0.7 0.4 0.001 0.001], 'FontSize', 14);
%      saveas(fig3, fullfile(saveFig3Path,sprintf('%s WdSz10.png',ROIs_clean{rr})))     
% %     
% %     figX = figure();
% %     
% %     hold on
% %     
% %     plot(1:21, deltaCorrVols_Spearman(1,:),'color',clrMap(1,:),'linewidth', 2) %group
% %     plot(1:21, deltaCorrVols_Spearman(2,:),'color',clrMap(2,:),'linewidth', 2) %cluster
% %     plot(1:21, deltaCorrVols_Spearman(3,:),'color',clrMap(5,:),'linewidth', 2) %spherical
% %     
% %     %Auxiliar lines
% %     line([0 22],[0 0],'linestyle',':','color','k') %y=00
% %     line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
% %     line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
% %     line([21 21], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
% %     
% %     hold off
% %     
% %     legend('Spherical group hMT+', 'Cluster SS hMT+', 'Spherical SS hMT+', 'location', 'southeast')
% %     title(sprintf('NegativeHyst - PositiveHyst in %s', string(ROIs_clean(rr))), 'interpreter', 'none')
% %     xlim([0 22]); ylim([-0.33 0.4])
% %     xlabel('Sliding window'); ylabel('\DeltaHyst Spearman Correlation')
% %     xticks([1 11 21]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
% %     
%     
% end