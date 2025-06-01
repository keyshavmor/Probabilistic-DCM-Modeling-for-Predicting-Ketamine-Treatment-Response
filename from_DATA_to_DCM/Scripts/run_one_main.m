%script to call functions for one subject

%Author: Leon

%paths
thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);
addpath(scriptsDir);
projectRoot = fileparts(scriptsDir);
baseDir     = fullfile(projectRoot, 'data', 'ds005917-download');

disp(['Using data folder: ', baseDir]);
assert(isfolder(baseDir), 'Cannot find data folder: %s', baseDir);

%select subject & session
dataDir = fullfile(baseDir, 'sub-MOA101', 'ses-b0');

% Run the preprocessing
%prepro_adj_subject(dataDir, 0);  % run = 0 -> dryrun, run = 1 
glm_adj_subject(dataDir);

tic %measures time between tic and toc

%select matching exctract_VOI and construct_spDCM scripts
%extract_VOI_DMN(dataDir);
%extract_VOI_rsTozzi_15(dataDir);
extract_VOI_rsTozzi_K(dataDir);

%construct_spDCM_DMN(dataDir);
%construct_spDCM_rsTozzi_15(dataDir);
construct_spDCM_rsTozzi_K(dataDir);
toc
