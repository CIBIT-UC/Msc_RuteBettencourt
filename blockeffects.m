%% plot with effect block
clear all, close all, clc

effects_data = load(strip(fullfile(' ', 'DATAPOOL', 'home', 'rutebettencourt',...
    'Documents', 'GitHub', 'Msc_RuteBettencourt', 'Hysteresis-keypress-label-data.mat')));
%load(effects_data)

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
runNames = {'run1', 'run2', 'run3', 'run4'};
% for run = runs
%     runNames{run} = sprintf('run-%1d',run);
% end

effect = {'Negative', 'Positive', 'Null', 'Undefined'};
markers = {'v','+','o','s'}; 
%SLIDING WINDOW
window = 1:5;
windowSize = length(window);

subjects = fieldnames(trialvol.CompPatt.FEF_bilateral_roi);
subs = 1:25;

xx_condition = 1:21;
xx_corr = 1:17;

%Create structure to save effect blocks
effectblocks = struct();

% effectblocks.Negative.CompPatt.block = zeros(20,25); %4runs*window, block size
% effectblocks.Adjusted.Negative.CompPatt.block = zeros(20,25);
% effectblocks.Negative.PattComp.block = zeros(20,25);
% effectblocks.Adjusted.Negative.PattComp.block = zeros(20,25);
% effectblocks.Positive.CompPatt.block = zeros(20,25);
% effectblocks.Adjusted.Positive.CompPatt.block = zeros(20,25);
% effectblocks.Positive.PattComp.block = zeros(20,25);
% effectblocks.Adjusted.Positive.PattComp.block = zeros(20,25);
% effectblocks.Null.CompPatt.block = zeros(20,25);
% effectblocks.Adjusted.Null.CompPatt.block = zeros(20,25);
% effectblocks.Null.PattComp.block = zeros(20,25);
% effectblocks.Adjusted.Null.PattComp.block = zeros(20,25);
% effectblocks.Undefined.CompPatt.block = zeros(20,25);
% effectblocks.Adjusted.Undefined.CompPatt.block = zeros(20,25);
% effectblocks.Undefined.PattComp.block = zeros(20,25); 
% effectblocks.Adjusted.Undefined.PattComp.block = zeros(20,25);

for ii = 1:4
    effectblocks.(effect{ii}).CompPatt.block = zeros(20,25); %4runs*window, block size
    effectblocks.Adjusted.(effect{ii}).CompPatt.block = zeros(20,25);
    effectblocks.(effect{ii}).PattComp.block = zeros(20,25);
    effectblocks.Adjusted.(effect{ii}).PattComp.block = zeros(20,25);
end


for sub=subs
    
    for run = runs
        
        %Gets the last point from the effect block for each subject/run
        effect_list_idx = 4*(sub-1)+run; % index of specific subject and run (in the 100x1 matrix - 25 subjects x 4 runs = 100)
        
        lastEffect_CompPatt = effects_data.EffectBlockIndex_CompPatt(effect_list_idx); % last volume of effect block in CompPatt condition
        lastEffect_PattComp = effects_data.EffectBlockIndex_PattComp(effect_list_idx); % last volume of effect block in PattComp condition

        effect_CompPatt = effects_data.Effect_CompPatt(effect_list_idx); %Neg, Pos, Null Und
        effect_PattComp = effects_data.Effect_PattComp(effect_list_idx); %Neg, Pos, Null Und

        %Set the xx values for the Effect Block for CompPatt
        if lastEffect_CompPatt>=5 && lastEffect_CompPatt<=17 %NORMAL CASE
            
            effectBlock_CompPatt = lastEffect_CompPatt-(windowSize-1):lastEffect_CompPatt;
            effectBlock_CompPatt_corr = effectBlock_CompPatt; % (end)?? -->se for subsitituir no DynConn_04
            
            %Effects
