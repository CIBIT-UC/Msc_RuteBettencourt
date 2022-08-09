%% Copy events.tsv files to the derivatives/spm_main folder



for sub = 3:25
    
    for run = 1:4
        file = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/sub-%02d/func/sub-%02d_task-main_run-%02d_events.tsv', sub, sub, run);
        folder = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func', sub);
        
        copyfile(file, folder);
    end % run iteration
    
end %sub iteration

%%
% %---------------------%
% % Convert Onset Times %
% %---------------------%
% 
% % Converts timing files from BIDS format into a two-column format that can
% % be read by SPM
% 
% % The columns are:
% % 1. Onset (in seconds); and
% % 2. Duration (in seconds
% 
% 
% % Run this script from the directory that contains all of your subjects
% % (i.e., the Flanker directory)

%subjects = [01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25]; % Replace with a list of all of the subjects you wish to analyze


for sub= 1:25
    
    %sub = num2str(sub, '%02d'); % Zero-pads each number so that the subject ID is 2 characters long
    
    %cd(['sub-' sub '/func']) % Navigate to the subject's directory
    
    for run = 1:4
        % Set event file and path to work in
        path = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func', sub);
        cd(path)
        
        file = sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/func/sub-%02d_task-main_run-%02d_events.tsv', sub, sub, run)
        
        % Read the data from the .tsv file
        onsetTimes = tdfread(file, '\t'); % Read onset times file
        onsetTimes.trial_type = string(onsetTimes.trial_type); % Convert char array to string array, to make logical comparisons easier
        
        % Conditions
        Discard = [];
        Static = [];
        CompPatt = [];
        PattComp = [];
        MAE = [];
        
        % Get the onsets and duration for each condition from the .tsv file
        for i = 1:length(onsetTimes.onset)
            
            if strtrim(onsetTimes.trial_type(i,:)) == 'Discard'
                Discard = [Discard; onsetTimes.onset(i,:) onsetTimes.duration(i,:)];
                
            elseif strtrim(onsetTimes.trial_type(i,:)) == 'Static'
                Static = [Static; onsetTimes.onset(i,:) onsetTimes.duration(i,:)];
                
            elseif strtrim(onsetTimes.trial_type(i,:)) == 'Patt_Comp'
                PattComp = [PattComp; onsetTimes.onset(i,:) onsetTimes.duration(i,:)];
                
            elseif strtrim(onsetTimes.trial_type(i,:)) == 'Comp_Patt'
                CompPatt = [CompPatt; onsetTimes.onset(i,:) onsetTimes.duration(i,:)];
                
            elseif strtrim(onsetTimes.trial_type(i,:)) == 'MAE'
                MAE = [MAE; onsetTimes.onset(i,:) onsetTimes.duration(i,:)];
                
            end %if
            
        end % onset iteration
        
        %cd(path)
        save(sprintf('Discard_run-%02d.txt', run), 'Discard', '-ASCII');
        save(sprintf('Static_run-%02d.txt', run), 'Static', '-ASCII');
        save(sprintf('PattComp_run-%02d.txt', run), 'PattComp', '-ASCII');
        save(sprintf('CompPatt_run-%02d.txt', run), 'CompPatt', '-ASCII');
        save(sprintf('MAE_run-%02d.txt', run), 'MAE', '-ASCII');
    end % run iteration
    

end % subject iteration
