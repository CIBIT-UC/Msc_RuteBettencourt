%% plot with effect block
clear all, close all, clc

effects_data = strip(fullfile(' ', 'DATAPOOL', 'home', 'rutebettencourt',...
    'Documents', 'GitHub', 'Msc_RuteBettencourt', 'Hysteresis-keypress-label-data.mat'));
load(effects_data)

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'new_trialvolumes.mat');
datacon = fullfile(path, 'new_blockmetrics.mat');
load(data); load(datacon); 

%Cell with ROIs names
ROIs = fieldnames(trialvol.CompPatt);
aux1 = strrep(ROIs,'_roi','');
ROIs_clean = strrep(aux1, '_','-');

comb = combnk(1:7,2); % To iterate in ROIs
idxs = 1:length(comb(:,1));

runs = 1:4;
runname = {};
for run = runs
    runname{run} = sprintf('run-%1d',run);
end

%SLIDING WINDOW
window = 1:5;

subjects = fieldnames(trialvol.CompPatt.FEF_bilateral_roi);
subs = 1:25;

xx_condition = 1:21;
xx_corr = 1:17;

effectblocks = struct();

effectblocks.Negative.CompPatt.block = zeros(20,25);
effectblocks.adjustedNegative.CompPatt.block = zeros(20,25);
effectblocks.Negative.PattComp.block = zeros(20,25);
effectblocks.adjustedNegative.PattComp.block = zeros(20,25);
effectblocks.Positive.CompPatt.block = zeros(20,25);
effectblocks.adjustedPositive.CompPatt.block = zeros(20,25);
effectblocks.Positive.PattComp.block = zeros(20,25);
effectblocks.adjustedPositive.PattComp.block = zeros(20,25);
effectblocks.Null.CompPatt.block = zeros(20,25);
effectblocks.adjustedNull.CompPatt.block = zeros(20,25);
effectblocks.Null.PattComp.block = zeros(20,25);
effectblocks.adjustedNull.PattComp.block = zeros(20,25);
effectblocks.Undefined.CompPatt.block = zeros(20,25);
effectblocks.adjustedUndefined.CompPatt.block = zeros(20,25);
effectblocks.Undefined.PattComp.block = zeros(20,25); %4runs*window, block size
effectblocks.adjustedUndefined.PattComp.block = zeros(20,25);


for sub=subs
    for run = runs
        
        %Gets the last point from the effect block for each subject/run
        effect_list_idx = 4*(sub-1)+run; 
        lastEffect_CompPatt = EffectBlockIndex_CompPatt(effect_list_idx);
        lastEffect_PattComp = EffectBlockIndex_PattComp(effect_list_idx);

        effect_CompPatt = Effect_CompPatt(effect_list_idx); %Neg, Pos, Null Und
        effect_PattComp = Effect_PattComp(effect_list_idx); %Neg, Pos, Null Und

        %Set the xx values for the Effect Block for CompPatt
        if lastEffect_CompPatt>=5 && lastEffect_CompPatt<=17 %NORMAL CASE
            effectBlock_CompPatt = window + lastEffect_CompPatt-5;
            effectBlock_CompPatt_corr = effectBlock_CompPatt;
            %Effects
            if effect_CompPatt == 1 %Negative Hysteresis
                effectblocks.Negative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 2 %Positive Hysteresis
                effectblocks.Positive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 3 %Null
                effectblocks.Null.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 4 %Undefined
                effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            end
            
            %ADJUSTED WINDOWS
        elseif lastEffect_CompPatt<5 
            effectBlock_CompPatt = 1:5;
            effectBlock_CompPatt_corr = effectBlock_CompPatt;
            if effect_CompPatt == 1 %Negative Hysteresis
                effectblocks.Negative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedNegative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 2 %Positive Hysteresis
                effectblocks.Positive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedPositive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 3 %Null
                effectblocks.Null.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedNull.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 4 %Undefined
                effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedUndefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            end
            
        elseif lastEffect_CompPatt>17
            effectBlock_CompPatt = 17:21;
            effectBlock_CompPatt_corr = 13:17;
            
            if effect_CompPatt == 1 %Negative Hysteresis
                effectblocks.Negative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedNegative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 2 %Positive Hysteresis
                effectblocks.Positive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedPositive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 3 %Null
                effectblocks.Null.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedNull.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            elseif effect_CompPatt == 4 %Undefined
                effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
                effectblocks.adjustedUndefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
            end
        end

        % Set the xx values for the Effect Block for PattComp
        if lastEffect_PattComp>=5 && lastEffect_PattComp<=17 %NORMAL CASE
            effectBlock_PattComp = window + lastEffect_PattComp-5;
            effectBlock_PattComp_corr = effectBlock_PattComp;
            if effect_PattComp == 1 %Negative Hysteresis
                effectblocks.Negative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 2 %Positive Hysteresis
                effectblocks.Positive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 3 %Null
                effectblocks.Null.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 4 %Undefined
                effectblocks.Undefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            end
            
            %ADJUSTED SLIDING WINDOWS
        elseif lastEffect_PattComp<5
            effectBlock_PattComp = 1:5;
            effectBlock_PattComp_corr = effectBlock_PattComp;
            
            if effect_PattComp == 1 %Negative Hysteresis
                effectblocks.Negative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedNegative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 2 %Positive Hysteresis
                effectblocks.Positive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedPositive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 3 %Null
                effectblocks.Null.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedNull.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 4 %Undefined
                effectblocks.Undefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedUndefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            end
            
        elseif lastEffect_PattComp>17
            effectBlock_PattComp = 17:21;
            effectBlock_PattComp_corr = 13:17;
            
            if effect_PattComp == 1 %Negative Hysteresis
                effectblocks.Negative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedNegative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 2 %Positive Hysteresis
                effectblocks.Positive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedPositive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 3 %Null
                effectblocks.Null.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedNull.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            elseif effect_PattComp == 4 %Undefined
                effectblocks.Undefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
                effectblocks.adjustedUndefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
            end
        end


    end
