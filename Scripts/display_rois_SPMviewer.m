roi_folder = 'C:\Users\leon\Programming\Julia\TNM_project\rois Tozzi\';
% Define path to the 'rois Tozzi' folder (relative to script location)
roi_folder = fullfile(scriptDir, '..', 'rois Tozzi');

roi_files = dir(fullfile(roi_folder, 'Defaultmode*.nii'));

%reset the window
spm_figure('GetWin','Graphics');           % Open/activate SPM Graphics window
spm_orthviews('Reset');                    % Reset orthviews to avoid conflicts

%roifile = 'C:\Users\leon\Programming\Julia\TNM_project\rois Tozzi\Attention_LPFC_L(1).nii';
%anatfile = fullfile(spm('Dir'), 'canonical', 'avg152T1.nii');

% Base anatomical background
spm_orthviews('Image', fullfile(spm('Dir'), 'canonical', 'avg152T1.nii'));

% Colormap: assign different colors
colors = lines(length(roi_files));  % distinguishable colors

for i = 1:length(roi_files)
    roi_path = fullfile(roi_folder, roi_files(i).name);
    spm_orthviews('AddColouredImage', 1, roi_path, colors(i, :));
end

% spm_orthviews('Reposition', [0 0 0]);  % Optional centering