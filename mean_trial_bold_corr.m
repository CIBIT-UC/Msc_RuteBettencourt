%% plot with effect block
clear all, close all, clc

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

comb = combnk(1:7,2);
idxs = 1:length(comb(:,1));
%idxs = 1:3;

runs = 1:4;
runname = {};
for run = runs
    runname{run} = sprintf('run-%1d',run);
end

window = 1:5;
subjects = fieldnames(trialvol.CompPatt.FEF_bilateral_roi);
subs = 1:4;
%xx_trajectory = 1:21;
xx_trajectory = 1:52;
dt = 52-21;
dtc = 48-17;

for sub=subs
    for idx=idxs
        figure(idx)
        for run = runs
        
            effect_list_idx = 4*(sub-1)+run;
            lastEffect_CompPatt = EffectBlockIndex_CompPatt(effect_list_idx);
            lastEffect_PattComp = EffectBlockIndex_PattComp(effect_list_idx);
            
            effectBlock_CompPatt = window + lastEffect_CompPatt-5;
            effect_CompPatt = Effect_CompPatt(effect_list_idx); %Neg, Pos, Null Und
            effectBlock_PattComp = window + lastEffect_PattComp-5;
            effect_PattComp = Effect_PattComp(effect_list_idx); %Neg, Pos, Null Und
            
            sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
            subplot 411
            plot(xx_trajectory, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(xx_trajectory, run), 'color', [0.9290 0.6940 0.1250])
            hold on
            plot(xx_trajectory, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(xx_trajectory, run), 'color', [0.4660 0.6740 0.1880])
            title(ROIs_clean{comb(idx,1)})
            ylabel('BOLD signal'); xlabel('Time (volumes)');
            hold off
            
            subplot 412
            plot(xx_trajectory, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(xx_trajectory, run), 'color', [0.9290 0.6940 0.1250])
            xlabel('Time (volumes)')
            hold on
            plot(xx_trajectory, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(xx_trajectory, run), 'color', [0.4660 0.6740 0.1880])
            title(ROIs_clean{comb(idx,2)})
            ylabel('BOLD signal');
            hold off
            
            subplot 413
            plot(1:48, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(1:48, run), 'color', [0.9290 0.6940 0.1250])
            title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
            xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
            hold on
            plot(1:48, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(1:48, run), 'color', [0.4660 0.6740 0.1880])
            hold off
            
            subplot 414
            plot(1:48, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(1:48, run), 'color', [0.9290 0.6940 0.1250])
            title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
            xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
            hold on
            plot(1:48, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(1:48, run), 'color', [0.4660 0.6740 0.1880])
            hold off
            
            if lastEffect_CompPatt>=5 && lastEffect_CompPatt<=17
                if effect_CompPatt == 1 %Negative Hysteresis
                    
                    %sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
                    subplot 411
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-vb')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-vb')
                    hold off
                    
                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-vb')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-vb')
                    hold off
                    
                    subplot 413
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-vb')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-vb')
                    hold off
                    
                    subplot 414
                    hold on 
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-vb')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-vb')
                    hold off
                    
                elseif effect_CompPatt == 2 %Positive Hysteresis
                    
                    subplot 411
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-+b')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-+b')
                    hold off
                    
                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-+b')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-+b')
                    hold off
                    
                    subplot 413
                    %Pearson Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-+b')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-+b')
                    hold off
                    
                    subplot 414
                    %Spearman Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-+b')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-+b')
                    hold off
                
                elseif effect_CompPatt == 3 
                    
                    subplot 411
                    %BOLD signal - ROI1
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-ob')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-ob')
                    hold off
                    
                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-ob')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-ob')
                    hold off
                    
                    subplot 413
                    %Pearson Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-ob')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-ob')
                    hold off
                    
                    subplot 414
                    %Spearman Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-ob')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-ob')
                    hold off
                    
                elseif effect_CompPatt == 4
                    subplot 411
                    %BOLD signal - ROI1
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-sb')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-sb')
                    hold off
                    
                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_CompPatt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), '-sb')
                    hold on
                    plot(effectBlock_CompPatt+dt, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt+dt, run), '-sb')
                    hold off
                    
                    subplot 413
                    %Pearson Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-sb')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-sb')
                    hold off
                    
                    subplot 414
                    %Spearman Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_CompPatt, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_CompPatt,run), '-sb')
                    hold on
                    plot(effectBlock_CompPatt+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_CompPatt+dtc,run), '-sb')
                    hold off
                    
                end
            end
                

            if lastEffect_PattComp>=5 && lastEffect_PattComp<=17
                if effect_PattComp == 1 %Negative Hysteresis

                    %sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
                    subplot 411
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-vr')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-vr')
                    hold off; hold off

                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-vr')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-vr')
                    hold off; hold off

                    subplot 413
                    hold on
                    %Pearson Correlation ROI1 ROI2
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-vr')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-vr')
                    hold off; hold off

                    subplot 414
                   % hold on
                    %Pearson Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-vr')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-vr')
                    hold off; hold off

                elseif effect_PattComp == 2 %Positive Hysteresis
                                            %sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
                    subplot 411
                    %BOLD signal - ROI1
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-+r')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-+r')
                    title(ROIs_clean{comb(idx,1)})
                    ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                    hold off; hold off

                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-+r')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-+r')
                    title(ROIs_clean{comb(idx,2)})
                    xlabel('Time (volumes)')
                    ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                    hold off; hold off

                    subplot 413
                    hold on
                    %Pearson Correlation ROI1 ROI2
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-+r')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-+r')
                    hold off; hold off

                    subplot 414
                    %Spearman Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-+r')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-+r')
                    hold off; hold off

                elseif effect_PattComp == 3 
                                            %sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
                    subplot 411
                    %BOLD signal - ROI1
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-or')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-or')
                    title(ROIs_clean{comb(idx,1)})
                    ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                    hold off; hold off

                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-or')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-or')
                    title(ROIs_clean{comb(idx,2)})
                    xlabel('Time (volumes)')
                    ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                    hold off; hold off

                    subplot 413
                    hold on
                    %Pearson Correlation ROI1 ROI2
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-or')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-or')
                    hold off; hold off

                    subplot 414
                    %Pearson Correlation ROI1 ROI2
                    hold on
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-or')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-or')
                    hold off; hold off

                elseif effect_PattComp == 4

                    subplot 411
                    %BOLD signal - ROI1
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-sr')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-sr')
                    title(ROIs_clean{comb(idx,1)})
                    ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                    hold off; hold off

                    subplot 412
                    %BOLD signal - ROI2
                    hold on
                    plot(effectBlock_PattComp, trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), '-sr')
                    hold on
                    plot(effectBlock_PattComp+dt, trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp+dt, run), '-sr')
                    title(ROIs_clean{comb(idx,2)})
                    xlabel('Time (volumes)')
                    ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                    hold off; hold off

                    subplot 413
                    hold on
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-sr')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-sr')
                    hold off; hold off

                    subplot 414
                    hold on
                    plot(effectBlock_PattComp, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{sub})(effectBlock_PattComp,run), '-sr')
                    hold on
                    plot(effectBlock_PattComp+dtc, blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{sub})(effectBlock_PattComp+dtc,run), '-sr')
                    hold off; hold off
                    
                end           
            end
            hold on
            LH(1) = plot(nan, nan, 'color', [0.9290 0.6940 0.1250]);
            H{1} =  'IncCoh - CohInc';
            LH(2) = plot(nan, nan, 'color', [0.4660 0.6740 0.1880]);
            H{2} = 'CohInc - IncCoh';
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
             
            path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS','BOLD-CORR-TRIAL',sprintf('sub-%02d', sub)));
 
            if ~exist(path2, 'dir')
                mkdir(path2);
            end
            saveas(figuren, fullfile(path2,sprintf('sub-%02d_%s_%s_%s.png',...
                sub, string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2))), string(runname{run}))))
        end
    end
end