end
% path2 = strip(fullfile(' ','DATAPOOL', 'home', 'rutebettencourt', 'Documents', 'GitHub', 'Msc_RuteBettencourt'));
% save(fullfile(path2, 'block_with_effects_idx.mat'), 'effectblocks')

%% Create fields for each effect/ROIs depending on the indexes saved in the last section
%Get the effect block indexes (x axis) for each ROI pair and the 
%corresponding y-value (correlation) for each condition
%Save in effect block in the format (window run, subject)
%NaN is atributted to the cell if it is other effect, so it doesn't
%influence the mean
for sub = 1:25
    for idx=idxs
        for run = 1:4

            %CompPatt
            %NEGATIVE
            xx_Negative_CompPatt = effectblocks.Negative.CompPatt.block(window+5*(run-1),sub);
            if xx_Negative_CompPatt ~= zeros(5,1)
                yy_Negative_CompPatt = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Negative_CompPatt, run);
                effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_CompPatt;
            else
                yy_Negative_CompPatt = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_CompPatt;
            end
            %POSITIVE
            xx_Positive_CompPatt = effectblocks.Positive.CompPatt.block(window+5*(run-1),sub);
            if xx_Positive_CompPatt ~= zeros(5,1)
                yy_Positive_CompPatt = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Positive_CompPatt, run);
                effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_CompPatt;
            else
                yy_Positive_CompPatt = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_CompPatt;
            end
            %NULL
            xx_Null_CompPatt = effectblocks.Null.CompPatt.block(window+5*(run-1),sub);
            if xx_Null_CompPatt ~= zeros(5,1)
                yy_Null_CompPatt = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Null_CompPatt, run);
                effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_CompPatt;
            else
                yy_Null_CompPatt = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_CompPatt;
            end
            %UNDEFINED
            xx_Undefined_CompPatt = effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub);
            if xx_Undefined_CompPatt ~= zeros(5,1)
                yy_Undefined_CompPatt = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Undefined_CompPatt, run);
                effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_CompPatt;  
            else
                yy_Undefined_CompPatt = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_CompPatt;
            end
            
            %PattComp
            %NEGATIVE
            xx_Negative_PattComp = effectblocks.Negative.PattComp.block(window+5*(run-1),sub);
            if xx_Negative_PattComp ~= zeros(5,1)
                yy_Negative_PattComp = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Negative_PattComp, run);
                effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_PattComp;
            else
                yy_Negative_PattComp = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_PattComp;
            end
            
            %POSITIVE
            xx_Positive_PattComp = effectblocks.Positive.PattComp.block(window+5*(run-1),sub);
            if xx_Positive_PattComp ~= zeros(5,1)
                yy_Positive_PattComp = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Positive_PattComp, run);
                effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_PattComp;
            else
                yy_Positive_PattComp = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_PattComp;
            end
            
            %NULL
            xx_Null_PattComp = effectblocks.Null.PattComp.block(window+5*(run-1),sub);
            if xx_Null_PattComp ~= zeros(5,1)
                yy_Null_PattComp = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Null_PattComp, run);
                effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_PattComp;
            else
                yy_Null_PattComp = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_PattComp;
            end
            
            %UNDEFINED
            xx_Undefined_PattComp = effectblocks.Undefined.PattComp.block(window+5*(run-1),sub);
            if xx_Undefined_PattComp ~= zeros(5,1)
                yy_Undefined_PattComp = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Undefined_PattComp, run);
                effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_PattComp;  
            else
                yy_Undefined_PattComp = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_PattComp;
            end           
        end
    end        
