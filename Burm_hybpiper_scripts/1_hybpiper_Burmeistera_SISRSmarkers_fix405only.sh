#!/bin/bash
#SBATCH --job-name="hyb"
#SBATCH --time=60:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH -p uri-cpu

cd $SLURM_SUBMIT_DIR
module purge

module load conda/latest
conda activate hybpiper
module load uri/main 

SPP=Bur_sp_A405_Lago980
FASTA=../../../andromeda_transfer/rachel/Burmeistera_markers/SISRS_Run/contigs_for_probes_0_alignment_pi_locs_m0.txt_5.fa.fasta
READS=/project/pi_rsschwartz_uri_edu/andromeda_transfer/Campanulaceae/TrimReads

hybpiper assemble --force_overwrite -t_dna ${FASTA} -r ${READS}/${SPP}/*.fastq.gz --prefix ${SPP} --bwa

