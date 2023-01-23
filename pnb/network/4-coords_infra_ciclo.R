library(sf)
library(data.table)
library(dplyr)
library(mapview)

# coords infraestrutura cicloviaria
# open and reproject infra_ciclo
infra_ciclo <- st_read('./dados/infra_transporte/infra_cicloviaria/2019/pontos/ciclomapa_capitais_filtrado_pontos.shp')%>%
  st_transform(., 4326)


#clean lat lon
coords_infra_ciclo <- setDT(infra_ciclo)
coords_infra_ciclo <- coords_infra_ciclo[, id_points := 1:.N]
coords_infra_ciclo <- coords_infra_ciclo %>% select(id_points, geometry)

# delete commas
coords_infra_ciclo <- coords_infra_ciclo[, geometry := ifelse(id_points == nrow(coords_infra_ciclo), 
                                                              geometry, 
                                                              stringr::str_sub(geometry, start = 2, end = -1))]
# delete ()
coords_infra_ciclo <- coords_infra_ciclo[, geometry := gsub("\\(|\\)", "", geometry)]

# extract coords
coords_infra_ciclo <- tidyr::separate(coords_infra_ciclo, geometry, c("lat", "lon"), sep = ", ") # remove ","
coords_infra_ciclo <- coords_infra_ciclo %>% 
  mutate(lat = ifelse(lat == "c-40.3503139437859", "-40.3503139437859", lat))

head(coords_infra_ciclo)

coords_infra_ciclo_sf <- st_as_sf(coords_infra_ciclo, coords = c("lat", "lon"), crs = 4326)
st_write(coords_infra_ciclo_sf, './dados/infra_transporte/infra_cicloviaria/2019/pontos/ciclomapa_coords_capitais.shp')
fwrite(coords_infra_ciclo, file = "E:/R/dados/infra_transporte/infra_cicloviaria/2019/pontos//ciclomapa_coords_capitais.txt",
       sep = ",")
