%% plot with effect block
clear all, close all, clc

effects_data = strip(fullfile(' ', 'DATAPOOL', 'home', 'rutebettencourt',...
    'Documents', 'GitHub', 'Msc_RuteBettencourt', 'Hysteresis-keypress-label-data.mat'));
load(effects_data)

path = strip(fullfile(' ','DATAPOOL', 'VPHYSTERESIS', 'BOLD_timecourses'));
data = fullfile(path, 'ROIs_BOLD_timecourse.mat');
datacon = fullfile(path, 'dynCon_metrics.mat');
datavols = fullfile(path, 'volume_onset.mat');
load(data); load(datacon); load(datavols);

comb = combnk(1:7,2);
idxs = 1:length(comb(:,1));

ROIs = fieldnames(BOLD_denoised_timecourse);
aux1 = strrep(ROIs,'_roi','');
ROIs_clean = strrep(aux1, '_','-');
nROIs = length(ROIs);

runs = fieldnames(BOLD_denoised_timecourse.SS_hMT_bilateral);
nruns =2:length(runs); %Ignore the concatenated runs
trials = 1:4;

effectBlock_sz = 5;
window = 1:effectBlock_sz;
nvols = 21-1; %31.5/1.5 -1o volume
runsnames = fieldnames(volumes);

subs = 1:25;
subjects = {};
for sub = subs
    subjects{sub} = sprintf('sub%d',sub);
end

for sub=subs
    for run = nruns
        for rr = 1:nROIs
            for trial = trials
            
                effect_list_idx = 4*(sub-1)+run-1;
                lastEffect_CompPatt = EffectBlockIndex_CompPatt(effect_list_idx);
                lastEffect_PattComp = EffectBlockIndex_PattComp(effect_list_idx);
               
                volmin_CompPatt = volumes.(runsnames{run-1}).CompPatt(trial);
                xx_CompPatt = volmin_CompPatt:(volmin_CompPatt+nvols);
                CompPatt = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_CompPatt,sub);
                
                volmin_PattComp = volumes.(runsnames{run-1}).PattComp(trial);
                xx_PattComp = volmin_PattComp:(volmin_PattComp+nvols);
                PattComp = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_PattComp,sub);
                
                trialvol.CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,trial) = CompPatt;
                trialvol.PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,trial) = PattComp;
                if xx_PattComp(end)>xx_CompPatt(end)
                    xx_full = volmin_CompPatt:(volmin_PattComp+nvols);
                    CompPatt2PattComp = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_full,sub);
                    trialvol.CompPatt2PattComp.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,trial) = CompPatt2PattComp;
                else
                    xx_full = volmin_PattComp:(volmin_CompPatt+nvols);
                    PattComp2CompPatt = BOLD_denoised_timecourse.(ROIs{rr}).(runs{run})(xx_full,sub);
                    trialvol.PattComp2CompPatt.(ROIs{rr}).(subjects{sub}).(runsnames{run-1})(:,trial) = PattComp2CompPatt;
                end
                
            end
        end
    end
end

save(fullfile(path,'trialvolumes.mat'), 'trialvol')