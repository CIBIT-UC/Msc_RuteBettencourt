%%

clear all, close all, clc
%% load data

load('correlation_per_effect_p2.mat'); % To calculate the statistical tests

load('meanCorrelation.mat'); % To make the plots

%% Define stuff

load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');
ROIs_titles  = {'FEF', 'IPS', 'Anterior Insula', 'SPL', 'V3A', 'Group hMT+',...
    'Subject-specific cluster-based hMT+','Subject-specific spherical hMT+'};

nROIs = length(ROIs_clean);


comb = combnk(1:8,2);

nCombinations = length(comb(:,1));


clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
effects_plot = {'Negative Hysteresis', 'Positive Hysteresis', 'No Hysteresis', 'Undefined'};
nEffects = length(effects);

%% Kolmogorov-Smirnov test

for cc = 1:nCombinations
    
    for ii = [1 6 11] % the pre, effect block, and pos correlation volumes
        
       [hn(ii), pn(ii)] = kstest(corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));

       [hp(ii), pp(ii)] = kstest(corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,ii));
    
    end
    
    normality.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Neg = [hn', pn'];
    normality.Spearman.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pos = [hp', pp'];
end

save('normality_test.mat', 'normality')