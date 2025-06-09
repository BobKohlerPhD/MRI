#!/usr/bin/env bash
set -euo pipefail

# Docker image 
DOCKER_IMG="gabdesgreg/rabies:0.5.0"

# Directories 
INPUT_DIR="${PWD}/input_bids"
OUTPUT_DIR="${PWD}/preprocess_outputs"
TEMPLATE_DIR="${PWD}/rat_templates"

# Run the RABIES 
docker run -it --rm \
  --user "$(id -u):$(id -g)" \
  -e MPLCONFIGDIR=/tmp \
  -v "${INPUT_DIR}:/input_BIDS:ro" \
  -v "${OUTPUT_DIR}:/preprocess_outputs" \
  -v "${TEMPLATE_DIR}:/rat_templates:ro" \
  "${DOCKER_IMG}" \
  -p MultiProc \
  --local_threads 15 \
  confound_correction /preprocess_outputs/ /preprocess_outputs/ \
    --conf_list WM_signal CSF_signal global_signal vascular_signal mot_6 \
    --smoothing_filter 0.3 \
    --TR 1.5 
    

