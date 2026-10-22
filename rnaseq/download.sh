#!/usr/bin/env bash

#PBS -lwalltime=12:00:00
#PBS -lselect=1:ncpus=1:mem=5gb
#PBS -o download.log
#PBS -e download.err
#PBS -N download_ref


cd $PBS_O_WORKDIR
#make required directories
mkdir -p ref_data

## the fastq files are downloaded by the nf-core/fetchngs pipeline (see ../fetchngs/nf_run.sh)

## get the reference data of your choice
wget -P ref_data https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
gunzip ref_data/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz

wget -P ref_data  https://ftp.ensembl.org/pub/release-115/gtf/homo_sapiens/Homo_sapiens.GRCh38.115.gtf.gz
gunzip ref_data/Homo_sapiens.GRCh38.115.gtf.gz
