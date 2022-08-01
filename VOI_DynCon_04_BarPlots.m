%% DynCon - graph plots

clear all, close all, clc

%% load data

load('VOI_correlation_per_effect.mat'); % To calculate the statistical tests

load('VOI_meanCorrelation.mat'); % To make the plots

%load('new_stat_test.mat'); % To show the significance level

load('VOI_stat_test_BonfCorr.mat'); %To show the significance level with the Bonferroni correction
%% Define stuff

load('VOIs_BOLD_timecourse.mat','ROI_clean');
ROIs_titles  = {'Subject-specific FEF', 'Subject-specific IPS', ' Subject-specific Anterior Insula',...
    'Subject-specific SPL', 'Subject-specific V3A', 'Subject-specific hMT+'};


nROIs = length(ROI_clean);


comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));


clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);

%% Make directory to save plots

saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynCon_Bars');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'VOI DynCon_Bars', 'Bonferroni Corrected');

if ~exist(saveFig2Path, 'dir')
    mkdir(saveFig2Path);
end

%% Plot barchart and errorbar
% 
% for cc = 1:nCombinations
%     % Matrix of correlation points for ROI1 ROI2 following the structure
%     %[NegHyst before PosHyst before; NegHyst effectblock PosHyst effectblock; NegHyst after PosHyst after]
%     corrPoints = [meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(1,1)...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(2,1);...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(1,6)...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(2,6);...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(1,11)...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(2,11)];
% 
%     % Standard error of the mean for the points
%     semPoints = [meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(1,1)...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(2,1);...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(1,6)...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(2,6);...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(1,11)...
%         meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(2,11)];
% 
%     [ngroups, nbars] = size(corrPoints); %To group the effects in before/during/after
%     
%     fig1 = figure('position',[50 50 1100 900]);
%     b = bar(corrPoints); %barplot
%     
%     %Define color of the bars
%     b(1).FaceColor = clrMap(9,:); %NegHyst
%     b(2).FaceColor = clrMap(12,:); %PosHyts
%     
%     %titles
% 
%     title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
% 
%     % Plot significance 
%     hold on
%     for wdIdx = [1 6 11]
%         
%         if (stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1) && wdIdx == 1
% 
%             plot(1, 0.6, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
% 
%         elseif (stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1) && wdIdx == 6
% 
%             plot(2, 0.6, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
% 
%         elseif(stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1) && wdIdx == 11
% 
%             plot(3, 0.6, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)
% 
%         end
%     end
%     % Legend
%     LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',2);
%     H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
%             length(corrPerEffect.(effects{1}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
%     LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',2);
%     H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
%             length(corrPerEffect.(effects{2}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
%     LH(3) = plot(nan, nan, '*' , 'color','k','markersize', 20,'linewidth',2);
%     H{3} = 'p < 0.05';
%     
%     legend(LH, H, 'Fontsize', 16, 'Location', 'southoutside'); 
%     
% % Get the center of each bar to put the errorbar
%     x = nan(nbars, ngroups);
% 
%     for ii = 1:nbars
% 
%         x(ii,:) = b(ii).XEndPoints;
% 
%     end %nbars iteration
%     % Plot error bar
%    
%     errorbar(x', corrPoints, semPoints, 'k', 'linestyle','none', 'LineWidth', 1.5, 'HandleVisibility', 'off') %Handle visibility off --> to not update the legend
% 
%     %Change x-axis font size
%     ax = gca(fig1);
%     ax.XAxis.FontSize = 16;
% 
%     %Axis properties
%     xticks([1 2 3]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
%     ylabel('Spearman correlation', 'FontSize', 16); ylim([-0.2 0.7]);
% 
%     hold off
%     
%     % save figure
%     saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})));
% 
% end %ROIs iteration

%% Plot barchart and errorbar with Bonferroni correction

for cc = 1:nCombinations
    % Matrix of correlation points for ROI1 ROI2 following the structure
    %[NegHyst before PosHyst before; NegHyst effectblock PosHyst effectblock; NegHyst after PosHyst after]
    corrPoints = [meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(1,1)...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(2,1);...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(1,6)...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(2,6);...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(1,11)...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).mean(2,11)];

    % Standard error of the mean for the points
    semPoints = [meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(1,1)...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(2,1);...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(1,6)...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(2,6);...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(1,11)...
        meanCorr.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).sem(2,11)];

    [ngroups, nbars] = size(corrPoints); %To group the effects in before/during/after
    
    fig2 = figure('position',[50 50 1100 900]);
    b = bar(corrPoints); %barplot
    
    %Define color of the bars
    b(1).FaceColor = clrMap(9,:); %NegHyst
    b(2).FaceColor = clrMap(12,:); %PosHyts
    
    %titles
    if length(ROIs_titles{comb(cc,2)}) > 4
        title(sprintf('%s \x2194 \n %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    else
        title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 25)
    end

    % Plot significance 
    hold on
    for wdIdx = [1 6 11]
        
        if (stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1) && wdIdx == 1

            plot(1, 0.8, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)

        elseif (stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1) && wdIdx == 6

            plot(2, 0.8, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)

        elseif(stat.Spearman.Wilcoxon_3tBonferroniCorr.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)})(wdIdx, 1) == 1) && wdIdx == 11

            plot(3, 0.8, '*', 'color', 'k', 'markersize', 20, 'linewidth', 2)

        end
    end
    % Legend
    LH(1) = plot(nan, nan, '-' , 'color',clrMap(9,:),'linewidth',2);
    H{1} = sprintf('%s (N=%d)',effects_plot{1}, ...
            length(corrPerEffect.(effects{1}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(2) = plot(nan, nan, '-' , 'color',clrMap(12,:),'linewidth',2);
    H{2} = sprintf('%s (N=%d)',effects_plot{2}, ...
            length(corrPerEffect.(effects{2}).(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman));
    LH(3) = plot(nan, nan, '*' , 'color','k','markersize', 20,'linewidth',2);
    H{3} = 'p < 0.05 (Bonferroni corrected)';
    
    legend(LH, H, 'Fontsize', 24, 'Location', 'southoutside'); 
    
% Get the center of each bar to put the errorbar
    x = nan(nbars, ngroups);

    for ii = 1:nbars

        x(ii,:) = b(ii).XEndPoints;

    end %nbars iteration
    % Plot error bar
   
    errorbar(x', corrPoints, semPoints, 'k', 'linestyle','none', 'LineWidth', 1.5, 'HandleVisibility', 'off') %Handle visibility off --> to not update the legend

    %Change x-axis font size
    ax = gca(fig2);
    ax.XAxis.FontSize = 18;
    ax.YAxis.FontSize = 18;
    
    %Axis properties
    xticks([1 2 3]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 22); ylim([-0.2 0.9]);

    hold off
    
    % save figure
    saveas(fig2, fullfile(saveFig2Path,sprintf('%s-%s.png',ROI_clean{comb(cc,1)},ROI_clean{comb(cc,2)})));

end %ROIs iteration