## This is an initial pipeline for importing NMR spectral data from Bruker topspin software. It was run in Ubuntu 16.04 "Xenial".
## 
############################################### The R packages explored ##########################################################
## There are several R packages available in the repository for analysing spectral data
## The explored useful packages are: BATMAN, hyperspec, and specmine
##################################################################################################################################
##
############################################# Online tools for spectra analyses ##################################################
## There are also useful online tools for spectral analyses.
## These are: nmrML (nmrml.org) which has useful function for converting TopSpin peaks into format that could be used by other
# r packages, NMRProcFlow, which in itself you can also import TopSpin data and convert into format that could be used by itself or
# other r packages for further pre-processing and stastical analyses.
##################################################################################################################################
##
##
################################################# Setting R environment ###########################################################
rm(list=ls()) ## Start new R session with clean global environment
## Set working directory, it might be set where your data files reside.
# setwd("/home/your/working/directory")
setwd("/home/bajuna/rworksgenomics/anisha")
################################################################################################################################
#                                          Loading required R Packages
#################################################################################################################################
#
################################################# 1. Specmine ####################################################################
# Provides a set of methods for metabolomics data analysis, including data loading in different formats, pre-processing,
# metabolite identification, univariate and multivariate data analysis, machine learning, feature selection and pathway analysis.
#
## Installing specmine
#install.packages("specmine")
library(specmine)
#################################################################################################################################
#
########################################## 1. Reading Bruker topspin Files ########################################################
# List the files from currrent directory that you are working in.
list.files()
#
## A. With specmine
#
new_spec_read_bruker <- read_Bruker_files("~/rworksgenomics/anisha/examdata", zipped = F) ## read new Bruker file from directory
#new_spec_read_bruker <- read_Bruker_files("/opt/topspin4.0.3/examdata", zipped = F)
#spec.read.bruker <- read_Bruker_files("/opt/topspin4.0.3/examdata", zipped = F) ## the built-in topspin example dataset
#
check_dataset(new_spec_read_bruker) ## Check if the dataset is valid spec data
#
sum_dataset(new_spec_read_bruker) ## summary of the imported data
#
## Retrieve sample names
get_sample_names(new_spec_read_bruker)
# [1] "exam_DNMR_ipr2sic"  "exam_DNMR_Me2NCOMe" "exam1d_13C"         "exam1d_1H"
#
# check the dataset is from the spectral data
is_spectra(new_spec_read_bruker)
#
#
########################################## 2. Missing values (NAs) imputation #####################################################
#
## A. Remove NAs using specmine
# count NAs on the dataset
count_missing_values(new_spec_read_bruker) 
#
## count NAs on each sample of the dataset and you can remove them by option remove.zero = T
count_missing_values_per_sample(new_spec_read_bruker, remove.zero = F) 
#
# Use impute_nas_mean()
removed_na_new_spec_read_bruker <- impute_nas_mean(new_spec_read_bruker)
#
## B. Remove NAs using hyperSpec.
library(hyperSpec)
# Convert first into hyperspec from specmine
#
hyperspec_new_spec_read_bruker <- convert_to_hyperspec(new_spec_read_bruker)
#
# Then remove NAs
new_spec_read_bruker_no_NA <- spc.NA.approx(hyperspec_new_spec_read_bruker, debuglevel = 2)
#
## Visualising dimmensions, columns, and rows
# A. With hypeSpec
#
#dimnames(hyperspec_new_spec_read_bruker)
rownames(hyperspec_new_spec_read_bruker, prefix = "row")
colnames(hyperspec_new_spec_read_bruker, prefix = "col")
#
########################################## PRE-PROCESSING ######################################################################
#
########################################## 1. Background Correction ###############################################################
## A. with specmine
# Compute background correction after removing missing values (NAs)
corrected_spec_bruker <- background_correction(removed_na_new_spec_read_bruker)
#
######################################### 2. Baseline Correction  ################################################################
#
## A. With specmine
# Perform baseline correction using "modpolyfit" method
base_corrected_spec_bruker <- baseline_correction(removed_na_new_spec_read_bruker, method = "modpolyfit")
#
## B. With hyperSpec
#
## Run spc.fit.poly.below
baselines_hyperSpec <- spc.fit.poly.below(new_spec_read_bruker_no_NA)
#
######################################## 3. Normalise the spectra data #########################################################
#
# A. Using specmine with non NAs dataset
normalized_spectra_specmine <- normalize(removed_na_new_spec_read_bruker, method = "median")
normalized_spectra_specmine1 <- normalize(removed_na_new_spec_read_bruker, method = "sum", constant = 1000)
#
# B. Using hyperspec with non NAs dataset
normalized_spectra_hyperspec <- normalize01(new_spec_read_bruker_no_NA)
#
####################################### 4. Aligning spectra peaks ######################################################################
#
# Detecting lower peaks with mininimum intensity baseline and align them.
#
align_peaks <- detect_nmr_peaks_from_dataset(normalized_spectra_specmine, baseline_tresh = 50000, ap.method = "own", ap.step = 0.03)
# Plot the aligned peaks
#
plot_spectra_simple(align_peaks, main = "Aligned spectra peaks", xlab = "ppm", ylab = "intensity")
#
############################################## END PREPROCESSING ################################################################
############################################## PLOTTING SPECTRA DATA ############################################################
#
## A. With specmine using dataset containing NAs
## Plot dendrogram of hierarchical clustering results.
bruker_hc_cluster <- hierarchical_clustering(new_spec_read_bruker)
dendrogram_plot(new_spec_read_bruker,bruker_hc_cluster)
#
# Plot dendogram with color
dendrogram_plot_col(new_spec_read_bruker, bruker_hc_cluster, classes.col = "Muscle.loss", title = "Sample bruker data")
#
# Plot spectra from dataset
plot_spectra_simple(new_spec_read_bruker, samples = c("exam_DNMR_ipr2sic", "exam_DNMR_Me2NCOMe", "exam1d_13C"))
#
## Without NAs in the data
plot_spectra_simple(removed_na_new_spec_read_bruker, samples = c("exam_DNMR_ipr2sic", "exam_DNMR_Me2NCOMe", "exam1d_13C"))
#
## Plot normalised data
plot_spectra_simple(normalized_spectra_specmine, samples = c("exam_DNMR_ipr2sic", "exam_DNMR_Me2NCOMe", "exam1d_13C"))
plot_spectra_simple(normalized_spectra_specmine1, samples = c("exam_DNMR_ipr2sic", "exam_DNMR_Me2NCOMe", "exam1d_13C"))
#
#
## B. With hyperSpec
#
plotspc(hyperspec_new_spec_read_bruker) # The same plot as plot() function below
plot(hyperspec_new_spec_read_bruker)
#qplotc(hyperspec_new_spec_read_bruker) + geom_smooth(method = "lm") ## does not work well with the data, probably data need more cleaning
#qplotmap(hyperspec_new_spec_read_bruker) ## does not work
qplotspc(hyperspec_new_spec_read_bruker) # Plotting using ggplot2
#
# Plot using hyperspec normalized data
plotspc(normalized_spectra_hyperspec) # No difference with the one contains NAs
#
################################# EXPORT SPECTRA DATA INTO DATAFRAME ##############################################################
#
## A. Using specmine
#
# Get the data matrix from the dataset
#
bruker.dm <- get_data(new_spec_read_bruker)
#
# Get the data frame from the dataset
bruker_specm.df <- get_data_as_df(new_spec_read_bruker)
#
# Get metadata from the dataset
bruker.mt <- get_metadata(new_spec_read_bruker)
#
# View the few rows of the data frame
head(new_spec_read_bruker_df, n=6)
#
# After removing NAs (see above) the new data frame could be generated using the imputed data
new_spec_read_bruker_df1 <- get_data_as_df(removed_na_new_spec_read_bruker)
head(new_spec_read_bruker_df1, n=6)
#
## Write new data frame to harddrive as csv file
write.csv("specmine_new_spec_read_bruker_df.csv", new_spec_read_bruker_df1)
#
# Using hyperspec
specmine_hyperspec_df <- as.data.frame(hyperspec_new_spec_read_bruker, row.names = NULL)
#
######################################## END EXPORT SPECTRA DATA INTO DATAFRAME ##################################################
#
################################################# End Specmine ################################################################
#
################################################ 2. HYPERSPEC ###################################################################
#
# Install hypeSpec package from CRAN repository.
#
install.packages("hyperSpec")
#
# load the package into R
library(hyperSpec) 
#
# Create new hyperSpec spectra object using new() function
#
# Using the converted bruker data from specmine
#
spc <- hyperspec_new_spec_read_bruker
spectra <- new ("hyperSpec", spc = spc)
#
## Convert the hyperspec object into a data frame
hyperspec_df <- as.data.frame(spectra, row.names = NULL)
#
## Plot the spectra from the hyperSpec object
plotspc(spectra)
## Plot spectra using ggplot2
#qplotc(spectra)
qplotspc(spectra, mapping = aes_string(x = ".wavelength", y = "spc", group = ".rownames"))
#
##Give summary statistics of the spectra
summary(spectra)
#
####################################################### END HYPERSPEC #########################################################
##
####################################################### 3. BATMAN #############################################################
# BATMAN is very useful as it has a function to directly read data from Bruker TopSpin data. It can convert this data into matrix
# The matrix can be converted into data frame accordingly and which could be used by the package itself or other packages for
# pre-processing tasks.
#
## The key functions are batman() which can directly read the Bruker TopSpin data (zipped or not) from its directory. readBruker()
# and readBrukerZipped() which can directly read TopSpin Data from the directory.
#
## Below is an example of TopSpin demo
#
# Installing package batman
install.packages("batman", repos="http://R-Forge.R-project.org")
library(batman)
#
# Run batman() function which performs metabolite and wavelet fitting to input NMR spectra, plots fitting
# results, posterior distributions for relateive concentrations and peak positions, and saves output. This function automatically 
# look for BrukerDataDir or BrukerDataZipDir which contain the TopSpin data. It automatically creates a folder name "runBATMAN" 
# in specified directory, within which, two folders "BatmanInput" and "BatmanOutput" are created."BatmanInput" contains the input
# data files copied from installed package folder "extdata". The user only needs to modify files in this folder to change the 
# settings for running batman.The batman output files are saved in "BatmanOutput" subfolders.
#
if (interactive())
{
  bm <- batman()
}
#
## The batmanrerun() function performs metabolite and wavelet fitting to input NMR spectra with fixed multiplet position obtained 
# from running batman, and also plots fitting results. The user should modify parameters in the copy file "batmanOptions.txt" 
# in batman output folder to change the rerun settings.
bm_rerun <- batmanrerun(bm)
#
##################################################### Plotting with BATMAN ######################################################
plotBatmanFit(bm) ## This function works and plots the BATMAN fit results, and saves the figure to pdf file in specified directory
plotBatmanFitHR(bm) ## plots a high resolution BATMAN fit results and save figure to pdf file in user specified directory
#
plotBatmanFitStack(bm) #plots the BATMAN fit results in stack, and saves the figure to pdf file in specified directory
#
#
###################################################### Import topspin data #####################################################
#
# Read topspin data using readBrukerZipped() function from batman
#
# This create a large matrix of [ppm, spec1, spec2,..,specN]
brukerdata <- readBrukerZipped("/home/bajuna/rworksgenomics/2018_02_28_Gemma_Batch_Samples.zip")
#

