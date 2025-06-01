function construct_spectral_DCM_subject_v1(dataDir)

%This was the first version for constructing a spDCM - we didnt end up using it
%kept it for testing purposes

% This function constructs a spectral DCM for a single subject, using VOI time
% series data extracted from fMRI data. It takes the dataDir as input, which
% should contain the first-level GLM results (including the SPM.mat and VOI
% folder).

% Input:
% dataDir: Path to the subject's data directory, containing the first-level
% GLM results (e.g., '...\TNM_project\git\data\ds005917-download\sub-MOA101\ses-b0')

% Output:
% DCM.mat: A DCM structure saved in the subject's first-level GLM directory.

% Author: Leon
% Adapted from: Imre Kertesz, Stefan Fraessle, TNU, UZH & ETHZ


% Initialize SPM for batch processing without GUI
spm('defaults', 'fmri');
spm_jobman('initcfg');
spm_get_defaults('cmdline', true); % This is crucial for suppressing GUIs


firstlevelDir = fullfile(dataDir, 'glm'); % Directory containing SPM.mat
voiDir = fullfile(firstlevelDir, 'VOI'); % Directory containing VOI data (.mat files)

% Load VOI Data and SPM.mat

try
    spm_data = load(fullfile(firstlevelDir, 'SPM.mat'), 'SPM'); % Load SPM.mat into a struct
    SPM = spm_data.SPM; % Extract the SPM struct
catch
    error('Could not load SPM.mat from %s', fullfile(firstlevelDir, 'SPM.mat'));
end

voi_files = dir(fullfile(voiDir, 'VOI_Default*.mat')); % select VOI files
if isempty(voi_files)
    error('No VOI data files found in %s.', voiDir);
end

num_regions = length(voi_files);

% Initialize Y structure
Y = struct();
for i = 1:num_regions
    % Load data for each region
    temp = load(fullfile(voiDir, voi_files(i).name));
    
    % Assign to data matrix
    Y.y(:,i) = temp.Y;
    
    % Get the region names
    Y.name{i} = voi_files(i).name(1:end-4);
end

% Set sampling rate (TR)
Y.dt = SPM.xY.RT;

% Specify and Estimate spectral DCM

DCM = [];

% Basic DCM setup
DCM.name = 'Spectral_DCM'; % Name for the saved file
DCM.n = num_regions; % Number of regions
DCM.v = size(Y.y, 1); % Number of scans/timepoints

% Setup I/O and data
DCM.Y = Y; % VOI data
DCM.xY = Y; % Copy to xY field for compatibility
DCM.xY.RT = Y.dt; % Set TR
DCM.xY.name = Y.name; % Region names
DCM.xY.Dfile = fullfile(firstlevelDir, 'SPM.mat'); % Path to SPM.mat
DCM.xY.modality = 'fMRI'; % Modality

% For spectral DCM, we don't need inputs
DCM.U.u = zeros(DCM.v, 1); % Empty input
DCM.U.name = {'null'};  % Input name
DCM.U.dt = Y.dt; % Input timing

% Connectivity matrices - start with fully connected model
DCM.a = ones(num_regions) - eye(num_regions);   % Enable all connections except self-connections
DCM.b = zeros(num_regions, num_regions, 0);     % No modulatory effects
DCM.c = zeros(num_regions, 1);                  % No driving inputs
DCM.d = zeros(num_regions, num_regions, 0);     % No nonlinear modulations

% Options for spectral DCM
DCM.options.analysis = 'CSD';  % Cross-Spectral Density (for spectral DCM)
DCM.options.model = 'fMRI';    % fMRI model
DCM.options.spatial = 'local'; % Local spatial model       -?
DCM.options.Nmax = 64;         % Number of frequency bins  -?
DCM.options.Tdcm = [];  % Effective number of observations (let SPM estimate)
DCM.options.Fdcm = [0.008 0.1]; % Frequency range for analysis (in Hz) -?
DCM.options.D = 1; % Down-sampling (decimation)            -?
DCM.options.nograph = 0; % Allow graphs
DCM.options.centre = 1; % Mean center inputs               -?
DCM.options.induced = 1; % Use induced responses           -?
DCM.options.stochastic = 1; % Enable stochastic terms      -?
DCM.options.nonlinear = 0; % No nonlinear effects          -?
DCM.options.two_state = 0; % Use one-state model
DCM.options.one_state = 1; % Confirm one-state model
DCM.options.maxnodes = 8; % Maximum iterations             -?
DCM.options.maxit = 128; % Maximum iterations              -?
DCM.options.hidden = [];  % No hidden regions

try
    % Estimate the model
    DCM = spm_dcm_estimate(DCM);
    
    % Save the DCM structure
    output_filename = fullfile(firstlevelDir, [DCM.name '.mat']);
    save(output_filename, 'DCM');
    
    disp(['Spectral DCM saved to: ' output_filename]);
catch ME
    fprintf('Error during spectral DCM estimation for %s:\n', dataDir);
    fprintf('Error message: %s\n', ME.message);
    fprintf('Error stack: \n');
    disp(getReport(ME, 'extended'));
end
end