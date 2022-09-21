###############################################################
## DATA GATHERING AND CLEANING: OCCURRENCE POINTS AND RANGES ##
###############################################################

#### Load libraries ####
library(rgbif)
library(CoordinateCleaner)
library(redlistr)
library(sf)

#### General parameters ####
sf_use_s2(FALSE)
# usethis::edit_r_environ("project")

#### Download taxonomy from GBIF and IUCN ####
taxonKeys <- c(
  # "Amphibia" = 131,
  # "Aves" = 212,
  # "Reptilia" = 358,
  "Mammalia" = 359
)
taxGBIF <- occ_download(
  pred_and(
    pred_in("taxonKey", taxonKeys),
    pred("hasCoordinate", TRUE)
  ),
  format = 'SIMPLE_CSV'
)

if(!dir.exists('inputs/gbif')) dir.create('inputs/gbif', recursive = TRUE)

occ_download_get(taxGBIF, path = 'inputs/gbif/')
