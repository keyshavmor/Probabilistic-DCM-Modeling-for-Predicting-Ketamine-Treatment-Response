function srpbs_construct_DCM_subject(dataDir)

%unfinished 
% This script demonstrates how to construct a DCM that can be used for
% effective connectivity analysis using rDCM. In order to use this script,
% TAPAS needs to be installed. This script is written for a single subject.
% The final DCM.mat file is saved in the sub-0001 folder.
% TAPAS can be downloaded here: https://translationalneuromodeling.github.io/tapas/

% Created: May 2024, Imre Kertesz, Translational Neuromodeling Unit, IBT
% University and ETH Zurich


% define where the code is located
%example dataDir: ...\TNM_project\git\data\ds005917-download\sub-MOA101\ses-b0 
%choose baseDir that work for your datastructure
%[baseDir, ~] = fileparts(mfilename('fullpath'));
%[baseDir, ~, ~] = fileparts(dataDir);
% add the path to Matlab ( PLEASE ADAPT THIS )
%addpath(genpath(fullfile(baseDir,'tapas','rdcm')));

% define the relevant folders
%firstlevelDir	= fullfile(baseDir,'sub-0001','glm');
firstlevelDir	= fullfile(dataDir,'glm');
voiDir          = fullfile(firstlevelDir,'VOI');

%parcelDir       = fullfile(baseDir,'Brainnetome2016');
%change this later
parcelDir = 'C:\Users\leon\Programming\Julia\TNM_project\git\rois Tozzi';

% load the structural connectome
load(fullfile(parcelDir,'StructConn.mat'),"adjacency_matrix");
args.a = adjacency_matrix;

% find all BOLD signal time series
files = dir(fullfile(voiDir,'VOI*.mat'));


% load the SPM.mat for the regressors
load(fullfile(firstlevelDir,'SPM.mat'),'SPM');


% load the BOLD signal time series
for region_number = 1:length(files)
    
    % load data for each regions
    temp = load(fullfile(voiDir,files(region_number).name));
    
    % asign to data matrix
    Y.y(:,region_number) = temp.Y;
    
    % get the repetition time
    Y.dt = SPM.xY.RT;
    
    % get the region names
    Y.name{region_number} = files(region_number).name(1:end-4);
    
end

% set-up a DCM structure, using the structural connectome as network architecture
DCM = tapas_rdcm_model_specification(Y,[],args);

save(fullfile(baseDir,'sub-0001','DCM.mat'),'DCM')

end