end

%% Plot the mean effect block

path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'MEAN-EFFECT-BLOCK'));
if ~exist(path2, 'dir')
    mkdir(path2);
end

for idx = idxs
    %CompPatt
    %Calculates the mean for each line in each condition
    NegCompPatt = mean(effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    PosCompPatt = mean(effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    NulCompPatt = mean(effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    UndCompPatt = mean(effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    
    %Creates 5x4 double with the mean values for each run
    NegativeCompPatt = [NegCompPatt(1:5) NegCompPatt(6:10) NegCompPatt(11:15) NegCompPatt(16:20)];
    PositiveCompPatt = [PosCompPatt(1:5) PosCompPatt(6:10) PosCompPatt(11:15) PosCompPatt(16:20)];
    NullCompPatt = [NulCompPatt(1:5) NulCompPatt(6:10) NulCompPatt(11:15) NulCompPatt(16:20)];
    UndefinedCompPatt = [UndCompPatt(1:5) UndCompPatt(6:10) UndCompPatt(11:15) UndCompPatt(16:20)];
    
    %Creates a 5x1 double with the mean correlation values for the effect block
    mNEGCompPatt = mean(NegativeCompPatt, 2, 'omitnan');
    mPOSCompPatt = mean(PositiveCompPatt, 2, 'omitnan');
    mNULLCompPatt = mean(NullCompPatt, 2, 'omitnan');
    mUNDEFINEDCompPatt = mean(UndefinedCompPatt, 2, 'omitnan');
    
    %PattComp
    NegPattComp = mean(effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    PosPattComp = mean(effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    NulPattComp = mean(effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    UndPattComp = mean(effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');

    NegativePattComp = [NegPattComp(1:5) NegPattComp(6:10) NegPattComp(11:15) NegPattComp(16:20)];
    PositivePattComp = [PosPattComp(1:5) PosPattComp(6:10) PosPattComp(11:15) PosPattComp(16:20)];
    NullPattComp = [NulPattComp(1:5) NulPattComp(6:10) NulPattComp(11:15) NulPattComp(16:20)];
    UndefinedPattComp = [UndPattComp(1:5) UndPattComp(6:10) UndPattComp(11:15) UndPattComp(16:20)];

    mNEGPattComp = mean(NegativePattComp, 2, 'omitnan');
    mPOSPattComp = mean(PositivePattComp, 2, 'omitnan');
    mNULLPattComp = mean(NullPattComp, 2, 'omitnan');
    mUNDEFINEDPattComp = mean(UndefinedPattComp, 2, 'omitnan');
    
    figuren = figure(idx);
    subplot 211
    plot(1:5, mNEGCompPatt, '-v',...
        1:5, mPOSCompPatt, '-+',...
        1:5, mNULLCompPatt, '-o',...
        1:5, mUNDEFINEDCompPatt, '-s')
    
    %legend('Negative hysteresis', 'Positive Hysteresis', 'Null', 'Undefined')
    title(sprintf('Effect block in  CohInc \n %s - %s', string(ROIs_clean{comb(idx,1)}),string(ROIs_clean{comb(idx,2)})));
    xlabel('Effect block'), ylabel('Mean Pearson Correlation')
    ylim([-1 1])
    
    subplot 212
    plot(1:5, mNEGPattComp, '-v',...
        1:5, mPOSPattComp, '-+',...
        1:5, mNULLPattComp, '-o',...
        1:5, mUNDEFINEDPattComp, '-s')
    
    lgd = legend('Negative hysteresis', 'Positive Hysteresis', 'Null', 'Undefined', 'Position', [0.5 0.04 0.01 0.01]);
    lgd.NumColumns = 4;
    title(sprintf('Effect block in  IncCoh \n %s - %s', string(ROIs_clean{comb(idx,1)}),string(ROIs_clean{comb(idx,2)})));
    xlabel('Effect block'), ylabel('Mean Pearson Correlation')
    ylim([-1 1])
    

    
     saveas(figuren, fullfile(path2,sprintf('%s_%s_meaneffectblock.png',...
                 string(ROIs_clean(comb(idx,2))), string(ROIs_clean(comb(idx,1))))))
end


save(fullfile(path2, 'block_with_effects_idx.mat'), 'effectblocks')
