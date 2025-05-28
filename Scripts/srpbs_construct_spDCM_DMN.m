function srpbs_construct_spDCM_DMN(dataDir)
% srpbs_construct_spectral_DCM_subject(dataDir)
%
% This function constructs a spectral DCM for a single subject, using VOI time
% series data extracted from fMRI data. It takes the dataDir as input, which
% should contain the first-level GLM results (including the SPM.mat and VOI
% folder).
%
% Input:
% dataDir: Path to the subject's data directory, containing the first-level
% GLM results (e.g., '...\TNM_project\git\data\ds005917-download\sub-MOA101\ses-b0')
%
% Output:
% DCM.mat: A DCM structure saved in the subject's first-level GLM directory.
%
% ----------------------------------------------------------------------
% Author: Leon, Rico, Keyshav
% Adapted from: Herman, Imre Kertesz, Stefan Fraessle, TNU, UZH & ETHZ
% ----------------------------------------------------------------------

% Initialize SPM for batch processing without GUI
spm('defaults', 'fmri');
spm_jobman('initcfg');
spm_get_defaults('cmdline', true); % This is crucial for suppressing GUIs

% 1. Define Directories
% ----------------------
firstlevelDir = fullfile(dataDir, 'glm'); % Directory containing SPM.mat
voiDir = fullfile(firstlevelDir, 'VOI'); % Directory containing VOI data (.mat files)

% 2. Load VOI Data and SPM.mat
% -----------------------------
try
    spm_data = load(fullfile(firstlevelDir, 'SPM.mat'), 'SPM'); % Load SPM.mat into a struct
    SPM = spm_data.SPM; % Extract the SPM struct
catch
    error('Could not load SPM.mat from %s', fullfile(firstlevelDir, 'SPM.mat'));
end

%change this for constructing other DCMs
voi_files = dir(fullfile(voiDir, 'VOI_Default*.mat')); % select VOI files
if isempty(voi_files)
    error('No VOI data files found in %s.', voiDir);
end

num_regions = length(voi_files);

% Initialize Y structure
Y = struct();
for i = 1:num_regions
    % Load data for each region - 
    % file order does not matter for fully connected DCM
    temp = load(fullfile(voiDir, voi_files(i).name));
    
    % Assign to data matrix
    Y.y(:,i) = temp.Y;
    
    % Get the region names
    Y.name{i} = voi_files(i).name(1:end-4);
end

% Set sampling rate (TR)
Y.dt = SPM.xY.RT;

% 3. Specify and Estimate spectral DCM
% ------------------------------------
DCM = struct();

% Basic DCM setup
DCM.name = 'spDCM_DMN'; % Name for the saved file
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
DCM.a = ones(num_regions, num_regions); %- eye(num_regions);   % Enable all connections except self-connections
DCM.b = zeros(num_regions, num_regions);     % No modulatory effects
DCM.c = zeros(num_regions, 1);                  % No driving inputs
DCM.d = zeros(num_regions, num_regions, 0);     % No nonlinear modulations


try
    % Estimate the model
    
    DCM_est = spm_dcm_fmri_csd(DCM);
    params = DCM_est.Ep.A;

    % Save the DCM structure
    output_filename = fullfile(firstlevelDir, [DCM_est.name '.mat']);
    save(output_filename, 'params');

    
    
    disp(['Spectral DCM saved to: ' output_filename]);
catch ME
    fprintf('Error during spectral DCM estimation for %s:\n', dataDir);
    fprintf('Error message: %s\n', ME.message);
    fprintf('Error stack: \n');
    disp(getReport(ME, 'extended'));
end
end