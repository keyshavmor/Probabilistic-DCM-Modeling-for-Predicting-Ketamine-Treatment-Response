1. This folder contains everything from data preprocessing to DCM generation.

2. The data needs to be downloaded from:

    unzipped .nii.gz -> .nii
    and placed into the data folder.

3.The scripts use relative paths. Implementing the used hierarchy is advised. 

4. The data folder should contain a folder entitled: ds005917-download

5. Within in should be the subjects folders: sub-MOA101, etc.

6. The run_one_main and run_all_main scripts call the relevant functions for one or all subjects respectively.

7. If not all DCMs should be generated, commenting out unwanted functions is advised.

8. Reference runtimes per 1 subject:

9. preprocessing & glm: 20min

10. extract VOI & construct DCM for
    DMN: 1 min
    15-node DCM: 35 min
    20-node DCM: 5hrs 30min


11. The scripts check_ROI_properties, display_rois_SPMviewer, display_ROI_DCM_style are for illustrative and quality control purposes.

12. Combine_Brainnetome_ROIs can be used to combine NifTi mask to obtain bigger Regions of intrests. Its intended usecase is merging 
    Regions from the Brainnetome atlas.

13. roisTozzi, roisTozzi_k, combined ROIs store the NifTi mask for Volume extraction.


README by Leon Schönleber
scleon@ethz.ch