####################################################### End importing data ########################################################
#
################################# EXPORT SPECTRA DATA INTO DATAFRAME ##############################################################
#
# convert the matrix into dataframe for downstream analyses
#
brukerdataframe <- as.data.frame(brukerdata)
head(brukerdataframe[,c(1,2,3,32)])
#
## Write converted data to the disk in form of csv
write.csv(brukerdataframe, "brukerdataframe.csv")
#
## saveBruker2Txt() Save the multiple raw binary Bruker NMR spectra (1D) from a specified folder into ASCII file as a
# matrix with columns:
saveBruker2Txt("/home/bajuna/rworksgenomics/2018_02_28_Gemma_Batch_Samples", saveFileName = "bruker.txt")
#
#################################################### END EXPORT DATA ##############################################################
#
######################################################## END BATMAN ##############################################################
#
################################################## 4. ChemoSpec ##################################################################
## ChemoSpec can deal with many types of spectra data.
## Though it cannot directly import data from Bruker TopSpin.
## Needs extra work around to import data from Bruker TopSpin
## Need first to create spectra object, which can be created using files2SpectraObject() function. This function is fundamentally
# used for data importation. But it cannot import directly Bruker TopSpin data.
## Example below shows the demo of ChemoSpec with Infra Red spectral data.
rm(list=ls())
## Set working directory, maybe where your data files reside, example code in ubuntu
# setwd("/home/your/working/directory")
setwd("/home/bajuna/rworksgenomics/anisha")
install.packages("ChemoSpec")
library(ChemoSpec)
#
#################################################### END CHEMOSPEC #############################################################
##
################################################### 5. MetaboAnalystR #############################################################
# This package contains key InitDataObject() function which handles the construction of a mSetObj object for storing data for further processing
#and analysis. It is necessary to utilize this function to specify to MetaboAnalystR the type of data
#and the type of analysis you will perform.
#
## Setup and installation
#
# This package requires devtools package installed in first place.
devtools::install_github("xia-lab/MetaboAnalystR")
library(devtools)
# Then you can install MetaboAnalystR from the github using the following code
#
metanr_packages <- function(){
  
  metr_pkgs <- c("Rserve", "ellipse", "scatterplot3d", "Cairo", "randomForest", "caTools", "e1071", "som", "impute", "pcaMethods", "RJSONIO", "ROCR", "globaltest", "GlobalAncova", "Rgraphviz", "preprocessCore", "genefilter", "pheatmap", "SSPA", "sva", "Rcpp", "pROC", "data.table", "limma", "car", "fitdistrplus", "lars", "Hmisc", "magrittr", "methods", "xtable", "pls", "caret", "lattice", "igraph", "gplots", "KEGGgraph", "reshape", "RColorBrewer", "tibble", "siggenes")
  
  list_installed <- installed.packages()
  
  new_pkgs <- subset(metr_pkgs, !(metr_pkgs %in% list_installed[, "Package"]))
  
  if(length(new_pkgs)!=0){
    
    source("https://bioconductor.org/biocLite.R")
    biocLite(new_pkgs, dependencies = TRUE, ask = FALSE)
    print(c(new_pkgs, " packages added..."))
  }
  
  if((length(new_pkgs)<1)){
    print("No new packages added...")
  }
}
# Run the function
metanr_packages()
# How to use
library(MetaboAnalystR)
#
######################################################### END METABOANALYSTR #####################################################
#