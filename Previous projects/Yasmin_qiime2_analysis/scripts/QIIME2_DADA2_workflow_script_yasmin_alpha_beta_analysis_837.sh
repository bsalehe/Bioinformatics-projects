#mkdir ../analysis/dada2-diversity-837
#
qiime diversity core-metrics-phylogenetic --i-table ../analysis/table-dada2.qza --i-phylogeny ../analysis/rooted-tree.qza --p-sampling-depth 837 --output-dir ../analysis/dada2-diversity-837_updated --m-metadata-file ../data/metadata_yasmin.tsv
#
# Find the significance of diversity (alpha)
#cd ../analysis/dada2-diversity-837
# For the Kruskal-Wallis
qiime diversity alpha-group-significance --i-alpha-diversity ../analysis/dada2-diversity-837/shannon_vector.qza --m-metadata-file ../data/metadata_yasmin.tsv --o-visualization ../analysis/dada2-diversity-837/shannon-group-significance.kw.qzv
#
qiime diversity alpha-group-significance --i-alpha-diversity ../analysis/dada2-diversity-837/observed_otus_vector.qza --m-metadata-file ../data/metadata_yasmin.tsv --o-visualization ../analysis/dada2-diversity-837/observed_otus-group-significance.kw.qzv
#
qiime diversity alpha-group-significance --i-alpha-diversity ../analysis/dada2-diversity-837/faith_pd_vector.qza --m-metadata-file ../data/metadata_yasmin.tsv --o-visualization ../analysis/dada2-diversity-837/faith_pd-group-significance.kw.qzv
#
# For the ranked Spearman (if there is numerical columns in the metadata file
qiime diversity alpha-correlation --i-alpha-diversity shannon_vector.qza --m-metadata-file ../data/metadata_yasmin.tsv --o-visualization ../analysis/dada2-diversity-837/shannon-group-significance.rs.qzv
#
# Find the significance of diversity (beta) based on the selected covariate from emperor plot (PCoA) analysis
#Beta diversity significance (permanova) unweighted-unifrac-significance
qiime diversity beta-group-significance --i-distance-matrix ../analysis/dada2-diversity-837/unweighted_unifrac_distance_matrix.qza --m-metadata-file ../data/metadata_yasmin.tsv --m-metadata-column Time_in_chamber --p-method permanova --p-pairwise --p-permutations 999 --o-visualization ../analysis/dada2-diversity-837/unweighted-unifrac-significance.Time_in_chamber.qzv
#
qiime diversity beta-group-significance --i-distance-matrix ../analysis/dada2-diversity-837/weighted_unifrac_distance_matrix.qza --m-metadata-file ../data/metadata_yasmin.tsv --m-metadata-column Treatment_ambient_recoded_temperature --p-method permanova --p-pairwise --p-permutations 999 --o-visualization ../analysis/dada2-diversity-837/unweighted-unifrac-significance.Treatment_ambient_recoded_temperature.qzv
#
qiime diversity beta-group-significance --i-distance-matrix ../analysis/dada2-diversity-837/weighted_unifrac_distance_matrix.qza --m-metadata-file ../data/metadata_yasmin.tsv --m-metadata-column Set_reactor_temperature --p-method permanova --p-pairwise --p-permutations 999 --o-visualization ../analysis/dada2-diversity-837/unweighted-unifrac-significance.Set_reactor_temperature.qzv
#
#Beta diversity significance (permanova) unweighted-unifrac-significance
qiime diversity beta-group-significance --i-distance-matrix ../analysis/dada2-diversity-837/jaccard_distance_matrix.qza --m-metadata-file ../data/metadata_yasmin.tsv --m-metadata-column Time_in_chamber --p-method permanova --p-pairwise --p-permutations 999 --o-visualization ../analysis/dada2-diversity-837/jaccard_distance_matrix.qza.Time_in_chamber.qzv
#
qiime diversity beta-group-significance --i-distance-matrix ../analysis/dada2-diversity-837/jaccard_distance_matrix.qza --m-metadata-file ../data/metadata_yasmin.tsv --m-metadata-column Treatment_ambient_recoded_temperature --p-method permanova --p-pairwise --p-permutations 999 --o-visualization ../analysis/dada2-diversity-837/jaccard_distance_matrix.qza.Treatment_ambient_recoded_temperature.qzv
#
qiime diversity beta-group-significance --i-distance-matrix ../analysis/dada2-diversity-837/bray_curtis_distance_matrix.qza --m-metadata-file ../data/metadata_yasmin.tsv --m-metadata-column Set_reactor_temperature --p-method permanova --p-pairwise --p-permutations 999 --o-visualization ../analysis/dada2-diversity-837/bray_curtis_distance_matrix.qza
#
#Questions: does the chosen grouping information result in statistical differences between two or more groups (as before the p-values are corrected for false-discovery rate)? 
#Does using ‘anosim’ instead of ‘permanova’ change the result? And using a different ordination metric?
#What about choosing a different grouping (metadata category)?
#
