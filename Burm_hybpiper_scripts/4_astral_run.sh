#!/bin/bash
#SBATCH --job-name="astral"
#SBATCH --time=50:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=END,FAIL
#SBATCH -p uri-cpu

module purge
module load conda/latest
conda activate hybpiper
#conda install bioconda::astral-tree
module load uri/main 

cd $SLURM_SUBMIT_DIR

for f in *FNA.tre; do if [ $(grep -o 'Bur' $f |wc -l) -le 4 ]; then mv $f $f.short; fi; done  #remove trees w too few spp

cat *FNA.tre > SISRS_marker_genetrees.tre  #concat gene trees

astral -i SISRS_marker_genetrees.tre -o SISRS_marker_Bur.tre 2> SISRS_marker_Bur.log

