thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);
addpath(scriptsDir);


projectRoot = fileparts(scriptsDir);


% Base directory containing all subject/session folders
baseDir     = fullfile(projectRoot, 'data', 'ds005917-download');

disp(['Using data folder: ', baseDir]);
assert(isfolder(baseDir), 'Cannot find data folder: %s', baseDir);



% Get list of all subject folders
subjects = dir(fullfile(baseDir, 'sub-MOA1*'));

% Loop over subjects
for i = 1:length(subjects)
    subjDir = fullfile(baseDir, subjects(i).name);
    
    % Get list of all session folders within each subject folder
    sessions = dir(fullfile(subjDir, 'ses-b0*'));
    
    for j = 1:length(sessions)
        dataDir = fullfile(subjDir, sessions(j).name);
        
        % Print current subject and session
        fprintf('Running subject %s, session %s\n', subjects(i).name, sessions(j).name);
        
        % Call the functions
        try
            srpbs_prepro_adj2_subject(dataDir, 1);  % run = 0 -> dryrun, run = 1
            %srpbs_glm_adj_subject(dataDir);
            
            %tic toc measures the time between tic and toc
            tic
            %srpbs_extract_VOI_DMN(dataDir);
            %srpbs_extract_VOI_rsTozzi_11(dataDir);
            srpbs_extract_VOI_rsTozzi_15(dataDir);
            %srpbs_extract_VOI_rsTozzi_K(dataDir);
            
            %srpbs_construct_spDCM_DMN(dataDir);
            %srpbs_construct_spDCM_rsTozzi_11(dataDir);
            srpbs_construct_spDCM_rsTozzi_15(dataDir);
            %srpbs_construct_spDCM_rsTozzi_K(dataDir);
            toc


        catch ME
            warning('Failed for %s %s: %s', subjects(i).name, sessions(j).name, ME.message);
        end
    end
end