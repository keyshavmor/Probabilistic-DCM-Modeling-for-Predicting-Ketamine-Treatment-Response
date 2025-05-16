%skript to run prepro and glm for one subject
% Path to the subject folder (must contain anat/ and func/ subfolders)

thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);


projectRoot = fileparts(scriptsDir);

baseDir     = fullfile(projectRoot, 'data', 'ds005917-download');

disp(['Using data folder: ', baseDir]);
assert(isfolder(baseDir), 'Cannot find data folder: %s', baseDir);
%dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-MOA101
%dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\git\data\ds005917-download\sub-MOA101\ses-b0';
dataDir = fullfile(baseDir, 'sub-MOA101', 'ses-b0');

% Run the preprocessing
%srpbs_prepro_adj2_subject(dataDir, 1);  % run = 0 -> dryrun, run = 1 -> run the batch directly, run = 2 -> SPM Batch editor gui
%srpbs_glm_adj_subject(dataDir);
srpbs_extract_VOI_subject(dataDir);
