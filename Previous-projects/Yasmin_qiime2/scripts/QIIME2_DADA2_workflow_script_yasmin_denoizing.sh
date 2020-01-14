######################## Denoising and generating features' table ################################################
#
qiime dada2 denoise-paired --i-demultiplexed-seqs ../analysis/paired-end-demux.qza --p-trunc-len-f 225 --p-trunc-len-r 235 --p-no-hashed-feature-ids --o-representative-sequences ../analysis/rep-seqs-dada2_2.qza --o-table ../analysis/table-dada2_2.qza --output-dir ../analysis/dada2out_2 --verbose
#
#View the representative sequence file for all samples
qiime feature-table tabulate-seqs \
--i-data ../analysis/rep-seqs-dada2.qza \ # The ‘rep-seqs-dada2.qza’ artifact contains the identified sequence variants
--o-visualization ../analysis/rep-seqs-dada2.qzv
#
# View identfied sequence variants
qiime tools view ../analysis/rep-seqs-dada2.qzv
#
#To visualise the result of your abundance table, run:
qiime feature-table summarize \
--i-table ../analysis/table-dada2.qza \ # The 'table-dada2.qza ’ artifact contains abundance data
--o-visualization ../analysis/table-dada2.qzv \
--m-sample-metadata-file ../data/metadata_yasmin.csv
#
qiime tools view ../analysis/table-dada2.qzv
#
#################################################################################################################################
## Alternatively, you may try to use ‘DEBLUR’ to de-noise your data (after joining the reads with vsearch), this is generally faster.
# vsearch commands:
#qiime vsearch join-pairs --i-demultiplexed-seqs <paired-end-demux.qza> --o-joined-sequences demux-joined.qza
# generate visualization file (.qzv):
#qiime demux summarize --i-data demux-joined.qza --o-visualization demux-joined.qzv
#qiime tools view demux-joined.qzv
#qiime deblur denoise-16S --i-demultiplexed-seqs deblur-demux-joined.qza --p-trim-length 300 --o-representative-sequences deblur-rep-seqs.qza --o-table table-deblur.qza --o-stats deblur-stats.qza --p-jobs-to-start 8
#
#qiime feature-table tabulate-seqs --i-data deblur-rep-seqs.qza --o-visualization deblur-rep-seqs.qzv
##################################################################################################################################
#

