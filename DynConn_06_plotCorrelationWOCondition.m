%% plot BOLD denoised signal and correlations with effect block
clear, clc, close all

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes_p2.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs_p2.mat'); % Correlation time courses (windowed)

%% Define stuff

load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');
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

comb = combnk(1:8,2);

nCombinations = length(comb(:,1));

% X axis data
xx_condition = 1:21;
xx_corr = 1:17;

clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);
%markers = {'v','+','o','s'}; % one for each effect (neg hyst, pos hyst, null, undefined)

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
                
            end %runs
            
        end %subjects
    %% Concatenate the CompPatt and PattComp correlation values for each effect in the struct field with size
    %((NCompPatt+NPattComp) x 11)
        for ee = 1:nEffects
            corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson = ...
                [corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson;...
                corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson];
            
            corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman = ...
                [corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman;...
                corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman];
            
        end %effects
        
        
end %ROIs

%% Save correlations in current directory, create paths to save the plots
save('correlation_per_effect_p2.mat', 'corrPerEffect');
saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DYN-CORR-p2', 'SPEARMAN');
saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DYN-CORR-p2', 'PEARSON');
saveFig3Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'hMT-COMPARISON', 'SPEARMAN');
saveFig4Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'hMT-COMPARISON', 'Pearson');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

if ~exist(saveFig2Path, 'dir')
    mkdir(saveFig2Path);
end

if ~exist(saveFig3Path, 'dir')
    mkdir(saveFig3Path);
end

if ~exist(saveFig4Path, 'dir')
    mkdir(saveFig4Path);
end

%% Plot average correlations in the Effect block
xx = 1:4;
ROIs_titles  = {'FEF', 'IPS', 'Anterior Insula', 'SPL', 'V3A', 'Group hMT+', 'Subject-specific cluster-based hMT+', 'Subject-specific spherical hMT+'};

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
    meanCorrVols_Spearman = zeros(4,11);
    semCorrVols_Spearman = zeros(4,11);%lines effects, column correlations TCs
    meanCorrVols_Pearson = zeros(4,11);
    semCorrVols_Pearson = zeros(4,11);
