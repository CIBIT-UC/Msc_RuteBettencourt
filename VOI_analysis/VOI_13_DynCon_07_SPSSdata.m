%%
clear all, close all, clc

load('VOI_correlation_per_effect_INSunc.mat');
load('VOIs_BOLD_timecourse_INSunc.mat','ROI_clean');

ROIs_titles  = {'Subject-specific FEF', 'Subject-specific IPS', ' Subject-specific Anterior Insula',...
    'Subject-specific SPL', 'Subject-specific V3A', 'Subject-specific hMT+'};

nROIs = length(ROI_clean);

comb = combnk(1:nROIs,2);

nCombinations = length(comb(:,1));

length_neg = length(corrPerEffect.NegativeHyst.SS_FEF.SS_hMT.Spearman(:,1));
length_pos = length(corrPerEffect.PositiveHyst.SS_FEF.SS_hMT.Spearman(:,1));
length_null = length(corrPerEffect.Null.SS_FEF.SS_hMT.Spearman(:,1));

path = 'C:\Users\User\Documents\GitHub\Msc_RuteBettencourt\VOI_analysis\SPSS_data'

if ~exist(path, 'dir')
    mkdir(path);
end
cd(path)

for cc = 1:nCombinations
    
    a = nan(60,9); % [NegHyst_Pre NegHyst_EffectBlock NegHyst_Post PosHyst_Pre PosHyst_EffectBlock PosHyst_Post NullHyst_Pre NullHyst_EffectBlock NullHyst_Post ]
    a(1:length_neg,1) = corrPerEffect.NegativeHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,1);
    a(1:length_neg,2) = corrPerEffect.NegativeHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,6);
    a(1:length_neg,3) = corrPerEffect.NegativeHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,11);
    a(1:length_pos,4) = corrPerEffect.PositiveHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,1);
    a(1:length_pos,5) = corrPerEffect.PositiveHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,6);
    a(1:length_pos,6) = corrPerEffect.PositiveHyst.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,11);
    a(1:length_null,7) = corrPerEffect.Null.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,1);
    a(1:length_null,8) = corrPerEffect.Null.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,6);
    a(1:length_null,9) = corrPerEffect.Null.(ROI_clean{comb(cc,1)}).(ROI_clean{comb(cc,2)}).Spearman(:,11);
    
    
    save(sprintf('%s_%s.mat',ROI_clean{comb(cc,1)}, ROI_clean{comb(cc,2)}), 'a')
end