%             if effect_CompPatt == 1 %Negative Hysteresis
%                 effectblocks.Negative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 2 %Positive Hysteresis
%                 effectblocks.Positive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 3 %Null
%                 effectblocks.Null.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 4 %Undefined
%                 effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             end
            
            effectblocks.(effect{effect_CompPatt}).CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;

            %ADJUSTED WINDOWS
        elseif lastEffect_CompPatt<5 
            
            effectBlock_CompPatt = 1:5;
            effectBlock_CompPatt_corr = effectBlock_CompPatt;
            
%             if effect_CompPatt == 1 %Negative Hysteresis
%                 effectblocks.Negative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedNegative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 2 %Positive Hysteresis
%                 effectblocks.Positive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedPositive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 3 %Null
%                 effectblocks.Null.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedNull.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 4 %Undefined
%                 effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedUndefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             end

            effectblocks.(effect{effect_CompPatt}).CompPatt.block(window+5*(run-1), sub) = effectBlock_CompPatt_corr;
            effectblocks.Adjusted.(effect{effect_CompPatt}).CompPatt.block(window+5*(run-1), sub) = effectBlock_CompPatt_corr;
            
        elseif lastEffect_CompPatt>17
            
            effectBlock_CompPatt = 17:21;
            effectBlock_CompPatt_corr = 13:17;
            
%             if effect_CompPatt == 1 %Negative Hysteresis
%                 effectblocks.Negative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedNegative.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 2 %Positive Hysteresis
%                 effectblocks.Positive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedPositive.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 3 %Null
%                 effectblocks.Null.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedNull.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             elseif effect_CompPatt == 4 %Undefined
%                 effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%                 effectblocks.adjustedUndefined.CompPatt.block(window+5*(run-1),sub) = effectBlock_CompPatt_corr;
%             end

            effectblocks.(effect{effect_CompPatt}).CompPatt.block(window+5*(run-1), sub) = effectBlock_CompPatt_corr;
            effectblocks.Adjusted.(effect{effect_CompPatt}).CompPatt.block(window+5*(run-1), sub) = effectBlock_CompPatt_corr;
       
        end

        % Set the xx values for the Effect Block for PattComp
        if lastEffect_PattComp>=5 && lastEffect_PattComp<=17 %NORMAL CASE
            
            effectBlock_PattComp = window + lastEffect_PattComp-5;
            effectBlock_PattComp_corr = effectBlock_PattComp; 
            
%             if effect_PattComp == 1 %Negative Hysteresis
%                 effectblocks.Negative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 2 %Positive Hysteresis
%                 effectblocks.Positive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 3 %Null
%                 effectblocks.Null.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 4 %Undefined
%                 effectblocks.Undefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             end
            
            effectblocks.(effect{effect_PattComp}).PattComp.block(window+5*(run-1), sub) = effectBlock_PattComp_corr;

            
            %ADJUSTED SLIDING WINDOWS
        elseif lastEffect_PattComp<5
            
            effectBlock_PattComp = 1:5;
            effectBlock_PattComp_corr = 1:5;
            
%             if effect_PattComp == 1 %Negative Hysteresis
%                 effectblocks.Negative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedNegative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 2 %Positive Hysteresis
%                 effectblocks.Positive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedPositive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 3 %Null
%                 effectblocks.Null.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedNull.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 4 %Undefined
%                 effectblocks.Undefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedUndefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             end

            effectblocks.(effect{effect_PattComp}).PattComp.block(window+5*(run-1), sub) = effectBlock_PattComp_corr;
            effectblocks.Adjusted.(effect{effect_PattComp}).PattComp.block(window+5*(run-1), sub) = effectBlock_PattComp_corr;
            
        elseif lastEffect_PattComp>17
            
            effectBlock_PattComp = 17:21;
            effectBlock_PattComp_corr = 13:17;
            
%             if effect_PattComp == 1 %Negative Hysteresis
%                 effectblocks.Negative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedNegative.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 2 %Positive Hysteresis
%                 effectblocks.Positive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedPositive.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 3 %Null
%                 effectblocks.Null.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedNull.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             elseif effect_PattComp == 4 %Undefined
%                 effectblocks.Undefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%                 effectblocks.adjustedUndefined.PattComp.block(window+5*(run-1),sub) = effectBlock_PattComp_corr;
%             end

            effectblocks.(effect{effect_PattComp}).PattComp.block(window+5*(run-1), sub) = effectBlock_PattComp_corr;
            effectblocks.Adjusted.(effect{effect_PattComp}).PattComp.block(window+5*(run-1), sub) = effectBlock_PattComp_corr;
        end


    end
