#!/bin/bash
#Make index of the refgenome (.fai)
#samtools faidx ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic.fa ## This gives errors
#
# So use the seqit
#seqkit seq -w 70 GCF_003731985.1_ASM373198v1_genomic.fa > GCF_003731985.1_ASM373198v1_genomic_2.fa
#then
#samtools faidx ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa
#
#bwa index /home/bajuna/bioinf_projects/Kris_Pseudomonas_poae/genome/assembled/wildtype/23146E_unicycler_bold.fna
#
##Create dictionary for reference genome
#java -jar picard.jar CreateSequenceDictionary R= ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa O= ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.dict
#
###QC each sample file using fastqc
# No cleaning as Files appears to be clean and trimmed
#
###Run bwa mem for each sample file to create bam files (Galaxy version 0.7.16.0)
#Parameters for wildtype: -a Algorithm for constructing the BWT index: Auto. Let BWA decide the best algorithm to use, Single or Paired-end reads: Paired-end reads, Set read groups information?: Set read groups (SAM/BAM specification) Auto-assign: No, Read group identifier (ID): p_poae_wildtype_lib1, Read group sample name (SM): wildtype_ppoae, Platform/technology used to produce the reads (PL): ILLUMINA, Library name (LB): 23146_wildtype_ppoae, Select analysis mode: Simple illumina mode
##Parameters for aphidpassage: -a Algorithm for constructing the BWT index: Auto. Let BWA decide the best algorithm to use, Single or Paired-end reads: Paired-end reads, Set read groups information?: Set read groups (SAM/BAM specification) Auto-assign: Yes, Auto-assign: No, Read group sample name (SM): aphidpassage_ppoae, Platform/technology used to produce the reads (PL): ILLUMINA, Auto-assign: No, Library name (LB): 23147_aphidpassage_ppoae, Select analysis mode: Simple illumina mode
##Parameters for biofilmpassage: -a Algorithm for constructing the BWT index: Auto. Let BWA decide the best algorithm to use, Single or Paired-end reads: Paired-end reads, Set read groups information?: Set read groups (SAM/BAM specification) Auto-assign: Yes, Auto-assign: No, Read group sample name (SM): biofilmpassage_ppoae, Platform/technology used to produce the reads (PL): ILLUMINA, Auto-assign: No, Library name (LB): 23148_biofilmpassage_ppoae, Select analysis mode: Simple illumina mode
#
##Run bwa mem in command line
echo "running bwa mem on wildtype sample"
bwa mem -M -t 4 -R "@RG\tID:23146_wildtype_ppoae\tSM:23146E_wildtype_ppoae\tPL:illumina" /home/bajuna/bioinf_projects/Kris_Pseudomonas_poae/genome/assembled/wildtype/23146E_unicycler_bold.fna ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23146_wildtype_ppoae_1_trimmed.fastq.gz ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23146_wildtype_ppoae_2_trimmed.fastq.gz > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_aln.sam
#
echo "running bwa mem on aphidpassage sample"
bwa mem -M -t 4 -R "@RG\tID:23147E_aphidpassage_ppoae\tSM:aphidpassage_ppoae\tPL:illumina" /home/bajuna/bioinf_projects/Kris_Pseudomonas_poae/genome/assembled/aphid_passage/23147E_unicycler_bold.fna ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23147_aphidpassage_ppoae_1_trimmed.fastq.gz ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23147_aphidpassage_ppoae_2_trimmed.fastq.gz > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_aln.sam 
#
echo "running bwa mem on bioflmpassage sample"
bwa mem -M -t 4 -R "@RG\tID:23148E_biofilmpassage\tSM:biofilmpassage_ppoae\tPL:illumina" /home/bajuna/bioinf_projects/Kris_Pseudomonas_poae/genome/assembled/biofilm_passage/23148E_unicycler_bold.fna ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23148_biofilmpassage_ppoae_1_trimmed.fastq.gz ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23148_biofilmpassage_ppoae_2_trimmed.fastq.gz > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_aln.sam
#
sudo chmod -R 777 ~/bioinf_projects/
#
sudo samtools sort -n -O sam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_aln.sam | sudo samtools fixmate -m -O bam - ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_fixmate_aln.bam
rm ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_aln.sam
#
sudo samtools sort -O bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_fixmate_aln_sorted.bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_fixmate_aln.bam
sudo samtools flagstat ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/ppoae_wildtype_fixmate_aln_sorted.bam > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/wildtype_bam_stats.txt
#
sudo samtools sort -n -O sam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_aln.sam | sudo samtools fixmate -m -O bam - ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_fixmate_aln.bam
rm ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_aln.sam
#
sudo samtools sort -O bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_fixmate_aln_sorted.bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_fixmate_aln.bam
sudo samtools flagstat ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_ppoae_fixmate_aln_sorted.bam > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23147_aphidpassage_bam_stats.txt
#
sudo samtools sort -n -O sam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_aln.sam | sudo samtools fixmate -m -O bam - ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_fixmate_aln.bam
rm ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_aln.sam
#
sudo samtools sort -O bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_fixmate_aln_sorted.bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_fixmate_aln.bam
sudo samtools flagstat ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_ppoae_fixmate_aln_sorted.bam > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa_assembled/23148_biofilmpassage_bam_stats.txt

