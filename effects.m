%% plot with effect block
clear all, close all, clc

effects_data = strip(fullfile(' ', 'DATAPOOL', 'home', 'rutebettencourt',...
    'Documents', 'GitHub', 'Msc_RuteBettencourt', 'Hysteresis-keypress-label-data.mat'));
load(effects_data)

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'ROIs_BOLD_timecourse.mat');
datacon = fullfile(path, 'dynCon_metrics.mat');
datavols = fullfile(path, 'volume_onset.mat');
load(data); load(datacon); load(datavols);

comb = combnk(1:7,2);
%idxs = 1:length(comb(:,1));
idxs = 1:3;

ROIs = fieldnames(BOLD_denoised_timecourse);
aux1 = strrep(ROIs,'_roi','');
ROIs_clean = strrep(aux1, '_','-');

runs = fieldnames(BOLD_denoised_timecourse.SS_hMT_bilateral);
nruns =2:length(runs); %Ignore the concatenated runs
trials = 1:4;
effectBlock_sz = 5;
window = 1:effectBlock_sz;

nvols = 21; %31.5/1.5 
runsnames = fieldnames(volumes);
subs = 2%:4;%1:25;

for sub=subs
    for run = nruns
        for idx=idxs
            for trial = trials
            
                effect_list_idx = 4*(sub-1)+run-1;
                lastEffect_CompPatt = EffectBlockIndex_CompPatt(effect_list_idx);
                lastEffect_PattComp = EffectBlockIndex_PattComp(effect_list_idx);

                volmax = max(volumes.(runsnames{run-1}).CompPatt(trial), volumes.(runsnames{run-1}).PattComp(trial));
                volmin = min(volumes.(runsnames{run-1}).CompPatt(trial), volumes.(runsnames{run-1}).PattComp(trial));
                xx = volmin:(volmax+nvols);

                figure(idx)

                if lastEffect_CompPatt>=5

                    effectBlock_CompPatt = window +volumes.(runsnames{run-1}).CompPatt(trial) +lastEffect_CompPatt-5;
                    effect_CompPatt = Effect_CompPatt(effect_list_idx); %Neg, Pos, Null Und

                    if effect_CompPatt == 1 %Negative Hysteresis
                       % figure(idx)
                        sgtitle(sprintf('Sub-%02d %s trial-%02d', sub, string(runs{run}),trial))
                        subplot 411
                        %BOLD signal - ROI1
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_CompPatt,sub), '-*b')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_CompPatt,sub), '-*b')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(xx,1), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_CompPatt,1), '-*b')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_CompPatt,sub), '-*b')
                        hold off

                    elseif effect_CompPatt == 2 %Positive Hysteresis
                       % figure(idx)
                        sgtitle(sprintf('Sub-%02d %s trial-%02d', sub, string(runs{run}), trial))
                        subplot 411
                        %BOLD signal - ROI1
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_CompPatt,sub), '-+b')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_CompPatt,sub), '-+b')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(xx,1), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_CompPatt,1), '-+b')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_CompPatt,sub), '-+b')
                        hold off
                    elseif effect_CompPatt == 3 %Null
                       % figure(idx)
                        sgtitle(sprintf('Sub-%02d %s trial-%02d', sub, string(runs{run}), trial))
                        subplot 411
                        %BOLD signal - ROI1
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_CompPatt,sub), '-ob')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_CompPatt,sub), '-ob')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(xx,1),'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_CompPatt,1), '-ob')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_CompPatt,sub), '-ob')
                        hold off

                    elseif effect_CompPatt == 4 %Undefined
                        %figure(idx)
                        sgtitle(sprintf('Sub-%02d %s trial-%02d', sub, string(runs{run}), trial))
                        subplot 411
                        %BOLD signal - ROI1
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_CompPatt,sub), '-sb')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        plot(xx, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        hold on
                        plot(effectBlock_CompPatt, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_CompPatt,sub), '-sb')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(xx,1), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_CompPatt,1), '-sb')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        plot(xx, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(xx,sub), 'color', [0.9290 0.6940 0.1250])
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_CompPatt, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_CompPatt,sub), '-sb')
                        hold off

                    end
                end
                if lastEffect_PattComp>=5

                    effectBlock_PattComp = window +volumes.(runsnames{run-1}).PattComp(trial) +lastEffect_PattComp-5;
                    effect_PattComp = Effect_PattComp(effect_list_idx);

                    if effect_CompPatt == 1 %Negative Hysteresis
                       % figure(idx)
                        %sgtitle(sprintf('Sub-%02d %s', sub, string(runs{run})))
                        subplot 411
                        %BOLD signal - ROI1
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_PattComp,sub), '-*r')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(:,sub), '-y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_PattComp,sub), '-*r')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(:,1), '-y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_PattComp,1), '-*r')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(:,sub), '-y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_PattComp,sub), '-*r')
                        hold off

                    elseif effect_CompPatt == 2 %Positive Hysteresis
                       % figure(idx)
                        %sgtitle(sprintf('Sub-%02d %s', sub, string(runs{run})))
                        subplot 411
                        %BOLD signal - ROI1
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_PattComp,sub), '-+r')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                       % plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_PattComp,sub), '-+r')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(:,1), '--y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_PattComp,1), '-+r')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(:,sub), '--y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_PattComp,sub), '-+r')
                        hold off
                    elseif effect_CompPatt == 3 %Null
                       % figure(idx)
                        %sgtitle(sprintf('Sub-%02d %s', sub, string(runs{run})))
                        subplot 411
                        %BOLD signal - ROI1
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_PattComp,sub), '-or')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_PattComp,sub), '-or')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(:,1), '--y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_PattComp,1), '-or')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(:,sub), '--y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_PattComp,sub), '-or')
                        hold off

                    elseif effect_CompPatt == 4 %Undefined
                        %figure(idx)
                       % sgtitle(sprintf('Sub-%02d %s', sub, string(runs{run})))
                        subplot 411
                        %BOLD signal - ROI1
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(effectBlock_PattComp,sub), '-sr')
                        title(ROIs_clean{comb(idx,1)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %BOLD signal - ROI2
                        subplot 412
                        %plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(:,sub), '--y')
                        hold on
                        plot(effectBlock_PattComp, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(effectBlock_PattComp,sub), '-sr')
                        title(ROIs_clean{comb(idx,2)})
                        ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                        hold off

                        %Pearson Correlation ROI1 ROI2
                        subplot 413
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(:,1), '--y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(effectBlock_PattComp,1), '-sr')
                        hold off

                        %Spearman Correlation ROI1 ROI2
                        subplot 414
                        %plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(:,sub), '--y')
                        title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                        xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                        hold on
                        plot(effectBlock_PattComp, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(effectBlock_PattComp,sub), '-sr')
                        hold off

                    end
                    legend()
                    figuren = figure(idx);

                end

                path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS','DYNAMIC-EFFECTS',sprintf('sub-%02d', sub)));

                if ~exist(path2, 'dir')
                    mkdir(path2);
                end
                saveas(figuren, fullfile(path2,sprintf('sub-%02d_%s_%s_%s_trial-%02d.png',...
                    sub, string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2))), string(runs{run}),trial)))
            end
        end
    end
end 

