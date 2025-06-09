#!/usr/bin/env bash
set -euo pipefail

# Docker image to use
DOCKER_IMG="gabdesgreg/rabies:0.5.0"

# Directories (assumed to exist in your current working directory)
INPUT_DIR="${PWD}/input_bids"
OUTPUT_DIR="${PWD}/preprocess_outputs"
TEMPLATE_DIR="${PWD}/rat_templates"

# Run the RABIES container with mounted volumes
docker run -it --rm \
  --user $(id -u):$(id -g) \
  -e MPLCONFIGDIR=/tmp \
  -v "${INPUT_DIR}:/input_BIDS:ro" \
  -v "${OUTPUT_DIR}:/preprocess_outputs" \
  -v "${TEMPLATE_DIR}:/rat_templates:ro" \
  "${DOCKER_IMG}" -p MultiProc \
  --local_threads 12 \
  preprocess /input_BIDS/ /preprocess_outputs/ \
    --anat_template  /rat_templates/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/anatomy/SIGMA_InVivo_Anatomical_Brain_template.nii.gz \
    --brain_mask     /rat_templates/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/anatomy/SIGMA_InVivo_Anatomical_Brain_mask.nii.gz \
    --WM_mask        /rat_templates/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/anatomy/SIGMA_InVivo_Anatomical_Brain_wm_bin.nii.gz \
    --CSF_mask       /rat_templates/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/anatomy/SIGMA_InVivo_Anatomical_Brain_csf_bin.nii.gz \
    --vascular_mask  /rat_templates/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/anatomy/SIGMA_InVivo_Anatomical_Brain_csf_bin.nii.gz \
    --labels         /rat_templates/SIGMA_Rat_Brain_Atlases/SIGMA_Anatomical_Atlas/InVivo_Atlas/SIGMA_InVivo_Anatomical_Brain_Atlas.nii.gz \
    --apply_STC \
    --TR 1.5s \
    --commonspace_reg masking=true,brain_extraction=false,template_registration=SyN,fast_commonspace=false \
    --bold_inho_cor method=N4_reg,otsu_thresh=2,multiotsu=false \
    --anat_inho_cor method=N4_reg,otsu_thresh=2,multiotsu=false \
    --anat_autobox
