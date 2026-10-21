#!/bin/bash

#PBS -lwalltime=01:00:00
#PBS -lselect=1:mem=15gb
#PBS -o nf.log
#PBS -e nf.err
#PBS -N nf_test

module load Nextflow

#make sure a tmp folder required by singularity exists
mkdir -p /rds/general/user/${USER}/ephemeral/tmp/

cd $PBS_O_WORKDIR

nextflow run nf-core/fetchngs \
    -r 1.12.0 \
		-profile imperial \
		--input ids.csv \
		--download_method sratools \
		--outdir nf_out 
