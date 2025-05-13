function srpbs_glm_subject(dataDir)

% This script demonstrates how to perform a GLM analysis for a subject from
% the SRPBS Multidisorder MRI dataset. SPM needs to be installed. The
% analysis is done for one subject.

%-----------------------------------------------------------------------
% Created: Apr 2024, Imre Kertesz, Translational Neuromodeling Unit,
% University and ETH Zurich
% Edited: May 2025, Leon Schönleber
%-----------------------------------------------------------------------

%dataDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine\sub-MOA101\ses-b0';

% define where the code is located
%[baseDir, ~] = fileparts(mfilename('fullpath'));

% old ---- leon
% -----------------------------------------------------------------------
%baseDir = 'C:\Users\leon\Programming\Julia\TNM_project\Data\Ketamine';
subjectDir   = fileparts(dataDir);  
firstlevelDir = fullfile(subjectDir, 'glm');
disp(['Using first‐level GLM folder: ', firstlevelDir]);
assert(isfolder(firstlevelDir), ...
       'Cannot find GLM folder: %s', firstlevelDir);

% path to SPM.mat file (GLM result) old ------ leon
%firstlevelDir   = fullfile(baseDir,'sub-test1','glm');


% get all regions of interest
%preproc_vol = dir(fullfile(baseDir,'sub-test1','func','s8wasub*.nii'));
preproc_vol = dir(fullfile(dataDir,'func','s8wasub*.nii'));

% file containing regressors for movement
%movement_reg = fullfile(baseDir,'sub-test1','func','rp_asub-MOA101_ses-b0_task-rest_run-01_bold.txt');
files = dir(fullfile(dataDir, 'func', 'rp_*'));
movement_reg = fullfile(files(1).folder, files(1).name);

% --- START DEBUGGING BLOCK 1: Check selected preprocessed files ---
if isempty(preproc_vol)
    %error('No preprocessed files found matching s8wasub* in %s', fullfile(baseDir,'sub-test1','func'));
    error('No preprocessed files found matching s8wasub* in %s', fullfile(dataDir,'func'));
end
fprintf('Found %d preprocessed file(s):\n', length(preproc_vol));
for k_debug = 1:length(preproc_vol)
    fprintf('  %s\n', fullfile(preproc_vol(k_debug).folder, preproc_vol(k_debug).name));
end
% --- END DEBUGGING BLOCK 1 ---

%resume here
preproc_paths_for_spm_scans = {}; % Initialize as an empty cell array
fprintf('\nExpanding 4D NIfTI files into individual volume paths for SPM:\n');
num_total_volumes_from_expansion = 0;

for i_file = 1:length(preproc_vol)
    current_4D_nifti_path = fullfile(preproc_vol(i_file).folder, preproc_vol(i_file).name);
    try
        % Use spm_select to get all frames (volumes) from the current 4D NIfTI
        % The 'Inf' argument means all frames.
        % spm_select returns a character array here, one row per volume path.
        individual_volume_paths_char_array = spm_select('ExtFPList', ...
            fileparts(current_4D_nifti_path), ...
            ['^' preproc_vol(i_file).name '$'], ... % Exact filename match
            Inf);

        if isempty(individual_volume_paths_char_array)
            warning('spm_select found no volumes for %s. Skipping this file.', current_4D_nifti_path);
            continue;
        end
        
        num_volumes_in_current_file = size(individual_volume_paths_char_array, 1);
        fprintf('  Expanded %s into %d individual volume paths.\n', current_4D_nifti_path, num_volumes_in_current_file);
        num_total_volumes_from_expansion = num_total_volumes_from_expansion + num_volumes_in_current_file;

        % Convert char array to cell array and append to our main list
        preproc_paths_for_spm_scans = [preproc_paths_for_spm_scans; cellstr(individual_volume_paths_char_array)];

    catch ME
        warning('Error using spm_select to expand volumes for %s. Error: %s', current_4D_nifti_path, ME.message);
    end
end
if isempty(preproc_paths_for_spm_scans)
    error('Failed to create any individual volume paths for SPM. Check NIfTI files and spm_select usage.');
end
fprintf('Total individual volume paths generated for SPM: %d\n', length(preproc_paths_for_spm_scans));
fprintf('First few generated paths for SPM scans:\n');
disp(preproc_paths_for_spm_scans(1:min(5,end)));


matlabbatch = {}; % Initialize matlabbatch - do we need this?

matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(firstlevelDir);
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs'; % units for design
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;       % repetition time
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;    % microtime resolution
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;    % microtime onset

%matlabbatch{1}.spm.stats.fmri_spec.sess.scans = preproc_paths; % path to all fMRI scans for this session

% --- **** USE THE FULLY EXPANDED LIST OF INDIVIDUAL VOLUME PATHS **** ---
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = preproc_paths_for_spm_scans;

matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(movement_reg);
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128; % high-pass filter cutoff
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8; % masking threshold
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)'; % serial correlations
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(fullfile(firstlevelDir,'SPM.mat')); 
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat = cellstr(fullfile(firstlevelDir,'SPM.mat'));
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'mean'; % name of F-contrast
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [0 0 0 0 0 0 1]; % using 7th regressor (mean)
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 1; % delete existing contrasts -> yes

fprintf('\n--- Running SPM Jobman ---\n');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);
fprintf('SPM job completed.\n');

end
