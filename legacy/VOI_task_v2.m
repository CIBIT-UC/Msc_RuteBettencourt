% List of open inputs
% Volume of Interest: Select SPM.mat - cfg_files
% Volume of Interest: Adjust data - cfg_entry
% Volume of Interest: Which session - cfg_entry
% Volume of Interest: Name of VOI - cfg_entry
% Volume of Interest: Image file - cfg_files
% Volume of Interest: Expression - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'/DATAPOOL/home/rutebettencourt/Documents/GitHub/Msc_RuteBettencourt/VOI_task_v2_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(6, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Volume of Interest: Select SPM.mat - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Volume of Interest: Adjust data - cfg_entry
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Volume of Interest: Which session - cfg_entry
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % Volume of Interest: Name of VOI - cfg_entry
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % Volume of Interest: Image file - cfg_files
    inputs{6, crun} = MATLAB_CODE_TO_FILL_INPUT; % Volume of Interest: Expression - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
