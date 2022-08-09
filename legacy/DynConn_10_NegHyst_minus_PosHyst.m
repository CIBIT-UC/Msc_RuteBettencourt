%% NegHyst-PosHyst

clear all, close all, clc

%% load data

KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes_p2.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs_p2.mat'); % Correlation time courses (windowed)

load('correlation_per_effect_p2.mat'); % To calculate the statistical tests

load('meanCorrelation.mat'); % To make the plots

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
%% Make directory to save plots

saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynCon_Difference');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

%%
for cc = 1:nCombinations-3
%for cc =  [8 11 12 13 14 20 21 22]    
    
    %NegHyst-PosHyst
    difference = meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,:)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,:);
    
    
    
    %% Plot Effects 
    fig1 = figure('position',[50 50 1100 900]); 
    
    for ee = 1:2 %Positive and Negative Hysteresis   
      
        hold on
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 16],[0 0],'linestyle',':','color','k') %y=0
        
        e4 = errorbar(1:11,...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(ee,:),...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).sem(ee,:),...
            'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',20,'marker','.', 'HandleVisibility', 'off');
        
         LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
         H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, ...
             length(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    end

    plot(1:11, difference, '--k', 'LineWidth', 2);
    LH(ee+1) = plot(nan, nan, '--k', 'LineWidth', 2);
    H{ee+1} = sprintf('Negative Hysteresis - Positive Hysteresis'); 
    
    hold off
    
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    
    legend(LH, H, 'Fontsize', 16, 'Location', 'southoutside');
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.35 0.7]);
    
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end