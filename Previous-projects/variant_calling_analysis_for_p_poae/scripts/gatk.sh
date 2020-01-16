##gatk Haplotype Caller (v4.1.2.0-28-ge8f5443-SNAPSHOT)

#Make index of the refgenome (.fai)
samtools faidx ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic.fa ## This gives errors
#
# So use the seqit
seqkit seq -w 70 GCF_003731985.1_ASM373198v1_genomic.fa > GCF_003731985.1_ASM373198v1_genomic_2.fa
#then
samtools faidx ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa
#
#
##Create dictionary for reference genome
java -jar picard.jar CreateSequenceDictionary R= ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa O= ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.dict
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
bwa mem -M -t 4 ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23146_wildtype_ppoae_1_trimmed.fastq.gz ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23146_wildtype_ppoae_2_trimmed.fastq.gz > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_aln.sam
#
echo "running bwa mem on aphidpassage sample"
bwa mem -M -t 4 ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23147_aphidpassage_ppoae_1_trimmed.fastq.gz ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23147_aphidpassage_ppoae_2_trimmed.fastq.gz > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_aln.sam 
#
echo "running bwa mem on bioflmpassage sample"
bwa mem -M -t 4 ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23148_biofilmpassage_ppoae_1_trimmed.fastq.gz ~/bioinf_projects/Kris_Pseudomonas_poae/data/seq/short_reads/23148_biofilmpassage_ppoae_2_trimmed.fastq.gz > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_aln.sam
#
samtools sort -n -O sam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_aln.sam | samtools fixmate -m -O bam - ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln.bam
rm ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_aln.sam
samtools sort -O bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln_sorted.bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln.bam
samtools flagstat ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln_sorted.bam > $pwd/wildtype_bam_stats.txt
#
samtools sort -n -O sam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_aln.sam | samtools fixmate -m -O bam - ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln.bam
rm ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_aln.sam
samtools sort -O bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln_sorted.bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln.bam
samtools flagstat ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln_sorted.bam > $pwd/23147_aphidpassage_bam_stats.txt
#
samtools sort -n -O sam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_aln.sam | samtools fixmate -m -O bam - ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln.bam
rm ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_aln.sam
samtools sort -O bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln_sorted.bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln.bam
samtools flagstat ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln_sorted.bam > $pwd/23148_biofilmpassage_bam_stats.txt
#
###Mark duplicate using picard (version ...) in Galaxy (version )
##Parameters: REMOVE_DUPLICATES; default=False, ASSUME_SORTED; default=True, DUPLICATE_SCORING_STRATEGY (The scoring strategy for choosing the non-duplicate among candidates); default=SUM_OF_BASE_QUALITIES, Regular expression that can be used in unusual situations to parse non-standard read names in the incoming SAM/BAM dataset: [a-zA-Z0-9]+:[0-9]:([0-9]+):([0-9]+):([0-9]+).*. OPTICAL_DUPLICATE_PIXEL_DISTANCE (The maximum offset between two duplicte clusters in order to consider them optical duplicates); default=100 Select validation stringency: SILENT
#
java -jar /usr/local/bioinfx/picard.jar MarkDuplicates I=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln_sorted.bam O=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln_sorted_marked_duplicates.bam M=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln_sorted_marked_duplicates_marked_dup_metrics.txt REMOVE_DUPLICATES READ_NAME_REGEX="[a-zA-Z0-9]+:[0-9]:([0-9]+):([0-9]+):([0-9]+).*."
java -jar /usr/local/bioinfx/picard.jar MarkDuplicates I=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln_sorted.bam O=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln_sorted_marked_duplicates.bam M=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln_sorted_marked_dup_metrics.txt REMOVE_DUPLICATES READ_NAME_REGEX="[a-zA-Z0-9]+:[0-9]:([0-9]+):([0-9]+):([0-9]+).*."
java -jar /usr/local/bioinfx/picard.jar MarkDuplicates I=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln_sorted.bam O=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln_sorted_marked_duplicates.bam M=~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln_sorted_marked_dup_metrics.txt REMOVE_DUPLICATES READ_NAME_REGEX="[a-zA-Z0-9]+:[0-9]:([0-9]+):([0-9]+):([0-9]+).*."
#
## Run gatk4 HaplotypeCaller for each sample BAM file
/usr/local/bioinfx/gatk/gatk HaplotypeCaller -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -I ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/ppoae_wildtype_fixmate_aln_sorted_marked_duplicates.bam -O ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants2/gatk/MarkDuplicates_on_ppoae_wildtype.g.vcf --native-pair-hmm-threads 3 -ERC GVCF -ploidy 1
#
/usr/local/bioinfx/gatk/gatk HaplotypeCaller -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -I ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23147_aphidpassage_ppoae_fixmate_aln_sorted_marked_duplicates.bam -O ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants2/gatk/MarkDuplicates_on_23147_aphidpassage_ppoae.g.vcf --native-pair-hmm-threads 3 -ERC GVCF -ploidy 1
#
/usr/local/bioinfx/gatk/gatk HaplotypeCaller \
-R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa \
-I ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa2/23148_biofilmpassage_ppoae_fixmate_aln_sorted_marked_duplicates.bam \
-O MarkDuplicates_on_23148_biofilmpassage_ppoae.g.vcf \
--native-pair-hmm-threads 3 \
-ploidy 1
-ERC GVCF

