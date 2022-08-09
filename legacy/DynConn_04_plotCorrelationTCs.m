%% plot BOLD denoised signal and correlations with effect block
clear, clc, close all

%% Load the keypresses data, the denoised BOLD signal and the correlation
% matrixes
KeypressData = load('Hysteresis-keypress-label-data.mat');

data = load('new_trialvolumes.mat'); % BOLD time courses per run/sub

datacon = load('correlationTCs.mat'); % Correlation time courses (windowed)

%% Define stuff

load('ROIs_BOLD_timecourse.mat','ROIs_clean');
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

comb = combnk(1:7,2);

nCombinations = length(comb(:,1));

% X axis data
xx_condition = 1:21;
xx_corr = 1:17;

clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
nEffects = length(effects);
markers = {'v','+','o','s'}; % one for each effect (neg hyst, pos hyst, null, undefined)

%% Adjust effect blocks
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt < 5) = 5;
KeypressData.EffectBlockIndex_CompPatt(KeypressData.EffectBlockIndex_CompPatt > 17) = 17;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp < 5) = 5;
KeypressData.EffectBlockIndex_PattComp(KeypressData.EffectBlockIndex_PattComp > 17) = 17;

%% Count number of runs per effect
nRunsPerEffect_CompPatt = histcounts(KeypressData.Effect_CompPatt);
nRunsPerEffect_PattComp = histcounts(KeypressData.Effect_PattComp);

%% Initialize correlation matrices for all ROI pairs per effect
corrPerEffect = struct();

for cc = 1:nCombinations
    
    for ee = 1:nEffects
        
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson = zeros(nRunsPerEffect_CompPatt(ee),1);
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson = zeros(nRunsPerEffect_PattComp(ee),1);
        
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman = zeros(nRunsPerEffect_CompPatt(ee),1);
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman = zeros(nRunsPerEffect_PattComp(ee),1);
        
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
                
                corrIdx_CompPatt = KeypressData.EffectBlockIndex_CompPatt(subrunidx)-(windowSize-1); % index of correlation TC that corresponds to the effect block
                corrIdx_PattComp = KeypressData.EffectBlockIndex_PattComp(subrunidx)-(windowSize-1); % index of correlation TC that corresponds to the effect block
                
                % fetch Pearson Correlation
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt)) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdx_CompPatt,rr);
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp)) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdx_PattComp,rr);
                
                % fetch Spearman Correlation
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt)) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_CompPatt.(subjects{ss})(corrIdx_CompPatt,rr);
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp)) = ...
                    datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman_PattComp.(subjects{ss})(corrIdx_PattComp,rr);                
                
                % add to counters
                subrunidx = subrunidx + 1;
                
                counterPerEffect_CompPatt(auxEffect_CompPatt) = counterPerEffect_CompPatt(auxEffect_CompPatt) + 1;
                counterPerEffect_PattComp(auxEffect_PattComp) = counterPerEffect_PattComp(auxEffect_PattComp) + 1;
                
            end
            
        end
    
end

%% Plot average correlations in the Effect block
xx_CompPatt = 1:2:8;
xx_PattComp = 2:2:8;

