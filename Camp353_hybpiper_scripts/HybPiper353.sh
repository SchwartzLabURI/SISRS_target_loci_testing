#!/bin/bash
#SBATCH -J HybPiper
#SBATCH -t 48:00:00
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=50g
#SBATCH -p uri-cpu
#SBATCH -o HybPiper.out
#SBATCH -e HybPiper.err

eval "$(conda shell.bash hook)"
conda activate hybpiper

# Check and fix target file
hybpiper check_targetfile --targetfile_dna Campanulaceae353.fasta
hybpiper fix_targetfile --targetfile_dna Campanulaceae353.fasta --filter_by_length_percentage 0.5 --allow_gene_removal fix_targetfile_2025-05-09-12_43_34.ctl

# Assemble 353 loci (run as array job, only shown here for completeness)
for file in `cat filelist.txt`
do
hybpiper assemble -r /project/pi_rsschwartz_uri_edu/cbreusing/Campanulaceae_paralog_analysis/filtered_reads/${file}*.fastq.gz -t_dna Campanulaceae353_fixed.fasta --cpu ${SLURM_CPUS_ON_NODE} --prefix ${file} --bwa --chimeric_stitched_contig_check
done

# Get initial run statistics
hybpiper stats --cpu ${SLURM_CPUS_ON_NODE} -t_dna Campanulaceae353_fixed.fasta gene filelist.txt

# Create new directory for locus analysis excluding internal stop codons
mkdir without_internal_stop_codons
cd without_internal_stop_codons
cp -r ../* .

# Extract only loci without internal stop codons (run as array job, only shown here for completeness)
for file in `cat filelist.txt`
do
hybpiper assemble -r /project/pi_rsschwartz_uri_edu/cbreusing/Campanulaceae_paralog_analysis/filtered_reads/${file}*.fastq.gz -t_dna Campanulaceae353_fixed.fasta --cpu ${SLURM_CPUS_ON_NODE} --prefix ${file} --bwa --chimeric_stitched_contig_check --start_from extract_contigs --force_overwrite --exonerate_skip_hits_with_internal_stop_codons
done

# Get new stats and length recovery heatmap
hybpiper stats --cpu ${SLURM_CPUS_ON_NODE} -t_dna Campanulaceae353_fixed.fasta gene filelist.txt
hybpiper recovery_heatmap seq_lengths.tsv

# Recover DNA, amino-acid, supercontig and paralogous sequences
hybpiper retrieve_sequences -t_dna Campanulaceae353_fixed.fasta dna --cpu ${SLURM_CPUS_ON_NODE} --skip_chimeric_genes --sample_names filelist.txt --fasta_dir 01_dna_seqs
hybpiper retrieve_sequences -t_dna Campanulaceae353_fixed.fasta aa --cpu ${SLURM_CPUS_ON_NODE} --skip_chimeric_genes --sample_names filelist.txt --fasta_dir 02_aa_seqs
hybpiper retrieve_sequences -t_dna Campanulaceae353_fixed.fasta supercontig --cpu ${SLURM_CPUS_ON_NODE} --skip_chimeric_genes --sample_names filelist.txt --fasta_dir 03_supercontig_seqs
hybpiper paralog_retriever filelist.txt -t_dna Campanulaceae353_fixed.fasta --cpu ${SLURM_CPUS_ON_NODE}

# Recover DNA, amino-acid, supercontig and paralogous for Burmeistera 
hybpiper retrieve_sequences -t_dna Campanulaceae353_fixed.fasta dna --cpu ${SLURM_CPUS_ON_NODE} --skip_chimeric_genes --sample_names Burmeistera.list --fasta_dir 01_Bur_dna_seqs
hybpiper retrieve_sequences -t_dna Campanulaceae353_fixed.fasta aa --cpu ${SLURM_CPUS_ON_NODE} --skip_chimeric_genes --sample_names Burmeistera.list --fasta_dir 02_Bur_aa_seqs
hybpiper retrieve_sequences -t_dna Campanulaceae353_fixed.fasta supercontig --cpu ${SLURM_CPUS_ON_NODE} --skip_chimeric_genes --sample_names Burmeistera.list --fasta_dir 03_Bur_supercontig_seqs
hybpiper paralog_retriever Burmeistera.list -t_dna Campanulaceae353_fixed.fasta --cpu ${SLURM_CPUS_ON_NODE} --fasta_dir_all Bur_paralogs_all --paralog_report_filename Bur_paralog_report --paralogs_above_threshold_report_filename Bur_paralogs_above_threshold_report --heatmap_filename Bur_paralog_heatmap
