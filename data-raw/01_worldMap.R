library(sf)
library(pryr)
library(dplyr)
library(countrycode)
## prepare worldMap
# download shapefile. levels are separated and we need 0 for countries
# download.file("https://biogeo.ucdavis.edu/data/gadm3.6/gadm36_levels_shp.zip",
              destfile = "data-raw/world/gadm36_levels_shp.zip") # beware timeout
# unzip("data-raw/gadm36_levels_shp.zip", exdir = "data-raw/world")

# read, check size in disk and simplify first!
world_original <- st_read("data-raw/world/gadm36_0.shp")
world_original
pryr::object_size(world_original) #552!
world <- st_simplify(world_original, dTolerance = 0.01, preserveTopology = TRUE)
pryr::object_size(world) # 46.4


# correct names
world$NAME_0 <- tolower(textclean::replace_non_ascii(world$NAME_0))
worldMap <- world
usethis::use_data(worldMap, internal = F, compress = "xz", overwrite = T)