% Iterate on the ROI combinations
for cc = 1:nCombinations

    idx = 1;
    meanCorr = zeros(1,8);
    semCorr = zeros(1,8);
    
    % calculate means and SEM for each effect
    for ee = 1:nEffects
        
        meanCorr(idx) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman);
        meanCorr(idx+1) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman);
        
        semCorr(idx) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman) / sqrt(nRunsPerEffect_CompPatt(ee));
        semCorr(idx+1) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman) / sqrt(nRunsPerEffect_PattComp(ee));

        idx = idx+2;
        
    end

    %% PLOT
    
    figure('position',[1500 1000 700 400])
    hold on
    line([0 12],[0 0],'linestyle',':','color','k')
    e1 = errorbar([1,4,7,10], meanCorr(xx_CompPatt), semCorr(xx_CompPatt),'color',clrMap(4,:),'linestyle','none','markersize',10,'marker','.');
    e2 = errorbar([2,5,8,11], meanCorr(xx_PattComp), semCorr(xx_PattComp),'color',clrMap(5,:),'linestyle','none','markersize',10,'marker','.');
    hold off
    
    xlim([0 12]); xlabel('Effects')
    ylim([-1 1]); ylabel('Spearman correlation')

    xticks([1.5 4.5 7.5 10.5]); xticklabels(effects);
    
    title(sprintf('%s <--> %s',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
    
    legend([e1 e2],{'Component \rightarrow Pattern','Pattern \rightarrow Component'},'location','best')
    
end

% %% Base plot
% 
% sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
% 
% %CompPatt and PattComp volumes
% subplot 221
% %BOLD DENOISED signal - ROI1
% line([xx_condition(1) xx_condition(end)],[0 0],'linestyle',':','color','k')
% hold on
% errorbar(xx_condition, data.trialvol.CompPatt.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(:, run), data.trialvol.CompPatt.(ROIs_clean{comb(idx,1)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(1,:),'markersize',10)
% hold on
% errorbar(xx_condition, data.trialvol.PattComp.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(:, run), data.trialvol.PattComp.(ROIs_clean{comb(idx,1)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(2,:),'markersize',10)
% hold off
% 
% title(ROIs_clean{comb(idx,1)},'interpreter','none')
% xlabel('Time (volumes)');
% ylabel('Denoised BOLD signal');
% xlim([0 22]); ylim([-0.5 0.5]); xticks(xx_condition);
% 
% 
% subplot 222
% %BOLD DENOISED signal - ROI2
% line([xx_condition(1) xx_condition(end)],[0 0],'linestyle',':','color','k')
% hold on
% errorbar(xx_condition, data.trialvol.CompPatt.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(:, run), data.trialvol.CompPatt.(ROIs_clean{comb(idx,2)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(1,:),'markersize',10)
% hold on
% errorbar(xx_condition, data.trialvol.PattComp.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(:, run), data.trialvol.PattComp.(ROIs_clean{comb(idx,2)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(2,:),'markersize',10)
% hold off
% 
% title(ROIs_clean{comb(idx,2)},'interpreter','none')
% xlabel('Time (volumes)');
% ylabel('Denoised BOLD signal');
% xlim([0 22]); ylim([-0.5 0.5]); xticks(xx_condition);
% 
% subplot 223
% %Pearson correlation
% line([xx_corr(1) xx_corr(end)],[0 0],'linestyle',':','color','k')
% hold on
% plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(:, run),'.-', 'color', clrMap(1,:))
% hold on
% plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(:, run),'.-', 'color', clrMap(2,:))
% hold off
% 
% title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))),'interpreter','none');
% xlabel('Time (volumes)'); ylabel('Pearson r');
% xlim([0 22]); ylim([-1.1 1.1]); xticks(xx_corr);
% 
% 
% subplot 224
% %Spearman correlation
% line([xx_corr(1) xx_corr(end)],[0 0],'linestyle',':','color','k')
% hold on
% plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(:, run),'.-', 'color', clrMap(1,:))
% hold on
% plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(:, run),'.-', 'color', clrMap(2,:))
% hold off
% 
% title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))),'interpreter','none');
% xlabel('Time (volumes)'); ylabel('Spearman r');
% xlim([0 22]); ylim([-1.1 1.1]); xticks(xx_corr);
% 
% 
% %% draw effect block
% 
% subplot 221
% %BOLD signal - ROI1
% hold on
% plot(effectBlock_CompPatt, data.trialvol.CompPatt.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), ['-' markers{effect_CompPatt} 'b'], 'linewidth', 2)
% hold on
% plot(effectBlock_PattComp, data.trialvol.PattComp.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), ['-' markers{effect_PattComp} 'r'], 'linewidth', 2)
% hold off
% 
% subplot 222
% %BOLD signal - ROI2
% hold on
% plot(effectBlock_CompPatt, data.trialvol.CompPatt.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), ['-' markers{effect_CompPatt} 'b'],'linewidth', 2)
% hold on
% plot(effectBlock_PattComp, data.trialvol.PattComp.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), ['-' markers{effect_PattComp} 'r'],'linewidth', 2)
% hold off
% 
% subplot 223
% %Pearson Correlation ROI1 ROI2
% hold on
% plot(effectBlock_CompPatt_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), ['-' markers{effect_CompPatt} 'b'],'linewidth', 2)
% hold on
% plot(effectBlock_PattComp_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), ['-' markers{effect_PattComp} 'r'],'linewidth', 2)
% hold off
% 
% subplot 224
% %Spearman Correlation ROI1 ROI2
% hold on
% plot(effectBlock_CompPatt_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), ['-' markers{effect_CompPatt} 'b'],'linewidth', 2)
% hold on
% plot(effectBlock_PattComp_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), ['-' markers{effect_PattComp} 'r'],'linewidth', 2)
% hold off
% 
% 
% %% For legend porpuses
% hold on
% LH(1) = plot(nan, nan, '-' , 'color',clrMap(1,:),'linewidth',2);
% H{1} =  'Incoherent to Coherent';
% LH(2) = plot(nan, nan, '-', 'color', clrMap(2,:),'linewidth',2);
% H{2} = 'Coherent to Incoherent';
% LH(3) = plot(nan, nan, 'k+');
% H{3} = 'Positive Hysteresis';
% LH(4) = plot(nan, nan, 'kv');
% H{4} = 'Negative Hysteresis';
% LH(5) = plot(nan, nan, 'ko');
% H{5} = 'Null';
% LH(6) = plot(nan, nan, 'ks');
% H{6} = 'Undefined';
% lgd = legend(LH, H, 'Position', [0.5 0.04 0.01 0.01]);
% 
% lgd.NumColumns = 3;
% 
% hold off
% 
% saveas(fig, fullfile(path2,sprintf('sub-%02d_%s_%s_%s.png',...
%     sub, string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2))), string(runNames{run}))))
% 
% close(fig)
