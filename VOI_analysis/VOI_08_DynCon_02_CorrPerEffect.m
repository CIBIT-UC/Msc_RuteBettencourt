%% plot BOLD denoised signal and correlations with effect block
clear, clc, close all

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

%data = load('VOIs_trialvolumes_INSunc.mat'); 
%data = load('VOIs_trialvolumes_INScorrected.mat'); % BOLD time courses per run/sub
data = load('VOIs_trialvolumes_INSpeak.mat'); % BOLD time courses per run/sub

%datacon = load('VOI_correlationTCs_INSunc.mat');
%datacon = load('VOI_correlationTCs_INScorrected.mat'); % Correlation time courses (windowed)
datacon = load('VOI_correlationTCs_INSpeak.mat'); % Correlation time courses (windowed)

%% Define stuff

%load('VOIs_BOLD_timecourse_INSunc.mat','ROI_clean');
%load('VOIs_BOLD_timecourse_INScorrected.mat','ROI_clean');
load('VOIs_BOLD_timecourse_INSpeak.mat','ROI_clean');

nROIs = length(ROI_clean);

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

comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));

% X axis data
xx_condition = 1:21;
xx_corr = 1:17;

clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);


%% Adjust effect blocks
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt < 6) = 6;
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt > 20) = 20;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp < 6) = 6;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp > 20) = 20;

%% Count number of runs per effect
nRunsPerEffect_CompPatt = histcounts(KeypressData.Effect_CompPatt);
nRunsPerEffect_PattComp = histcounts(KeypressData.Effect_PattComp);

%% Initialize correlation matrices for all ROI pairs per effect
corrPerEffect = struct();

for cc = 1:nCombinations
    
    for ee = 1:nEffects
        
        corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson = nan(nRunsPerEffect_CompPatt(ee),11); 
        corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson = nan(nRunsPerEffect_PattComp(ee),11); 
        corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman = nan(nRunsPerEffect_CompPatt(ee),11); 
        corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman = nan(nRunsPerEffect_PattComp(ee),11); 
        
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
                
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), :) = nan(1,11);
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), :) = nan(1,11);
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), :) = nan(1,11);
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), :) = nan(1,11);

                for ii = 1:11
                    
                    idxWW_CompPatt = corrIdxBlock_CompPatt-windowSize-1+ii;
                    idxWW_PattComp = corrIdxBlock_PattComp-windowSize-1+ii;
                    
                    try
                        corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), ii) = ...
                           datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(idxWW_CompPatt,rr);
                       corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), ii) = ...
                           datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(idxWW_CompPatt,rr);
                    catch
                        disp('meh');
                    end
                    
                    try
                        corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), ii) = ...
                            datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(idxWW_PattComp,rr);
                        corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), ii) = ...
                            datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(idxWW_PattComp,rr);
                    catch
                        disp('meh');
                    end
                    
             
                end
                
