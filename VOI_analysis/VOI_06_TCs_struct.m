%% Struct with all timecourses for sub/ROI/run
clear all, close all, clc
ROI = {'FEF', 'IPS', 'insula', 'SPL', 'V3A', 'hMT'};
%ROI = {'FEF', 'IPS', 'INS', 'SPL', 'V3A', 'hMT'};
%ROI = {'FEF', 'IPS', 'INSpeak', 'SPL', 'V3A', 'hMT'};
ROI_clean = {'SS_FEF', 'SS_IPS', 'SS_Insula', 'SS_SPL', 'SS_V3A', 'SS_hMT'};
runs = {'run1', 'run2', 'run3', 'run4'};


%%
for sub = 1:25
    for run = 1:4
        for rr = 1:6
            
            data = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs_denoised/sub-%02d_run-%02d_%s_denoised.mat', ...
                sub, sub, run, ROI{rr}));
            if rr == 3
                
                BOLD_denoised_timecourse.(ROI_clean{rr}).(runs{run})(:, sub) = data.timeseries;
            else
                BOLD_denoised_timecourse.(ROI_clean{rr}).(runs{run})(:, sub) = data.bilateral;
            end
            
            
        end % ROI iteration
    end % run iteration
end % subject iteration
save('VOIs_BOLD_timecourse_INSunc.mat','BOLD_denoised_timecourse', 'ROI_clean');
%save('VOIs_BOLD_timecourse_INSpeak.mat','BOLD_denoised_timecourse', 'ROI_clean');
%save('VOIs_BOLD_timecourse_INScorrected.mat','BOLD_denoised_timecourse', 'ROI_clean');