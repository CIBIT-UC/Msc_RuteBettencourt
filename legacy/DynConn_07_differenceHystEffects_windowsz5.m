%% plot BOLD denoised signal and correlations with effect block
clear all, clc, close all

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes_p2.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs_p2.mat'); % Correlation time courses (windowed)

load('correlation_per_effect_p2.mat'); % To calculate the statistical tests

load('meanCorrelation.mat'); % To make the plots
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

effects = {'NegativeHyst', 'PositiveHyst'};
nEffects = length(effects);

%% Count number of runs per effect
nRunsPerEffect_CompPatt = histcounts(KeypressData.Effect_CompPatt);
nRunsPerEffect_PattComp = histcounts(KeypressData.Effect_PattComp);

%% hMT comparison plots
xx = 1:2; %four effect

%% Create path for saving figures
saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DELTAHYST', 'SPEARMAN');
saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DELTAHYST', 'PEARSON');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

if ~exist(saveFig2Path, 'dir')
    mkdir(saveFig2Path);
end

%%
for rr = 1:5 %ROI indexes that aren't hMT
    
    %% Define matrixes
    meanCorrBlock = zeros(3,2); % lines: 1 hMT_bilateral, 2 SS_hMT_bilateral, 3 Sph_hMT_SS_bilateral, columns effects
    semCorrBlock = zeros(3,2);
    meanCorrPre = zeros(3,2);
    semCorrPre = zeros(3,2);
    meanCorrPos = zeros(3,2);
    semCorrPos = zeros(3,2);
    meanCorrVols_Spearman = zeros(6,11);
    semCorrVols_Spearman = zeros(6,11);%lines effects (1st 2 group, 3-4 SS hMT cluster, 5-6 spherical, column correlations TCs
    deltaCorrVols_Spearman = zeros(3,11); % difference of the mean correlation Negative - Positive
    semdeltaCorrVols_Spearman = zeros(3,11);
    %Preprare iteration
    idx = 1; %matrix index
   
          
    for mt = 6:8 %ROI indexes that are hMT
            
    % calculate means and SEM for each effect
        for ee = 1:nEffects

            %Before effect block
            meanCorrPre(idx,ee) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan');
            semCorrPre(idx,ee) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

            %During effect block
            meanCorrBlock(idx,ee) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,6));
            semCorrBlock(idx,ee) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

            %After effect block
            meanCorrPos(idx,ee) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11), 'omitnan');
            semCorrPos(idx,ee) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

            %The 11 correlation volumes
            meanCorrVols_Spearman(ee,:) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan');
            semCorrVols_Spearman(ee,:) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

        end %end ee iteration
        
        deltaCorrVols_Spearman(mt-5,:) = meanCorrVols_Spearman(1,:) -meanCorrVols_Spearman(2,:);
 %       semdeltaCorrVols_Spearman(mt-5,:) = semCorrVols_Spearman(1,:)
 %       -semCorrVols_Spearman(2,:);  <<<<<<<<CHECK
    end
    
    fig1 = figure();
    
    hold on
    
     plot(1:11, deltaCorrVols_Spearman(1,:),'color',clrMap(12,:),'linewidth', 2) %group
     plot(1:11, deltaCorrVols_Spearman(2,:),'color',clrMap(14,:),'linewidth', 2) %cluster
     plot(1:11, deltaCorrVols_Spearman(3,:),'color',clrMap(15,:),'linewidth', 2) %spherical
% 
%     e1 = errorbar([1:11], deltaCorrVols_Spearman(1,:), semdeltaCorrVols_Spearman(1,:),'color',clrMap(12,:),'linestyle','-','markersize',20,'marker','.')
%     e2 = errorbar([1:11], deltaCorrVols_Spearman(2,:), semdeltaCorrVols_Spearman(2,:),'color',clrMap(14,:),'linestyle','-','markersize',20,'marker','.')
%     e1 = errorbar([1:11], deltaCorrVols_Spearman(3,:), semdeltaCorrVols_Spearman(3,:),'color',clrMap(15,:),'linestyle','-','markersize',20,'marker','.')
    
    %Auxiliar lines
    line([0 11],[0 0],'linestyle',':','color','k') %y=00
    line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
    line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
    line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
    
    hold off
    
    legend('Spherical group hMT+', 'Cluster SS hMT+', 'Spherical SS hMT+', 'location', 'southeast')
    title(sprintf('NegativeHyst - PositiveHyst in %s', string(ROIs_clean(rr))), 'interpreter', 'none')
    xlim([0 12]); ylim([-0.33 0.4])
    xlabel('Sliding window'); ylabel('\DeltaHyst Spearman Correlation')
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    %saveas(fig1, fullfile(saveFig1Path,sprintf('dHyst-%s.png',ROIs_clean{rr})));
    
    %% Pearson
    
    %Define matrixes
    meanCorrBlock = zeros(3,2); % lines: 1 hMT_bilateral, 2 SS_hMT_bilateral, 3 Sph_hMT_SS_bilateral, columns effects
    semCorrBlock = zeros(3,2);
    meanCorrPre = zeros(3,2);
    semCorrPre = zeros(3,2);
    meanCorrPos = zeros(3,2);
    semCorrPos = zeros(3,2);
    meanCorrVols_Pearson = zeros(6,11);
    semCorrVols_Pearson = zeros(6,11);
    deltaCorrVols_Pearson = zeros(3,11);

    %Prepare iteration
    idx = 1; %For the different mts
    
    %Open figure for Pearson correlation
        
    for mt = 6:8 %ROIindexes that are hMT
            
    % calculate means and SEM for each effect
        for ee = 1:nEffects

            %Before effect block
            meanCorrPre(idx,ee) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,1), 'omitnan');
            semCorrPre(idx,ee) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,1), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
          
            %During effect block
            meanCorrBlock(idx,ee) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,6), 'omitnan');
            semCorrBlock(idx,ee) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,6)) / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
           
            %After effect block
            meanCorrPos(idx,ee) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,11), 'omitnan');
            semCorrPos(idx,ee) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson(:,11), 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
            
            %The 11 correlation volumes
            meanCorrVols_Pearson(ee,:) = mean(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson, 'omitnan');
            semCorrVols_Pearson(ee,:) = std(datacorr.corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Pearson, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
            
        end %end ee iteration
        
        deltaCorrVols_Pearson(mt-5, :) = meanCorrVols_Pearson(1,:) - meanCorrVols_Pearson(2,:);

    end %end mt iteration
    
    fig2 = figure();
    
    hold on
    
    plot(1:11, deltaCorrVols_Pearson(1,:),'color',clrMap(1,:),'linewidth', 2) %group
    plot(1:11, deltaCorrVols_Pearson(2,:),'color',clrMap(2,:),'linewidth', 2) %cluster
    plot(1:11, deltaCorrVols_Pearson(3,:),'color',clrMap(5,:),'linewidth', 2) %spherical
    %Auxiliar lines
    line([0 11],[0 0],'linestyle',':','color','k') %y=00
    line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
    line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
    line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
    
    hold off
    legend('Spherical group hMT+', 'Cluster SS hMT+', 'Spherical SS hMT+', 'location', 'southeast')
    title(sprintf('NegativeHyst - PositiveHyst in %s', string(ROIs_clean(rr))), 'interpreter', 'none')
    xlim([0 12]); ylim([-0.33 0.4])
    xlabel('Sliding window'); ylabel('\DeltaHyst Pearson Correlation')
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    
    %saveas(fig2, fullfile(saveFig2Path,sprintf('dHyst-%s.png',ROIs_clean{rr})));
    
end %end rr iteration
