This folder contains everything from data preprocessing to DCM generation.

The data needs to be downloaded from:
unzipped .nii.gz -> .nii
and placed into the data folder.

The scripts use relative paths. Implementing the used hierarchy is advised
The data folder should contain a folder entitled: ds005917-download
Within in should be the subjects folders: sub-MOA101, etc.

The run_one_main and run_all_main scripts call the relevant functions for one or all subjects respectively.
If not all DCMs should be generated, commenting out unwanted functions is advised.

Reference runtimes per 1 subject:

preprocessing & glm: 20min

extract VOI & construct DCM for
DMN: 1 min
15-node DCM: 35 min
20-node DCM: 5hrs 30min


The scripts check_ROI_properties, display_rois_SPMviewer, display_ROI_DCM_style are for illustrative and quality control purposes.

combine_Brainnetome_ROIs can be used to combine NifTi mask to obtain bigger Regions of intrests. Its intended usecase is merging Regions from the Brainnetome atlas.

roisTozzi, roisTozzi_k, combined ROIs store the NifTi mask for Volume extraction.


README by Leon Schönleber
scleon@ethz.ch