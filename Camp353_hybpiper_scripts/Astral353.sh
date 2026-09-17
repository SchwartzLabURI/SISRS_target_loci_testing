#!/bin/bash
#SBATCH -J Astral
#SBATCH -t 24:00:00
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -p uri-cpu
#SBATCH --mem=50g
#SBATCH -o Astral.out
#SBATCH -e Astral.err
#SBATCH --account=pi_rsschwartz_uri_edu

# Commands for full analysis, run separately for Burmeistera only samples
for gene in `cat SCG.list`
do 
cat trees/${gene}.tre >> SCG_trees.tre
done

cat trees/*.tre > gene_trees.tre

java -jar /home/cbreusing_uri_edu/software/Astral/astral.5.7.8.jar -i SCG_trees.tre -o 353_SCG_SpeciesTree_supercontigs_TargetCapture_astral3.tre
java -jar /home/cbreusing_uri_edu/software/Astral/astral.5.7.8.jar -i gene_trees.tre -o 353_SpeciesTree_supercontigs_TargetCapture_astral3.tre
