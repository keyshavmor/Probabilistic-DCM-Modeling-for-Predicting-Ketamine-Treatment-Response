thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);
projectRoot = fileparts(scriptsDir);

% path to SPM.mat file (GLM result)
firstlevelDir	= fullfile(dataDir,'glm');
parcelDir = fullfile(projectRoot, 'git', 'roisTozzi');

roi_file = fullfile(parcelDir, 'Defaultmode_PCC_M.nii'); % Get the path to the first ROI file
bold_file = fullfile(dataDir, 'func', 's8wasub-MOA101_ses-b0_task-rest_run-01_bold.nii');

    V_roi = spm_vol(roi_file);
    V_bold = spm_vol(bold_file);
    %disp(['Voxel size of ', ROI_names(1).name, ': ', num2str(abs(diag(V_roi.mat))'), ' mm']);
    disp(['Voxel size of roifile: ', num2str(abs(diag(V_roi.mat))'), ' mm']);
    disp(['Voxel size of boldfile: ', num2str(abs(diag(V_bold.mat(1).(1)))'), ' mm']);

    disp('Transformation matrix of roifile: ');
    disp(V_roi.mat);

    disp('Transformation matrix of roifile: ');
    disp(V_bold.mat);

    % You can also load and display the image to visually inspect alignment
    spm_check_registration(V_roi); % You might want to load a template or functional image as well
    spm_check_registration(V_bold);
    
% You would repeat this for other ROI files to compare their properties.