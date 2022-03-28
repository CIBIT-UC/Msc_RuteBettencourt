%% Create trialvol and block metrics

%% Create struct with the BOLD signal from the PattComp, CompPatt,
%PattComp-->Static-->CompPatt and CompPatt-->Static-->PattComp

clear all, close all, clc

% KeypressData = load('Hysteresis-keypress-label-data.mat');

%path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
%path = '/home/alexandresayal/media-sim01/DATAPOOL/VPHYSTERESIS/BOLD_timecourses';

data = load('ROIs_BOLD_timecourse.mat'); % BOLD time courses

datavols = load('volume_onset.mat');

%% Define stuff

ROIs = data.ROIs_clean;
nROIs = data.nROIs;

runNames = {'run1','run2','run3','run4'};
nRuns = 4;

nTrials = 4;

%effectBlock_sz = 5; % in volumes

%window = 1:effectBlock_sz;

nVols = 21-1; %31.5/1.5 -1o volume

subs = 1:25;

subjects = cell(1,25);

for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

%%
for sub = subs
    
    for run = 1:nRuns
        
        %effect_list_idx = 4*(sub-1)+run; % index of specific subject and run (in the 100x1 matrix - 25 subjects x 4 runs = 100)
        
        %lastEffect_CompPatt = KeypressData.EffectBlockIndex_CompPatt(effect_list_idx); % last volume of effect block in CompPatt condition
        %lastEffect_PattComp = KeypressData.EffectBlockIndex_PattComp(effect_list_idx); % last volume of effect block in PattComp condition
        
        for rr = 1:nROIs
            
            %trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run-1}) = zeros(52, 2); %52=2*nvols+tstatic/1.5
            %trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run-1}) = zeros(52, 2);
            
            for trial = 1:nTrials
                
                %Uses the onset volume for the CompPatt condition for the trial
                volmin_CompPatt = datavols.volumes.(runNames{run}).CompPatt(trial);
                
                xx_CompPatt = volmin_CompPatt:(volmin_CompPatt+nVols); % block indexes
                
                CompPatt = data.BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_CompPatt,sub); % time course during the CompPatt block
                
                
                %Uses the onset volume for the PattComp condition for the
                %trial
                volmin_PattComp = datavols.volumes.(runNames{run}).PattComp(trial);
                
                xx_PattComp = volmin_PattComp:(volmin_PattComp+nVols);
                
                PattComp = data.BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_PattComp,sub);
                
                %Save the trial BOLD denoised signal in a struct
                trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run})(:,trial) = CompPatt;
                
                trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run})(:,trial) = PattComp;
                
                
                %                 %Creates the trajectory Compatt-->Static -->PattComp
                %                 if xx_PattComp(end)>xx_CompPatt(end)
                %
                %                     xx_full = volmin_CompPatt:(volmin_PattComp+nvols);
                %                     CompPatt2PattComp = BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_full,sub);
                %
                %                     if trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run-1})(:,1)==0
                %                         trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run-1})(:,1) = CompPatt2PattComp;
                %                     else
                %                         trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run-1})(:,2) = CompPatt2PattComp;
                %
                %                     end
                %
                %
                %                 else %Creates the opposite trajectory
                %
                %                     xx_full = volmin_PattComp:(volmin_CompPatt+nvols);
                %                     PattComp2CompPatt = BOLD_denoised_timecourse.(ROIs{rr}).(runNames{run})(xx_full,sub);
                %
                %                     if trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run-1})(:,1)==0
                %                         trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run-1})(:,1) = PattComp2CompPatt;
                %                     else
                %                         trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run-1})(:,2) = PattComp2CompPatt;
                %                     end
                %
                %                 end
                
                
            end
            
            %% Calculate trial averages
            meanCompPatt = mean(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run}),2);
            meanPattComp = mean(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run}),2);
            
            semCompPatt = std(trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run}),[],2) / sqrt(nTrials);
            semPattComp = std(trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run}),[],2) / sqrt(nTrials);
            
            %             meanCompPatt2PattComp = mean(trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runNames{run-1}),2);
            %             meanPattComp2CompPatt = mean(trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runNames{run-1}),2);
            
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).mean(:,run) = meanCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).mean(:,run) = meanPattComp;
            
            trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).sem(:,run) = semCompPatt;
            trialvol.PattComp.(ROIs{rr}).(subjects{sub}).sem(:,run) = semPattComp;
            
            %             trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).mean(:,run-1) = meanCompPatt2PattComp;
            %             trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).mean(:,run-1) = meanPattComp2CompPatt;
            
        end % end ROI iteration
        
    end % end run iteration
    
end % end subject iteration


save('new_trialvolumes.mat', 'trialvol')

%% Calculate the correlations and corresponding p-values

% Structure to save correlation time courses
correlationTCs = struct();

comb = combnk(1:7,2);

nCombinations = length(comb(:,1));

for idx = 1:nCombinations
    
    for ss = subs
        
        pvalsCompPatt = []; pvalsPattComp = [];
        rhosCompPatt = []; rhosPattComp = [];
