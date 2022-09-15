%%
clear all, close all, clc

%% Load data
load('correlation_per_effect_p2.mat'); % To calculate the statistical tests

load('meanCorrelation.mat'); % To make the plots
load('stat_test_BonfCorr.mat');
%% Define stuff


load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');
ROIs_titles  = {'FEF', 'IPS', 'Anterior Insula', 'SPL', 'V3A', 'Group hMT+',...
    'Subject-specific cluster-based hMT+','Subject-specific spherical hMT+'};

nROIs = length(ROIs_clean);


comb = combnk(1:8,2);

nCombinations = length(comb(:,1));


clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);

%%
saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynCon_ConnMatrix');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

%% Pre-effect block
auxMat = nan(nROIs);

for rr = 1:nROIs-1
    
    
    for idx = rr+1:nROIs
        
        auxMat(idx, rr) = stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROIs_clean{rr}).(ROIs_clean{idx})(1,2);
        
    end
     
    
end
corr_lower = tril(auxMat, -1);

corr_upper = corr_lower';
corr = corr_lower +corr_upper;

fig = figure;
set(gcf, 'Position', [50 50 1100 900]);
 
im = imagesc(corr, [0 1]);
h = colorbar('eastoutside');
xlabel(h, 'p-value', 'FontSize', 20);

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
        
        auxMat(idx, rr) = stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROIs_clean{rr}).(ROIs_clean{idx})(6,2);
        
    end
     
    
end
corr_lower = tril(auxMat, -1);

corr_upper = corr_lower';
corr = corr_lower +corr_upper;

fig = figure;
set(gcf, 'Position', [50 50 1100 900]);
% 
im = imagesc(corr, [0 1]);
h = colorbar('eastoutside');
xlabel(h, 'p-value', 'FontSize', 20);

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
        
        auxMat(idx, rr) = stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROIs_clean{rr}).(ROIs_clean{idx})(11,2);
        
    end
     
    
end
corr_lower = tril(auxMat, -1);

corr_upper = corr_lower';
corr = corr_lower +corr_upper;

fig = figure;
set(gcf, 'Position', [50 50 1100 900]);
% 
im = imagesc(corr, [0 1]);
h = colorbar('eastoutside');
xlabel(h, 'p-value', 'FontSize', 20);

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