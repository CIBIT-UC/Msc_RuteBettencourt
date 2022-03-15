%% plots
clear all, close all, clc
path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'ROIs_BOLD_timecourse.mat');
datacon = fullfile(path, 'dynCon_metrics.mat');
load(data); load(datacon);

comb = combnk(1:7,2);
idxs = 1:length(comb(:,1));

ROIs = fieldnames(BOLD_denoised_timecourse);
aux1 = strrep(ROIs,'_roi','');
ROIs_clean = strrep(aux1, '_','-');

runs = fieldnames(BOLD_denoised_timecourse.SS_hMT_bilateral);
nruns =1:length(runs);

subs = 1:25;

for sub=subs
    for run = nruns
        for idx=idxs
            if run == 1
                figure(idx)
                sgtitle(sprintf('Sub-%02d %s', sub, string(runs{run})))
                subplot 411
                %BOLD signal - ROI1
                plot(1:1064, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(:,sub))
                title(ROIs_clean{comb(idx,1)})
                ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                %BOLD signal - ROI2
                subplot 412
                plot(1:1064, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(:,sub))
                title(ROIs_clean{comb(idx,2)})
                ylabel('BOLD signal'); %ylim([-2.3 2.3]);

                %Pearson Correlation ROI1 ROI2
                subplot 413
                plot(1:1060, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(:,sub))
                title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                
                %Spearman Correlation ROI1 ROI2
                subplot 414
                plot(1:1060, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(:,sub))
                title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                figuren = figure(idx);
            else
                figure(idx)
                sgtitle(sprintf('Sub-%02d %s', sub, string(runs{run})))
                subplot 411
                %BOLD signal - ROI1
                plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runs{run})(:,sub))
                title(ROIs_clean{comb(idx,1)})
                ylabel('BOLD signal'); %ylim([-2.3 2.3]);
                %BOLD signal - ROI2
                subplot 412
                plot(1:266, BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runs{run})(:,sub))
                title(ROIs_clean{comb(idx,2)})
                ylabel('BOLD signal'); %ylim([-2.3 2.3]);

                %Pearson Correlation ROI1 ROI2
                subplot 413
                plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefPearson.(runs{run})(:,1))
                title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                xlabel('Time (volumes)'); ylabel('Pearson r'); %ylim ([-1 1]);
                
                subplot 414
                plot(1:262, metrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrcoefSpearman.(runs{run})(:,sub))
                title(sprintf('Correlation between %s and %s', string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2)))));
                xlabel('Time (volumes)'); ylabel('Spearman r'); %ylim ([-1 1]);
                figuren = figure(idx);
            
            end
            path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS','DYNAMIC',sprintf('sub-%02d', sub)));
            
            if ~exist(path2, 'dir')
                mkdir(path2);
            end
            saveas(figuren, fullfile(path2,sprintf('sub-%02d_%s_%s_%s.png',...
                sub, string(ROIs_clean(comb(idx,1))), string(ROIs_clean(comb(idx,2))), string(runs{run}))))
        end
    end
end 

