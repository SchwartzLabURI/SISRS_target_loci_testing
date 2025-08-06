#!/bin/bash
#SBATCH --job-name="align_Camp"
#SBATCH --time=200:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH --array=[0-559]%36 
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

cd $SLURM_SUBMIT_DIR

module purge

module load MAFFT/7.475-gompi-2020b-with-extensions
module load FastTree/2.1.11-GCCcore-11.2.0

SPP=($(ls *FNA))


cat ${SPP[$SLURM_ARRAY_TASK_ID]} |mafft --auto - | FastTree -nt -gtr > ${SPP[$SLURM_ARRAY_TASK_ID]}.tre 
