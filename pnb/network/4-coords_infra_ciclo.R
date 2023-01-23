# O Script importa o arquivo de todas as capitais filtradas e quebra as linhas da infra em pontos para georreferenciá-los


# Carrega os pacotes necess?rios

library(sf)
library(data.table)
library(dplyr)
library(stringr)
library(mapview)
library(purrr)
library(readr)

# Seleciona a pasta de trabalho

setwd('D:/Projetos/mobilidados/pnb_novo')

# Define o ano de refer?ncia

ano <- 2022

# Importa o arquivo filtrado

infra_ciclo <- read_rds(paste0("./dados/infra_cicloviaria/geofabrik_filtrado/",ano,"/rds","/geofabrik_capitais_filtrado.rds")) %>%
  st_transform(., 4326)

# Quebra a infraestrutura em pontos, com diferença de 5 metros entre si

infra_ciclo_ponts <- st_segmentize(infra_ciclo, 5) %>% st_cast(.,"POINT")

# Transforma geometry em lat e long

infra_ciclo_ponts <- infra_ciclo_ponts %>%
  mutate(lat = unlist(map(infra_ciclo_ponts$geometry,1)),
         lon = unlist(map(infra_ciclo_ponts$geometry,2)))

infra_ciclo_ponts$id_points <- 1:nrow(infra_ciclo_ponts)

infra_ciclo_ponts <- infra_ciclo_ponts %>% as.data.frame() %>% select(id_points, lat, lon) 

# Transformn the dataframe in sf
coords_infra_ciclo_sf <- st_as_sf(infra_ciclo_ponts, coords = c("lat", "lon"), crs = 4326)

# Salvando o arquivo em dois formatos para futura importação na próxima etapa

st_write(coords_infra_ciclo_sf, paste0('./dados/infra_cicloviaria/geofabrik_pontos/',ano,'/geofabrik_coords_capitais.shp'), append = TRUE)
fwrite(infra_ciclo_ponts, file = paste0('./dados/infra_cicloviaria/geofabrik_pontos/',ano,'/geofabrik_coords_capitais.txt'))

