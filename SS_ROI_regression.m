%% Regress the motion parameters out of the signal
clear all, close all, clc

%%
ROI = {'IPS', 'SPL', 'V3A', 'hMT', 'FEF', 'INSpeak'}; %'insula' 'INScorrected'
runs = {'run1' 'run2' 'run3' 'run4'};
%%
%% Conditions definition
load('task_onsets.mat')

for run = 1:4
    
    discard = zeros(266,1);
    static = zeros(266,1);
    comppatt  = zeros(266,1);
    pattcomp = zeros(266,1);
    mae = zeros(266,1);
    
    nvolsmov = 20;
    nvolsdiscard = 6/1.5-1;
    nvolsS =7.5/1.5-1;
    
    for d = 1:2
        discard(volumes.(runs{run}).Discard(d,1):volumes.(runs{run}).Discard(d,1)+nvolsdiscard) = 1;
    end
    
    for ss = 1:10
       static(volumes.(runs{run}).Static(ss,1):volumes.(runs{run}).Static(ss,1)+nvolsS) = 1; 
    end
    
    for mm = 1:8
        mae(volumes.(runs{run}).MAE(mm,1):volumes.(runs{run}).MAE(mm,1)+nvolsS) = 1;
    end
    
    for trial = 1:4
        comppatt(volumes.(runs{run}).CompPatt(trial,1):volumes.(runs{run}).CompPatt(trial,1)+nvolsmov) = 1;
        pattcomp(volumes.(runs{run}).PattComp(trial,1):volumes.(runs{run}).PattComp(trial,1)+nvolsmov) = 1;
    end
    vols.(runs{run}).CompPatt = comppatt;
    vols.(runs{run}).PattComp = pattcomp;
    vols.(runs{run}).Discard = discard;
    vols.(runs{run}).Static = static;
    vols.(runs{run}).MAE = mae;
end

%% hrf for TR 1.5
hrf = spm_hrf(1.5);

%% task*hrf

for run = 1:4
    
%     CompPatt_effect = conv(vols.(runs{run}).CompPatt,hrf, 'same');
%     PattComp_effect = conv(vols.(runs{run}).PattComp,hrf, 'same');
%     Discard_effect = conv(vols.(runs{run}).Discard,hrf, 'same');
%     Static_effect = conv(vols.(runs{run}).Static,hrf, 'same');
%     MAE_effect = conv(vols.(runs{run}).MAE,hrf, 'same');

    CompPatt_effect = conv(vols.(runs{run}).CompPatt,hrf);
    PattComp_effect = conv(vols.(runs{run}).PattComp,hrf);
    Discard_effect = conv(vols.(runs{run}).Discard,hrf);
    Static_effect = conv(vols.(runs{run}).Static,hrf);
    MAE_effect = conv(vols.(runs{run}).MAE,hrf);
    
    task_effect.CompPatt.(runs{run}) = CompPatt_effect(1:266,1);
    task_effect.PattComp.(runs{run}) = PattComp_effect(1:266,1);
    task_effect.Discard.(runs{run}) = Discard_effect(1:266,1);
    task_effect.Static.(runs{run}) = Static_effect(1:266,1);
    task_effect.MAE.(runs{run}) = MAE_effect(1:266,1);
end

%% path to the ROI timeseries and to the motion parameters
for sub = 1:25 %25
    
    pathROI = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs', sub);
    for run = 1:4 %4
        %Motion parameters for sub/run timeseries
        pathRP = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func', sub);
        rps = load(fullfile(pathRP, sprintf('rp_sub-%02d_task-main_run-%02d_bold.txt', sub, run)));
        %rps = [rps ones(266,1)];
        
        %White Matter time series
        WM = load(fullfile(pathROI, sprintf('WM_run%d', run)));
        
        %CSF time series
        CSF = load(fullfile(pathROI, sprintf('CSF_run%d', run)));
        
        %matrix of regressors
        X = [ones(266,1) rps WM.y CSF.y task_effect.CompPatt.(runs{run}) task_effect.PattComp.(runs{run})...
            task_effect.Discard.(runs{run}) task_effect.Static.(runs{run}) task_effect.MAE.(runs{run})];
        
        for rr = 1:6 %nROIs  
            
            timeseries = [];
            roi = load(fullfile(pathROI, sprintf('%s_run%d.mat', ROI{rr}, run)));
            
            [b1, bint1, r1] = regress(roi.y(:,1), X);
            if rr ~= 6 % not insula
                [b2, bint2, r2] = regress(roi.y(:,2), X);
            
                timeseries = [(r1+mean(roi.y(:,1))) (r2+mean(roi.y(:,2)))];
                save(fullfile(pathROI, sprintf('sub-%02d_run-%02d_%s_denoised.mat', sub, run, ROI{rr})), 'timeseries')
            
            else %insula
                timeseries = r1+mean(roi.y(:,1));
                save(fullfile(pathROI, sprintf('sub-%02d_run-%02d_%s_denoised.mat', sub, run, ROI{rr})), 'timeseries')
            end
        end

    end
end
%%
%plot(1:266, roi.y(:,1), 'r', 1:266, roi.y(:,2), 'b', 1:266, r1, 'g', 1:266, r2, 'k')
% plot( 1:266, roi.y(:,2), 'b', 1:266, r2 +mean(roi.y(:,2)), 'k')
% legend('hMT right timeseries','hMT2 right residuals')
% hold on
% plot(1:266, roi.y(:,2), 'b')
% plot(1:266, r2 +mean(roi.y(:,2)), 'k')
% plot(1:266, 154 +task_effect.CompPatt.(runs{run}), 'r')
% plot(1:266, 154 +task_effect.PattComp.(runs{run}), 'g')
% plot(1:266, 154 +task_effect.Discard.(runs{run}), 'c')
% plot(1:266, 154 +task_effect.Static.(runs{run}), 'm')
% plot(1:266, 154 +task_effect.MAE.(runs{run}), 'color', [0.4940 0.1840 0.5560])
% 
% legend('hMT', 'denoised hMT', 'Effect CompPatt', 'Effect PattComp', 'Effect Discard', 'Effect Static', 'Effect MAE')

