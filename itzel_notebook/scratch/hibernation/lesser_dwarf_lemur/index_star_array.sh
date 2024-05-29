#!/bin/bash

#SBATCH --partition=128x24               # Partition/queue to run on
#SBATCH --time=2-00:00:00                # Max time for job to run
#SBATCH --job-name=starIndex             # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --output=starIndex.out           # output file
#SBATCH --error=starIndex.err            # error file
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=15G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL
#SBATCH --array=[1-1]                   # array job

### for paralellizing each star genome indexing run for SRA samples into a job array
### script creates a special index of the reference genome for mapping to occur ###
### done once per genome ###


cd /hb/groups/kelley_training/itzel/data/genomic/hibernation/13_lined_ground_squirrel/index_star_out
species=$(echo ${LINE} | awk '{ print $1; }')

module load star

LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}"p /hb/groups/kelley_training/itzel/data/genomic/hibernation/13_lined_ground_squirrel/index_star_out/species_gcf.txt)
species=$(echo ${LINE} | awk '{ print $1; }')

echo "running STAR indexing for: ${species}"

genome_dir=/hb/groups/kelley_training/itzel/data/genomic/hibernation/13_lined_ground_squirrel
fna=$(basename ${genome_dir}/GCF_*_genomic.fna)
mkdir -p 13_lined_ground_squirrel
cd 13_lined_ground_squirrel

# Index genome for use with STAR (one genome needed more RAM, which is why the --limitGenomeGenerateRAM option is used)
STAR --runMode genomeGenerate --runThreadN 8 --genomeDir . --genomeFastaFiles ${genome_dir}/${fna} --sjdbGTFfile ${genome_dir}/genomic.gff --limitGenomeGenerateRAM 123560700863
