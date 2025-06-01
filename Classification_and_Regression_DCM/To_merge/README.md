# Permutation Classification Analysis

This repository contains notebooks and result files related to permutation testing on DCMs (Dynamic Causal Models) for delta categories. The analyses are conducted on three connectivity matrices: 4×4 DMN DCM, 11×11 DCM, and 15×15 DCM, all excluding b0.

## Contents

| Component                                                         | Type       | Description                                                                                                          | Location                         |
|-------------------------------------------------------------------|------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------|
| `Permutation_Classification_DMN_4x4_without_b0_on_delta_categories.ipynb` | Notebook   | Runs permutation testing for the 4×4 DMN DCM (without b0) on delta categories; generates a CSV containing p-value, observed accuracy, and null mean accuracy.  | `current_dir/`                     |
| `Permutation_Classification_11x11_without_b0_on_delta_categories.ipynb`   | Notebook   | Runs permutation testing for the 11×11 DCM (without b0) on delta categories; generates a CSV containing p-value, observed accuracy, and null mean accuracy.   | `current_dir/`                     |
| `Permutation_Classification_15x15_without_b0_on_delta_categories.ipynb`   | Notebook   | Runs permutation testing for the 15×15 DCM (without b0) on delta categories; generates a CSV containing p-value, observed accuracy, and null mean accuracy.   | `current_dir/`                     |
| `permutation_results/4x4_DMN_DCM_results.csv`                      | Output CSV | Contains the p-value, observed accuracy, and null mean accuracy for the 4×4 DMN DCM permutation test.               | `permutation_results/`           |
| `permutation_results/11x11_DCM_results.csv`                        | Output CSV | Contains the p-value, observed accuracy, and null mean accuracy for the 11×11 DCM permutation test.                 | `permutation_results/`           |
| `permutation_results/15x15_DCM_results.csv`                        | Output CSV | Contains the p-value, observed accuracy, and null mean accuracy for the 15×15 DCM permutation test.                 | `permutation_results/`           |
| `Visualization_perm.ipynb`                                        | Notebook   | Aggregates results from all `permutation_results` CSVs and visualizes them as heatmaps and bar charts for an overall relationship overview. | `current_dir/`                     |

## How to Use

1. The notebooks are included in the ( `current_dir/`) .
2. Run the desired permutation classification notebook.
3. View output CSVs in `permutation_results/`.
4. Use `Visualization_perm.ipynb` to compare and visualize the aggregated results.
