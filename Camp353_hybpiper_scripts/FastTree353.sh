#!/bin/bash
#SBATCH -J FastTree
#SBATCH -t 100:00:00
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -p uri-cpu
#SBATCH --mem=50g
#SBATCH -o FastTree.out
#SBATCH -e FastTree.err

eval "$(conda shell.bash hook)"
conda activate orthofinder2

# Produce gene trees (unfiltered), redo separately for Burmeistera only
for gene in `cat gene.list`
do
mafft --auto --thread ${SLURM_CPUS_ON_NODE} 03_supercontig_seqs/${gene}.fasta > alignments_supercontigs/${gene}.aln
FastTree -gtr -nt alignments_supercontigs/${gene}.aln > trees_supercontigs/${gene}.tre 
mafft --auto --thread ${SLURM_CPUS_ON_NODE} paralogs_all/${gene}_paralogs_all.fasta > alignments_paralogs/${gene}.aln
FastTree -gtr -nt alignments_paralogs/${gene}.aln > trees_paralogs/${gene}.tre 
mafft --auto --thread ${SLURM_CPUS_ON_NODE} 01_dna_seqs/${gene}.FNA > alignments_dna/${gene}.aln
FastTree -gtr -nt alignments_dna/${gene}.aln > trees_dna/${gene}.tre 
done

conda deactivate