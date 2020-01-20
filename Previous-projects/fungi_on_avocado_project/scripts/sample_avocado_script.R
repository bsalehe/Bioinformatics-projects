## Packages
#betapart
library(betapart)
source("https://bioconductor.org/biocLite.R")
biocLite()

biocLite("OmicsMarkeR") # For computing Dice-Sorensen similarity index
require(OmicsMarkeR)

## Set working directory
setwd('~/rworksgenomics/jessica')
## Display files and load data files
list.files()
avocado_incubated <- read.csv("AvocadoDataIncubatedFruit.csv", header = T)
avocado_non_incubated <- read.csv("AvocadoDataNotIncubatedFruitNew.csv", header = T)
avocado_non_incubatedFiltered <- read.csv("AvocadoDataNotIncubatedFruitNewFiltered2.csv", header = T)

# In the data table given change the factor variable into character in addition of excluding the first column of the table
avocado_non_incubated_char_df <- data.frame(lapply(avocado_non_incubatedFiltered, as.character), stringsAsFactors = FALSE)

brown_symptoms_not_inc <- avocado_non_incubated_char_df$BrowningSymptoms
phenotype_not_inc <- avocado_non_incubated_char_df$Phenotype

# Apply sorensen similarity index
sorensen_brown_symptoms_not_inc <- sorensen(brown_symptoms_not_inc, phenotype_not_inc)

print(sorensen_brown_symptoms_not_inc)

####################### End Demo ##########################
