%% Statistical tests

clear all, close all, clc


%% load data

load('VOI_correlation_per_effect_INSunc.mat');
%load('VOI_correlation_per_effect_INScorrected.mat'); % To calculate the statistical tests
%load('VOI_correlation_per_effect_INSpeak.mat');
%load('VOIs_BOLD_timecourse_INScorrected.mat','ROI_clean'); 

load('VOI_meanCorrelation_INSunc.mat');
%load('VOI_meanCorrelation_INScorrected.mat'); % To make the plots
%load('VOI_meanCorrelation_INSpeak.mat'); % To make the plots

%load('new_stat_test.mat');
%% Define stuff
load('VOIs_BOLD_timecourse_INSunc.mat','ROI_clean');
%load('VOIs_BOLD_timecourse_INScorrected.mat','ROI_clean');
%load('VOIs_BOLD_timecourse_INSpeak.mat','ROI_clean');
ROIs_titles  = {'Subject-specific FEF', 'Subject-specific IPS', ' Subject-specific Anterior Insula',...
    'Subject-specific SPL', 'Subject-specific V3A', 'Subject-specific hMT+'};

nROIs = length(ROI_clean);


comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));


clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);

%% Wilcoxon rank sum test - point to point
alpha_bonferroni_corr = 0.05/3; %alpha/#tests
p_bonfCorr = 1 -(1-alpha_bonferroni_corr)^3;

for cc = 1:nCombinations
    
    for ii = [1 6 11] % the 11 correlation volumes considered
        
       [p(ii), h(ii)] = ranksum(corrPerEffect.NegativeHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,ii),...
           corrPerEffect.PositiveHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,ii));
 
        
    end
    
    stat.Spearman.Wilcoxon_3tests.PointToPoint.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}) = [h', p'];
    
    for ii = [1 6 11]
        if stat.Spearman.Wilcoxon_3tests.PointToPoint.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(ii,2) < p_bonfCorr
            h = 1;
            p = stat.Spearman.Wilcoxon_3tests.PointToPoint.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(ii, 2);
            stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(ii,:) = [h, p];
        else
            h = 0;
            p = stat.Spearman.Wilcoxon_3tests.PointToPoint.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(ii, 2);
            stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(ii,:) = [h, p];
        end
        
    end
end

%% Save stat file
save('VOI_stat_test_BonfCorr_INSunc.mat', 'stat');

%save('VOI_stat_test_BonfCorr_INSpeak.mat', 'stat');
%save('VOI_stat_test_BonfCorr_INScorrected.mat', 'stat');
%%
saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynConStat', 'INS unc', 'Wilcoxon test BonfCorr', 'Hyst and Null');

%saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynConStat', 'INS correction 1', 'Wilcoxon test BonfCorr', 'Hyst and Null');

%saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynConStat', 'INS correction 2', 'Wilcoxon test BonfCorr', 'Hyst and Null');


if ~exist(saveFig2Path, 'dir')
    mkdir(saveFig2Path);
end

saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynConStat', 'INS unc', 'Wilcoxon test BonfCorr');

%saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynConStat', 'INS correction 1', 'Wilcoxon test BonfCorr');

%saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynConStat', 'INS correction 2', 'Wilcoxon test BonfCorr');


if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

%load('new_stat_test.mat')

%% Hysteresis and nulls

for cc = 1:nCombinations %Last 3 are MT - MT correlations
%for cc =  [8 11 12 13 14 20 21 22]    
%for cc = 18
    %% Plot Effects 
    fig2 = figure('position',[50 50 1100 900]); 
    
    hold on
    errorbar(1:11,...
            meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(3,:),...
            meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(3,:),...
            'color',[.7 .7 .7],'linestyle','-','linewidth', 1,'markersize',20,'marker','.');
        
    for ee = 1:nEffects-2 %Positive and Negative Hysteresis   
      
        
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 16],[0 0],'linestyle',':','color','k') %y=0
        
        e4 = errorbar(1:11,...
            meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(ee,:),...
            meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(ee,:),...
            'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 3,'markersize',20,'marker','.');
    end

    
    % Plot statistical data
    for wdIdx = [1 6 11]
       if stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1
           
           plot(wdIdx, 0.65, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
           
       end
    end
    LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',3);
    H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
        length(corrPerEffect.(effects{1}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',3);
    H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
        length(corrPerEffect.(effects{2}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(3) = plot(nan, nan, '-' , 'color',[.7 .7 .7],'linewidth',2);
    H{3} = sprintf('%s (N=%d)',effects_plot{3}, ...
        length(corrPerEffect.(effects{3}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(4) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2);
    H{4} = 'p < 0.05 (Bonferroni corrected)';
    
    hold off
    ax = gca(fig2);
    ax.XAxis.FontSize = 18;
    ax.YAxis.FontSize = 18;
    
    if length(ROIs_titles{comb(cc,2)}) > 4
        title(sprintf('%s \x2194 \n %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    else
        title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    end
    
    legend(LH, H,'location','southoutside', 'FontSize', 24, 'NumColumns', 2)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 22); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 22); ylim([-0.2 0.75]);
    
   % set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 7.48 10])
    %print(fig2, fullfile(saveFig2Path,sprintf('%s-%s',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})), '-deps2', '-r300')
    saveas(fig2, fullfile(saveFig2Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})));
   %print(gcf, fullfile(saveFig2Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})), '-dpng', '-r300');
    %saveas(gcf, fullfile(saveFig2Path,sprintf('%s-%s',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})), 'bmp')
end

%% Hysteresis

for cc = 1:nCombinations %Last 3 are MT - MT correlations
%for cc =  [8 11 12 13 14 20 21 22]    
%for cc = 18
    %% Plot Effects 
    fig1 = figure('position',[50 50 1100 900]); 
    
        
    for ee = 1:nEffects-2 %Positive and Negative Hysteresis   
        hold on
        
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 16],[0 0],'linestyle',':','color','k') %y=0
        
        e4 = errorbar(1:11,...
            meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(ee,:),...
            meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(ee,:),...
            'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',20,'marker','.');
    end

    
    % Plot statistical data
    for wdIdx = 1:11
       if stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1
           
           plot(wdIdx, 0.8, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
           
       end
    end
    
    LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',2);
    H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
        length(corrPerEffect.(effects{1}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',2);
    H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
        length(corrPerEffect.(effects{2}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
%     LH(3) = plot(nan, nan, '-' , 'color',[.7 .7 .7],'linewidth',1);
%     H{3} = sprintf('%s (N=%d)',effects_plot{3}, ...
%        length(corrPerEffect.(effects{3}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(3) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2);
    H{3} = 'p < 0.05 (Bonferroni corrected)';
    
    hold off
    ax = gca(fig1);
    ax.XAxis.FontSize = 18;
    ax.YAxis.FontSize = 18;
    
    if length(ROIs_titles{comb(cc,2)}) > 4
        title(sprintf('%s \x2194 \n %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    else
        title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    end
    
    legend(LH(1:3), H(1:3),'location','southoutside', 'FontSize', 24)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 22); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 22); ylim([-0.2 0.75]);
    %print(gcf, fullfile(saveFig1Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})), '-dpng', '-r300');
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})));
end