end
path2 = strip(fullfile(' ','DATAPOOL', 'home', 'rutebettencourt', 'Documents', 'GitHub', 'Msc_RuteBettencourt'));
save(fullfile(path2, 'block_with_effects_idx.mat'), 'effectblocks')

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
                
                yy_Negative_CompPatt_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Negative_CompPatt, run);
                effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_CompPatt_Pearson;
                yy_Negative_CompPatt_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(xx_Negative_CompPatt, run);
                effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Negative_CompPatt_Spearman;
            
            else
                
                yy_Negative_CompPatt_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_CompPatt_Pearson;
                yy_Negative_CompPatt_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Negative_CompPatt_Spearman;
            
            end
            
            %POSITIVE
            
            xx_Positive_CompPatt = effectblocks.Positive.CompPatt.block(window+5*(run-1),sub);
            
            if xx_Positive_CompPatt ~= zeros(5,1)
            
                yy_Positive_CompPatt_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Positive_CompPatt, run);
                effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_CompPatt_Pearson;
                yy_Positive_CompPatt_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(xx_Positive_CompPatt, run);
                effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Positive_CompPatt_Spearman;
           
            else
                
                yy_Positive_CompPatt_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_CompPatt_Pearson;
                yy_Positive_CompPatt_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Positive_CompPatt_Spearman;
            
            end
            
            %NULL
            
            xx_Null_CompPatt = effectblocks.Null.CompPatt.block(window+5*(run-1),sub);
            
            if xx_Null_CompPatt ~= zeros(5,1)
            
                yy_Null_CompPatt_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Null_CompPatt, run);
                effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_CompPatt_Pearson;
                yy_Null_CompPatt_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(xx_Null_CompPatt, run);
                effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Null_CompPatt_Spearman;
            
            else
                
                yy_Null_CompPatt_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_CompPatt_Pearson;
                yy_Null_CompPatt_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Null_CompPatt_Spearman;
            
            end
            
            %UNDEFINED
            
            xx_Undefined_CompPatt = effectblocks.Undefined.CompPatt.block(window+5*(run-1),sub);
            
            if xx_Undefined_CompPatt ~= zeros(5,1)
            
                yy_Undefined_CompPatt_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{sub})(xx_Undefined_CompPatt, run);
                effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_CompPatt_Pearson; 
                yy_Undefined_CompPatt_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{sub})(xx_Undefined_CompPatt, run);
                effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Undefined_CompPatt_Spearman;  
            
            else
                
                yy_Undefined_CompPatt_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_CompPatt_Pearson;
                yy_Undefined_CompPatt_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Undefined_CompPatt_Spearman;
            
            end
            
            %PattComp
            
            %NEGATIVE
            
            xx_Negative_PattComp = effectblocks.Negative.PattComp.block(window+5*(run-1),sub);
            
            if xx_Negative_PattComp ~= zeros(5,1)
            
                yy_Negative_PattComp_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Negative_PattComp, run);
                effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_PattComp_Pearson;
                yy_Negative_PattComp_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(xx_Negative_PattComp, run);
                effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Negative_PattComp_Spearman;
            
            else
                
                yy_Negative_PattComp_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Negative_PattComp_Pearson;
                yy_Negative_PattComp_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Negative_PattComp_Spearman;
            
            end
            
            %POSITIVE
            
            xx_Positive_PattComp = effectblocks.Positive.PattComp.block(window+5*(run-1),sub);
            
            if xx_Positive_PattComp ~= zeros(5,1)
            
                yy_Positive_PattComp_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Positive_PattComp, run);
                effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_PattComp_Pearson;
                yy_Positive_PattComp_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(xx_Positive_PattComp, run);
                effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Positive_PattComp_Spearman;
            
            else
                
                yy_Positive_PattComp_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_PattComp_Pearson;
                yy_Positive_PattComp_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Positive.Spearman.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Positive_PattComp_Spearman;
            
            end
            
            %NULL
            
            xx_Null_PattComp = effectblocks.Null.PattComp.block(window+5*(run-1),sub);
            
            if xx_Null_PattComp ~= zeros(5,1)
            
                yy_Null_PattComp_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Null_PattComp, run);
                effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_PattComp_Pearson;
                yy_Null_PattComp_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(xx_Null_PattComp, run);
                effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Null_PattComp_Spearman;
            
            else
                
                yy_Null_PattComp_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Null_PattComp_Pearson;
                yy_Null_PattComp_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Null_PattComp_Spearman;
            
            end
            
            %UNDEFINED
            
            xx_Undefined_PattComp = effectblocks.Undefined.PattComp.block(window+5*(run-1),sub);
            
            if xx_Undefined_PattComp ~= zeros(5,1)
            
                yy_Undefined_PattComp_Pearson = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{sub})(xx_Undefined_PattComp, run);
                effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_PattComp_Pearson;  
                yy_Undefined_PattComp_Spearman = blockmetrics.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{sub})(xx_Undefined_PattComp, run);
                effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Undefined_PattComp_Spearman;  
            
            else
                
                yy_Undefined_PattComp_Pearson = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson(window+5*(run-1),sub) = yy_Undefined_PattComp_Pearson;
                yy_Undefined_PattComp_Spearman = [NaN; NaN; NaN; NaN; NaN] ;
                effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman(window+5*(run-1),sub) = yy_Undefined_PattComp_Spearman;
            
            end           
        end %runs
    end %idxs        
