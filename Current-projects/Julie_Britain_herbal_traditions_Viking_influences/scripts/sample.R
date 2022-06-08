###
getwd()
setwd("/home/bajuna/bioinf_projects/julie_plants/scripts")
#
#
install.packages("statnet.common")
install.packages("sna")
install.packages("quanteda")
library(quanteda)
set.seed(2000)
# sampling from a corpus
summary(corpus_sample(data_corpus_inaugural, 5))
summary(corpus_sample(data_corpus_inaugural, 10, replace = TRUE))

# sampling sentences within document
corp <- corpus(c(one = "Sentence one.  Sentence two.  Third sentence.",
                 two = "First sentence, doc2.  Second sentence, doc2."))
corpsent <- corpus_reshape(corp, to = "sentences")
texts(corpsent)
texts(corpus_sample(corpsent, replace = TRUE, by = "document"))
#
#