###############################################################
## DATA GATHERING AND CLEANING: OCCURRENCE POINTS AND RANGES ##
###############################################################

#### Load libraries ####
library(rgbif)
library(CoordinateCleaner)
library(redlistr)
library(sf)
library(tidyverse)

#### General parameters ####
sf_use_s2(FALSE)
# usethis::edit_r_environ("project")

#### Download taxonomy from GBIF and IUCN ####
taxonKeys <- c(
  # "Amphibia" = 131,
  # "Aves" = 212,
  # "Reptilia" = 358,
  # "Mammalia" = 359
  732, 792 #"Carnivora"
)
taxGBIF <- occ_download(
  pred_and(
    pred_in("taxonKey", taxonKeys),
    pred("hasCoordinate", TRUE)
  ),
  format = 'SIMPLE_CSV'
)

if(!dir.exists('inputs/gbif')) dir.create('inputs/gbif', recursive = TRUE)

status = occ_download_meta(taxGBIF)$status
count = 1
while(status != 'SUCCEEDED' | count > 20){
  Sys.sleep(120)
  status = occ_download_meta(taxGBIF)$status
  count = count + 1
}

x <- occ_download_get(taxGBIF, path = 'inputs/gbif', overwrite =FALSE)

x <- as.download("inputs/gbif/0021573-220831081235567.zip")
occs <- occ_download_import(x)
colnames(occs) <- tolower(colnames(occs))


occs_clean <- CoordinateCleaner::clean_coordinates(occs)
