%%
clear all, close all, clc

%% Load data
load('VOI_stat_test_BonfCorr_INSunc.mat');
%% Define stuff

load('VOIs_BOLD_timecourse_INSunc.mat','ROI_clean')
ROIs_titles  = {'Subject-specific FEF', 'Subject-specific IPS', ' Subject-specific Anterior Insula',...
    'Subject-specific SPL', 'Subject-specific V3A', 'Subject-specific hMT+'};


nROIs = length(ROI_clean);


comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));


clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);

%%
%saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI_ConnMatrix');
saveFig1Path = 'C:\Users\User\Desktop\5ano\Projeto\Connectivity_matrix\VOI_DynConn';
if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

%% Pre-effect block
auxMat = nan(nROIs);

for rr = 1:nROIs-1
    
    
    for idx = rr+1:nROIs
        
        auxMat(idx, rr) = stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{rr}).(ROI_clean{idx})(1,2);
        
    end
     
    
end
corr_lower = tril(auxMat, -1);

corr_upper = corr_lower';
corr = corr_lower +corr_upper;
aux = eye(6);
aux(eye(6)==1) = nan;
corr = corr+aux;

fig = figure;
set(gcf, 'Position', [50 50 1100 900]);
 
%im = imagesc(corr, [0 1]);
imAlpha=ones(size(corr));
imAlpha(isnan(corr))=0;
imagesc(corr,'AlphaData',imAlpha);
set(gca,'color',[1 1 1]);

h = colorbar('eastoutside');
xlabel(h, 'p-value', 'FontSize', 20);
caxis([0 1])

% Title
title('Pre-effect block')
% Axis
set(gca, 'XTick', (1:nROIs));
set(gca, 'YTick', (1:nROIs));
set(gca, 'Ticklength', [0 0]);
grid off
box off

% Labels
set(gca, 'XTickLabel', ROIs_titles, 'XTickLabelRotation', 45, 'FontSize', 20, 'defaultAxesTickLabelInterpreter', 'latex');
set(gca, 'YTickLabel', ROIs_titles, 'FontSize', 20);
saveas(fig, fullfile(saveFig1Path,'pre-effect-block.png'));

%% Effect Block
auxMat = nan(nROIs);

for rr = 1:nROIs-1
    
    
    for idx = rr+1:nROIs
        
        auxMat(idx, rr) = stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{rr}).(ROI_clean{idx})(6,2);
        
    end
     
    
end
corr_lower = tril(auxMat, -1);

corr_upper = corr_lower';
corr = corr_lower +corr_upper;
aux = eye(6);
aux(eye(6)==1) = nan;
corr = corr+aux;

fig = figure;
set(gcf, 'Position', [50 50 1100 900]);
% 
%im = imagesc(corr, [0 1]);
imAlpha=ones(size(corr));
imAlpha(isnan(corr))=0;
imagesc(corr,'AlphaData',imAlpha);
set(gca,'color',[1 1 1]);
h = colorbar('eastoutside');
xlabel(h, 'p-value', 'FontSize', 20);
caxis([0 1])

% Title
title('Effect block')
% Axis
set(gca, 'XTick', (1:nROIs));
set(gca, 'YTick', (1:nROIs));
set(gca, 'Ticklength', [0 0]);
grid off
box off

% Labels
set(gca, 'XTickLabel', ROIs_titles, 'XTickLabelRotation', 45, 'FontSize', 20, 'defaultAxesTickLabelInterpreter', 'latex');
set(gca, 'YTickLabel', ROIs_titles, 'FontSize', 20);
saveas(fig, fullfile(saveFig1Path,'effect-block.png'));


%% Effect Block
auxMat = nan(nROIs);

for rr = 1:nROIs-1
    
    
    for idx = rr+1:nROIs
        
        auxMat(idx, rr) = stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{rr}).(ROI_clean{idx})(11,2);
        
    end
     
    
end
corr_lower = tril(auxMat, -1);

corr_upper = corr_lower';
corr = corr_lower +corr_upper;
aux = eye(6);
aux(eye(6)==1) = nan;
corr = corr+aux;

fig = figure;
set(gcf, 'Position', [50 50 1100 900]);
% 
%im = imagesc(corr, [0 1]);
imAlpha=ones(size(corr));
imAlpha(isnan(corr))=0;
imagesc(corr,'AlphaData',imAlpha);
set(gca,'color',[1 1 1]);
h = colorbar('eastoutside');
xlabel(h, 'p-value', 'FontSize', 20);
caxis([0 1])

% Title
title('Post-effect block')
% Axis
set(gca, 'XTick', (1:nROIs));
set(gca, 'YTick', (1:nROIs));
set(gca, 'Ticklength', [0 0]);
grid off
box off

% Labels
set(gca, 'XTickLabel', ROIs_titles, 'XTickLabelRotation', 45, 'FontSize', 20, 'defaultAxesTickLabelInterpreter', 'latex');
set(gca, 'YTickLabel', ROIs_titles, 'FontSize', 20);
saveas(fig, fullfile(saveFig1Path,'post-effect-block.png'));