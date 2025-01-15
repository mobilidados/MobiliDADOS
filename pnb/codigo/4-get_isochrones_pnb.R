library(readr)
library(dplyr)
library(opentripplanner)
library(data.table)
library(sf)
library(purrr)
library(beepr)
library(mapview)
library(pbapply)
library(devtools)
library(geobr)
library(tictoc)

sf_use_s2(FALSE)

# DataFrame de municípios
munis_df <- data.frame(
  code_muni = c(2927408, 3550308, 3304557, 2611606, 2304400, 5300108, 4106902, 3106200, 1501402, 1100205, 
                1200401, 1302603, 1400100, 1600303, 1721000, 2111300, 2211001, 2408102, 2507507, 2704302, 
                2800308, 3205309, 4205407, 4314902, 5002704, 5103403, 5208707),
  name_muni = c('salvador', 'sao paulo', 'rio de janeiro', 'recife', 'fortaleza', 'distrito federal', 'curitiba', 
                'belo horizonte', 'belem', 'porto velho', 'rio branco', 'manaus', 'boa vista', 'macapa', 'palmas', 
                'sao luis', 'teresina', 'natal', 'joao pessoa', 'maceio', 'aracaju', 'vitoria', 'florianopolis', 
                'porto alegre', 'campo grande', 'cuiaba', 'goiania'),
  abrev_state = c('BA', 'SP', 'RJ', 'PE', 'CE', 'DF', 'PR', 'MG', 'PA', 'RO', 'AC', 'AM', 'RR', 'AP', 'TO', 'MA', 
                  'PI', 'RN', 'PB', 'AL', 'SE', 'ES', 'SC', 'RS', 'MS', 'MT', 'GO'), 
  espg = c(31984, 31983, 31983, 31985, 31984, 31983, 31982, 31983, 31982, 31980, 31979, 31980, 31980, 31982, 
           31982, 31983, 31983, 31985, 31985, 31985, 31984, 31984, 31982, 31982, 31981, 31981, 31982),
  sigla_muni = c("ssa", "spo", "rio", "rec", "for", "dis", "cur", "bho", "bel", "por", "rbr", "man", "boa", "mac", 
                 "pal", "sls", "ter", "nat", "joa", "mco", "ara", "vit", "flo", "poa", "cam", "cui", "goi"))

# Define o ano de referência
ano <- 2023

# Caminho para o arquivo java a ser carregado pelo opt
path_otp <- "./otp/programs/otp.jar"

# Caminho para o diretório com as pastas preparadas com as malhas viárias dentro
dir <- paste0("./otp/", ano)

# Função para processar dados de infraestrutura cicloviária e gerar isócronas
processa_municipio <- function(caminho_base, nome_subpasta, mun) {
  # Importa o arquivo de infraestrutura cicloviária existente
  infra_ciclo_existente <- st_read(paste0(caminho_base, nome_subpasta, "/geofabrik_pontos/", ano, "/geofabrik_coords_capitais.shp")) %>% 
    st_make_valid()
  
  # Carrega a base de camadas dos municípios brasileiros
  muni <- read_municipality()
  
  # Define a função para obter isócronas
  get_isochrone <- function(fromPlace, dist, walk_speed = 3.6, ...) {
    x_speed <- walk_speed / 3.6
    x_times <- dist / x_speed
    iso <- otp_isochrone(fromPlace = fromPlace, cutoffSec = x_times, ...)
    iso <- iso %>% mutate(distance = dist[length(dist):1])
  }
  
  # Função para obter coordenadas do município
  coords <- function(mun) {
    muni <- muni %>% st_transform(4326) %>% filter(code_muni == mun)
    coords_infra_ciclo_muni <- st_intersection(infra_ciclo_existente, muni)
    coords_infra_ciclo <- fread(paste0(caminho_base, nome_subpasta, "/geofabrik_pontos/", ano, "/geofabrik_coords_capitais.txt"))
    coords_infra_ciclo <- coords_infra_ciclo %>% filter(id_points %in% coords_infra_ciclo_muni$id_points)
    return(coords_infra_ciclo)
  }
  
  # Obtém as coordenadas do município
  coords_infra_ciclo <- coords(mun)
  
  # Para outras instâncias do otp
  otp_stop(FALSE)
  Sys.sleep(10)
  
  # Monta a aplicação
  otp_setup(otp = path_otp, dir = dir, router = paste0("", subset(munis_df, code_muni == mun)$sigla_muni, ""), port = 8080, wait = FALSE)
  Sys.sleep(5)
  
  # Registra o roteador
  otp_cid <- otp_connect(router = paste0("", subset(munis_df, code_muni == mun)$sigla_muni, ""))
  
  # Cria lista de coordenadas
  coords_list <- purrr::map2(as.numeric(coords_infra_ciclo$lat), as.numeric(coords_infra_ciclo$lon), c)
  
  # Aplica isócronas à lista de coordenadas
  get_isochrone_safe <- purrr::safely(get_isochrone)
  tic()
  buffer <- purrr::map(coords_list, get_isochrone_safe, dist = c(300), mode = "WALK", otpcon = otp_cid, walk_speed = 3.6)
  toc()
  Sys.sleep(3)
  
  # Extrai o primeiro elemento (data.frame sf)
  buf <- map_depth(buffer, 1, function(x) x[[1]][1])
  buf_sf <- rbindlist(buf) %>% st_sf(crs = 4326) %>% st_buffer(0) %>% st_union()
  buf_sf <<- buf_sf[!st_is_empty(buf_sf), drop = FALSE]
  mapview(buf_sf)
  
  # Salva em dois formatos diferentes
  readr::write_rds(buf_sf, paste0(caminho_base, nome_subpasta, "/buffer/", ano, "/rds/", subset(munis_df, code_muni == mun)$name_muni, '_network_buffer.rds'))
  st_write(buf_sf, paste0(caminho_base, nome_subpasta, "/buffer/", ano, "/shp/", subset(munis_df, code_muni == mun)$name_muni, '_network_buffer.shp'), append = FALSE)
  Sys.sleep(10)
}

# Função para processar todos os municípios
processa_todos_municipios <- function() {
  lista <- munis_df$code_muni
  pblapply(lista, safely(function(mun) {
    processa_municipio('./pnb/dados/infra_cicloviaria/', 'pnb', mun)
    processa_municipio('./pnb/dados/infra_cicloviaria/', 'pnpb', mun)
  }))
}

# Processa todos os municípios
processa_todos_municipios()
beep(3)




 # lista_arquivos <- list.files("./dados/infra_transporte/infra_cicloviaria/2020/buffer/rds", pattern='*\\.rds', full.names = TRUE)

# teste <- do.call("st_union", lapply(lista_arquivos,read_rds))

# st_write(teste, "teste.shp")
