
% Path to the subject folder (must contain anat/ and func/ subfolders)
%dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-test1';
dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-MOA101\ses-d2';

% Run the preprocessing
srpbs_prepro_adj2_subject(dataDir, 0);  % run = 0 -> dryrun, run = 1 -> run the batch directly, run = 2 -> SPM Batch editor gui
srpbs_glm_adj_subject(dataDir);