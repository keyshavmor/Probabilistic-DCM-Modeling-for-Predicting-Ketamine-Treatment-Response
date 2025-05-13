
% Path to the subject folder (must contain anat/ and func/ subfolders)
dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-MOA101\ses-d2';
%C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-MOA101\ses-d2

% Run the preprocessing
srpbs_prepro_adj_subject(dataDir, 1);  % run = 0 -> dryrun, run = 1 -> run the batch directly, run = 2 -> SPM Batch editor gui