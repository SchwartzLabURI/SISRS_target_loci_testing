#!/bin/bash
#SBATCH --job-name="hyb"
#SBATCH --time=60:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=END,FAIL
#SBATCH -p uri-cpu

cd $SLURM_SUBMIT_DIR

module purge

module load conda/latest
conda activate hybpiper
module load uri/main 

FASTA=../../../andromeda_transfer/rachel/Burmeistera_markers/SISRS_Run/contigs_for_probes_0_alignment_pi_locs_m0.txt_5.fa.fasta

hybpiper stats -t_dna ${FASTA} gene TaxonListwout.txt

hybpiper retrieve_sequences -t_dna ${FASTA} dna --sample_names TaxonListwout.txt
