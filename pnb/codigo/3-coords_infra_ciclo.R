# Carrega os pacotes necessários
library(sf)
library(data.table)
library(dplyr)
library(stringr)
library(mapview)
library(purrr)
library(readr)

# Define o ano de referência
ano <- 2024

# Função para processar dados de infraestrutura cicloviária
processa_infra_ciclo <- function(caminho_base, nome_subpasta) {
  # Importa o arquivo filtrado
  infra_ciclo <- read_rds(paste0(caminho_base, nome_subpasta, "/geofabrik_filtrado/", ano, "/rds/geofabrik_capitais_filtrado.rds")) %>%
    st_transform(4326)
  
  # Quebra a infraestrutura em pontos, com diferença de 20 metros entre si
  infra_ciclo_pontos <- st_segmentize(infra_ciclo, 20) %>% st_cast("POINT")
  
  # Transforma geometry em lat e lon
  infra_ciclo_pontos <- infra_ciclo_pontos %>%
    mutate(lat = unlist(map(geometry, 1)),
           lon = unlist(map(geometry, 2)))
  
  infra_ciclo_pontos$id_points <- 1:nrow(infra_ciclo_pontos)
  infra_ciclo_pontos <- infra_ciclo_pontos %>% as.data.frame() %>% select(id_points, lat, lon)
  
  # Transforma o dataframe em sf
  coords_infra_ciclo_sf <- st_as_sf(infra_ciclo_pontos, coords = c("lat", "lon"), crs = 4326)
  
  # Salvando o arquivo em dois formatos para futura importação na próxima etapa
  st_write(coords_infra_ciclo_sf, paste0(caminho_base, nome_subpasta, "/geofabrik_pontos/", ano, "/geofabrik_coords_capitais.shp"), append = FALSE)
  fwrite(infra_ciclo_pontos, file = paste0(caminho_base, nome_subpasta, "/geofabrik_pontos/", ano, "/geofabrik_coords_capitais.txt"))
}

# Processa os dados para pnb e pnpb
processa_infra_ciclo('./pnb/dados/infra_cicloviaria/', 'pnb')
processa_infra_ciclo('./pnb/dados/infra_cicloviaria/', 'pnpb')
