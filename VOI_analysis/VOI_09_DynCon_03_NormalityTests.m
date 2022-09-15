%% Normality tests

clear all, close all, clc

%% load data

%load('VOI_correlation_per_effect_INSunc.mat');
load('VOI_correlation_per_effect_INScorrected.mat'); % To calculate the statistical tests
%load('VOI_correlation_per_effect_INSpeak.mat');
%load('VOIs_BOLD_timecourse_INScorrected.mat','ROI_clean'); 

%load('VOI_meanCorrelation_INSunc.mat');
load('VOI_meanCorrelation_INScorrected.mat'); % To make the plots
%load('VOI_meanCorrelation_INSpeak.mat'); % To make the plots

%% Define stuff
%load('VOIs_BOLD_timecourse_INSunc.mat','ROI_clean');
load('VOIs_BOLD_timecourse_INScorrected.mat','ROI_clean');
%load('VOIs_BOLD_timecourse_INSpeak.mat','ROI_clean');
ROIs_titles  = {'Subject-specific FEF', 'Subject-specific IPS', ' Subject-specific Anterior Insula',...
    'Subject-specific SPL', 'Subject-specific V3A', 'Subject-specific hMT+'};

nROIs = length(ROI_clean);


comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));


clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);

%% Kolmogorov-Smirnov test

for cc = 1:nCombinations
    
    for ii = [1 6 11] % the pre, effect block, and pos correlation volumes
        
       [hn(ii), pn(ii)] = kstest(corrPerEffect.NegativeHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,ii));

       [hp(ii), pp(ii)] = kstest(corrPerEffect.PositiveHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,ii));
        
       [hnull(ii), pnull(ii)] = kstest(corrPerEffect.PositiveHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,ii));
    
    end
    
    normality.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Neg = [hn', pn'];
    normality.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Pos = [hp', pp'];
    normality.Spearman.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Null = [hnull', pnull'];
    
end

%save('VOI_normalitytest_INSunc.mat', 'normality')
save('VOI_normalitytest_INScorrected.mat', 'normality')
%save('VOI_normalitytest_INSpeak.mat', 'normality')