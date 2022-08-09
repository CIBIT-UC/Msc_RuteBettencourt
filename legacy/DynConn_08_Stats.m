%% Statistical tests

clear all, close all, clc


%% load data

%KeypressData = load('Hysteresis-keypress-label-data.mat');

%data = load('new_trialvolumes_p2.mat'); % BOLD time courses per run/sub

%datacon = load('correlationTCs_p2.mat'); % Correlation time courses (windowed)

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

%% Wilcoxon rank sum test - point to point

for cc = 1:nCombinations
    
    for ii = 1:11 % the 11 correlation volumes considered
        
       [p(ii), h(ii)] = ranksum(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii),...
           corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));
    
    end
    
    stat.Spearman.Wilcoxon.PointToPoint.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}) = [h', p'];
end

%% Save stat file
save('new_stat_test.mat', 'stat');

%%
saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynConStat', 'PointToPoint', 'Wilcoxon test', 'Hyst and Null', 'paper');


if ~exist(saveFig2Path, 'dir')
    mkdir(saveFig2Path);
end

saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynConStat', 'PointToPoint', 'Wilcoxon test');


if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

load('new_stat_test.mat')

%% Hysteresis and nulls

for cc = 1:nCombinations-3 %Last 3 are MT - MT correlations
%for cc =  [8 11 12 13 14 20 21 22]    
%for cc = 18
    %% Plot Effects 
    fig2 = figure(); %figure('position',[50 50 1100 900]); 
    %fig2.Units = 'centimeters';
    %fig2.Position = [1 1 7.48 6.12];
    hold on
    errorbar(1:11,...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(3,:),...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).sem(3,:),...
            'color',[.7 .7 .7],'linestyle','-','linewidth', 1,'markersize',20,'marker','.');
        
    for ee = 1:nEffects-2 %Positive and Negative Hysteresis   
      
        
        line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
        line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
        line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
        line([0 16],[0 0],'linestyle',':','color','k') %y=0
        
        e4 = errorbar(1:11,...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(ee,:),...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).sem(ee,:),...
            'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',20,'marker','.');
    end

    
    % Plot statistical data
    for wdIdx = 1:11
       if stat.Spearman.Wilcoxon.PointToPoint.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(wdIdx, 1) == 1
           
           plot(wdIdx, 0.6, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
           
       end
    end
    LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',2);
    H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
        length(corrPerEffect.(effects{1}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',2);
    H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
        length(corrPerEffect.(effects{2}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(3) = plot(nan, nan, '-' , 'color',[.7 .7 .7],'linewidth',1);
    H{3} = sprintf('%s (N=%d)',effects_plot{3}, ...
        length(corrPerEffect.(effects{3}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(4) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2);
    H{4} = 'p < 0.05';
    
    hold off
    ax = gca(fig2);
    ax.XAxis.FontSize = 12; %16
    ax.YAxis.FontSize = 12; %16
    
    if length(ROIs_titles{comb(cc,2)}) > 4
        title(sprintf('%s \x2194 \n %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 18) %24
    else
        title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 18) %24
    end
    
    legend(LH, H,'location','southoutside', 'FontSize', 16, 'NumColumns', 2) % 24
    
    xlabel('Sliding window (L = 5)', 'FontSize', 14); xlim([0 12]); % 14
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 14); ylim([-0.2 0.7]); % 20
    
%     set(gcf, 'PaperUnits', 'centimeters');
%     set(gcf, 'PaperPosition', [0 0 7.48 6.12]);
    %saveas(fig2, fullfile(saveFig2Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
    print(gcf, fullfile(saveFig2Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})), '-dpng', '-r300');
end

%% Hysteresis

for cc = 1:nCombinations-3 %Last 3 are MT - MT correlations
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
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(ee,:),...
            meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).sem(ee,:),...
            'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2,'markersize',20,'marker','.');
    end

    
    % Plot statistical data
    for wdIdx = 1:11
       if stat.Spearman.Wilcoxon.PointToPoint.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(wdIdx, 1) == 1
           
           plot(wdIdx, 0.6, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
           
       end
    end
    
    LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',2);
    H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
        length(corrPerEffect.(effects{1}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',2);
    H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
        length(corrPerEffect.(effects{2}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
%     LH(3) = plot(nan, nan, '-' , 'color',[.7 .7 .7],'linewidth',1);
%     H{3} = sprintf('%s (N=%d)',effects_plot{3}, ...
%        length(corrPerEffect.(effects{3}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    LH(3) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2);
    H{3} = 'p < 0.05';
    
    hold off
    ax = gca(fig1);
    ax.XAxis.FontSize = 16;
    ax.YAxis.FontSize = 16;
    
    if length(ROIs_titles{comb(cc,2)}) > 4
        title(sprintf('%s \x2194 \n %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 24)
    else
        title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 24)
    end
    
    legend(LH, H,'location','southoutside', 'FontSize', 24, 'NumColumns', 2)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.2 0.7]);
    
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end