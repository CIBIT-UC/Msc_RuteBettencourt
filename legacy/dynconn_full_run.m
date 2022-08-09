%% Window is the same size of the trial

clear all, close all, clc

data = load('ROIs_BOLD_timecourse_p2.mat'); % BOLD time courses

datavols = load('volume_onset.mat');

%% Define stuff

ROIs = data.ROIs_clean;
nROIs = data.nROIs;

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

nVols = 21-1; %(31.5 trial)/1.5 -1o volume
%nStatic = 10; %15/1.5
subs = 1:25;

subjects = cell(1,25);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

%%
for sub = subs
    
    for run = 1:nRuns
                 
        for rr = 1:nROIs
                       
            for trial = 1:nTrials
                
                %Uses the onset volume for the CompPatt condition for the trial
                volmin_CompPatt = datavols.volumes.(runNames{run}).CompPatt(trial);
                
                xx_CompPatt = (volmin_CompPatt):(volmin_CompPatt+nVols); % block indexes
                
                CompPatt = data.BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_CompPatt,sub); % time course during the CompPatt block
                
                
                %Uses the onset volume for the PattComp condition for the
                %trial
                volmin_PattComp = datavols.volumes.(runNames{run}).PattComp(trial);
                
                xx_PattComp = (volmin_PattComp):(volmin_PattComp+nVols);
                
                PattComp = data.BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_PattComp,sub);
                
                %Save the trial BOLD denoised signal in a struct
                trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run})(:,trial) = CompPatt;
                
                trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run})(:,trial) = PattComp;      
                
                %Sace the condition volumes in a struct
                trialvol.CompPatt.volumeIdx.(runNames{run})(:,trial) = xx_CompPatt;
                
                trialvol.PattComp.volumeIdx.(runNames{run})(:,trial) = xx_PattComp;
                
            end %end trial iteration
            
            %% Calculate trial averages and sem
            meanCompPatt = mean(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run}),2);
            meanPattComp = mean(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run}),2);
            
            semCompPatt = std(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run}),[],2) / sqrt(nTrials);
            semPattComp = std(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run}),[],2) / sqrt(nTrials);
            
            %Save in struct
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).mean(:,run) = meanCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).mean(:,run) = meanPattComp;
            
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).sem(:,run) = semCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).sem(:,run) = semPattComp;
            
            
        end % end ROI iteration
        
    end % end run iteration
    
end % end subject iteration

save('trialvolumes.mat', 'trialvol');

%% Calculate the correlations and corresponding p-values

% Structure to save correlation time courses
correlationTCs = struct();

windowSz = 21;
comb = combnk(1:8,2);

nCombinations = length(comb(:,1));

for idx = 1:nCombinations
    
    for ss = subs
        
        pvalsCompPatt = []; pvalsPattComp = [];
        rhosCompPatt = []; rhosPattComp = [];

        pvalsSpearman = []; %pvalsSpearmanPattComp = [];
        Spearman = []; %SpearmanPattComp = [];

        
        
        window = 1:windowSz;
                
        while window(end) < 267
            
            % estimate correlation and p-value for all runs
%             [rhoCompPatt, pvalCompPatt] = corr(...
%                 trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
%                 trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:)  );
%             
%             rhoCompPatt = diag(rhoCompPatt); % extract values per run
%             pvalCompPatt = diag(pvalCompPatt); % extract values per run
%             
%             rhosCompPatt = [rhosCompPatt rhoCompPatt];
%             pvalsCompPatt = [pvalsCompPatt pvalCompPatt];
%             
%             
%             [rhoPattComp, pvalPattComp] = corr(...
%                 trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
%                 trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:) );
%             
%             rhoPattComp = diag(rhoPattComp);
%             pvalPattComp = diag(pvalPattComp);
%             rhosPattComp = [rhosPattComp rhoPattComp];
%             pvalsPattComp =  [pvalsPattComp pvalPattComp];
            
            [rSpearman, pvalSpearman] = corr(...
                data.BOLD_denoised_timecourse.(ROIs{comb(idx,1)}).(runNames{run})(window,ss), ...
                data.BOLD_denoised_timecourse.(ROIs{comb(idx,2)}).(runNames{run})(window,ss), ...
                'Type', 'Spearman');
            
            rSpearman = diag(rSpearman);
            pvalSpearman = diag(pvalSpearman);
            Spearman = [Spearman rSpearman];
            pvalsSpearman = [pvalsSpearman pvalSpearman];
            
