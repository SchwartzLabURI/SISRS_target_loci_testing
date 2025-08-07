#!/bin/bash
#SBATCH -J Astral
#SBATCH -t 24:00:00
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -p uri-cpu
#SBATCH --mem=50g
#SBATCH -o Astral.out
#SBATCH -e Astral.err

# Full dataset (run separately for Burmeistera only dataset)
for gene in `cat SCG.list`
do 
cat trees_supercontigs/${gene}.tre >> SCG_trees_supercontigs.tre
cat trees_dna/${gene}.tre >> SCG_trees.tre
done

java -jar /home/cbreusing_uri_edu/software/Astral/astral.5.7.8.jar -i SCG_trees_supercontigs.tre -o SCG_SpeciesTree_supercontigs_astral3.tre
java -jar /home/cbreusing_uri_edu/software/Astral/astral.5.7.8.jar -i SCG_trees.tre -o SCG_SpeciesTree_dna_astral3.tre