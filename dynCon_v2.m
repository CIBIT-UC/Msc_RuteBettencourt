%% 
clear all, close all, clc
path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'ROIs_BOLD_timecourse.mat');
load(data);

subjects = 1:25;
effect_block = 5;

metrics = struct();
ROIs = fieldnames(BOLD_denoised_timecourse);
ROIs_clean = strrep(ROIs,'+','');
nROIs = length(ROIs);

runs = fieldnames(BOLD_denoised_timecourse.SS_hMT_bilateral);
nruns =1:length(runs); 

for run = nruns
    for sub = subjects

        for seed = 1:nROIs
            for rr= 1:nROIs
                if seed ~= rr
                    rhos1 = []; rhos2 = [];
                    pvals1 = []; pvals2 = [];
                    window = 1:effect_block;
                    if run==1
                        while window(end)<1065
                        
                            %Pearson correlation and p-value
                            [rho1, pval1] = corr(BOLD_denoised_timecourse.(ROIs{seed}).(runs{run})(window,:),...
                                BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(window,:));
                            rho1 = diag(rho1);
                            pval1 = diag(pval1);
                            rhos1 = [rhos1 rho1];
                            pvals1 = [pvals1 pval1];
                            
                            %Spearman correlation and p-value
                            [rho2, pval2] = corr(BOLD_denoised_timecourse.(ROIs{seed}).(runs{run})(window,:),...
                                BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(window,:), 'Type', 'Spearman');
                            rho2 = diag(rho2);
                            pval2 = diag(pval2);
                            rhos2 = [rhos2 rho2];
                            pvals2 = [pvals2 pval2];

                            window = window+1;

                        end
                    
                    else

                        while window(end)<267

                            %Pearson correlation and p-value
                            [rho1, pval1] = corr(BOLD_denoised_timecourse.(ROIs{seed}).(runs{run})(window,:),...
                                BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(window,:));
                            rho1 = diag(rho1);
                            pval1 = diag(pval1);
                            rhos1 = [rhos1 rho1];
                            pvals1 = [pvals1 pval1];
                            
                            %Spearman correlation and p-value
                            [rho2, pval2] = corr(BOLD_denoised_timecourse.(ROIs{seed}).(runs{run})(window,:),...
                                BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(window,:), 'Type', 'Spearman');
                            rho2 = diag(rho2);
                            pval2 = diag(pval2);
                            rhos2 = [rhos2 rho2];
                            pvals2 = [pvals2 pval2];

                            window = window+1;

                        end
                    end

                    %%%%%%%%%%%%%%%%%%%%%
                    rhos1 = rhos1'; pvals1 = pvals1';
                    rhos2 = rhos2'; pvals2 = pvals2';

                    metrics.(ROIs{seed}).(ROIs{rr}).corrcoefPearson.(runs{run}) = rhos1;
                    metrics.(ROIs{seed}).(ROIs{rr}).corrpvalPearson.(runs{run}) = pvals1;
                    metrics.(ROIs{seed}).(ROIs{rr}).corrcoefSpearman.(runs{run}) = rhos2;
                    metrics.(ROIs{seed}).(ROIs{rr}).corrpvalSpearman.(runs{run}) = pvals2;

                end
            end
        end
    end
end

%%
save(fullfile(path,'dynCon_metrics.mat'), 'metrics')

%%

% --------------Uncomment if running by sections--------------------------
% clear all, close all, clc
% path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
% datacon = fullfile(path, 'dynCon_metrics.mat');
% data = fullfile(path, 'ROIs_BOLD_timecourse.mat');
% load(data); load(datacon);
% 
% ROIs = fieldnames(BOLD_denoised_timecourse);
% nROIs = length(ROIs);
% 
% runs = fieldnames(BOLD_denoised_timecourse.SS_hMT_bilateral);
% nruns =1:length(runs); 
% 
% for run = nruns
%     for seed = 1:nROIs
%         for rr= 1:nROIs
%             if seed ~= rr
% 
%                 %Correlation coefficients mean
%                 metrics.(ROIs{seed}).(ROIs{rr}).meancorrcoef.(runs{run}) = mean(metrics.(ROIs{seed}).(ROIs{rr}).corrcoef.(runs{run}));
%                
%                 %Correlation p-values mean
%                 metrics.(ROIs{seed}).(ROIs{rr}).meancorrpval.(runs{run}) = mean(metrics.(ROIs{seed}).(ROIs{rr}).corrpval.(runs{run}));
% 
%                 %Correlation coefficients standard deviation
%                 metrics.(ROIs{seed}).(ROIs{rr}).stdcorrcoef.(runs{run}) = std(metrics.(ROIs{seed}).(ROIs{rr}).corrcoef.(runs{run}));
% 
%                 %Correlation p-values standard deviation
%                 metrics.(ROIs{seed}).(ROIs{rr}).stdcorrpval.(runs{run}) = std(metrics.(ROIs{seed}).(ROIs{rr}).corrpval.(runs{run}));
%                 
%                 %Fisher-transformed correlation coefficients
%                 metrics.(ROIs{seed}).(ROIs{rr}).fisher.(runs{run}) = atanh(metrics.(ROIs{seed}).(ROIs{rr}).corrcoef.(runs{run}));
%             end
%         end
%     end
% end
% 
% save(fullfile(path,'dynCon_metrics.mat'), 'metrics')