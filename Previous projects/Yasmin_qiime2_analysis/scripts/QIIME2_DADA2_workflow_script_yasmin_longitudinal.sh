##Pairwise difference comparisons
###Pairwise difference tests determine whether the value of a specific metric changed significantly between pairs of paired samples (e.g., pre- and post-treatment).
qiime longitudinal pairwise-differences \
  --m-metadata-file ../data/metadata_yasmin.tsv \
  --m-metadata-file ../analysis/dada2-diversity-837/shannon_vector.qza \
  --p-metric shannon \
  --p-group-column Time_in_chamber \
  --p-state-column Temperature_state \
  --p-state-1 1 \
  --p-state-2 2 \
  --p-individual-id-column Group \
  --p-replicate-handling random \
  --o-visualization ../analysis/dada2-diversity-837/pairwise-differences_13_14_15_17_degree.qzv

