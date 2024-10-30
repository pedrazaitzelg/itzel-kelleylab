#!/bin/bash

#SBATCH --partition=128x24               # Partition/queue to run on
#SBATCH --time=2-00:00:00                # Max time for job to run
#SBATCH --job-name=sbedtool_extract           # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=15G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL

### script to subset vcf files into only regions of interest ###
### in genes.bed: NW_026622763.1  13276405        13368337        -  ###

#working directory
cd /hb/groups/kelley_training/itzel/fall24/bedtools_out

#load module
module load bedtools

#script
bedtools intersect \
-a /hb/groups/kelley_training/itzel/fall24/allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.vcf.gz \
-b genes.bed \
-wa \
> insig_intersect.bed
