# Dynamic Energy Landscape Analysis of Auditory Verbal Hallucinations in Schizophrenia

## Project Overview

This repository contains the preprocessing configurations, cluster execution scripts, and statistical energy landscape modeling routines for evaluating dynamic brain network states in task-based fMRI. The project investigates neural stability and attractor basin dynamics in patients with schizophrenia experiencing Auditory Verbal Hallucinations (**AVH+**) compared to non-hallucinating patients (**AVH-**) and Healthy Controls (**CON**).

---

## Dataset & Cohort Structure

* **Data Provenance:** Secondary analysis of task-based fMRI data originally published by **Soler-Vidal et al. 2022**
* **Experimental Paradigm:** Auditory **word-list paradigm** (auditory word processing vs. baseline).
* **Sample Size ($N = 71$):**
  * **CON:** Healthy Controls ($N = 25$)
  * **AVH+:** Schizophrenia with Auditory Verbal Hallucinations ($N = 23$)
  * **AVH-:** Schizophrenia without Auditory Verbal Hallucinations ($N = 23$)
* **Design Covariates:** Sex (Male/Female) and Smoking Status (Smoker/Non-Smoker).
* **Atlas Parcellation:** **Brainnetome Atlas (BNA-246)**, comprising 210 cortical and 36 subcortical subregions. Full ROI definitions, MNI coordinates, and network mappings are provided in `BrainnetomeAtlas_subregions_finalized.xlsx`.

---

## Pipeline & Methods Summary

### 1. Preprocessing & Denoising (CONN Toolbox / SPM12)
Preprocessing and denoising were executed using automated batch scripts (`conn_batch_BN_subset.m`) within the **CONN Functional Connectivity Toolbox**:
* **Preprocessing Pipeline:** Spatial realignment, unwarping, anatomical-functional coregistration, direct MNI normalization, and spatial smoothing.
* **Artifact Scrubbing:** Artifact Detection Tools (ART) identify motion outliers (frame-wise displacement thresholds and global signal spikes).
* **Denoising Parameters:**
  * **Bandpass Filtering:** $0.01\text{ Hz} \le f \le 0.1\text{ Hz}$
  * **Confound Regression:** Anatomical CompCor (White Matter and CSF signal components), realignment parameters, and ART scrubbing covariates.
* **Second-Level Contrasts:** Group-level baseline and dynamic connectivity comparisons between **CON**, **AVH+**, and **AVH-**, controlling for sex and smoking status.

### 3. Energy Landscape Analysis (Maximum Entropy Model)
The MEM energy landscape modeling pipeline is located in the `energy-landscape-analysis-master/` directory. The scripts extract BOLD timeseries using `BrainnetomeAtlas_subregions_finalized.xlsx` definitions and execute in four sequential stages:

1. **Signal Binarization (`01_binarize_timeseries.m`):** Regional BOLD timeseries are thresholded relative to mean ROI activation:

$$S_i(t) = +1 \quad \text{if active}, \quad S_i(t) = -1 \quad \text{if inactive}$$

2. **Model Parameter Fitting (`02_fit_maxent_model.m`):** Intrinsic activity parameters ($h_i$) and pairwise interaction constants ($J_{ij}$) are iteratively fitted to match empirical activation rates and pairwise covariances while maximizing entropy:

$$E(S) = -\sum_{i} h_i S_i - \frac{1}{2}\sum_{i}\sum_{j} J_{ij} S_i S_j$$

3. **Attractor & Transition Dynamics (`03_find_local_minima.m` & `04_state_transitions.m`):**
   * **State Occupancy Probability:** Calculated via $P(S) = \frac{e^{-E(S)}}{\sum_{S'} e^{-E(S')}}$ where $E(S) = -\ln P(S) - C$.
   * **Metrics:** Local energy minima identification, basin transition probabilities, total visit counts, and mean dwell times (measured in TRs) compared across **CON**, **AVH-**, and **AVH+** cohorts.
---

### Note: High-Performance Computing (HPCF / Slurm Workflow)
Image processing and regional ROI time-series extraction were executed on a Slurm-managed High-Performance Computing Facility (HPCF).

#### Cluster Job Execution
```bash
#!/bin/bash 
#SBATCH --job-name=sz_energy_landscape
#SBATCH --mem=100000                     # Request 100 GB RAM
#SBATCH --gres=gpu:2                     # Request GPU acceleration
#SBATCH --time=108:00:00                 # Maximum walltime allocation
#SBATCH --constraint=rtx_2080            # Hardware constraint
#SBATCH --error=slurm_%j.err
#SBATCH --output=slurm_%j.out

# Load MATLAB module environment
module load MATLAB

# Execute batch processing in headless mode
matlab -nodisplay -nosplash -nodesktop -r \
"addpath(genpath('/path/to/MATLAB/conn22a/')); \
 addpath(genpath('/path/to/MATLAB/spm12/')); \
 run('/path/to/scripts/conn_batch_BN_subset.m'); exit"
