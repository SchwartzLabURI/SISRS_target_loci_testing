#!/bin/bash
#SBATCH --job-name="astral_Camp"
#SBATCH --time=200:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=END,FAIL

cd $SLURM_SUBMIT_DIR

module purge

module load Java/17.0.2

for f in *FNA.tre; do if [ $(grep -o 'Centro\|Siph\|Lys\|Bur' $f |wc -l) -le 4 ]; then mv $f $f.short; fi; done  #remove trees w too few spp

cat *FNA.tre > SISRS_marker_genetrees.tre  #concat gene trees

java -jar ../../Astral/astral.5.7.8.jar -i SISRS_marker_genetrees.tre -o SISRS_marker_Camp.tre 2> SISRS_marker_Camp.log

