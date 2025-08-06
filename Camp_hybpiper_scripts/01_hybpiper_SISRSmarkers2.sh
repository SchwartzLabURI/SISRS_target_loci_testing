#!/bin/bash
#SBATCH --job-name="hyb_Camp"
#SBATCH --time=200:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # processor core(s) per node
#SBATCH --mail-user="rsschwartz@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH --array=[0-8]%4 
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

cd $SLURM_SUBMIT_DIR

module purge

module load SciPy-bundle/2020.11-foss-2020b
module load matplotlib/3.3.3-foss-2020b
module load BBMap/38.96-foss-2020b
#pip install progressbar2 seaborn pebble
module load BWA/0.7.17-GCCcore-11.2.0
module load BLAST+/2.8.1-foss-2018b
module load SAMtools/1.14-GCC-11.2.0
module load DIAMOND/2.0.7-GCC-10.2.0
module load SPAdes/3.15.2-GCC-10.2.0
module load Exonerate/2.4.0-GCC-10.2.0
module load MAFFT/7.475-gompi-2020b-with-extensions

export PATH="../../HybPiper:$PATH"

SPP=($(cat TaxonList_redo.txt))
contigs=../SISRS_Run/contigs_for_probes_10_alignment_pi_locs_m10.txt_2.fa.fasta
read_folder=../../../ambedoya/sisrs_out_Campanulaceae/Reads/TrimReads

#do this manually - don't uncomment
#rm -rf Bom* Luz* fna_sp_name_only/*FNA

#make single pair of fastqs
cat ${read_folder}/${SPP[$SLURM_ARRAY_TASK_ID]}/*_1.fastq.gz > ${SPP[$SLURM_ARRAY_TASK_ID]}_1.fastq.gz
cat ${read_folder}/${SPP[$SLURM_ARRAY_TASK_ID]}/*_2.fastq.gz > ${SPP[$SLURM_ARRAY_TASK_ID]}_2.fastq.gz

hybpiper assemble -t_dna $contigs -r ${SPP[$SLURM_ARRAY_TASK_ID]}*.fastq.gz --prefix ${SPP[$SLURM_ARRAY_TASK_ID]} --bwa

rm ${SPP[$SLURM_ARRAY_TASK_ID]}*.fastq.gz