end %subs

%% Plot the mean effect block

path2 = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'MEAN-EFFECT-BLOCK'));
if ~exist(path2, 'dir')
    mkdir(path2);
end

for idx = idxs
    
    %PEARSON CORRELATION
    %CompPatt
    %Calculates the mean for each line in each condition
    
    NegCompPatt_Pearson = mean(effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    PosCompPatt_Pearson = mean(effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    NulCompPatt_Pearson = mean(effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    UndCompPatt_Pearson = mean(effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    
    %Creates 5x4 double with the mean values for each run
    NegativeCompPatt_Pearson = [NegCompPatt_Pearson(1:5) NegCompPatt_Pearson(6:10) NegCompPatt_Pearson(11:15) NegCompPatt_Pearson(16:20)];
    PositiveCompPatt_Pearson = [PosCompPatt_Pearson(1:5) PosCompPatt_Pearson(6:10) PosCompPatt_Pearson(11:15) PosCompPatt_Pearson(16:20)];
    NullCompPatt_Pearson = [NulCompPatt_Pearson(1:5) NulCompPatt_Pearson(6:10) NulCompPatt_Pearson(11:15) NulCompPatt_Pearson(16:20)];
    UndefinedCompPatt_Pearson = [UndCompPatt_Pearson(1:5) UndCompPatt_Pearson(6:10) UndCompPatt_Pearson(11:15) UndCompPatt_Pearson(16:20)];
    
    %Creates a 5x1 double with the mean correlation values for the effect block
    mNEGCompPatt_Pearson = mean(NegativeCompPatt_Pearson, 2, 'omitnan');
    mPOSCompPatt_Pearson = mean(PositiveCompPatt_Pearson, 2, 'omitnan');
    mNULLCompPatt_Pearson = mean(NullCompPatt_Pearson, 2, 'omitnan');
    mUNDEFINEDCompPatt_Pearson = mean(UndefinedCompPatt_Pearson, 2, 'omitnan');
    
    %PattComp
    NegPattComp_Pearson = mean(effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    PosPattComp_Pearson = mean(effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    NulPattComp_Pearson = mean(effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');
    UndPattComp_Pearson = mean(effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Pearson,2, 'omitnan');

    NegativePattComp_Pearson = [NegPattComp_Pearson(1:5) NegPattComp_Pearson(6:10) NegPattComp_Pearson(11:15) NegPattComp_Pearson(16:20)];
    PositivePattComp_Pearson = [PosPattComp_Pearson(1:5) PosPattComp_Pearson(6:10) PosPattComp_Pearson(11:15) PosPattComp_Pearson(16:20)];
    NullPattComp_Pearson = [NulPattComp_Pearson(1:5) NulPattComp_Pearson(6:10) NulPattComp_Pearson(11:15) NulPattComp_Pearson(16:20)];
    UndefinedPattComp_Pearson = [UndPattComp_Pearson(1:5) UndPattComp_Pearson(6:10) UndPattComp_Pearson(11:15) UndPattComp_Pearson(16:20)];

    mNEGPattComp_Pearson = mean(NegativePattComp_Pearson, 2, 'omitnan');
    mPOSPattComp_Pearson = mean(PositivePattComp_Pearson, 2, 'omitnan');
    mNULLPattComp_Pearson = mean(NullPattComp_Pearson, 2, 'omitnan');
    mUNDEFINEDPattComp_Pearson = mean(UndefinedPattComp_Pearson, 2, 'omitnan');
    
    figuren = figure(idx);
    subplot 211
    plot(1:5, mNEGCompPatt_Pearson, '-v',...
        1:5, mPOSCompPatt_Pearson, '-+',...
        1:5, mNULLCompPatt_Pearson, '-o',...
        1:5, mUNDEFINEDCompPatt_Pearson, '-s')
    
    %legend('Negative hysteresis', 'Positive Hysteresis', 'Null', 'Undefined')
    title(sprintf('Effect block in  CohInc \n %s - %s', string(ROIs_clean{comb(idx,1)}),string(ROIs_clean{comb(idx,2)})));
    xlabel('Effect block'), ylabel('Mean Pearson Correlation')
    ylim([-1 1])
    
    subplot 212
    plot(1:5, mNEGPattComp_Pearson, '-v',...
        1:5, mPOSPattComp_Pearson, '-+',...
        1:5, mNULLPattComp_Pearson, '-o',...
        1:5, mUNDEFINEDPattComp_Pearson, '-s')
    
    lgd = legend('Negative hysteresis', 'Positive Hysteresis', 'Null', 'Undefined', 'Position', [0.5 0.04 0.01 0.01]);
    lgd.NumColumns = 4;
    title(sprintf('Effect block in  IncCoh \n %s - %s', string(ROIs_clean{comb(idx,1)}),string(ROIs_clean{comb(idx,2)})));
    xlabel('Effect block'), ylabel('Mean Pearson Correlation')
    ylim([-1 1])
    

    
    saveas(figuren, fullfile(path2,sprintf('%s_%s_meaneffectblock.png',...
        string(ROIs_clean(comb(idx,2))), string(ROIs_clean(comb(idx,1))))));
     
    %SPEARMAN CORRELATION
    %CompPatt
    %Calculates the mean for each line in each condition
    NegCompPatt_Spearman = mean(effectblocks.Negative.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    PosCompPatt_Spearman = mean(effectblocks.Positive.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    NulCompPatt_Spearman = mean(effectblocks.Null.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    UndCompPatt_Spearman = mean(effectblocks.Undefined.CompPatt.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    
    %Creates 5x4 double with the mean values for each run
    NegativeCompPatt_Spearman = [NegCompPatt_Spearman(1:5) NegCompPatt_Spearman(6:10) NegCompPatt_Spearman(11:15) NegCompPatt_Spearman(16:20)];
    PositiveCompPatt_Spearman = [PosCompPatt_Spearman(1:5) PosCompPatt_Spearman(6:10) PosCompPatt_Spearman(11:15) PosCompPatt_Spearman(16:20)];
    NullCompPatt_Spearman = [NulCompPatt_Spearman(1:5) NulCompPatt_Spearman(6:10) NulCompPatt_Spearman(11:15) NulCompPatt_Spearman(16:20)];
    UndefinedCompPatt_Spearman = [UndCompPatt_Spearman(1:5) UndCompPatt_Spearman(6:10) UndCompPatt_Spearman(11:15) UndCompPatt_Spearman(16:20)];
    
    %Creates a 5x1 double with the mean correlation values for the effect block
    mNEGCompPatt_Spearman = mean(NegativeCompPatt_Spearman, 2, 'omitnan');
    mPOSCompPatt_Spearman = mean(PositiveCompPatt_Spearman, 2, 'omitnan');
    mNULLCompPatt_Spearman = mean(NullCompPatt_Spearman, 2, 'omitnan');
    mUNDEFINEDCompPatt_Spearman = mean(UndefinedCompPatt_Spearman, 2, 'omitnan');
    
    %PattComp
    NegPattComp_Spearman = mean(effectblocks.Negative.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    PosPattComp_Spearman = mean(effectblocks.Positive.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    NulPattComp_Spearman = mean(effectblocks.Null.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');
    UndPattComp_Spearman = mean(effectblocks.Undefined.PattComp.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).Spearman,2, 'omitnan');

    NegativePattComp_Spearman = [NegPattComp_Spearman(1:5) NegPattComp_Spearman(6:10) NegPattComp_Spearman(11:15) NegPattComp_Spearman(16:20)];
    PositivePattComp_Spearman = [PosPattComp_Spearman(1:5) PosPattComp_Spearman(6:10) PosPattComp_Spearman(11:15) PosPattComp_Spearman(16:20)];
    NullPattComp_Spearman = [NulPattComp_Spearman(1:5) NulPattComp_Spearman(6:10) NulPattComp_Spearman(11:15) NulPattComp_Spearman(16:20)];
    UndefinedPattComp_Spearman = [UndPattComp_Spearman(1:5) UndPattComp_Spearman(6:10) UndPattComp_Spearman(11:15) UndPattComp_Spearman(16:20)];

    mNEGPattComp_Spearman = mean(NegativePattComp_Spearman, 2, 'omitnan');
    mPOSPattComp_Spearman = mean(PositivePattComp_Spearman, 2, 'omitnan');
    mNULLPattComp_Spearman = mean(NullPattComp_Spearman, 2, 'omitnan');
    mUNDEFINEDPattComp_Spearman = mean(UndefinedPattComp_Spearman, 2, 'omitnan');
    
    figurem = figure(idx);
    subplot 211
    plot(1:5, mNEGCompPatt_Spearman, '-v',...
        1:5, mPOSCompPatt_Spearman, '-+',...
        1:5, mNULLCompPatt_Spearman, '-o',...
        1:5, mUNDEFINEDCompPatt_Spearman, '-s')
    
    %legend('Negative hysteresis', 'Positive Hysteresis', 'Null', 'Undefined')
    title(sprintf('Effect block in  CohInc \n %s - %s', string(ROIs_clean{comb(idx,1)}),string(ROIs_clean{comb(idx,2)})));
    xlabel('Effect block'), ylabel('Mean Spearman Correlation')
    ylim([-1 1])
    
    subplot 212
    plot(1:5, mNEGPattComp_Spearman, '-v',...
        1:5, mPOSPattComp_Spearman, '-+',...
        1:5, mNULLPattComp_Spearman, '-o',...
        1:5, mUNDEFINEDPattComp_Spearman, '-s')
    
    lgd = legend('Negative hysteresis', 'Positive Hysteresis', 'Null', 'Undefined', 'Position', [0.5 0.04 0.01 0.01]);
    lgd.NumColumns = 4;
    title(sprintf('Effect block in  IncCoh \n %s - %s', string(ROIs_clean{comb(idx,1)}),string(ROIs_clean{comb(idx,2)})));
    xlabel('Effect block'), ylabel('Mean Spearman Correlation')
    ylim([-1 1])
    

    
     saveas(figurem, fullfile(path2,sprintf('%s_%s_meaneffectblock_Spearman.png',...
                 string(ROIs_clean(comb(idx,2))), string(ROIs_clean(comb(idx,1))))));
             
            
end


save(fullfile(path2, 'block_with_effects_idx.mat'), 'effectblocks')
