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
nSubs = 25;

windowSize = 5; % in volumes

subjects = cell(1,25);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

comb = combnk(1:7,2);

nCombinations = length(comb(:,1));

% X axis data
xx_condition = 1:21;
xx_corr = 1:17;

clrMap = lines;

markers = {'v','+','o','s'}; % one for each effect (neg hyst, pos hyst, null, undefined)

%% Iteration

for sub = 1:nSubs
    
    % define/create output path for figures
    %path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS','BOLD-CORR',sprintf('sub-%02d', sub)));
    path2 = sprintf('/home/alexandresayal/media-sim01/DATAPOOL/VPHYSTERESIS/BOLD-CORR/sub-%02d', sub);
    
    if ~exist(path2, 'dir')
        mkdir(path2);
    end
 
    for idx = 1:nCombinations
        
        for run = 1:nRuns
            
            fig = figure('position',[1000 10 1900 1200]);
            
            effect_list_idx = 4*(sub-1)+run; % index of specific subject and run (in the 100x1 matrix - 25 subjects x 4 runs = 100)
            
            lastEffect_CompPatt = KeypressData.EffectBlockIndex_CompPatt(effect_list_idx); % last volume of effect block in CompPatt condition
            lastEffect_PattComp = KeypressData.EffectBlockIndex_PattComp(effect_list_idx); % last volume of effect block in PattComp condition
            
            effect_CompPatt = KeypressData.Effect_CompPatt(effect_list_idx); %Neg, Pos, Null Und
            effect_PattComp = KeypressData.Effect_PattComp(effect_list_idx); %Neg, Pos, Null Und
            
            
            %% Define effect block indexes for this run
            %Set the xx values for the Effect Block for CompPatt
            %NORMAL CASE
            if lastEffect_CompPatt>=5 && lastEffect_CompPatt<=17
                
                effectBlock_CompPatt = lastEffect_CompPatt-(windowSize-1):lastEffect_CompPatt;
                effectBlock_CompPatt_corr = effectBlock_CompPatt(1);
                
                %ADJUSTED WINDOWS
            elseif lastEffect_CompPatt<5
                
                effectBlock_CompPatt = 1:5;
                effectBlock_CompPatt_corr = 1;
                
            elseif lastEffect_CompPatt>17
                
                effectBlock_CompPatt = 17:21;
                effectBlock_CompPatt_corr = 17;
                
            end
            
            % Set the xx values for the Effect Block for PattComp
            %NORMAL CASE
            if lastEffect_PattComp>=5 && lastEffect_PattComp<=17
                
                effectBlock_PattComp = lastEffect_PattComp-(windowSize-1):lastEffect_PattComp;
                effectBlock_PattComp_corr = effectBlock_PattComp(1);
                
                %ADJUSTED WINDOWS
            elseif lastEffect_PattComp < 5
                
                effectBlock_PattComp = 1:5;
                effectBlock_PattComp_corr = 1;
                
            elseif lastEffect_PattComp > 17
                
                effectBlock_PattComp = 17:21;
                effectBlock_PattComp_corr = 17;
                
            end
            
            %% Base plot
            
            sgtitle(sprintf('Sub-%02d run-%02d' , sub, run))
            
            %CompPatt and PattComp volumes
            subplot 221
            %BOLD DENOISED signal - ROI1
            line([xx_condition(1) xx_condition(end)],[0 0],'linestyle',':','color','k')
            hold on
            errorbar(xx_condition, data.trialvol.CompPatt.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(:, run), data.trialvol.CompPatt.(ROIs_clean{comb(idx,1)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(1,:),'markersize',10)
            hold on
            errorbar(xx_condition, data.trialvol.PattComp.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(:, run), data.trialvol.PattComp.(ROIs_clean{comb(idx,1)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(2,:),'markersize',10)
            hold off
            
            title(ROIs_clean{comb(idx,1)},'interpreter','none')
            xlabel('Time (volumes)');
            ylabel('Denoised BOLD signal');
            xlim([0 22]); ylim([-0.5 0.5]); xticks(xx_condition);
            
            
            subplot 222
            %BOLD DENOISED signal - ROI2
            line([xx_condition(1) xx_condition(end)],[0 0],'linestyle',':','color','k')
            hold on
            errorbar(xx_condition, data.trialvol.CompPatt.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(:, run), data.trialvol.CompPatt.(ROIs_clean{comb(idx,2)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(1,:),'markersize',10)
            hold on
            errorbar(xx_condition, data.trialvol.PattComp.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(:, run), data.trialvol.PattComp.(ROIs_clean{comb(idx,2)}).(subjects{sub}).sem(:, run), '.-','color', clrMap(2,:),'markersize',10)
            hold off
            
            title(ROIs_clean{comb(idx,2)},'interpreter','none')
            xlabel('Time (volumes)');
            ylabel('Denoised BOLD signal');
            xlim([0 22]); ylim([-0.5 0.5]); xticks(xx_condition);
            
            subplot 223
            %Pearson correlation
            line([xx_corr(1) xx_corr(end)],[0 0],'linestyle',':','color','k')
            hold on
            plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(:, run),'.-', 'color', clrMap(1,:))
            hold on
            plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(:, run),'.-', 'color', clrMap(2,:))
            hold off
            
            title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))),'interpreter','none');
            xlabel('Time (volumes)'); ylabel('Pearson r');
            xlim([0 22]); ylim([-1.1 1.1]); xticks(xx_corr);
            
            
            subplot 224
            %Spearman correlation
            line([xx_corr(1) xx_corr(end)],[0 0],'linestyle',':','color','k')
            hold on
            plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(:, run),'.-', 'color', clrMap(1,:))
            hold on
            plot(xx_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(:, run),'.-', 'color', clrMap(2,:))
            hold off
            
            title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))),'interpreter','none');
            xlabel('Time (volumes)'); ylabel('Spearman r');
            xlim([0 22]); ylim([-1.1 1.1]); xticks(xx_corr);
            
            
            %% draw effect block
            
            subplot 221
            %BOLD signal - ROI1
            hold on
            plot(effectBlock_CompPatt, data.trialvol.CompPatt.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(effectBlock_CompPatt, run), ['-' markers{effect_CompPatt} 'b'], 'linewidth', 2)
            hold on
            plot(effectBlock_PattComp, data.trialvol.PattComp.(ROIs_clean{comb(idx,1)}).(subjects{sub}).mean(effectBlock_PattComp, run), ['-' markers{effect_PattComp} 'r'], 'linewidth', 2)
            hold off
            
            subplot 222
            %BOLD signal - ROI2
            hold on
            plot(effectBlock_CompPatt, data.trialvol.CompPatt.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(effectBlock_CompPatt, run), ['-' markers{effect_CompPatt} 'b'],'linewidth', 2)
            hold on
            plot(effectBlock_PattComp, data.trialvol.PattComp.(ROIs_clean{comb(idx,2)}).(subjects{sub}).mean(effectBlock_PattComp, run), ['-' markers{effect_PattComp} 'r'],'linewidth', 2)
            hold off
            
            subplot 223
            %Pearson Correlation ROI1 ROI2
            hold on
            plot(effectBlock_CompPatt_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), ['-' markers{effect_CompPatt} 'b'],'linewidth', 2)
            hold on
            plot(effectBlock_PattComp_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), ['-' markers{effect_PattComp} 'r'],'linewidth', 2)
            hold off
            
            subplot 224
            %Spearman Correlation ROI1 ROI2
            hold on
            plot(effectBlock_CompPatt_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(effectBlock_CompPatt_corr,run), ['-' markers{effect_CompPatt} 'b'],'linewidth', 2)
            hold on
            plot(effectBlock_PattComp_corr, datacon.correlationTCs.(ROIs_clean{comb(idx,1)}).(ROIs_clean{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(effectBlock_PattComp_corr,run), ['-' markers{effect_PattComp} 'r'],'linewidth', 2)
            hold off
            
            
           %% For legend porpuses
            hold on
            LH(1) = plot(nan, nan, '-' , 'color',clrMap(1,:),'linewidth',2);
            H{1} =  'Incoherent to Coherent';
            LH(2) = plot(nan, nan, '-', 'color', clrMap(2,:),'linewidth',2);
            H{2} = 'Coherent to Incoherent';
            LH(3) = plot(nan, nan, 'k+');
            H{3} = 'Positive Hysteresis';
            LH(4) = plot(nan, nan, 'kv');
            H{4} = 'Negative Hysteresis';
            LH(5) = plot(nan, nan, 'ko');
            H{5} = 'Null';
            LH(6) = plot(nan, nan, 'ks');
            H{6} = 'Undefined';
            lgd = legend(LH, H, 'Position', [0.5 0.04 0.01 0.01]);
            
            lgd.NumColumns = 3;
            
            hold off

            saveas(fig, fullfile(path2,sprintf('sub-%02d_%s_%s_%s.png',...
                sub, string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2))), string(runNames{run}))))
            
            close(fig)
            
        end % end run iteration
        
    end % end roi combination
    
end % end subject iteration
