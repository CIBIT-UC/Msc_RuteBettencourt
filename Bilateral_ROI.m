%% Create the bilateral ROI - mean of the 2 timeseries for each point

clear all, close all, clc

ROI = {'IPS', 'SPL', 'V3A', 'hMT', 'FEF'}; % right insula only

%% 
for sub = 1:25
    
    savepath = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs_denoised', sub);
    for run = 1:4
        % Create the bilateral ROI
        for rr = 1:5

            TC = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/sub-%02d_run-%02d_%s_denoised.mat', ...
                sub, sub, run, ROI{rr}));
            bilateral = mean(TC.timeseries, 2);
            save(fullfile(savepath, sprintf('sub-%02d_run-%02d_%s_denoised.mat', sub, run, ROI{rr})), 'bilateral')
        end
        
        % Move insula to the same path
%         
         movefile(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/sub-%02d_run-%02d_insula_denoised.mat', ...
                 sub, sub, run), savepath)
    end
    
end

