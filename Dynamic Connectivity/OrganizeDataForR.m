clear,clc

%% Load and settings
load("correlation_per_effect_p2.mat")

nTime = 3;
nEffect = 2;
Times = [1 6 11];
TimesLabels = {'Pre','Effect','Post'};
Effect = [1 2];
EffectLabels = {'NegativeHyst','PositiveHyst'};
EffectSamples = [50 60];

regions = {'FEF_bilateral','IPS_bilateral','Insula_right','SPL_bilateral','V3A_bilateral','hMT_bilateral','SS_hMT_bilateral', 'Sph_hMT_SS_bilateral'};

%% Output matrix

OUT = zeros(EffectSamples(1)*nTime+EffectSamples(2)*nTime,3); % column 1 - effect , column 2 - time , column 2 - data

OUT(1:EffectSamples(1)*nTime,1) = 1;
OUT(EffectSamples(1)*nTime+1:end,1) = 2;

OUT(1:EffectSamples(1),2) = 1;
OUT(EffectSamples(1)+1:EffectSamples(1)*2,2) = 2;
OUT(EffectSamples(1)*2+1:EffectSamples(1)*3,2) = 3;

OUT(EffectSamples(1)*3+1:EffectSamples(1)*3+EffectSamples(2),2) = 1;
OUT(EffectSamples(1)*3+1+EffectSamples(2):EffectSamples(1)*3+EffectSamples(2)*2,2) = 2;
OUT(EffectSamples(1)*3+1+EffectSamples(2)*2:end,2) = 3;

%% Iterate on the ROIs

comb = combnk(1:length(regions),2);

nCombinations = size(comb,1);

for ii = 1:nCombinations

    OUT(1:EffectSamples(1)*nTime,3) = reshape(corrPerEffect.(EffectLabels{1}).(regions{comb(ii,1)}).(regions{comb(ii,2)}).Spearman(:,Times),[EffectSamples(1)*nTime 1]);
    
    OUT(EffectSamples(1)*nTime+1:end,3) = reshape(corrPerEffect.(EffectLabels{2}).(regions{comb(ii,1)}).(regions{comb(ii,2)}).Spearman(:,Times),[EffectSamples(2)*nTime 1]);
    
    save(sprintf('./outputForR/%s--%s.mat',regions{comb(ii,1)},regions{comb(ii,2)}),'OUT')

end
