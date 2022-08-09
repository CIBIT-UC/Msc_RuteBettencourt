% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/DATAPOOL/home/rutebettencourt/Documents/GitHub/Msc_RuteBettencourt/VOI_task_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
