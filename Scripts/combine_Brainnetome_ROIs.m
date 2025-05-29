function combine_Brainnetome_ROIs()

%script that combines and saves subparcellation from the Brainatome atlas

% define where the code is located
%[baseDir, ~] = fileparts(mfilename('fullpath'));
thisFile = mfilename('fullpath');
scriptsDir = fileparts(thisFile);
projectRoot = fileparts(scriptsDir);

subparcelDir = fullfile(projectRoot, 'Brainnetome2016', 'all_masks');
parcelDir = fullfile(projectRoot, 'combinedROIs');

% Define search terms for region groups
region_keywords = {'Tha', 'BG*_l', 'BG*_r', 'Amy*left', 'Amy*right', 'Hipp*left','Hipp*right'};  % e.g., Thalamus, Amygdala, Hippocampus
%'BG*_l', 'BG*_r' 'Tha*left', 'Tha*right'

% Loop over region groups
for k = 1:length(region_keywords)
    keyword = region_keywords{k};
    ROI_files = dir(fullfile(subparcelDir, ['*' keyword '*.nii']));

    if isempty(ROI_files)
        warning('No files found for keyword "%s"', keyword);
        continue;
    end

    % Initialize combined mask
    V_template = spm_vol(fullfile(subparcelDir, ROI_files(1).name));
    combined_mask = spm_read_vols(V_template) > 0;

    % Loop through remaining ROI files
    for f = 2:length(ROI_files)
        V = spm_vol(fullfile(subparcelDir, ROI_files(f).name));
        mask = spm_read_vols(V) > 0;
        combined_mask = combined_mask | mask;
    end

    % Save combined mask for this group
    safe_keyword = strrep(keyword, '*', '_');

    V_template.fname = fullfile(parcelDir, ['combined_' safe_keyword '_mask.nii']);
    spm_write_vol(V_template, combined_mask);

    fprintf('Saved: %s\n', V_template.fname);
end