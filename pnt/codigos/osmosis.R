remotes::install_github("MatthewJWhittle/spatialutils")
library(sf)
library(spatialutils)
library(dplyr)
library(tidyr)
library(purrr)
library(osmdata)

q <- opq("hampi india")
q <- add_osm_feature (q, key="historic", value="ruins")
osmdata_xml (q, filename="hampi.osm")

getwd()


osmdata_xml(q = x, "data.osm")


split_bbox(-47.208,-24.064,-45.6948,-23.183)

tile_bbox('-47.208,-24.064,-45.6948,-23.183')


sf::st_bbox('-47.208,-24.064,-45.6948,-23.183')


bb <- st_bbox(c(xmin = -47.208, xmax = -24.064, ymax = -45.6948, ymin = -23.183), crs = st_crs(4326))
tile_bbox(bb, 4326, 4)

-47.208,-24.064,-45.694814,-23.183

x <- seq(1:2)
df <- data.frame(x)
xFactor <- (-45.694814 -47.208)/length(x)
yFactor <- (-23.183 - 24.064)/length(x)
df$xCH <- df$x*xFactor - 47.808453
df$yCH <- df$x*yFactor - 24.064

split_bbox <- function(bbox, n_x = 2, n_y = 2) {
  # Assert that bbox is a bounding box
  stopifnot(class(bbox) %in% "bbox")
  
  # Get the length of the x axis
  x_ext <- bbox["xmax"] - bbox["xmin"]
  # Get the length of the y axis
  y_ext <- bbox["ymax"] - bbox["ymin"]
  
  incr_x <- x_ext / n_x
  incr_y <- y_ext / n_y
  
  # Create a sequence of x and y coordinates to generate the xmins and ymins
  xmin <- seq(from = bbox["xmin"], to = bbox["xmax"], by = incr_x)
  ymin <- seq(from = bbox["ymin"], to = bbox["ymax"], by = incr_y)
  
  # Remove the last element of x and y to ensure that the
  # top right corner isnt create an xmin or ymin
  xmin <- xmin[1:length(xmin) - 1]
  ymin <- ymin[1:length(ymin) - 1]
  
  bbox_table <-
    expand_grid(xmin, ymin) %>%
    mutate(xmax = xmin + incr_x,
           ymax = ymin + incr_y)
  
  bounding_boxes <-
    transpose(bbox_table) %>% map( ~ .x %>%
                                     unlist %>% st_bbox(crs = st_crs(bbox)$epsg))
  
  return(bounding_boxes)
}

-47.208,-24.064,-45.694,-23.623
-47.208,-23.623,-45.694,-23.183

Tem que fazer com a porra do osmosis

C:\>osmosis --rb malha_viaria_rmsp1.osm.pbf --rb malha_viaria_rmsp2.osm.pbf --merge --wb merged.osm.pbf