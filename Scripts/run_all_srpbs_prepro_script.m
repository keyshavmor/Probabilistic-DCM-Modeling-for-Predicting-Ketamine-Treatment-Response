thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);
addpath(scriptsDir);


projectRoot = fileparts(scriptsDir);

baseDir     = fullfile(projectRoot, 'data', 'ds005917-download');

disp(['Using data folder: ', baseDir]);
assert(isfolder(baseDir), 'Cannot find data folder: %s', baseDir);




% Base directory containing all subject/session folders
%baseDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine';

% Get list of all subject folders
subjects = dir(fullfile(baseDir, 'sub-MOA*'));

% Loop over subjects
for i = 1:length(subjects)
    subjDir = fullfile(baseDir, subjects(i).name);
    
    % Get list of all session folders within each subject folder
    sessions = dir(fullfile(subjDir, 'ses-*'));
    
    for j = 1:length(sessions)
        dataDir = fullfile(subjDir, sessions(j).name);
        
        % Print current subject and session
        fprintf('Running subject %s, session %s\n', subjects(i).name, sessions(j).name);
        
        % Call the preprocessing function
        try
            %srpbs_prepro_adj2_subject(dataDir, 1);  % run = 0 -> dryrun, run = 1
            srpbs_glm_adj_subject(dataDir);
            srpbs_extract_VOI_subject(dataDir);
            srpbs_construct_spectral_DCM_subject_v1(dataDir);
        catch ME
            warning('Failed for %s %s: %s', subjects(i).name, sessions(j).name, ME.message);
        end
    end
end