#https://gatkforums.broadinstitute.org/gatk/discussion/13367/haplotypercaller-optional-arguments
#https://software.broadinstitute.org/gatk/blog?id=4535
# GATK Unified Genotyper https://www.biostars.org/p/292151/
#https://gatkforums.broadinstitute.org/gatk/discussion/5978/output-mode-option-in-haplotypecaller-using-gvcf-mode
#https://gatkforums.broadinstitute.org/gatk/discussion/comment/14045
#https://software.broadinstitute.org/gatk/documentation/tooldocs/3.8-0/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HCMappingQualityFilter.php
#gatk-4.0.2.1/gatk HaplotypeCaller --native-pair-hmm-threads 24 -I KU_filtered_sorted_mdup.bam -O HC.KU.raw.snps.indels.g.vcf -R ref.fasta -ploidy 1 --emit-ref-confidence GVCF
#
##
## Combine all gvcf sample files
/usr/local/bioinfx/gatk/gatk CombineGVCFs -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -V ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data//variants/gatk/Galaxy52_MarkDuplicates_on_ppoae_wildtype.g.vcf -V ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/Galaxy54_MarkDuplicates_on_23147_aphidpassage_ppoae.g.vcf -V ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/Galaxy56_MarkDuplicates_on_23148_biofilmpassage_ppoae.g.vcf -O combined_wildtype_23147_aphidpassage_23148_biofilmpassage.g.vcf

##Combine Genotype (joint genotyping)
/usr/local/bioinfx/gatk/gatk GenotypeGVCFs -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -V ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/combined_wildtype_23147_aphidpassage_23148_biofilmpassage.g.vcf -O final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage.vcf
##Filtering (posteriors)
/usr/local/bioinfx/gatk/gatk CalculateGenotypePosteriors -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -V final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage.vcf --skip-population-priors --skip-family-priors -RF MappingQualityReadFilter --minimum-mapping-quality 30 -O final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios.vcf
##
/usr/local/bioinfx/gatk/gatk VariantFiltration -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -V final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios.vcf --genotype-filter-expression "GQ<20" --genotype-filter-name "lowGQ" -O final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf

## Annotation
/usr/local/bioinfx/gatk/gatk VariantAnnotator -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -V final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf -A PossibleDeNovo -O final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered_annotated.vcf

#######Hard-filtering using bcftools #######
#Based on Quality Depth (QD) and Depth of reads (DP)
bcftools filter -i'INFO/QD>30 & FMT/DP>150' final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf > test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf
#bcftools query -i'INFO/QD>=30 & FMT/DP>100' -f'%CHROM %POS %REF %ALT[ %QD][ %GT %AD]\n' final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf | wc -l
#
#### Annotations
### snpEff
## Installing tool: http://snpeff.sourceforge.net/SnpEff_manual.html
## sample protocol: http://snpeff.sourceforge.net/protocol.html
## Steps taken
## Bulding ppoae Genome from ncbi based on accession number
{$snpEff_path}./scripts/buildDbNcbi.sh GCA_003731985.1
## Configure snpEff.config file by adding the line below : check https://www.biostars.org/p/50963/
# Modify the ./data/ line to data/ #but ensure the 'data' folder is created in the snpEff tool main directory, i.e. mkdir data
# The name GCA_003731985.1 should the name of the folder which contain the genomic data in genebank format (.gbk) and should be inside the 'data' folder
GCA_003731985.1.genome : GCA_003731985.1
## Download the GenBank file (.gbff) from the ftp site which contains the annotated ncbi genome of ppoae. Change the file name to genes.gbk
## Building database : https://www.biostars.org/p/50963/
{$snpEff_path}java -jar snpEff.jar build -genbank -v GCA_003731985.1
##Check the chromosomes names in the 'data/GCA_003731985.1/snpEffectPredictor.bin' file. The names of chromosomes are in the 6th column for this genome
zcat snpEffectPredictor.bin | head -n 2
## Build the genes using downloaded gff file from the ncbi assembled genome ftp site using the following command. Make sure the name of '.gff' file is changed to 'genes.gff'
java -jar snpEff.jar build -gff3 -v GCA_003731985.1
##Change the names of chromosomes in the input vcf file to match those in the 6th column of the file 'data/GCA_003731985.1/snpEffectPredictor.bin'. The script below does for a single chromosome 'MOAY01000081'
cat test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf | sed "s/^NZ_MOAY01000081.1/MOAY01000081/" > updated_test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf # Use loop to accomplish for all chromosomes
Alternatively you can change the input vcf file manually. #More info : https://www.biostars.org/p/124885/, http://snpeff.sourceforge.net/SnpEff_faq.html
##Run the snpEff to annotate the variants
java -Xmx4g -jar snpEff.jar -v GCA_003731985.1 ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.ann.vcf
##Or using this command
java -Xmx4g -jar snpEff.jar -v GCA_003731985.1 ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/modified_test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.vcf > ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/modified_test_filtering_final_variants_combined_wildtype_23147_aphidpassage_23148_biofilmpassage_gtposterios_filtered.ann.vcf
##Copy files 'snpEff_summary.html' and 'snpEff_genes.txt' from ${snpEff_path} to gatk folder.
mv snpEff_summary.html  ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/snpEff_summary.html
mv snpEff_genes.txt  ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/gatk/snpEff_genes.txt

######################### Finding SNPs using the assembly and reference genomes with minimap2 ###############
./minimap2 -c --cs ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa ~/bioinf_projects/Kris_Pseudomonas_poae/genome/assembled/23146E_unicycler.fna | sort -k6,6 -k8,8n | ./k8 misc/paftools.js call -f ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -L20000 - >  var.vcf

######################### Using IGV tool compare the var.vcf file with vcf file generated using gatk ########
## Examine the variants called by both approaches in each chromosomes of the variants


