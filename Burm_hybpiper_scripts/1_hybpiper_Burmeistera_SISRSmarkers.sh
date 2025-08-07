#!/bin/bash
#SBATCH --job-name="hyb"
#SBATCH --time=30:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH --array=[0-13]%2 
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH -p uri-cpu

cd $SLURM_SUBMIT_DIR
module purge

module load conda/latest
#when installing make sure to add memory in salloc
#conda config --add channels bioconda
#conda create -n hybpiper hybpiper
conda activate hybpiper

module load uri/main 
#module load SciPy-bundle/2023.07-gfbf-2023a
#module load matplotlib/3.7.2-gfbf-2023a
#module load bbmap/39.01
#pip install progressbar2 seaborn pebble
#module load BWA/0.7.17-GCCcore-12.3.0
#module load BLAST+/2.15.0-gompi-2023a 
#module load SAMtools/1.18-GCC-12.3.0
#module load DIAMOND/2.1.8-GCC-12.3.0
#module load SPAdes/3.15.5-GCC-11.3.0
#module load Exonerate/2.4.0-GCC-10.2.0
#module load MAFFT/7.505-GCC-11.3.0-with-extensions

#export PATH="../../../andromeda_transfer/rachel/HybPiper:$PATH"

SPP=($(cat TaxonListwout.txt))
#rm -rf Bur* Cen* fna_sp_name_only/*FNA
FASTA=../../../andromeda_transfer/rachel/Burmeistera_markers/SISRS_Run/contigs_for_probes_0_alignment_pi_locs_m0.txt_5.fa.fasta
READS=/project/pi_rsschwartz_uri_edu/andromeda_transfer/Campanulaceae/TrimReads

hybpiper assemble -t_dna ${FASTA} -r ${READS}/${SPP[$SLURM_ARRAY_TASK_ID]}/*.fastq.gz --prefix ${SPP[$SLURM_ARRAY_TASK_ID]} --bwa

