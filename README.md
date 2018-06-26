# dnanexus_repeathmm_htt v1.0

## What does this app do?
[repeatHMM](https://github.com/WGLab/RepeatHMM) is a tool that estimates repeat counts in long read sequencing data. It has a built in model for counting CAG repeats in HTT. The algorithm employs a random initialization step for GaussianMixture which results in the tool being non-deterministic. This app therefore runs repeatHMM 100 times on a BAM, and reports the median repeat counts.

## What are typical use cases for this app?
This app is used as part of the Oxford Nanopore HTT repeat counting workflow.

## What data are required for this app to run?
The app requires 2 inputs:
1. A sorted BAM file containing Oxford Nanopore reads aligned to hg19 reference.
2. A BAM index file

## What does this app output?
The app has 2 outputs:
1. A summary csv file containing the median and range of repeat counts for each allele 
2. An array of all repeatHMM output files

## How does this app work?
This app uses a repeatHMM docker image (https://hub.docker.com/r/mokaguys/repeathmm/). The BAM is fed through repeatHMM 100 times. A python script then parses the repeatHMM output files and calculates a median and a range for each allele. This information is written to a summary csv file. The summary csv file and repeatHMM output files are uploaded to the project.

## What are the limitations of this app
This app should only be used for Oxford Nanopore data as part of the HTT repeat counting workflow.

## This app was made by Viapath Genome Informatics 