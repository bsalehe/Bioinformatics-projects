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
