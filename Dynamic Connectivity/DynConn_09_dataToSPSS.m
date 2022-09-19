%%

clear all, close all, clc

load('correlation_per_effect_p2.mat'); % To calculate the statistical tests

load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');


ROIs_titles  = {'FEF', 'IPS', 'Anterior Insula', 'SPL', 'V3A', 'Group hMT+',...
    'Subject-specific cluster-based hMT+','Subject-specific spherical hMT+'};

nROIs = length(ROIs_clean);


comb = combnk(1:8,2);

nCombinations = length(comb(:,1));

length_neg = length(corrPerEffect.NegativeHyst.FEF_bilateral.hMT_bilateral.Spearman(:,1));
length_pos = length(corrPerEffect.PositiveHyst.FEF_bilateral.hMT_bilateral.Spearman(:,1));
length_null = length(corrPerEffect.Null.FEF_bilateral.hMT_bilateral.Spearman(:,1));


path = 'C:\Users\User\Documents\GitHub\Msc_RuteBettencourt\Dynamic Connectivity\SPSS_data'

if ~exist(path, 'dir')
    mkdir(path);
end
cd(path)
for cc = 1:nCombinations-3
    
    a = nan(60,9); % [NegHyst_Pre NegHyst_EffectBlock NegHyst_Post PosHyst_Pre PosHyst_EffectBlock PosHyst_Post NullHyst_Pre NullHyst_EffectBlock NullHyst_Post ]
    a(1:length_neg,1) = corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1);
    a(1:length_neg,2) = corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,6);
    a(1:length_neg,3) = corrPerEffect.NegativeHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11);
    a(1:length_pos,4) = corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1);
    a(1:length_pos,5) = corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,6);
    a(1:length_pos,6) = corrPerEffect.PositiveHyst.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11);
    a(1:length_null,7) = corrPerEffect.Null.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,1);
    a(1:length_null,8) = corrPerEffect.Null.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,6);
    a(1:length_null,9) = corrPerEffect.Null.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman(:,11);
    
    
    save(sprintf('%s_%s.mat',ROIs_clean{comb(cc,1)}, ROIs_clean{comb(cc,2)}), 'a')
end