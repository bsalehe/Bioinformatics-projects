########################### Assign a taxonomic classification to each amplicon sequence variant identfied above ###################
# Based on 99% similarity threshold from greengenes database
qiime tools import --input-path ../analysis/99_otus.fasta --output-path ../analysis/gg-13-8.99_otus.qza --type 'FeatureData[Sequence]'
# This file is also from greengenes database containing taxonomy of the sequences from 99_otus.fasta
qiime tools import --input-path ../analysis/99_otu_taxonomy.txt --output-path ../analysis/gg-13-8.99.taxa.qza --input-format HeaderlessTSVTaxonomyFormat --type 'FeatureData[Taxonomy]'
#
## Apply classification method using naive-bayes classifier
#
qiime feature-classifier extract-reads --i-sequences ../analysis/gg-13-8.99_otus.qza \
--p-f-primer TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGYCAGCMGCCGCGGTAA \ #primer for forward reads. These are just sample primer but actualliy were not used. # This step may take longer
--p-r-primer GTCTCGTGGGCTCGGAGATGTGTAATAAGAGACAGGGACTACNVGGGTWTCTAAT \ #primer for reverse reads. The same as forward
# Creating reads of 270 bp as in our case
#--p-trunc-len 270 \
--o-reads ../analysis/yasmin-gg-13-8.99.ref.seqs.qza
#
#Train the ‘sk-learn’ classifier on this set of reads (gg-13-8.99.ref.seqs.qza)
# 1
#qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads ../analysis/gg-13-8.99.ref.seqs.qza --i-reference-taxonomy ../analysis/gg-13-8.99.taxa.qza --o-classifier ../analysis/classifier.trained.qza
#
# 2
qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads ../analysis/yasmin-gg-13-8.99.ref.seqs.qza --i-reference-taxonomy ../analysis/gg-13-8.99.taxa.qza --o-classifier ../analysis/yasmin-classifier.trained1.qza
#
## Assign taxonomy
#
qiime feature-classifier classify-sklearn --i-classifier ../analysis/yasmin-classifier.trained1.qza --p-confidence 0.7 --i-reads ../analysis/rep-seqs-dada2.qza --o-classification ../analysis/yasmin-taxonomy.sklearn_second.qza
#
## Create a bar plot visualization of the taxonomy
qiime taxa barplot --i-table ../analysis/table-dada2.qza --i-taxonomy ../analysis/yasmin-taxonomy.sklearn_second.qza --m-metadata-file ../data/metadata_yasmin.tsv --o-visualization ../analysis/yasmin-taxa-bar-plots.dada2_second.qzv
#
## Visualization of your taxa
#
qiime tools view ../analysis/yasmin-taxa-bar-plots.dada2_second.qzv
#
## Questions: what is the most abundant taxon, at level 6, in the dataset? How do the samples compare to each other?
#
#
################ Make a phylogenetic tree of the identified ASVs ######################################################
#
# Alignment of the sequence variants with MAFFT
qiime alignment mafft --i-sequences ../analysis/rep-seqs-dada2.qza --o-alignment ../analysis/aligned-rep-seqs.qza
# Masking out the phylogenitically uninformative sequences with MASK
qiime alignment mask --i-alignment ../analysis/aligned-rep-seqs.qza --o-masked-alignment ../analysis/masked-aligned-rep-seqs.qza
# Creation of the un-rooted tree with FASTTREE
qiime phylogeny fasttree --i-alignment ../analysis/masked-aligned-rep-seqs.qza --o-tree ../analysis/unrooted-tree.qza
# Creation of the rooted tree
qiime phylogeny midpoint-root --i-tree ../analysis/unrooted-tree.qza --o-rooted-tree ../analysis/rooted-tree.qza
#
######################### Sequencing depth evaluation: rarefaction plot (Sampling/sequencing depth issue) ####################################
#The alpha-diversity, normally depends very strongly on sequencing depth. 
#Hence, performing rarefactions is important if you're comparing diversity between samples.
#
qiime diversity alpha-rarefaction --i-table table-dada2.qza \
--i-phylogeny rooted-tree.qza \
# Min and max depth for the plot
--p-min-depth 1 \ # But this is option could be left out or use default value which is 1
--p-max-depth 12000 \ # This was supposed to be 4000 based on the minimum sequence counts obtained from the feature table. OR 8000 based on the frequence per sample plot might be a good lead based on the peak
# Evaluating diversity every 50 seqs depth
--p-steps 50 \
# Using average from 55 iterations for the diversity count
--p-iterations 55 --m-metadata-file metadata.tsv --p-metrics chao1 --p-metrics simpson_e --p-metrics simpson --p-metrics shannon --p-metrics observed_otus --p-metrics faith_pd --o-visualization rarefaction-curve.qzv
# Alternative script for rarefaction/modified value
qiime diversity alpha-rarefaction --i-table table-dada2.qza --i-phylogeny rooted-tree.qza --p-max-depth 9781 --p-steps 50 --m-metadata-file metadata.tsv --p-iterations 55 --p-metrics chao1 --p-metrics simpson_e --p-metrics simpson --p-metrics shannon --p-metrics observed_otus --p-metrics faith_pd --o-visualization rarefaction-curve3.qzv
#
## Thefollowing commands are used to obtain the Principal Coordinate Analysis (PCoA) for the beta-diversity using the ‘bray-curtis’ distance.This is before rarefaction/normalization
qiime diversity beta --i-table table-dada2.qza --p-metric braycurtis --o-distance-matrix dada2.braycurtis.notNorm.diversity.qza
#
qiime diversity pcoa --i-distance-matrix dada2.braycurtis.notNorm.diversity.qza --o-pcoa dada2.braycurtis.notNorm.diversity.pcoa.qza
#
qiime emperor plot --i-pcoa dada2.braycurtis.notNorm.diversity.pcoa.qza --m-metadata-file metadata.file.txt --o-visualization dada2.braycurtis.notNorm.diversity.pcoa.qzv
#
######################### Diversity analysis: alpha and beta #############################################
#
qiime diversity core-metrics-phylogenetic --i-table table-dada2.qza --i-phylogeny rooted-tree.qza --p-sampling-depth 3000 --output-dir dada2-diversity-3000 --m-metadata-file metadata.tsv
#
# Find the significance of diversity (alpha)
cd dada2-diversity-3000
# For the Kruskal-Wallis
qiime diversity alpha-group-significance --i-alpha-diversity shannon_vector.qza --m-metadata-file ../metadata.tsv --o-visualization shannon-group-significance.kw.qzv
# For the ranked Spearman (if there is numerical columns in the metadata file
qiime diversity alpha-correlation --i-alpha-diversity shannon_vector.qza \
--m-metadata-file ../metadata.tsv \
--o-visualization shannon-group-significance.rs.qzv
#
# Find the significance of diversity (beta) based on the selected covariate from emperor plot (PCoA) analysis
qiime diversity beta-group-significance \
--i-distance-matrix weighted_unifrac_distance_matrix.qza \
--m-metadata-file ../metadata.tsv \
# Select one specific metadata column
--m-metadata-column Donor \
# permanova default, anosim as alternative choice
--p-method permanova \
--p-pairwise \
--p-permutations 999 \
--o-visualization weighted-unifrac-significance.Donor.qzv
#
#Questions: does the chosen grouping information result in statistical differences between two or more groups (as before the p-values are corrected for false-discovery rate)? 
#Does using ‘anosim’ instead of ‘permanova’ change the result? And using a different ordination metric?
#What about choosing a different grouping (metadata category)?
#
#
####################### Differential abundance analysis of AVSs across different conditions using ANCOM method ########################################
#
qiime taxa collapse --i-table table-dada2.qza --i-taxonomy taxonomy.sklearn.qza --p-level 5 --o-collapsed-table ancom-table-l6.qza
#
qiime composition add-pseudocount --i-table ancom-table-l6.qza --p-pseudocount 1 --o-composition-table comp-ancom-table-l6.qza
#
qiime composition ancom --i-table comp-ancom-table-l6.qza --m-metadata-file metadata1.tsv --m-metadata-column GxT --o-visualization l6-ancom-GxT.qzv
#
###################### Relative Percentage Abundance at level 6 ########################
#
qiime taxa collapse --i-table table-dada2.qza --i-taxonomy taxonomy.sklearn.qza --p-level 6 --o-collapsed-table genus-table.qza
## convert this new frequency table to relative-frequency
qiime feature-table relative-frequency --i-table genus-table.qza --o-relative-frequency-table rel-genus-table.qza
# This new artifact now has the needed relative-abundances. To get this into a text file, first export the data which is in biom format
qiime tools export rel-genus-table.qza --output-dir rel-table
#convert this to a text file in order to open it easily
# first move into the new directory
cd rel-table
# note that the table has been automatically labelled feature-table.biom
# You might want to change this filename for clarity
biom convert -i feature-table.biom -o rel-genus-table.tsv --to-tsv

