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

%% Normality test (Kolmogorov-Smirnov) (point-to-point)

for cc = 1:nCombinations
    
    for ii = 1:11 % the 11 correlation volumes considered
        
       [hn(ii), pn(ii)] = kstest(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));

       [hp(ii), pp(ii)] = kstest(corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));
    
    end
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).KStest.PointToPoint.Neg = [hn', pn'];
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).KStest.PointToPoint.Pos = [hp', pp'];
end

%% Normality test (Kolmogorov-Smirnov)
for cc = 1:nCombinations
    
    [hn, pn] = kstest(meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,:)');
        
    
    [hp, pp] = kstest(meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,:)');
    
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).KStest.Curve.Neg = [hn', pn'];
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).KStest.Curve.Pos = [hp', pp'];
end


%% Wilcoxon rank sum test - between curves

for cc = 1:nCombinations
    
    
        
    [p, h] = ranksum(meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,:)',...
           meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,:)');
    
    
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Wilcoxon.Curve = [h', p'];
end

%% t-test - between curves

for cc = 1:nCombinations
    
    
        
    [h, p] = ttest(meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,:)',...
           meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,:)');
    
    
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).ttestBilateral.Curve = [h', p'];
end

%% Two sample t-tests (bilateral tail) - point-to-point
%H0: Negative and Positive Hysteresis come from independent random samples
%from normal distributions with equal means but unknown variances
%H1: Negative and Positive Hysteresis come from populations with unequal
%means

for cc = 1:nCombinations
    
    for ii = 1:11 % the 11 correlation volumes considered
        
       [h(ii), p(ii)] = ttest2(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii),...
           corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));
    
    end
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).ttestBilateral.PointToPoint = [h', p'];
end
%% Two sample t-tests - right - point-to-point
%H0: Negative and Positive Hysteresis come from independent random samples
%from normal distributions with equal means but unknown variances
%H1: Negative Hysteresis' mean is greater than  Positive Hysteresis' mean

for cc = 1:nCombinations
    
    for ii = 1:11 % the 11 correlation volumes considered
        
       [h(ii), p(ii)] = ttest2(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii),...
           corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii), ...
           'Tail', 'right');
    
    end
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).ttestRight.PointToPoint = [h', p'];
end

%% Two sample t-tests - left - point-to-point
%H0: Negative and Positive Hysteresis come from independent random samples
%from normal distributions with equal means but unknown variances
%H1: Positive Hysteresis' mean is greater than Negative Hysteresis' mean

for cc = 1:nCombinations
    
    for ii = 1:11 % the 11 correlation volumes considered
        
       [h(ii), p(ii)] = ttest2(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii),...
           corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii), ...
           'Tail', 'right');
    
    end
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).ttestLeft.PointToPoint = [h', p'];
end

%% Wilcoxon rank sum test - point to point

for cc = 1:nCombinations
    
    for ii = 1:11 % the 11 correlation volumes considered
        
       [p(ii), h(ii)] = ranksum(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii),...
           corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));
    
    end
    
    stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Wilcoxon.PointToPoint = [h', p'];
end

%% Save stat file
save('stat_test.mat', 'stat');

%% Path creation
load('stat_test.mat')
saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynConStat', 'PointToPoint', 't-test bilateral');
saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynConStat', 'PointToPoint', 'Wilcoxon test');
saveFig3Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynConStat', 'Curves', 't-test bilateral');
saveFig4Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynConStat', 'Curves', 'Wilcoxon test');

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


%% Plot Negative Hysteresis, Positive Hysteresis and * significance - Point-to-Point bilateral t-test

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
        
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, ...
            length(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    end

%     % Plot statistical data
    for wdIdx = 1:11
       if stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).ttestBilateral.PointToPoint(wdIdx, 1) == 1
           
           plot(wdIdx, 0.6, '*', 'color', 'k', 'markersize', 20)
           
       end
    end

%     if stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Wilcoxon.Curve(1, 1) == 1
%         plot(6, 0.6, '*', 'color', 'k', 'markersize', 20)
% %            
%     end
% %     
    LH(ee+1) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20);
    H{ee+1} = 'p<0.05';
    
    hold off
    
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    
    legend(LH, H,'location','southeast', 'FontSize', 20)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.2 0.7]);
    
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end

%% Plot Negative Hysteresis, Positive Hysteresis and * significance - Point-to-Point Wilcoxon

for cc = 1:nCombinations-3 %Last 3 are MT - MT correlations
%for cc =  [8 11 12 13 14 20 21 22]    
%for cc = 18
    %% Plot Effects 
    fig2 = figure('position',[50 50 1100 900]); 
    
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
        
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, ...
            length(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    end
    
    % Plot statistical data
    for wdIdx = 1:11
       if stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Wilcoxon.PointToPoint(wdIdx, 1) == 1
           
           plot(wdIdx, 0.6, '*', 'color', 'k', 'markersize', 20)
           
       end
    end

    
    LH(ee+1) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20);
    H{ee+1} = 'p<0.05';
    
    hold off
    
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    
    legend(LH, H,'location','southeast', 'FontSize', 20)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.2 0.7]);
    
    saveas(fig2, fullfile(saveFig2Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end
%% Plot Negative Hysteresis, Positive Hysteresis and * significance - Curve bilateral t-test

for cc = 1:nCombinations-3 %Last 3 are MT - MT correlations
%for cc =  [8 11 12 13 14 20 21 22]    
%for cc = 18
    %% Plot Effects 
    fig3 = figure('position',[50 50 1100 900]); 
    
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
        
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, ...
            length(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    end

    % Plot statistical data
    if stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).ttestBilateral.Curve(1, 1) == 1
        
        plot(6, 0.6, '*', 'color', 'k', 'markersize', 20)
            
    end
   
    LH(ee+1) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20);
    H{ee+1} = 'p<0.05';
    
    hold off
    
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    
    legend(LH, H,'location','southeast', 'FontSize', 20)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.2 0.7]);
    
    saveas(fig3, fullfile(saveFig3Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end

%% Plot Negative Hysteresis, Positive Hysteresis and * significance - Curve bilateral Wilcoxon

for cc = 1:nCombinations-3 %Last 3 are MT - MT correlations
%for cc =  [8 11 12 13 14 20 21 22]    
%for cc = 18
    %% Plot Effects 
    fig4 = figure('position',[50 50 1100 900]); 
    
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
        
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects_plot{ee}, ...
            length(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman));
    end

    % Plot statistical data
    if stat.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Wilcoxon.Curve(1, 1) == 1
        
        plot(6, 0.6, '*', 'color', 'k', 'markersize', 20)
            
    end
   
    LH(ee+1) = plot(nan,nan, '*', 'color', 'k', 'markersize', 20);
    H{ee+1} = 'p<0.05';
    
    hold off
    
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    
    legend(LH, H,'location','southeast', 'FontSize', 20)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.2 0.7]);
    
    saveas(fig4, fullfile(saveFig4Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end