%         rhosCompPatt2PattComp = []; rhosPattComp2CompPatt = [];
        pvalsSpearmanCompPatt = []; pvalsSpearmanPattComp = [];
        SpearmanCompPatt = []; SpearmanPattComp = [];
%         SpearmanCompPatt2PattComp = []; SpearmanPattComp2CompPatt = [];
        
        
        window1 = 1:5;
        %             window2 = 1:5;
        
        while window1(end) < 22
            
            % estimate correlation and p-value for all runs
            [rhoCompPatt, pvalCompPatt] = corr(...
                trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:)  );
            
            rhoCompPatt = diag(rhoCompPatt); % extract values per run
            pvalCompPatt = diag(pvalCompPatt); % extract values per run
            
            rhosCompPatt = [rhosCompPatt rhoCompPatt];
            pvalsCompPatt = [pvalsCompPatt pvalCompPatt];
            
            
            [rhoPattComp, pvalPattComp] = corr(...
                trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:) );
            
            rhoPattComp = diag(rhoPattComp);
            pvalPattComp = diag(pvalPattComp);
            rhosPattComp = [rhosPattComp rhoPattComp];
            pvalsPattComp =  [pvalsPattComp pvalPattComp];
            
            [rSpearmanCompPatt, pvalSpearmanCompPatt] = corr(...
                trialvol.CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:), ...
                'Type', 'Spearman');
            
            rSpearmanCompPatt = diag(rSpearmanCompPatt);
            pvalSpearmanCompPatt = diag(pvalSpearmanCompPatt);
            SpearmanCompPatt = [SpearmanCompPatt rSpearmanCompPatt];
            pvalsSpearmanCompPatt = [pvalsSpearmanCompPatt pvalSpearmanCompPatt];
            
            [rSpearmanPattComp, pvalSpearmanPattComp] = corr(...
                trialvol.PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window1,:), ...
                trialvol.PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window1,:), ...
                'Type', 'Spearman');
            
            rSpearmanPattComp = diag(rSpearmanPattComp);
            pvalSpearmanPattComp = diag(pvalSpearmanPattComp);
            SpearmanPattComp = [SpearmanPattComp rSpearmanPattComp];
            pvalsSpearmanPattComp = [pvalsSpearmanPattComp pvalSpearmanPattComp];
            
            window1 = window1+1;
            
        end
        %
        %                 while window2(end)<53
        %                     rhoCompPatt2PattComp = corr(trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
        %                         trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:));
        %                     rhoCompPatt2PattComp = diag(rhoCompPatt2PattComp);
        %                     rhosCompPatt2PattComp = [rhosCompPatt2PattComp rhoCompPatt2PattComp];
        %
        %                     rhoPattComp2CompPatt = corr(trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
        %                         trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:));
        %                     rhoPattComp2CompPatt = diag(rhoPattComp2CompPatt);
        %                     rhosPattComp2CompPatt = [rhosPattComp2CompPatt rhoPattComp2CompPatt];
        %
        %                     rSpearmanCompPatt2PattComp = corr(trialvol.CompPatt2PattComp.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
        %                         trialvol.CompPatt2PattComp.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:), 'Type', 'Spearman');
        %                     rSpearmanCompPatt2PattComp = diag(rSpearmanCompPatt2PattComp);
        %                     SpearmanCompPatt2PattComp = [SpearmanCompPatt2PattComp rSpearmanCompPatt2PattComp];
        %
        %                     rSpearmanPattComp2CompPatt = corr(trialvol.PattComp2CompPatt.(ROIs{comb(idx,1)}).(subjects{ss}).mean(window2,:),...
        %                         trialvol.PattComp2CompPatt.(ROIs{comb(idx,2)}).(subjects{ss}).mean(window2,:), 'Type', 'Spearman');
        %                     rSpearmanPattComp2CompPatt = diag(rSpearmanPattComp2CompPatt);
        %                     SpearmanPattComp2CompPatt = [SpearmanPattComp2CompPatt rSpearmanPattComp2CompPatt];
        %                     window2= window2+1;
        %
        %                 end
        
        % rhos
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt.(subjects{ss}) = rhosCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp.(subjects{ss}) = rhosPattComp';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt.(subjects{ss})= SpearmanCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp.(subjects{ss})= SpearmanPattComp';
        
        %p-values
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_CompPatt.(subjects{ss}) = pvalsCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalPearson_PattComp.(subjects{ss}) = pvalsPattComp';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_CompPatt.(subjects{ss})= pvalsSpearmanCompPatt';
        correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).pvalSpearman_PattComp.(subjects{ss})= pvalsSpearmanPattComp';
        
        
%         %Trajectory1 -->Static -->Trajectory2
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_CompPatt2PattComp.(subjects{ss})= rhosCompPatt2PattComp';
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrPearson_PattComp2CompPatt.(subjects{ss})= rhosPattComp2CompPatt';
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_CompPatt2PattComp.(subjects{ss})= SpearmanCompPatt2PattComp';
%         correlationTCs.(ROIs{comb(idx,1)}).(ROIs{comb(idx,2)}).corrSpearman_PattComp2CompPatt.(subjects{ss})= SpearmanPattComp2CompPatt';
%         
    end
    
    
end

save('correlationTCs.mat', 'correlationTCs')
