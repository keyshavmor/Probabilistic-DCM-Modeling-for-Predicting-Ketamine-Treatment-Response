% Script to Display ROIs in the SPM viewer

%Author: Leon

%paths
thisFile    = mfilename('fullpath');        
scriptsDir  = fileparts(thisFile);       
projectRoot = fileparts(scriptsDir);      

% specify ROI folder: roisTozzi, roisTozzi_k, combinedROIs
roi_folder  = fullfile(projectRoot,'roisTozzi_k');

disp(['Using ROIs folder: ', roi_folder]);
assert(isfolder(roi_folder), 'Cannot find ROIs folder: %s', roi_folder);

% filter ROIs to display
%roi_files   = dir(fullfile(roi_folder, 'Defaultmode*.nii'));
%roi_files   = dir(fullfile(roi_folder, 'combined_BG*.nii')); %combinedROIs
%roi_files   = dir(fullfile(roi_folder, '*PFC*.nii'));
roi_files   = dir(fullfile(roi_folder, '*.nii')); %all in folder


%reset the window
spm_figure('GetWin','Graphics');           % Open/activate SPM Graphics window
spm_orthviews('Reset');                    % Reset orthviews to avoid conflicts

%anatfile = fullfile(spm('Dir'), 'canonical', 'avg152T1.nii');

% Base anatomical background
spm_orthviews('Image', fullfile(spm('Dir'), 'canonical', 'avg152T1.nii'));

% Colormap: assign different colors
colors = lines(length(roi_files)); 

for i = 1:length(roi_files)
    roi_path = fullfile(roi_folder, roi_files(i).name);
    spm_orthviews('AddColouredImage', 1, roi_path, colors(i, :));
end

% spm_orthviews('Reposition', [0 0 0]);  % Optional centering