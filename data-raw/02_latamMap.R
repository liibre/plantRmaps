# loads packages

# remotes::install_github("liibre/Rocc")
library(Rocc)
library(spData)
library(dplyr)
library(rworldmap)
library(purrr)

# first we need a standard country list to get the codes

latam <- spData::world %>%
  filter(region_un %in% c("Americas", "Seven seas (open ocean)")) %>%
  filter(subregion != "Northern America") %>%
  pull(name_long)
#too short

sort(latam)

# we add by hand for now the rest of the caribbean islands #not proud
other_caribbean <-
  c("Anguilla",
    "Antigua and Barbuda",
    "Aruba",
    "Barbados",
    "Bermuda",
    "British Virgin Islands",
    "Caribbean Netherlands",
    "Cayman Islands",
    "Curaçao",
    "Dominica",
    "French Guiana",
    "Grenada",
    "Guadeloupe",
    "Martinique",
    "Montserrat",
    "Saint Barthélemy",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Martin (French part)",
    "Saint Vincent and the Grenadines",
    "Sint Maarten",
    "Turks and Caicos Islands",
    "United States Virgin Islands")

# we need a source for this list. I tried wikipedia and other R packages. for now by hand u_U

lac_countries <- c(latam, other_caribbean)

# get iso codes to download
isocodes <- countrycode::countrycode(lac_countries,
                                     "country.name",
                                     "iso3c")

# downloads GADM shapefiles per country using Rocc to get the best resolution #proud
destfolder <- "data-raw/latam"
if (!exists(destfolder))
  dir.create(destfolder, recursive = T)

purrr::walk2(.x = rep(iso3, each = 4),
             .y = rep(3:0, length(countries.latam)),
             ~ getGADM(cod = .x,
                       level = .y,
                       best = TRUE, # we need the best only for now
                       destfolder = destfolder))
gadm_files <- list.files(destfolder, pattern = "rds$",
                                      full.names = TRUE)
# read everything
gadm_tudo <- purrr::map(gadm_files, ~readRDS(.))

#we need to set CRS because we lost it This must be something else because set_crs is not working. Check! ö
gadm_crs <- purrr::map(gadm_tudo, ~sf::st_set_crs(.x, prj))


# formats columns that begin with NAME

# function that formats and selects the columns
rename_cols <- function(sf, var) {
  sf %>% mutate(across(starts_with({{var}}),
                      .fns = function(x) tolower(textclean::replace_non_ascii(x)))) %>%
    select(starts_with({{var}}))
}

# applies the function to the list of shapes
latam_tudo <- purrr::map(gadm_crs, ~rename_cols(.x, "NAME"))
# trop cool


pryr::object_size(latam_tudo) #202MB! but i think i love this object maybe the user should have it.


# Symplifying the maps
 latam_simplified <- purrr::map(latam_tudo,
                                ~st_simplify(.x,
                                             dTolerance = 0.01,
                                             preserveTopology = TRUE))
pryr::object_size(latam_simplified)

latamMap <- latam_simplified

usethis::use_data(latamMap, internal = F, compress = "xz")
