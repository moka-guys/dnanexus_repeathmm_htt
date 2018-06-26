#!/bin/bash

# -e = exit on error; -x = output each line that is executed to log; -o pipefail = throw an error if there's an error in pipeline
set -e -x -o pipefail

main() {

    # Download BAM and index input files
    dx download "$bam"
    dx download "$bai"
    # Download reference genome and bwa index files 
    dx download -r 003_180614_repeatHMM_dev:/hg19/

    # Create output directories
    mkdir -p $HOME/out/repeathmm_output/repeathmm_output/all_results $HOME/out/results_summary/repeathmm_output

    # Run RepeatHMM 100x using HTT settings
    # -v mounts the home directory to /data in the docker container
    for i in {1..2}; do
        dx-docker run -v $HOME:/data mokaguys/repeathmm:v1.0 \
            BAMinput --Onebamfile /data/$bam_name \
            --hg hg19 --hgfile /data/hg19/hg19.fa \
            --SeqTech Nanopore \
            --repeatName HTT \
            > $HOME/${bam_prefix}_repeathmm_output.${i}.tsv
    done

    # Move output 
    sudo mv $HOME/${bam_prefix}_repeathmm_output.*.tsv $HOME/out/repeathmm_output/repeathmm_output/all_results/

    # Run python3 script to combine repeathmm results into summary file which is written to ~/repeathmm_results_summary.csv
    python3 $HOME/generate_results_summary.py

    # Move and rename results summary to output folder
    sudo mv $HOME/repeathmm_results_summary.csv $HOME/out/results_summary/repeathmm_output/${bam_prefix}_repeathmm_results_summary.csv

    # Upload output
    dx-upload-all-outputs
}