%                 %Effect block 
%   
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 6:10) = ...
%                     datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+4,rr);
%                 
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 6:10) = ...
%                     datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+4,rr);
%                
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 6:10) = ...
%                     datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+4,rr);
%                 
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 6:10) = ...
%                     datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+4,rr);
%                 
%                 %Before effect block CompPatt
%                 
%                 if corrIdxBlock_CompPatt < 6
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) = NaN;
%                    
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) = NaN;
%                 
%                 else
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) =...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-5:corrIdxBlock_CompPatt-1,rr);
%                 
%                      corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 1:5) =...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt-5:corrIdxBlock_CompPatt-1,rr);
%              
%                 end
%                 
%                 %After effect block CompPatt
%                 
%                 if corrIdxBlock_CompPatt > 12
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = NaN;
%                 else
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = ...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
%                
%                     corrPerEffect.(effects{auxEffect_CompPatt}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), 11) = ...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt+5,rr);
%                 
%                     
%                 end
%                 
%                 %Before effect block PattComp
%                 
%                 if corrIdxBlock_PattComp < 6
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) = NaN;
%                    
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) = NaN;
%                 
%                 else
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) =...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp-5:corrIdxBlock_PattComp-1,rr);
%                 
%                      corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 1:5) =...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp-5:corrIdxBlock_PattComp-1,rr);
%              
%                 end
%                 
%                 %After effect block PattComp
%                 
%                 if corrIdxBlock_PattComp > 12
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = NaN;
%                     
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = NaN;
%                 else
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11) = ...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp+5,rr);
%                
%                     corrPerEffect.(effects{auxEffect_PattComp}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), 11) = ...
%                         datacon.correlationTCs.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdxBlock_PattComp+5,rr);
%                 
%                     
%                 end
%                 
                                
                % add to counters
                subrunidx = subrunidx + 1;
                
                counterPerEffect_CompPatt(auxEffect_CompPatt) = counterPerEffect_CompPatt(auxEffect_CompPatt) + 1;
                counterPerEffect_PattComp(auxEffect_PattComp) = counterPerEffect_PattComp(auxEffect_PattComp) + 1;
                
            end %runs
            
        end %subjects
        
    %% Concatenate the CompPatt and PattComp correlation values for each effect in the struct field with size
    %((NCompPatt+NPattComp) x 11)
        for ee = 1:nEffects
            corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson = ...
                [corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Pearson;...
                corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Pearson];
            
            corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman = ...
                [corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).CompPatt.Spearman;...
                corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).PattComp.Spearman];
            
        end %effects
        
        
end %ROIs

%% Save correlations in current directory, create paths to save the plots
%save('VOI_correlation_per_effect_INSunc.mat', 'corrPerEffect');
%save('VOI_correlation_per_effect_INScorrected.mat', 'corrPerEffect');
save('VOI_correlation_per_effect_INSpeak.mat', 'corrPerEffect');

%saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DYN-CORR', 'SPEARMAN', 'INS_unc');
saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DYN-CORR', 'SPEARMAN', 'INS_correction_2');
%saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DYN-CORR', 'SPEARMAN', 'INS_correction_1');

%saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DYN-CORR-p2', 'PEARSON');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

% if ~exist(saveFig2Path, 'dir')
%     mkdir(saveFig2Path);
% end



%% Plot average correlations in the Effect block
xx = 1:4;
ROIs_titles  = {'Subject-specific FEF', 'Subject-specific IPS', 'Subject-specific Anterior Insula', 'Subject-specific SPL', 'Subject-specific V3A', 'Subject-specific hMT+'};

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
        meanCorrPre(1,ee) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,1), 'omitnan');
        meanCorrPre(2,ee) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson(:,1), 'omitnan');
        
        semCorrPre(1,ee) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrPre(2,ee) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        
        %During effect block
        meanCorrBlock(1,ee) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,6));
        meanCorrBlock(2,ee) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson(:,6));
        
        semCorrBlock(1,ee) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrBlock(2,ee) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
       
        %After effect block
        meanCorrPos(1,ee) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,11), 'omitnan');
        meanCorrPos(2,ee) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson(:,11), 'omitnan');
        
        semCorrPos(1,ee) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrPos(2,ee) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

        %The 11 correlation volumes
        meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman, 'omitnan');
        meanCorrVols_Pearson(ee,:) = mean(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson, 'omitnan');
        
        semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        semCorrVols_Pearson(ee,:) = std(corrPerEffect.(effects{ee}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pearson, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

    end  
    
    %% Create structure to save mean and sem
    meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean = meanCorrVols_Spearman;
    meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem = semCorrVols_Spearman;
    
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
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})));

%     
%    
 end %Combinations
%save('VOI_meanCorrelation_INSunc.mat', 'meanCorr')
save('VOI_meanCorrelation_INSpeak.mat', 'meanCorr')
%save('VOI_meanCorrelation_INScorrected.mat', 'meanCorr')
