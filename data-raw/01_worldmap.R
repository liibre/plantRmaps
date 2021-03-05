library(sf)

## prepare worldMap

download.file("https://biogeo.ucdavis.edu/data/gadm3.6/gadm36_shp.zip",
              destfile = "data-raw/gadm36_shp.zip")
unzip("data-raw/gadm36_shp.zip", exdir = "data-raw")

world <- st_read("data-raw/gadm36.shp")
