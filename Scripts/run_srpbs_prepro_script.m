%skript to run prepro and glm for one subject
% Path to the subject folder (must contain anat/ and func/ subfolders)
%dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-MOA101
dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\git\data\ds005917-download\sub-MOA101\ses-b0';

% Run the preprocessing
srpbs_prepro_adj2_subject(dataDir, 0);  % run = 0 -> dryrun, run = 1 -> run the batch directly, run = 2 -> SPM Batch editor gui
%srpbs_glm_adj_subject(dataDir);
srpbs_extract_VOI_subject(dataDir);
