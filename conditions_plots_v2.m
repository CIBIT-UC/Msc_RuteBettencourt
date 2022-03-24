%% plot BOLD denoised signal and correlations with effect block
clear all, close all, clc

%Load the keypresses data, the denoised BOLD signal and the correlation
%matrixes
effects_data = strip(fullfile(' ', 'DATAPOOL', 'home', 'rutebettencourt',...
    'Documents', 'GitHub', 'Msc_RuteBettencourt', 'Hysteresis-keypress-label-data.mat'));
load(effects_data)

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'new_trialvolumes.mat');
datacon = fullfile(path, 'new_blockmetrics.mat');
load(data); load(datacon); 

%Cell with ROIs names
ROIs = fieldnames(trialvol.CompPatt);
aux1 = strrep(ROIs,'_roi','');
ROIs_clean = strrep(aux1, '_','-');

comb = combnk(1:7,2); %To iterate the ROIs
idxs = 1:length(comb(:,1));

runs = 1:4;
runname = {};
for run = runs
    runname{run} = sprintf('run-%1d',run);
end

window = 1:5;
subjects = fieldnames(trialvol.CompPatt.FEF_bilateral_roi);
subs = 1:25;

%Volumes iteration
xx_condition = 1:21;
xx_corr = 1:17;

for sub=subs
    for idx=idxs
        figure(idx)
        for run = runs
        
            effect_list_idx = 4*(sub-1)+run; %idx for the last volume of the effect block
            lastEffect_CompPatt = EffectBlockIndex_CompPatt(effect_list_idx);
            lastEffect_PattComp = EffectBlockIndex_PattComp(effect_list_idx);
            
            effect_CompPatt = Effect_CompPatt(effect_list_idx); %Neg, Pos, Null Und
            effect_PattComp = Effect_PattComp(effect_list_idx); %Neg, Pos, Null Und
            
            %Set the xx values for the Effect Block for CompPatt
            %NORMAL CASE
            if lastEffect_CompPatt>=5 && lastEffect_CompPatt<=17
                effectBlock_CompPatt = window + lastEffect_CompPatt-5;
                effectBlock_CompPatt_corr = effectBlock_CompPatt;
            %ADJUSTED WINDOWS
            elseif lastEffect_CompPatt<5
                effectBlock_CompPatt = 1:5;
                effectBlock_CompPatt_corr = effectBlock_CompPatt;
            elseif lastEffect_CompPatt>17
                effectBlock_CompPatt = 17:21;
                effectBlock_CompPatt_corr = 13:17;
            end
            
            % Set the xx values for the Effect Block for PattComp
            %NORMAL CASE
            if lastEffect_PattComp>=5 && lastEffect_PattComp<=17
                effectBlock_PattComp = window + lastEffect_PattComp-5;
                effectBlock_PattComp_corr = effectBlock_PattComp;
            %ADJUSTED WINDOWS
            elseif lastEffect_PattComp<5
                effectBlock_PattComp = 1:5;
                effectBlock_PattComp_corr = effectBlock_PattComp;
            elseif lastEffect_PattComp>17
                effectBlock_PattComp = 17:21;
                effectBlock_PattComp_corr = 13:17;
            end

            %figure(idx)
            
            sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
            %CompPatt and PattComp volumes
            subplot 411
            %BOLD DENOISED signal - ROI1
            plot(xx_condition, trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(xx_condition, run), 'color', [0.9290 0.6940 0.1250])
            hold on
            plot(xx_condition, trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(xx_condition, run), 'color', [0.4660 0.6740 0.1880])
            title(ROIs_clean{comb(idx,1)})
            ylabel('Denoised BOLD signal'); xlabel('Time (volumes)')
            xlim([0 22]); ylim([-1.04 1.04]);
            hold off
            
            subplot 412
            %BOLD DENOISED signal - ROI2
            plot(xx_condition, trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(xx_condition, run), 'color', [0.9290 0.6940 0.1250])
            hold on
            plot(xx_condition, trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(xx_condition, run), 'color', [0.4660 0.6740 0.1880])
            xlabel('Time (volumes)')
            title(ROIs_clean{comb(idx,2)})
            ylabel('Denoised BOLD signal');
            xlim([0 22]); ylim([-1.04 1.04]);
            hold off
            
            subplot 413
            %Pearson correaltion
            plot(xx_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_corr, run), 'color', [0.9290 0.6940 0.1250])
            hold on
            plot(xx_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_corr, run), 'color', [0.4660 0.6740 0.1880])
            title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
            xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
            xlim([0 22]); ylim([-1 1])
            hold off
            
            subplot 414
            %Spearman correlation
            plot(xx_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(xx_corr, run), 'color', [0.9290 0.6940 0.1250])
            hold on
            plot(xx_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(xx_corr, run), 'color', [0.4660 0.6740 0.1880])
            title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
            xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
            xlim([0 22]); ylim([-1 1])
            hold off
            
            if effect_CompPatt == 1 %Negative Hysteresis
                    
                subplot 411
                %BOLD signal - ROI1
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-vb') 
                hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-vb')
                hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-vb')
                hold off

                subplot 414
                %Spearman Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-vb')
                hold off
                
            elseif effect_CompPatt == 2 %Positive Hysteresis
                subplot 411
                %BOLD signal - ROI1
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-+b')
                hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-+b')
                hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-+b')
                hold off

                subplot 414
                %Spearman Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-+b')
                hold off

            elseif effect_CompPatt == 3 
                subplot 411
                %BOLD signal - ROI1
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-ob')
                hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-ob')
                hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-ob')
                hold off

                subplot 414
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-ob')
                hold off
            elseif effect_CompPatt == 4
                subplot 411
                %BOLD signal - ROI1
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-sb')
                hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_CompPatt, trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-sb')
                hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-sb')
                hold off

                subplot 414
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_CompPatt_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), '-sb')
                hold off

            end
            if effect_PattComp == 1 %Negative Hysteresis
                subplot 411
                %BOLD signal - ROI1
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-vr')
                hold off; hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-vr')
                hold off; hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-vr')
                hold off; hold off

                subplot 414                   
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-vr')
                hold off; hold off

            elseif effect_PattComp == 2 %Positive Hysteresis
                subplot 411
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-+r')
                hold off; hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-+r')
                hold off; hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-+r')
                hold off; hold off

                subplot 414
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-+r')
                hold off; hold off


            elseif effect_PattComp == 3 
                sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
                subplot 411
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-or')
                hold off; hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-or')
                hold off; hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-or')
                hold off; hold off

                subplot 414
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-or')
                hold off; hold off

            elseif effect_PattComp == 4

                subplot 411
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-sr')
                hold off; hold off

                subplot 412
                %BOLD signal - ROI2
                hold on
                plot(effectBlock_PattComp, trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-sr')
                hold off; hold off

                subplot 413
                %Pearson Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-sr')
                hold off; hold off

                subplot 414
                %Spearman Correlation ROI1 ROI2
                hold on
                plot(effectBlock_PattComp_corr, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), '-sr')
                hold off; hold off
            end
            
            %For legend porpuses
            hold on
            LH(1) = plot(nan, nan, 'color', [0.9290 0.6940 0.1250]);
            H{1} =  'IncCoh';
            LH(2) = plot(nan, nan, 'color', [0.4660 0.6740 0.1880]);
            H{2} = 'CohInc';
            LH(3) = plot(nan, nan, '-b');
            H{3} = 'Block effect IncCoh';
            LH(4) = plot(nan, nan, '-r');
            H{4} = 'Block effect CohInc';
            LH(5) = plot(nan, nan, 'k+');
            H{5} = 'Positive Hysteresis';
            LH(6) = plot(nan, nan, 'kv');
            H{6} = 'Negative Hysteresis';
            LH(7) = plot(nan, nan, 'ko');
            H{7} = 'Null';
            LH(8) = plot(nan, nan, 'ks');
            H{8} = 'Undefined';
            lgd = legend(LH, H, 'Position', [0.5 0.04 0.01 0.01]);
            
            lgd.NumColumns = 4;
            
            hold off
            figuren = figure(idx);
            
            path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS','BOLD-CORR',sprintf('sub-%02d', sub)));

            if ~exist(path2, 'dir')
                mkdir(path2);
            end
            saveas(figuren, fullfile(path2,sprintf('sub-%02d_%s_%s_%s.png',...
                sub, string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2))), string(runname{run}))))
        end
    end
end