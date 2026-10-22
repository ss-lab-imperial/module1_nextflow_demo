# nf_core pipelines on the Imperial HPC

Walk through of setting-up nf-core workflows on the Imperial HPC


During the Week 3 materials, as well as introducing the Imperial HPC, we also briefly introduced the `nextflow` workflow system. The description of nextflow was buried a bit amongst lots of other crucial information, but the use of `nextflow` is probably one of the more important skills you can acquire. Since it's inception it has been revolutionised the way in which researchers develop, distribute and execute pipelines. It is primarily used for the processing of 'omics data, but pipelines for Neuroscience also exist.

- [nf-core](nf.core)
- [nf-neuro](https://nf-neuro.github.io)


# Why do we need a workflow manager?

By now we have learnt a few commands that, when joined together, can form the basis for a minimal analysis or data processing pipeline. We have also discussed how to submit our scripts to a HPC so we can use more computational resource and run tasks in parallel. These are all skills you will need to master in Computational Biomedicine, and critical if you want to prototype code or try something out that only has a few computational tasks. Another ability you will learn is how to make the best use of your time. Being able to run a publication-ready analysis on complex data types such as 'omics, which often involve many software tools, is another art in itself. Quite frankly, some of these details are not particularly exciting and can consume a large amount of time. A workflow manager solves this, and more.

Without getting into too much specific detail, let's assume we have the raw sequencing data for 100 patients to process. There are three very broad tasks for each patient. 

- QC; can we detect an instrumentation or technical error in our data?
- Alignment; whereabouts in our genome does each read come from?

<img src="https://training.galaxyproject.org/training-material/topics/sequence-analysis/images/mapping/mapping.png"/>

- Counting; for the given set of genomic regions, how many reads overlap with that region

<img src="https://raw.githubusercontent.com/sheffield-bioinformatics-core/rnaseq-beginners/main/media/htseq.png"/>

For a particular patient, the tasks have to be performed in order; QC -> Alignment -> Counting. However, the processing of each patient is completely independent.

Workflow managers such as nextflow perform critical roles in running a software pipeline

### Software Dependencies & Installation

Bioinformatics tools often rely on specific underlying libraries, drivers, or system packages. Installing these tools manually, or juggling conflicting version requirements across different packages—can quickly lead to "dependency hell". For example, you might have two software tools that you need to install that rely on different versions of C or Python. Workflow managers combat this using containerisation approaches such as Docker and Singularity.

### Task Dependencies

As the "counting" task for each patient depends on alignment, we have to make sure the alignment is completed without any errors before counting can commence. Managing task dependencies is possible with Unix we have learnt so far, but quickly becomes complex and unwieldy with many tasks running at the same time. Workflow managers can handle this, plus allow for tasks to execute in parallel where possible.

### Incompatible software input / output

It is not uncommon for software tools to be developed by different research groups in isolation, for a specific task. A piece of software might have certain requirements about what input it takes, and the software earlier in the pipeline may not always conform to these standards. An example might be that some software assumes chromosome names have a "chr" prefix, whereas another may not. Chaining data together and ensuring it flows from one tool to another requires some data manipulation that, whilst not particularly challenging, is time consuming to catch all edge-cases. Software can also change output formats over time, meaning we have to update these utility scripts.

## Automated file management

Running hundreds of processing steps across dozens of samples generates thousands of intermediate (i.e. not the final output), logs and error files. Without a systematic approach, your working directory quickly becomes cluttered and impossible to navigate. Automated file management enforces coherent, predictable folder structures (e.g., separating raw inputs, intermediate scratch files, logs, and final publication figures). Workflow managers automate the creation of these directory hierarchies, and can clean up temporary files that consume valuable HPC storage, and ensure intermediate outputs are placed exactly where downstream tools expect to find them. Files and folder can also naming in a consistent manner, so that the files relating to "Patient1", "Patient2" etc can be quickly located.

### Resource Allocation

Not all software requires the same computing resource. In our example, QC requires relatively little RAM and CPU, but alignment is extremely intensive. It would be incredibly inefficient to allocate the amount of memory required for alignment to a QC task. On a HPC it is critically important to make the most use of the shared resource. If you are requesting more RAM or HPC than you actually need, it is a wasted resource that others could be using. Moreover, you will likely have to queue for longer before the resource becomes available. Workflow managers will effectively manage resources such RAM, CPU and run time.

### Recovering from failed tasks

Some complex analyses can run for many days (if not weeks!) and during this time some individual tasks may fail due to network outages or exceeding resource requirements. In this case, it would be an incredible waste of the computing that had taken place up to the point of failure if the entire pipeline had to start from the beginning. Workflow systems will therefore keep a track on which jobs have completed so no unnecessary steps have to be repeated.


## nextflow / nf.core as an example

Projects like `nf-core` (and `nf-neuro`) are essentially collection of pre-built pipelines built using Nextflow that are freely available. It wasn't too long ago that each institute and research group would have it's own pipeline for a common task such as RNA-seq analysis, often covering the same steps, that had to be configured slightly differently for the nuances of their HPC setup. It was extremely challenging to *exactly* reproduce work from another lab even if you had all the same software installed. 

Unless you are doing something very novel or bespoke **we would recommend people re-using existing analysis pipelines rather than writing their own**. A challenging aspect of using pipelines for a specific analysis is choosing exactly which software to use for each step. For the tasks in our example, alignment and quantification have many credible options and an inexperience researcher may be unsure about which to use. The software chosen to be part of an `nf.core` pipeline is decided by a community, open-source effort to upon a best-practice consensus - rather than being the opinion of one particular individual or group (people unsurprisingly tend to recommend the software developed in their own group or lab!). Moreover, the parameters for each software have been chosen in advance using sensible values. This pre-configuration removes a significant time burden on the individual researcher. It is now possible to analyse data that you haven't previously encountered and get results that you can start to work with. **However, you still need to read the pipeline documentation and be aware of any caveats and assumptions**.




`nextflow` is available as a *module* on the Imperial HPC. Once you have logged-in in the usual fashion. It can be loaded in the following way, although we would normally do this via a script.

```
## Note the capitalisation of Nextflow
ml load Nextflow
nextflow
```


## Running a nf-core pipeline

In our opinion, nextflow is the preferred solution to running pipelines for omics analysis. It is particularly appealing as many popular Bioinformatics pipelines have already been written using nextflow and have been distributed as part of the nf-core project

- [nf.core homepage](https://nf-co.re/)

We will start by getting the "fetchngs" pipeline running, which is an automated way of retrieving "ngs" data from various repositories. Later on we will show the RNA-seq pipeline, which is more complex on the face of it, but not actually much more difficult to run.


- [nf-core fetchngs pipeline](https://seqera.io/pipelines/fetchngs--nf-core/#readme)

![](https://github.com/nf-core/fetchngs/raw/master/docs/images/nf-core-fetchngs_metro_map_grey.png)


- [nf.core RNA-seq pipeline](https://nf-co.re/rnaseq)

![](https://raw.githubusercontent.com/nf-core/rnaseq/3.24.0//docs/images/nf-core-rnaseq_metro_map_grey_animated.svg)


## Running the nf-core fetchngs pipeline

After logging into the HPC, create a directory (`mkdir`) called `fetchngs` where you want to run the `fetchngs` pipeline. You need to create a job submission script, which I have called `nf_run.sh`, and a file listing the IDs of the data we want to download (`ids.csv`, see below). Copies of both are available here:-

- [nf_run.sh](fetchngs/nf_run.sh)
- [ids.csv](fetchngs/ids.csv)


```{bash}
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
		--nf_core_pipeline rnaseq \
		--outdir nf_out 
```

The header of the script defines the HPC settings in the usual manner. I have picked a short runtime and low amount of RAM as this pipeline doesn't require much resource. A temporary folder also needs to be created to define where any temporary files required by the pipeline will be installed to. 

We then have to load the Nextflow module and make sure that our working directory is set to the directory that the job is submitted from. 

The command to run and install the pipeline is `nextflow run` followed by any associated parameters for the particular pipeline that you want to use. Each pipeline is held under version control via github. With the `-r` flag we can request a particular version of the pipeline. Here I am asking for version `1.12.0` of the `fetchngs` pipeline. 

A short explanation of `profile` is that it tells nextflow how to behave on your institutes HPC. Users and institutes are able to create configuration files that can be distributed and reused and define things like what containerisation approach to use, the job scheduler on the HPC and any memory, cpu or time limitations. Fortunately we don't have to work these out for ourselves as someone has already created an Imperial one. If you are curious you can see the contents on github. The `profile` can also be used to run the pipeline in `test` mode, meaning that demonstration data will be used rather than suppling your own.

- [Imperial profile](https://github.com/nf-core/configs/blob/master/conf/imperial.config)


There are a couple of options typical to all nf-core pipelines that are fairly self-explanatory:-

- `outdir`; where the outputs of the pipeline will be written to
- `input`; pointing to a csv file defining the locations of the input files. For this particular pipeline it is a file containing the public IDs of data we want to retrieve. **You will learn more about databases / repositories for storing published data next week**.

```{bash}
[mdunning@login-b fetchngs]$ cat ids.csv 
ERR732901
ERR732902
ERR732903
ERR732904
ERR732905
ERR732906
ERR732907
ERR732908
ERR732909
```


A further option we have used for this pipeline is to tell it to use the software suite `sra-tools` to download the data for us. 

Finally, `--nf_core_pipeline rnaseq` asks `fetchngs` to create a sample sheet in the format expected by the nf-core RNA-seq pipeline. We will use this later on to analyse the data we have downloaded.

We can then submit, and wait

```{bash}
qsub nf_run.sh
```

The first thing you will notice is that the output directory is created (if it does not exist) along with a `work` folder. If you haven't run this particular pipeline before it will download some scripts from github. When the pipeline is running, you can try a few different things to monitor the progress

- using the `qstat -u $USER` command to see what is currently running. As nextflow is utilising the HPC you should see several jobs being run at the same time. You might also notice that different RAM and time requirements are specified for different jobs. 
- the `nf_out/pipeline_info` folder (which may take a few moments to be created) contains an `execution_trace_` txt file which will be named with a time stamp. This is a log of what steps of the pipeline have been run.

The log and error files get written to your working folder after the pipeline finishes, and all outputs are written to `nf_out`. The most important outputs are:-

- `nf_out/fastq`; the raw sequencing data (fastq files) for each of the IDs we requested
- `nf_out/samplesheet/samplesheet.csv`; a sample sheet listing the samples and the (full) paths to their fastq files. As we used the `--nf_core_pipeline rnaseq` option, this is ready to be used as the `input` for the RNA-seq pipeline
- `nf_out/metadata`; information about each sample retrieved from the public repository

### A note about containers

We have told the pipeline to use a piece of software called `sra-tools` to help download our data. The particular command used to download fastq files is called `fastq-dump`. If this had been installed for us, we would be able to use the following:-

```{bash}
[mdunning@login-b fetchngs]$ fastq-dump
-bash: fastq-dump: command not found
```

So how is the pipeline able to use sra-tools? With nextflow software is distributed in the form of containers (or images). These are self-contained and isolated software environments, each containing a specific version of a piece of software. It is a technique to get around the "but the software works on my machine..." problem. The `singularity` (now apptainer) software has been used to create these images and by default these are stored in the `work` folder. This is an alternative to the popular "docker" project which is able to used on HPC (since docker is usually not allowed to be used on HPC).

```{bash}
[mdunning@login-b fetchngs]$ find work/ -name *.img -o -name *.sif
work/singularity/depot.galaxyproject.org-singularity-python-3.9--1.img
work/singularity/depot.galaxyproject.org-singularity-sra-tools-3.0.8--h9f5acd7_0.img
work/singularity/depot.galaxyproject.org-singularity-mulled-v2-5f89fe0cd045cb1d615630b9261a1d17943a9b6a-6a9ff0e76ec016c3d0d27e0c0d362339f2d787e6-0.img
```

If I *really* wanted to use the same version of `sra-tools` as used in the pipeline I could do:-

```{bash}
[mdunning@login-b fetchngs]$ singularity exec work/singularity/depot.galaxyproject.org-singularity-sra-tools-3.0.8--h9f5acd7_0.img fastq-dump

Usage:
  /usr/local/bin/fastq-dump [options] <path> [<path>...]
  /usr/local/bin/fastq-dump [options] <accession>

Use option --help for more information

/usr/local/bin/fastq-dump : 3.0.8
```

### Running on your own machine

A nice feature of nextflow is the portability between different computing environments. e.g. if the HPC becomes unavailable for a while you can keep running analyses on your own machine or the cloud with minimal setup. If running locally (i.e. on your own machine) you will probably want to install `docker` and you'll also need to install `nextflow` (which in turn requires `java`). The run command you can use is then:-

```{bash}
nextflow run nf-core/fetchngs \
    -r 1.12.0 \
		-profile docker \
		--input ids.csv \
		--download_method sratools \
		--nf_core_pipeline rnaseq \
		--outdir nf_out 
```


## Running an RNA-seq pipeline

Switching to using a different pipeline is a matter of changing the first argument in the `nextflow run` command. A list of all available pipelines can be found here. Here is an example of running a test dataset through the current RNA-seq pipeline. Using the `test` option in the profile is a good idea if you just want to see what the pipeline produces before running it on your own data. In this case we don't need an `input`, as the pipeiline will automatically download some example data.

- [nf-core pipelines list](https://nf-co.re/pipelines)

```{bash}
#!/bin/bash

#PBS -lwalltime=01:00:00
#PBS -lselect=1:mem=15gb
#PBS -o nf.log
#PBS -e nf.err
#PBS -N nf_test

module load Nextflow

cd $PBS_O_WORKDIR

nextflow run nf-core/rnaseq \
		-profile test,imperial \
		--outdir nf_out
```

The run command was mostly the same as before, except we are using `nf-core/rnaseq` instead of `nf-core/fetchngs`. We didn't need to specify a sample sheet, as it automatically downloaded a small test dataset.

In real-life there are a few more options you might want to change, so lets look at this using the published dataset that we downloaded with `fetchngs`. I would recommend creating a new directory for the RNA-seq analysis alongside the `fetchngs` directory we used earlier (e.g. `rnaseq`), so that the outputs of the two pipelines are kept separate.

The job submission command is as follows. Notice that the RAM specification is still quite low. This resource refers to the `nextflow` command itself and **NOT** any of the subsequent jobs that it will submit. It is a good idea to keep this low (a few Gb) to keep the wait time for the pipeline to start to a minimum. The `walltime` might need to be quite long, as this refers to the total time taken to the run the pipeline, and not the time allocation of any specific tasks. In practice, I have found this particular dataset to be fully analysed in a few hours or less depending on HPC capacity.

```{bash}
#!/bin/bash

#PBS -lwalltime=12:00:00
#PBS -lselect=1:ncpus=1:mem=5gb
#PBS -o nf_rnaseq_full.log
#PBS -e nf_rnaseq_full.err
#PBS -N nf_rnaseq_full

module load Nextflow

cd $PBS_O_WORKDIR

nextflow run nf-core/rnaseq -profile imperial \
		--outdir nf_out \
		--input samplesheet.csv \
		-params-file rnaseq_human.yml \
		-resume

```

I've added the `resume` flag to this pipeline run. This is a very good habit to get into if you are running longer pipelines and / or processing many samples. In the case of a pipeline error, which could be due to HPC downtime rather than something you did wrong, the next time you run the pipeline it will commence at the same stage the previous run failed. i.e. if the QC has already been completed it won't bother repeating the QC steps. This can be a huge time saver.

The `input` for this run is based on the sample sheet that was created by `fetchngs`, so we don't need to download the fastq files again or write our own sample sheet from scratch. However, we can't use it exactly as it is. Here are the first few lines (only the first four columns are shown):-

```{bash}
[mdunning@login-b rnaseq]$ head -n 3 ../fetchngs/nf_out/samplesheet/samplesheet.csv | cut -d, -f1-4
"sample","fastq_1","fastq_2","strandedness"
"ERX676592","nf_out/fastq/ERX676592_ERR732904.fastq.gz","","auto"
"ERX676593","nf_out/fastq/ERX676593_ERR732906.fastq.gz","","auto"
```

There are two problems:-

- the sample sheet contains lots of extra columns of metadata about each sample. Some of these contain long descriptions of the experimental protocol, including quotes that the RNA-seq pipeline isn't able to read. The pipeline only needs the first four columns.
- the paths to the fastq files are *relative* to the `fetchngs` directory, so the pipeline won't be able to find them when it is run from the `rnaseq` directory.

We can fix both of these with a couple of Unix commands, run from the `rnaseq` directory, to create a new sample sheet (`samplesheet.csv`) to use as the `input`. `cut` keeps the first four columns, and `sed` adds `../fetchngs/` to the start of each fastq path. The relative path `../fetchngs/` assumes the two directories sit side-by-side; change this if you ran `fetchngs` somewhere else.

```{bash}
cut -d, -f1-4 ../fetchngs/nf_out/samplesheet/samplesheet.csv | sed 's#"nf_out/fastq#"../fetchngs/nf_out/fastq#' > samplesheet.csv
```

This is quite a common situation; the output of one pipeline doesn't always slot straight into the next one, so it is always worth checking the files in between!

There are number of other files you will need to re-run this example; the first of which will download the reference genome and annotation (`download.sh`). Submit this script first (`qsub download.sh`) if you want to try out the pipeline for yourself

- [download.sh](rnaseq/download.sh)
- [nf_run_full.sh](rnaseq/nf_run_full.sh)
- [rnaseq_human.yml](rnaseq/rnaseq_human.yml)

I have created a file called `rnaseq_human.yml` to define the parameters for the pipeline. Having your parameters in a file such as this makes the job submission code a bit cleaner, and means you can re-analyse the same dataset with slightly different parameters by pointing to different config files. You can also reuse the same set of parameters on multiple projects. You can specify what reference data you want to use for alignment and annotation, and I have chosen to use Ensembl as my source. As I will want to re-use the same references I have created a small configuration file that points to the locations of these files.

I've also shown how to specify the particular alignment strategy to `star_rsem` from `star_salmon` (which is the one I tend to use in reality). In general you have quite a bit of flexibility with regards to the tools run at specific stages. If you need the results really quick, you can even turn off full genome alignment as use the `--skip_alignment` and `--pseudo-aligner salmon` options. For a full list of parameters you can consult the documentation:-

- [rnaseq pipeline parameters](https://nf-co.re/rnaseq/3.24.0/parameters/)

```{bash}
## rnaseq_human.yml
fasta: "ref_data/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
gtf: "ref_data/Homo_sapiens.GRCh38.115.gtf"
aligner: "star_rsem"
```

For this example, I could also create a separate parameter and job submission script for running an alternative branch of the pipeline. 

```{bash}
## rnaseq_human_quick.yml
fasta: "ref_data/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
gtf: "ref_data/Homo_sapiens.GRCh38.115.gtf"
skip_alignment: true
pseudo_aligner: "salmon"
```

Note that the choice of tools is dictated by what the community thinks is best-practice or gold standard. If you want to use some obscure tool from 10 years ago with only a couple of citations - you are probably out of luck. Similarly, only the most modern tools are supported and not deprecated tools. Each pipeline has active github and slack communities, so you can always suggest new tools if you have ideas...

### Tips for usage

- using a particular pipeline version; nextflow will automatically run the latest version of a pipeline that is available from github. This version is reported in the log file created by the pipeline. 
  + adding the flag `nextflow run nf-core/rnaseq -r 3.24.0` will make sure that the specific version 3.24.0 is used.
- working directory location; The work folder that nextflow creates can get rather large. There is a space quote on the home folders on Imperial HPC of 1Tb. This can get quickly used up. The contents on the work folder are not usually required once the pipeline has finished, so are ideal to be put in a temporary folder. For a dataset of around 100 samples I found I had to set a different location for the working directory to stop all my home drive being used up.
  + `-w ${EPHEMERAL}/work/rnaseq-aging`
- a shared location for reference genomes; if you are processing many datasets you can keep your reference data in a central location rather than copying the same reference genomes for each project as we have done here
- shared singularity folder: similar to above you can use the same location for each run to store the downloaded containers. This folder will have to be created in advance.
  + `export NXF_SINGULARITY_CACHEDIR="$HOME/software/singularity_cache`
- use version control (github); the configuration files, parameters and sample sheet used by nf-core are all really small and ideal for tracking with github for reproducibility. I also keep the execution traces and log files afterwards if needed. You can use the `.gitignore` file to make sure that large output files are excluded from github.
