
#Create a folder for quality checking of the raw reads
mkdir quality_check
#
#Create conda environment for Ppoae variant calling using samtools pipeline
conda create -n ppoae
#
#Activate conda environment for Ppoae variant calling using samtools pipeline
conda activate ppoae
#
#install required tools for mapping and variant calling using samtools pipeline
conda install -c bioconda bwa bedtools samtools
#
#Change uncompressed ref seq genome to typical fasta file
cat GCF_003731985.1_ASM373198v1_genomic.fna.gz > GCF_003731985.1_ASM373198v1_genomic.fa
#
#build index
bwa index seq/refseq/GCF_003731985.1_ASM373198v1_genomic.fa
#
#Create special folder for storing ref genome and bwa indices
mkdir ../genome
#
#Move all indices to this folder
sudo mv data/seq/refseq/GCF_003731985.1_ASM373198v1_genomic.fa.* ./genome/
#
#Create folder for storing bwa and bowtie mapping files
mkdir analysis/Intermediate_data/mapping analysis/Intermediate_data/mapping/bwa analysis/Intermediate_data/mapping/bowtie
#
#Run bwa mem for mapping wildtype, evolved strains for P poae rawreads with ref genome using default parameters
bwa mem ./genome/GCF_003731985.1_ASM373198v1_genomic.fa data/seq/short_reads/23146_wildtype_ppoae_1_trimmed.fastq.gz data/seq/short_reads/23146_wildtype_ppoae_2_trimmed.fastq.gz > ./analysis/Intermediate_data/ppoae_wildtype_aln.sam
#
#Move the alignment file to the bwa folder from current folder
sudo mv ppoae_wildtype_aln.sam mapping/bwa/ppoae_wildtype_aln.sam
#
#Clean aligned read pairing information due to unsual sam flags using samtools and produce compressed bam file. The 'samtools fixmate' command expects name-sorted sam input files
samtools sort -n -O sam analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_aln.sam | samtools fixmate -m -O bam - analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.bam
#
# Delete original sam alignment file
rm analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_aln.sam
#Sort the bam file into cordinate order
samtools sort -O bam -o analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.bam analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.bam
#Remove duplicates to mitigate the effects of PCR amplification bias introduced during library construction.In SNP calling it is a good idea to remove duplicates, as the statistics used in the tools that call SNPs sub-sequently expect this (most tools anyways).
samtools markdup -r -s -S analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.bam analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.bam
##READ 2422127 WRITTEN 2369656 
##EXCLUDED 786232 EXAMINED 1635895
##PAIRED 1604230 SINGLE 31665
##DULPICATE PAIR 35770 DUPLICATE SINGLE 16701
##DUPLICATE TOTAL 52471
samtools markdup -r -s -S analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.bam analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.bam
##READ 1861022 WRITTEN 1826146 
##EXCLUDED 608613 EXAMINED 1252409
##PAIRED 1228896 SINGLE 23513
##DULPICATE PAIR 23718 DUPLICATE SINGLE 11158
##DUPLICATE TOTAL 34876
samtools markdup -r -s -S analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.bam analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.dedup.bam
##READ 2352065 WRITTEN 2300502 
##EXCLUDED 751625 EXAMINED 1600440
##PAIRED 1572026 SINGLE 28414
##DULPICATE PAIR 36622 DUPLICATE SINGLE 14941
##DUPLICATE TOTAL 51563
#
#Get an mapping overview
samtools flagstat analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.bam
##2350871 + 0 in total (QC-passed reads + QC-failed reads)
##0 + 0 secondary
##37707 + 0 supplementary
##0 + 0 duplicates
##1621131 + 0 mapped (68.96% : N/A)
##2313164 + 0 paired in sequencing
##1156582 + 0 read1
##1156582 + 0 read2
##1542672 + 0 properly paired (66.69% : N/A)
##1568460 + 0 with itself and mate mapped
##14964 + 0 singletons (0.65% : N/A)
##19262 + 0 with mate mapped to a different chr
##15422 + 0 with mate mapped to a different chr (mapQ>=5)
samtools flagstat analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.bam
##1813582 + 0 in total (QC-passed reads + QC-failed reads)
##0 + 0 secondary
##27162 + 0 supplementary
##0 + 0 duplicates
##1244695 + 0 mapped (68.63% : N/A)
##1786420 + 0 paired in sequencing
##893210 + 0 read1
##893210 + 0 read2
##1186100 + 0 properly paired (66.40% : N/A)
##1205178 + 0 with itself and mate mapped
##12355 + 0 singletons (0.69% : N/A)
##14234 + 0 with mate mapped to a different chr
##11416 + 0 with mate mapped to a different chr (mapQ>=5)
samtools flagstat analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.dedup.bam
2283866 + 0 in total (QC-passed reads + QC-failed reads)
##0 + 0 secondary
##32244 + 0 supplementary
##0 + 0 duplicates
##1581121 + 0 mapped (69.23% : N/A)
##2251622 + 0 paired in sequencing
##1125811 + 0 read1
##1125811 + 0 read2
##1513878 + 0 properly paired (67.23% : N/A)
##1535404 + 0 with itself and mate mapped
##13473 + 0 singletons (0.60% : N/A)
##15970 + 0 with mate mapped to a different chr
##12802 + 0 with mate mapped to a different chr (mapQ>=5)
#
#Get read depth for at all positions of the reference genome, e.g. how many reads are overlapping the genomic position.
samtools depth analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.bam | gzip > analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_depth.txt.gz
samtools depth analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.dedup.bam | gzip > analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_depth.txt.gz
samtools depth analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.bam | gzip > analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_depth.txt.gz
#
#View the quality of the aligned bam files using qualimap bamqc
#First install the qaulimap if not in the system
##Download and unzip the program qualimap_v2.2.1.zip
unzip qualimap_v2.2.1.zip
##Install in the system with the depedencies
##For downloading, installing and use the tool (qualimap_v2.2.1): http://qualimap.bioinfo.cipf.es/ http://qualimap.bioinfo.cipf.es/doc_html/index.html and http://qualimap.bioinfo.cipf.es/doc_html/command_line.html#command-line
sudo Rscript installDependencies.r
#Check the quality of bam files of all samples.
./qualimap bamqc -bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.bam -outdir ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/qualitmap_23147_aphidpassage
./qualimap bamqc -bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.dedup.bam -outdir ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/qualitmap_23148_biofilmpassag_ppoae
./qualimap bamqc -bam ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.bam -outdir ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/qualitmap_ppoae_wildtype
#
#Quality-based sub-selection using MAPQ >= 50
samtools view -h -b -q 50 analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.bam > analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.q50.bam
samtools view -h -b -q 50 analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.bam > analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.q50.bam
samtools view -h -b -q 50 analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.dedup.bam > analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_fixmate_aln.sorted.dedup.q50.bam
#
########################### variant Calling with pileup
##Installing tools
conda install -c bioconda freebayes vcflib rtg-tools bcftools
#
#create a bam index file
bamtools index -in analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.q50.bam
bamtools index -in analysis/Intermediate_data/mapping/bwa/23148_biofilmpassag_ppoae_fixmate_aln.sorted.dedup.q50.bam
bamtools index -in analysis/Intermediate_data/mapping/bwa/23147_aphidpassage_ppoae_fixmate_aln.sorted.dedup.q50.bam
#
#Make index of the refgenome (.fai)
samtools faidx ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic.fa
#
# We first pile up all the reads and then call variants
samtools mpileup -u -g -f GCF_003731985.1_ASM373198v1_genomic_2.fa -b ../analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_23147_aphidpassage_23148_biofilmpassag.txt | bcftools call --ploidy 1 -v -m -O z -o ../analysis/Intermediate_data/variants/samtools/ppoae_wildtype_23147_aphidpassage_23148_biofilmpassag.mpileup.vcf.gz
#Options
## -u (deprecated) : uncompressed output
## -g (deprecated) : generate genotype likelihoods in BCF format
## -f : faidx indexed reference sequence file
## -b : multiple samples inpu BAM files
## --ploidy 1 : Haploid as are bacteria strains
## -v : Output variant sites only
## -m : alternative model for multiallelic and rare-variant calling
## -O z : 
## -o : output file-name : output type: ‘z’ compressed VCF
#
#
#
#
#
#
#
#
#
##################################### Varscan or GATK ##########################
#
#Generate bam file using bwa mem
#Markduplicate (picard/samtools)
#Check read group if exist in the file
#if not crreate read group byusing picard AddReadGroup command
#Perform indel realignment using gatk for each bam file
##Create dictionary for reference genome
java -jar picard.jar CreateSequenceDictionary R= ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa O= ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.dict
##Create target for realigner
java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -I ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/Galaxy52_MarkDuplicates_on_ppoae_wildtype.bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_realigner.intervals
##Perform indel realignment
java -jar GenomeAnalysisTK.jar -T IndelRealigner -R ~/bioinf_projects/Kris_Pseudomonas_poae/genome/GCF_003731985.1_ASM373198v1_genomic_2.fa -targetIntervals ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_realigner.intervals -I ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/Galaxy52_MarkDuplicates_on_ppoae_wildtype.bam -o ~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/mapping/bwa/Galaxy_realigned_ppoae_wildtype.dedup.bam
#Joint alignment using samtools/bcftools mpileup

########### VarScan 


##############freebayes
#freebayes -f GCF_003731985.1_ASM373198v1_genomic_2.fa -b ../analysis/Intermediate_data/mapping/bwa/ppoae_wildtype_fixmate_aln.sorted.dedup.q50.bam -p 1 -O --min-coverage 100 --min-base-quality 20 --min-mapping-quality 30 --min-supporting-allele-qsum 20 --min-supporting-mapping-qsum 30 --min-alternate-qsum 40 | gzip >~/bioinf_projects/Kris_Pseudomonas_poae/analysis/Intermediate_data/variants/freebayes/23146_ppoae_wildtype.freebayes_cov100.vcf.gz
