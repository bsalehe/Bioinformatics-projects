######################### Sequencing depth evaluation: rarefaction plot (Sampling/sequencing depth issue) ####################################
#The alpha-diversity, normally depends very strongly on sequencing depth. 
#Hence, performing rarefactions is important if you're comparing diversity between samples.
#
#qiime diversity alpha-rarefaction --i-table table-dada2.qza \
#--i-phylogeny rooted-tree.qza \
# Min and max depth for the plot
#--p-min-depth 1 \ # But this is option could be left out or use default value which is 1
#--p-max-depth 12000 \ # This was supposed to be 4000 based on the minimum sequence counts obtained from the feature table. OR 8000 based on the frequence per sample plot might be a good lead based on the peak
# Evaluating diversity every 50 seqs depth
#--p-steps 50 \
# Using average from 55 iterations for the diversity count
#--p-iterations 55 --m-metadata-file metadata.tsv --p-metrics chao1 --p-metrics simpson_e --p-metrics simpson --p-metrics shannon --p-metrics observed_otus --p-metrics faith_pd --o-visualization rarefaction-curve.qzv
# Alternative script for rarefaction/modified value
qiime diversity alpha-rarefaction --i-table ../analysis/table-dada2.qza --i-phylogeny ../analysis/rooted-tree.qza --p-max-depth 	4000 --p-steps 20 --m-metadata-file ../data/metadata_yasmin.csv --p-iterations 55 --p-metrics chao1 --p-metrics simpson_e --p-metrics simpson --p-metrics shannon --p-metrics observed_otus --p-metrics faith_pd --o-visualization ../analysis/rarefaction-curve1.qzv
#
## Thefollowing commands are used to obtain the Principal Coordinate Analysis (PCoA) for the beta-diversity using the ‘bray-curtis’ distance.This is before rarefaction/normalization
qiime diversity beta --i-table ../analysis/table-dada2.qza --p-metric braycurtis --o-distance-matrix ../analysis/dada2.braycurtis.notNorm.diversity.qza
#
qiime diversity pcoa --i-distance-matrix ../analysis/dada2.braycurtis.notNorm.diversity.qza --o-pcoa ../analysis/dada2.braycurtis.notNorm.diversity.pcoa.qza
#
qiime emperor plot --i-pcoa ../analysis/dada2.braycurtis.notNorm.diversity.pcoa.qza --m-metadata-file ../data/metadata_yasmin.csv --o-visualization ../analysis/dada2.braycurtis.notNorm.diversity.pcoa.qzv
#
