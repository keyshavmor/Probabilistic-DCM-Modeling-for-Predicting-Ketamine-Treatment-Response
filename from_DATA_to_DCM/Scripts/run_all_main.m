%this script is the main script to exceute the function over all subjects

%Author: Leon

%paths
thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);
addpath(scriptsDir);
projectRoot = fileparts(scriptsDir);

% Base directory containing all subject/session folders
baseDir     = fullfile(projectRoot, 'data', 'ds005917-download');

disp(['Using data folder: ', baseDir]);
assert(isfolder(baseDir), 'Cannot find data folder: %s', baseDir);

% Get list of all subject folders 
% you can filter here. e.g. use sub-MOA1* for only MDD participants
subjects = dir(fullfile(baseDir, 'sub-MOA*'));

% Loop over subjects
for i = 1:length(subjects)
    subjDir = fullfile(baseDir, subjects(i).name);
    
    % Get list of all session folders within each subject folder
    %select the session you want to use. use * for all sessions
    sessions = dir(fullfile(subjDir, 'ses-b0*'));
    
    for j = 1:length(sessions)
        dataDir = fullfile(subjDir, sessions(j).name);
        
        % Print current subject and session
        fprintf('Running subject %s, session %s\n', subjects(i).name, sessions(j).name);
        
        % Call the functions, comment out what you don't need
        try
            %preprocessing
            prepro_adj_subject(dataDir, 1);  % run = 0 -> dryrun, run = 1
            
            %glm
            glm_adj_subject(dataDir);
            
            %tic toc measures the time between tic and toc
            tic
            
            %select the DCM you want to use
            %use machting names for the extract_VOI and construct_spDCM scripts
            
            %extract_VOI_DMN(dataDir);
            %extract_VOI_rsTozzi_11(dataDir);
            %extract_VOI_rsTozzi_15(dataDir);
            extract_VOI_rsTozzi_K(dataDir);
            
            %construct_spDCM_DMN(dataDir);
            %construct_spDCM_rsTozzi_11(dataDir);
            %construct_spDCM_rsTozzi_15(dataDir);
            construct_spDCM_rsTozzi_K(dataDir);
            toc


        catch ME
            warning('Failed for %s %s: %s', subjects(i).name, sessions(j).name, ME.message);
        end
    end
end