#!/bin/bash
#SBATCH --job-name="align"
#SBATCH --time=10:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH --array=[1-1493]%36 
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH -p uri-cpu
#
cd $SLURM_SUBMIT_DIR

module purge

module load uri/main
module load MAFFT/7.505-GCC-11.3.0-with-extensions
module load FastTree/2.1.11-GCCcore-12.3.0

SPP=($(ls *FNA))

cat ${SPP[$SLURM_ARRAY_TASK_ID]} |mafft --auto - | FastTree -nt -gtr > ${SPP[$SLURM_ARRAY_TASK_ID]}.tre 
