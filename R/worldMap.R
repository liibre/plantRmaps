#' Simplified world data
#'
#' Simple feature collection with 256 features and 2 fields, corresponding to
#' GADM countries, downloaded from
#' "https://biogeo.ucdavis.edu/data/gadm3.6/gadm36_levels_shp.zip", simplified
#' using sf::st_simplify with a tolerance of 0.01. Country names have been
#' transformed to lower case and non-ascii characters.
#'
#' Simple feature collection with 256 features and 2 fields
#' \describe{
#'   \item{GID_0}{The ISO code of the country}
#'   \item{NAME_0}{The name of the country (lower case, non-ascii removed)}
#'   }
#'
#' @source \url{https://biogeo.ucdavis.edu/data/gadm3.6/gadm36_levels_shp.zip}
"worldMap"
