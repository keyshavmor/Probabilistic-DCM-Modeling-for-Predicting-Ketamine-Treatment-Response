1. This folder contains everything from data preprocessing to DCM generation.

2. The data needs to be downloaded from:https://openneuro.org/datasets/ds005917/versions/1.0.1/download

3. Recursively unzip all the .nii.gz files in the dataset to .nii files and place the data into the data folder.

4.The scripts use relative paths. Implementing the used hierarchy is advised. 

5. The data folder should contain a folder entitled: ds005917-download

6. Within in should be the subjects folders: sub-MOA101, etc.

7. The run_one_main and run_all_main scripts call the relevant functions for one or all subjects respectively.

8. If not all DCMs should be generated, commenting out unwanted functions is advised.

9. Reference runtimes per 1 subject:

10. preprocessing & glm: 20min

11. extract VOI & construct DCM for
    DMN: 1 min
    15-node DCM: 35 min
    20-node DCM: 5hrs 30min


12. The scripts check_ROI_properties, display_rois_SPMviewer, display_ROI_DCM_style are for illustrative and quality control purposes.

13. Combine_Brainnetome_ROIs can be used to combine NifTi mask to obtain bigger Regions of intrests. Its intended usecase is merging 
    Regions from the Brainnetome atlas.

14. roisTozzi, roisTozzi_k, combined ROIs store the NifTi mask for Volume extraction.


README by Leon Schönleber
scleon@ethz.ch