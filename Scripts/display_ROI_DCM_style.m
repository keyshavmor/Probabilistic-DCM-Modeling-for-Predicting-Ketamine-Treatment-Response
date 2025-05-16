% Get the path to the current script
scriptDir = fileparts(mfilename('fullpath'));

% Define path to the 'rois Tozzi' folder (relative to script location)
roi_folder = fullfile(scriptDir, '..', 'roisTozzi');

% Load ROIs of intrest
%roi_files = dir(fullfile(roi_folder, 'Defaultmode*.nii'));
roi_files = dir(fullfile(roi_folder, '*.nii'));

roi_centers = [];
roi_names = {};

for i = 1:length(roi_files)
    V = spm_vol(fullfile(roi_folder, roi_files(i).name));
    Y = spm_read_vols(V);
    
    [x, y, z] = ind2sub(size(Y), find(Y > 0));
    coords = V.mat * [x y z ones(length(x),1)]';
    center_mm = mean(coords(1:3, :), 2);
    
    roi_centers(end+1, :) = center_mm';
    [~, name, ~] = fileparts(roi_files(i).name);
    roi_names{end+1} = name;
end

% --- Load brain for context (use single_subj_T1) ---
V_brain = spm_vol(fullfile(spm('Dir'), 'canonical', 'single_subj_T1.nii'));
Y_brain = spm_read_vols(V_brain);
Y_brain = (Y_brain - min(Y_brain(:))) / (max(Y_brain(:)) - min(Y_brain(:)));

% Create brain mesh from voxel grid
[x, y, z] = ndgrid(1:V_brain.dim(1), 1:V_brain.dim(2), 1:V_brain.dim(3));
fv = isosurface(x, y, z, Y_brain, 0.2);

% Transform vertices to MNI space
fv.vertices = (V_brain.mat * [fv.vertices, ones(size(fv.vertices,1),1)]')';
fv.vertices = fv.vertices(:, 1:3);

% --- Plot brain and ROIs ---
figure;
p = patch(fv);
set(p, 'FaceColor', [0.85 0.85 0.85], 'EdgeColor', 'none', 'FaceAlpha', 0.05);
daspect([1 1 1]); axis tight off; view(3); camlight; lighting gouraud;
hold on;

% Plot ROI centers
scatter3(roi_centers(:,1), roi_centers(:,2), roi_centers(:,3), ...
    100, 'r', 'filled');
text(roi_centers(:,1), roi_centers(:,2), roi_centers(:,3), roi_names, ...
    'VerticalAlignment','bottom','HorizontalAlignment','right', 'FontSize', 10);

% --- Optional: add example DCM connections ---
connections = [
    %1 2;
    %2 3;
    %3 1;
    %1 4;
    %1 3;
    %4 2;
    %3 4;
];

for i = 1:size(connections, 1)
    pt1 = roi_centers(connections(i,1), :);
    pt2 = roi_centers(connections(i,2), :);
    plot3([pt1(1) pt2(1)], [pt1(2) pt2(2)], [pt1(3) pt2(3)], ...
        'k--', 'LineWidth', 1.5);
end

title('ROI network overlaid on brain (MNI space)');
xlabel('X'), ylabel('Y'), zlabel('Z');