%             [rSpearmanPattComp, pvalSpearmanPattComp] = corr(...
%                 trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window,:), ...
%                 trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window,:), ...
%                 'Type', 'Spearman');
%             
%             rSpearmanPattComp = diag(rSpearmanPattComp);
%             pvalSpearmanPattComp = diag(pvalSpearmanPattComp);
%             SpearmanPattComp = [SpearmanPattComp rSpearmanPattComp];
%             pvalsSpearmanPattComp = [pvalsSpearmanPattComp pvalSpearmanPattComp];
            
            window = window+1;
            
        end %while

        
        % rhos
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{ss}) = rhosCompPatt';
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{ss}) = rhosPattComp';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman.(subjects{ss})= Spearman';
%        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{ss})= SpearmanPattComp';
        
        %p-values
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_CompPatt.(subjects{ss}) = pvalsCompPatt';
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_PattComp.(subjects{ss}) = pvalsPattComp';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman.(subjects{ss})= pvalsSpearman';
%        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_PattComp.(subjects{ss})= pvalsSpearmanPattComp';
        
              
    end %subjects iteration
    
    
end %ROIs combination iteration

save('correlationTCs_fullrun.mat', 'correlationTCs');
%% 
KeypressData = load('Hysteresis-keypress-label-data.mat');

load('ROIs_BOLD_timecourse_p2.mat','ROIs_clean');
nROIs = length(ROIs_clean);

nSubs = 25;
comb = combnk(1:8,2);

nCombinations = length(comb(:,1));

% X axis data
% xx_condition = 1:21;
% xx_corr = 1:17;

clrMap = lines;

effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
nEffects = length(effects);

%% Count number of runs per effect
nRunsPerEffect_CompPatt = histcounts(KeypressData.Effect_CompPatt);
nRunsPerEffect_PattComp = histcounts(KeypressData.Effect_PattComp);

%% Initialize correlation matrices for all ROI pairs per effect
corrPerEffect = struct();

for cc = 1:nCombinations
    
    for ee = 1:nEffects
        
        %corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson = zeros(nRunsPerEffect_CompPatt(ee),21); 
        %corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson = zeros(nRunsPerEffect_PattComp(ee),21); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman = zeros(nRunsPerEffect_CompPatt(ee),246); 
        corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman = zeros(nRunsPerEffect_PattComp(ee),246); 
        
    end
    
end

%% Iterate on the ROI combinations to fetch correlations
for cc = 1:nCombinations
    
        %% Start counters
        subrunidx = 1; % index to iterate in the 100x1 matrix
        counterPerEffect_CompPatt = ones(1,nEffects);
        counterPerEffect_PattComp = ones(1,nEffects);

        %% Iterate on the subjects and runs
        for ss = 1:nSubs
            
            for rr = 1:4
                
                auxEffect_CompPatt = KeypressData.Effect_CompPatt(subrunidx); % effect in this run for CompPatt condition
                auxEffect_PattComp = KeypressData.Effect_PattComp(subrunidx); % effect in this run for PattComp condition
                

%% 
                % fetch Correlations                
                                
                %Trial 
  
%                 corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson(counterPerEffect_CompPatt(auxEffect_CompPatt), 11:20) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_CompPatt.(subjects{ss})(corrIdxBlock_CompPatt:corrIdxBlock_CompPatt+9,rr);
                
%                 corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson(counterPerEffect_PattComp(auxEffect_PattComp), 11:20) = ...
%                     datacon.correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrPearson_PattComp.(subjects{ss})(corrIdxBlock_PattComp:corrIdxBlock_PattComp+9,rr);
               
                corrPerEffect.(effects{auxEffect_CompPatt}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman(counterPerEffect_CompPatt(auxEffect_CompPatt), :) = ...
                    correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman.(subjects{ss})';
                
                corrPerEffect.(effects{auxEffect_PattComp}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman(counterPerEffect_PattComp(auxEffect_PattComp), :) = ...
                    correlationTCs.(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).corrSpearman.(subjects{ss})';
                
                
                                
                % add to counters
                subrunidx = subrunidx + 1;
                
                counterPerEffect_CompPatt(auxEffect_CompPatt) = counterPerEffect_CompPatt(auxEffect_CompPatt) + 1;
                counterPerEffect_PattComp(auxEffect_PattComp) = counterPerEffect_PattComp(auxEffect_PattComp) + 1;
                
            end %runs
            
        end %subjects
    %% Concatenate the CompPatt and PattComp correlation values for each effect in the struct field with size
    %((NCompPatt+NPattComp) x 11)
        for ee = 1:nEffects
%             corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson = ...
%                 [corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Pearson;...
%                 corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Pearson];
%             
            corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman = ...
                [corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).CompPatt.Spearman;...
                corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).PattComp.Spearman];
            
        end %effects
        

        
end %ROIs

%%


% Iterate on the ROI combinations
for cc = 1:nCombinations-3
    
    %% Spearman
    %idx = 1;
    meanCorrBlock = zeros(2,4); % lines 1 Spearman, 2 Pearson, columns effects
    semCorrBlock = zeros(2,4);
    meanCorrPre = zeros(2,4);
    semCorrPre = zeros(2,4);
    meanCorrPos = zeros(2,4);
    semCorrPos = zeros(2,4);
    meanCorrVols_Spearman = zeros(4,246);
    semCorrVols_Spearman = zeros(4,246);%lines effects, column correlations TCs
    meanCorrVols_Pearson = zeros(4,246);
    semCorrVols_Pearson = zeros(4,246);
