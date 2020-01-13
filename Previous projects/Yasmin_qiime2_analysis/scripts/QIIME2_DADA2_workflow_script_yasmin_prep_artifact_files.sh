#####################################################
##QIIME2 script using DADA2 workflow-denoising
#####################################################
#
#echo "Viewing your manifest file, if does not exist create it"
#
#head manifest2.csv
#
#
#tail manifest2.csv
#
#echo "Start conda to run QIIME2 by activating conda environment"
#conda activate
#
#echo "Show the available conda environments"
#conda env list
#
#echo "Activate QIIME2 version on conda, this depends on QIIME2 installed in your machine"
#source activate qiime2-2019.4
#
echo "Importing raw reads data (based on the information contained in the ‘manifest file’) into QIIME2 artifact file (.qza)"
#
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path ../data/manifest_1.csv --output-path ../analysis/paired-end-demux.qza --input-format PairedEndFastqManifestPhred33
#This will use the information contained in the ‘manifest file’ to create the artifact file ‘ paired-end-demux.qza ’
#
############################## Demultiplexing data ##########################
## Check if the data are not demultiplexed then demultiplex first before moving to the next step. If demultiplexed then go to importing read pairs into artifact step
## Check QIIME2 instructions for demultiplexing paired-end reads with cutadapt ('qiime cutadapt demux-paired'), 
## but this is used when your barcodes are still in the sequences and need to be both identified and trimmed out.
## Useful link: https://docs.qiime2.org/2018.11/plugins/available/cutadapt/demux-paired/.
## Otherwise use qiime 'emp-paired' to demultiplex if the data are paired-end
#
#qiime demux emp-paired --i-seqs <imported-file>.qza --m-barcodes-file <metadata>.txt –m-barcodes-column BarcodeSequence –p-rev-comp-mapping-barcodes –o-per-sample-sequences demux_seqs.qza
#
#echo "demultiplexing summary"
#qiime demux summarize --i-data demux_seqs.qza --output-dir demux_summary
#
echo "Visualising loaded samples, and check the quality of reads for potential trimming of poor quality regions and removing primers too."
#
qiime demux summarize --i-data ../analysis/paired-end-demux.qza --o-visualization ../analysis/paired-end-demux.qzv
#
qiime tools view ../analysis/paired-end-demux.qzv
#
#
## You may want to use FastQC to check the quality of the reads and identify primers before using dada2
#cat *_R1.fastq.gz > single_R1.fastq.gz
#fastqc single_R1.fastq.gz
#firefox single_R1_fastqc.html
#cat *_R2.fastq.gz > single_R2.fastq.gz
#fastqc single_R2.fastq.gz
#firefox single_R2_fastqc.html
#
echo "Trim the PCR primer sequences if exist using cutadapat before using dada2."
#
qiime cutadapt trim-paired --i-demultiplexed-sequences ../analysis/paired-end-demux.qza --p-front-f AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC --p-front-r AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA --o-trimmed-sequences ../analysis/paired-end-demux.trim.qza
#
echo "To visualise the trimmed samples"
qiime demux summarize --i-data ../analysis/paired-end-demux.trim.qza --o-visualization ../analysis/paired-end-demux.trim.qzv
#
qiime tools view ../analysis/paired-end-demux.trim.qzv
#exit
#