%%    
    
    % calculate means and SEM for each effect
    for ee = 1:nEffects
        
        %Before effect block
        meanCorrPre(1,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1), 'omitnan');
        meanCorrPre(2,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,1), 'omitnan');
        
        semCorrPre(1,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrPre(2,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        
        %During effect block
        meanCorrBlock(1,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,6));
        meanCorrBlock(2,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,6));
        
        semCorrBlock(1,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrBlock(2,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
       
        %After effect block
        meanCorrPos(1,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11), 'omitnan');
        meanCorrPos(2,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,11), 'omitnan');
        
        semCorrPos(1,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrPos(2,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

        %The 11 correlation volumes
        meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman, 'omitnan');
        meanCorrVols_Pearson(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson, 'omitnan');
        
        semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrVols_Pearson(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

    end  
    
    %% Create structure to save mean and sem
    meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean = meanCorrVols_Spearman;
    meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).sem = semCorrVols_Spearman;
    
    %% Plot Effects 
    fig1 = figure('position',[50 50 1100 900]);
    for ee = 1:nEffects-1 %Positive and Negative Hysteresis   
        %subplot 211
        hold on
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 16],[0 0],'linestyle',':','color','k') %y=0
        e1 = errorbar([1], meanCorrPre(1,xx(ee)), semCorrPre(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
        e2 = errorbar([6], meanCorrBlock(1,xx(ee)), semCorrBlock(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
        e3 = errorbar([11], meanCorrPos(1,xx(ee)), semCorrPos(1,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
        e4 = errorbar(1:11, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
    end

    hold off
    legend(LH, H,'location','southeast', 'FontSize', 20)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); 
    
    if cc == 26 || cc == 27 || cc == 28 %Correlation between different type of MTs
        ylim([0.2 1]);
    else
        ylim([-0.2 0.7]); %Different ROIs
    end
    
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    %title('SPL <--> Subject-specific spherical hMT+', 'FontSize', 20)
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
    
%     %% Plot Effects Pearson 
%     fig2 = figure('Position', [50 50 1100 900])    
%     
%     for ee = 1:nEffects-2
%         
%         hold on
%         line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x=1
%         line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x=6
%         line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x=11
%         line([0 16],[0 0],'linestyle',':','color','k') %y=0
%         e1 = errorbar([1], meanCorrPre(2,xx(ee)), semCorrPre(2,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%         e2 = errorbar([6], meanCorrBlock(2,xx(ee)), semCorrBlock(2,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%         e3 = errorbar([11], meanCorrPos(2,xx(ee)), semCorrPos(2,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%         e4 = errorbar(1:11, meanCorrVols_Pearson(ee,:), semCorrVols_Pearson(ee,:),'color',clrMap(6+3*ee,:), 'linestyle', '-', 'linewidth', 2, 'markersize', 1, 'marker', '.');
%         LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
%         H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%     end
%     
%     hold off
%     legend(LH, H,'location','southeast', 'FontSize', 20)
%     xlabel('Sliding window (N = 5)', 'FontSize', 20); xlim([0 12]);
%     xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
%     ylabel('Pearson correlation', 'FontSize', 20); 
%     if cc == 26 || cc == 27 || cc == 28
%         ylim([0.2 1]);
%     else
%         ylim([-0.2 0.7]);
%     end
%     
%     title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}),'FontSize', 20)
%     
%     saveas(fig2, fullfile(saveFig2Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
%     
%    
 end %Combinations
% 
% %%
% save('correlation_per_effect_p2.mat', 'corrPerEffect');
% save('meanCorrelation.mat', 'meanCorr')
% %% hMT comparison plots
% xx = 1:3; %four effect
% 
% 
% for rr = 1:5 %ROI indexes that aren't hMT
%     
%     %% Define matrixes
%     meanCorrBlock = zeros(3,4); % lines: 1 hMT_bilateral, 2 SS_hMT_bilateral, 3 Sph_hMT_SS_bilateral, columns effects
%     semCorrBlock = zeros(3,4);
%     meanCorrPre = zeros(3,4);
%     semCorrPre = zeros(3,4);
%     meanCorrPos = zeros(3,4);
%     semCorrPos = zeros(3,4);
%     meanCorrVols_Spearman = zeros(12,11);
%     semCorrVols_Spearman = zeros(12,11);%lines effects (1st 4 group, 5-8 SS hMT cluster, 9-12 spherical, column correlations TCs
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
%             %Before effect block
%             meanCorrPre(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan');
%             semCorrPre(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%             %During effect block
%             meanCorrBlock(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,6));
%             semCorrBlock(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%             %After effect block
%             meanCorrPos(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11), 'omitnan');
%             semCorrPos(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%             %The 11 correlation volumes
%             meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan');
%             semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
% 
%         end %end ee iteration
%         
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
%             line([0 16],[0 0],'linestyle',':','color','k') %y=0
%             e1 = errorbar([1], meanCorrPre(idx,xx(ee)), semCorrPre(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e2 = errorbar([6], meanCorrBlock(idx,xx(ee)), semCorrBlock(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e3 = errorbar([11], meanCorrPos(idx,xx(ee)), semCorrPos(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e4 = errorbar(1:11, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
%             LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
%             H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%             
%         end
% 
%         hold off
%         %Subplot properties
%         xlabel('Sliding window (N=5)', 'FontSize', 20); xlim([0 12]);
%         xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
%         ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.25 0.65]);
% 
% %         if rr == 4 || rr == 5
% %             ylim([0.1 0.6]);
% %         else
% %             ylim([-0.05 0.45]);
% %         end
%         title(sprintf('%s \x2194 %s',ROIs_titles{rr},ROIs_titles{mt}), 'FontSize', 20)
%         
%         %Prepare next iteration
%         idx = idx + 1;
%         aux = aux+1;
%         
%     end %end mt iteration
%     
%     %Figure properties
%     legend(LH(xx), H(xx),'Position', [0.7 0.4 0.001 0.001], 'FontSize', 20);
%     saveas(fig3, fullfile(saveFig3Path,sprintf('%s.png',ROIs_clean{rr})));
%     
%     
%     %% Pearson
%     
%     %Define matrixes
%     meanCorrBlock = zeros(3,4); % lines: 1 hMT_bilateral, 2 SS_hMT_bilateral, 3 Sph_hMT_SS_bilateral, columns effects
%     semCorrBlock = zeros(3,4);
%     meanCorrPre = zeros(3,4);
%     semCorrPre = zeros(3,4);
%     meanCorrPos = zeros(3,4);
%     semCorrPos = zeros(3,4);
%     meanCorrVols_Pearson = zeros(12,11);
%     semCorrVols_Pearson = zeros(12,11);
%     
%     %Prepare iteration
%     idx = 1; %For the different mts
%     aux = 1; %For the subplot position
%     
%     %Open figure for Pearson correlation
%     fig4 = figure('position',[50 50 1100 900]);
%     
%     for mt = 6:8 %ROIindexes that are hMT
%             
%     % calculate means and SEM for each effect
%         for ee = 1:nEffects
% 
%             %Before effect block
%             meanCorrPre(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,1), 'omitnan');
%             semCorrPre(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%           
%             %During effect block
%             meanCorrBlock(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,6), 'omitnan');
%             semCorrBlock(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%            
%             %After effect block
%             meanCorrPos(idx,ee) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,11), 'omitnan');
%             semCorrPos(idx,ee) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%             
%             %The 11 correlation volumes
%             meanCorrVols_Pearson(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson, 'omitnan');
%             semCorrVols_Pearson(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%             
%         end %end ee iteration
%         
%         %% Plot Effects 
%         subplot(2,2,aux) %open subplot
% 
%         for ee = xx  
% 
%             hold on
%             line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
%             line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
%             line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
%             line([0 16],[0 0],'linestyle',':','color','k') %y=0
%             e1 = errorbar([1], meanCorrPre(idx,xx(ee)), semCorrPre(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e2 = errorbar([6], meanCorrBlock(idx,xx(ee)), semCorrBlock(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e3 = errorbar([11], meanCorrPos(idx,xx(ee)), semCorrPos(idx,xx(ee)),'color',clrMap(6+3*ee,:),'linestyle','none','markersize',20,'marker','.');
%             e4 = errorbar(1:11, meanCorrVols_Pearson(ee,:), semCorrVols_Pearson(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',1,'marker','.');
%             LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
%             H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
%             
%         end %end ee iteration
% 
%         hold off
%         %Subplot properties
%         xlabel('Sliding window (N = 5)', 'FontSize', 20); xlim([0 12]);
%         xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
%         ylabel('Pearson correlation', 'FontSize', 20); ylim([-0.25 0.65]);
% 
% 
%         title(sprintf('%s \x2194 %s',ROIs_titles{rr},ROIs_titles{mt}), 'FontSize', 20)
%         
%         %preprare next iteration
%         idx = idx + 1;
%         aux = aux+1;
%         
%         
%     end %end mt iteration
%     
%     %Figure properties
%     legend(LH(xx), H(xx),'Position', [0.7 0.4 0.001 0.001], 'FontSize', 20);
%     saveas(fig4, fullfile(saveFig4Path,sprintf('%s.png',ROIs_clean{rr})));
% 
% end %end rr iteration