%%    
    
    % calculate means and SEM for each effect
    for ee = 1:nEffects
        

        %The 11 correlation volumes
        meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman, 'omitnan');
        %meanCorrVols_Pearson(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson, 'omitnan');
        
        semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
    %    semCorrVols_Pearson(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{comb(cc,1)}).(ROIs_clean{comb(cc,2)}).Pearson, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

    end  
    %% Plot Effects 
    fig1 = figure('position',[50 50 1100 900]);
    
    for ee = 1:nEffects   
        hold on
        %subplot 211
        e4 = errorbar(1:246, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:), 'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 1,'markersize',1,'marker','.');
        LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
        H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
    end

    hold off
%    legend(LH, H,'location','southeast', 'FontSize', 14)
    xlabel('Sliding window', 'FontSize', 16); xlim([0 247]);
    xticks([15 46 77 108 139 170 201 232]); xticklabels({'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition'});
    ylabel('Spearman correlation', 'FontSize', 16); 
    ylim([-0.2 0.6])
    
    title(sprintf('%s <--> %s',ROIs_clean{comb(cc,1)},ROIs_clean{comb(cc,2)}),'interpreter','none')
end

%% hMT comparison

xx = 1:3; %four effect
nEffects = length(xx);
effects = {'NegativeHyst', 'PositiveHyst', 'Null', 'Undefined'};
saveFig3Path = fullfile('/DATAPOOL', 'VPHYSTERESIS', 'ROI_SELECTION_FULL_RUN', 'SPEARMAN');

if ~exist(saveFig3Path, 'dir')
    mkdir(saveFig3Path);
end

for rr = 1:5 %ROI indexes that aren't hMT
    
    %% Define matrixes

    meanCorrVols_Spearman = zeros(12,246);
    semCorrVols_Spearman = zeros(12,246);%lines effects (1st 4 group, 5-8 SS hMT cluster, 9-12 spherical, column correlations TCs
    %deltaCorrVols_Spearman = zeros(3,246);
    saveas(fig3, fullfile(saveFig3Path,sprintf('%s.png',ROIs_clean{rr})))
    %Preprare iteration
    idx = 1; %matrix index
    aux = 1; %subplot index
    
    %Open figure
    fig3 = figure('position',[50 50 1100 900]);
      
    for mt = 6:8 %ROI indexes that are hMT
            
    % calculate means and SEM for each effect
        for ee = 1:nEffects

            meanCorrVols_Spearman(ee,:) = mean(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan');
            semCorrVols_Spearman(ee,:) = std(corrPerEffect.(effects{ee}).(ROIs_clean{rr}).(ROIs_clean{mt}).Spearman, 'omitnan') / sqrt(nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));

        end %end ee iteration
        
%         deltaCorrVols_Spearman(mt-5,:) = meanCorrVols_Spearman(1,:) -meanCorrVols_Spearman(2,:);
%         semCorrVols_Spearman(mt-5,:) = sqrt(0.45*(semCorrVols_Spearman(1,:)).^2 + 0.55*(semCorrVols_Spearman(2,:)).^2); %>>>>>>>>>>>>>>>>>>CHECK
   
        %% Plot Spearman effects 
        subplot(2,2,aux) %Open subplot

        for ee = 1:3   

            hold on

            line([0 247],[0 0],'linestyle',':','color','k') %y=0
            e1 = errorbar(1:246, meanCorrVols_Spearman(ee,:), semCorrVols_Spearman(ee,:),'color',clrMap(6+3*ee,:),'linestyle','-','linewidth', 2);
            %e2 = errorbar(1:246, deltaCorrVols_Spearman(aux,:), semCorrVols_Spearman(aux,:), 'color', clrMap(15,:),'linestyle','-','linewidth', 2);
            LH(ee) = plot(nan, nan, '-' , 'color',clrMap(6+3*ee,:),'linewidth',2);
            H{ee} = sprintf('%s (N=%d)',effects{ee}, nRunsPerEffect_CompPatt(ee)+nRunsPerEffect_PattComp(ee));
        end

        hold off
        
        %Subplot properties
        xlabel('Sliding window N = 21', 'FontSize', 16);% xlim([2 30]);
        xticks([15 46 77 108 139 170 201 232]); xticklabels({'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition', 'Motion condition'});
        ylabel('Spearman correlation', 'FontSize', 16); 
        ylim([-0.2 0.5])      


        title(sprintf('%s <--> %s',ROIs_clean{rr},ROIs_clean{mt}),'interpreter','none')
        
        %Prepare next iteration
        idx = idx + 1;
        aux = aux+1;
        
        
        
    end %end mt iteration

    legend(LH(1:3), H(1:3),'Position', [0.1 0.05 0.001 0.001], 'FontSize', 14);
   % saveas(fig3, fullfile(saveFig3Path,sprintf('%s.png',ROIs_clean{rr})));
end