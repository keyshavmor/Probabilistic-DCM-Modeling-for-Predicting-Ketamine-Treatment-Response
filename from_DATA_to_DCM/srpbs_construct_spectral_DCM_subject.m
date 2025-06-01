function srpbs_construct_spectral_DCM_subject(dataDir)
% srpbs_construct_spectral_DCM_subject(dataDir)
%
% This function constructs a spectral DCM for a single subject, using VOI time
% series data extracted from fMRI data. It takes the dataDir as input, which
% should contain the first-level GLM results (including the SPM.mat and VOI
% folder).
%
% Input:
%   dataDir:  Path to the subject's data directory, containing the first-level
%             GLM results (e.g., '...\TNM_project\git\data\ds005917-download\sub-MOA101\ses-b0')
%
% Output:
%   DCM.mat:  A DCM structure saved in the subject's first-level GLM directory.
%
% ----------------------------------------------------------------------
% Author: Leon, Rico, Keyshav
% Adapted from: Imre Kertesz, Stefan Fraessle, TNU, UZH & ETHZ
% ----------------------------------------------------------------------

% 1. Define Directories
% ----------------------
firstlevelDir = fullfile(dataDir, 'glm');  % Directory containing SPM.mat
voiDir = fullfile(firstlevelDir, 'VOI');      % Directory containing VOI data (.mat files)

if ~exist(firstlevelDir, 'dir')
    error('First-level GLM directory not found: %s', firstlevelDir);
end
if ~exist(voiDir, 'dir')
    error('VOI directory not found: %s', voiDir);
end

% 2. Load VOI Data and SPM.mat
% -----------------------------
try
    load(fullfile(firstlevelDir, 'SPM.mat'), 'SPM'); % Load SPM.mat to get TR
catch
    error('Could not load SPM.mat from %s', fullfile(firstlevelDir, 'SPM.mat'));
end

voi_files = dir(fullfile(voiDir, 'VOI_*.nii')); % Find VOI files.  Crucially, this assumes your VOI files start with "VOI_".
if isempty(voi_files)
    error('No VOI data files found in %s.  Are you sure they start with "VOI_"?', voiDir);
end

num_regions = length(voi_files);
Y.y = zeros(size(load(fullfile(voiDir, voi_files(1).name)).Y, 1), num_regions); % Preallocate
Y.name = cell(1, num_regions);

for i = 1:num_regions
    try
        voi_data = load(fullfile(voiDir, voi_files(i).name));
        Y.y(:, i) = voi_data.Y;          % Load VOI time series
        Y.name{i} = voi_files(i).name(5:end-4); % Store region name, removing "VOI_" and ".mat"
    catch
        error('Could not load VOI data from %s', fullfile(voiDir, voi_files(i).name));
    end
end

Y.dt = SPM.xY.RT;                      % Get repetition time (TR) from SPM.mat
if isempty(Y.dt)
    error('Repetition time (TR) not found in SPM.mat');
end


% 3. Specify and Estimate spectral DCM
% ------------------------------------
try
    DCM.xY    = Y;               % VOI data
    DCM.U     = [];              % No experimental inputs (for resting state) - you might add inputs later
    DCM.options.spectral.analyse = 1; % Perform spectral analysis
    DCM.options.spectral.nograph  = 0; % Show the graphs
    DCM.options.one_state        = 0;
    DCM.options.two_state        = 0;
    DCM.options.induced          = 0;

    DCM.A     = A;               % Structural connectivity (or [])
    DCM.B     = zeros(num_regions,num_regions,0);     % No input-driven changes in connectivity (for resting state)
    DCM.C     = zeros(num_regions,0);               % No inputs
    DCM.D     = zeros(num_regions,num_regions,0);     % No modulatory effects

    % Specify the model - this is where you can change model options
    DCM = spm_dcm_specify(DCM);

    % Estimate the model
    DCM = spm_dcm_fit(DCM);

    % Save the DCM structure
    save(fullfile(firstlevelDir, 'DCM.mat'), 'DCM');
    disp(['Spectral DCM saved to: ' fullfile(firstlevelDir, 'DCM.mat')]);

catch ME
    error('Error during spectral DCM specification or estimation: %s', ME.message);
end
end