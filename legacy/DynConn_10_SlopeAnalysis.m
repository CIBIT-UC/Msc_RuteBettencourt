%% Slope analysis


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

%% Slope calculation

%deriv = gradient(meanCorr.Spearman.FEF_bilateral.hMT_bilateral.mean(1,:))
%usa diferenças finitas só num lado nas extremidades, diferenças centrais
%nos restantes

for cc = 1:nCombinations-3
    slope = zeros(2,11); %line 1 Neg Hyst; line 2 Pos Hyst

    % Initial points
    slope(1,1) = meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,2)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,1);

    slope(2,1) = meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,2)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,1);

    % Remaining points
    for corrVol = 2:11

        slope(1, corrVol) = 0.5*(meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,corrVol)...
            -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,corrVol-1));

        slope(2, corrVol) = 0.5*(meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,corrVol)...
            -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,corrVol-1));

    end % corrVol iteration

    slopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}) = slope;

end %ROI iteration
%%
save('slopeAnalysis.mat', 'slopeAnalysis')

%% Make directory to save plots

saveFig1Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynCon_SlopeAnalysis', 'Slope and effects');

if ~exist(saveFig1Path, 'dir')
    mkdir(saveFig1Path);
end

saveFig2Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'DynCon_SlopeAnalysis', 'Slope only');

if ~exist(saveFig2Path, 'dir')
    mkdir(saveFig2Path);
end


%% Plot effects overlayed with point to point slope

for cc = 1:nCombinations-3
    
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
    
    % Plot slope variation
    plot(1:11, slopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(1,:),...
        '--', 'color', clrMap(9,:),'linewidth', 2);
    plot(1:11, slopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(2,:),...
        '--', 'color', clrMap(12,:),'linewidth', 2);
    
    % For legends
    LH(ee+1) = plot(nan,nan, '--', 'color', clrMap(9,:), 'markersize', 20);
    H{ee+1} = 'Deriv Negative Hysteresis';
    
    LH(ee+2) = plot(nan,nan, '--', 'color', clrMap(12,:), 'markersize', 20);
    H{ee+2} = 'Deriv Positive Hysteresis';
    
    hold off
    
    % Title, legend and axis properties
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    legend(LH, H,'location','southoutside', 'FontSize', 20, 'NumColumns', 2)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.3 0.7]);
    
     % save figure
    saveas(fig1, fullfile(saveFig1Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end


%% Plot only slope

for cc = 1:nCombinations-3
    
    %% Plot Effects 
    fig2 = figure('position',[50 50 1100 900]); 
    
    % Plot slope variation
    hold on
    
    plot(1:11, slopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(1,:),...
        '--', 'color', clrMap(9,:),'linewidth', 2);
    plot(1:11, slopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(2,:),...
        '--', 'color', clrMap(12,:),'linewidth', 2);
    
    % xAxis and vertical guidelines
    line([1 1], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 1
    line([6 6], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 6
    line([11 11], [-1.1 1.1], 'linestyle', ':', 'color', 'k'); %x = 11
    line([0 16],[0 0],'linestyle',':','color','k') %y=0
    
    % For legends
    LH2(1) = plot(nan,nan, '--', 'color', clrMap(9,:), 'markersize', 20);
    H2{1} = 'Deriv Negative Hysteresis';
    
    LH2(2) = plot(nan,nan, '--', 'color', clrMap(12,:), 'markersize', 20);
    H2{2} = 'Deriv Positive Hysteresis';
    
    hold off
    
    % Title, legend and axis properties
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    legend(LH2, H2,'location','southoutside', 'FontSize', 20)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.3 0.7]);
    
     % save figure
    saveas(fig2, fullfile(saveFig2Path,sprintf('%s-%s.png',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)})));
end

%% Variation on the three main points (before, effect block and after)


for cc = 1:nCombinations-3
    
    global_slope = zeros(2,2); %line 1 Neg Hyst; line 2 Pos Hyst; column 1 before to effect; column 2 effect to after

    % m = (y-y0)/(x-x0)
    
    global_slope(1,1) = (meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,6)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,1))/(6-1);

    global_slope(2,1) = (meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,6)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,1))/(6-1);

    global_slope(1,2) = (meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,11)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(1,6))/(11-6);

    global_slope(2,2) = (meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,11)...
        -meanCorr.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).mean(2,6))/(11-6);

    globalslopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}) = global_slope;

end %ROI iteration

%% 
for cc = 1:nCombinations-3
    
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
    
    % Plot slope variation
    plot(3, globalslopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(1,1),...
        '*', 'color', clrMap(9,:),'linewidth', 2);
    plot(9, globalslopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(1,2),...
        '*', 'color', clrMap(9,:),'linewidth', 2);
    plot(3, globalslopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(2,1),...
        '*', 'color', clrMap(12,:),'linewidth', 2);
    plot(9, globalslopeAnalysis.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)})(2,2),...
        '*', 'color', clrMap(12,:),'linewidth', 2);
    
    % For legends
    LH(ee+1) = plot(nan,nan, '--', 'color', clrMap(9,:), 'markersize', 20);
    H{ee+1} = 'Deriv Negative Hysteresis';
    
    LH(ee+2) = plot(nan,nan, '--', 'color', clrMap(12,:), 'markersize', 20);
    H{ee+2} = 'Deriv Positive Hysteresis';
    
    hold off
    
    % Title, legend and axis properties
    title(sprintf('%s \x2194 %s',ROIs_titles{comb(cc,1)},ROIs_titles{comb(cc,2)}), 'FontSize', 20)
    legend(LH, H,'location','southoutside', 'FontSize', 20, 'NumColumns', 2)
    
    xlabel('Sliding window (L = 5)', 'FontSize', 20); xlim([0 12]);
    xticks([1 6 11]); xticklabels({'Before effect block', 'Effect block', 'After effect block'});
    ylabel('Spearman correlation', 'FontSize', 20); ylim([-0.3 0.7]);
    
end
