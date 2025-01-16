# Bibliotecas necessárias
library(dplyr)
library(sf)
library(geobr)
library(data.table)
library(mapview)
library(opentripplanner)
library(beepr)
library(pbapply)
library(purrr)
library(readODS)
library(readr)

options(java.parameters = "-Xmx16G")

sf_use_s2(FALSE)

geo_br <- read_municipality() %>% st_transform(., 4989)

# Dados de municípios e regiões metropolitanas
munis_df <- data.frame(code_muni = c(2927408, 3550308, 3304557, 2611606, 2304400, 
                                     5300108, 4106902, 3106200, 1501402, 1100205, 
                                     1200401, 1302603, 1400100, 1600303, 1721000, 
                                     2111300, 2211001, 2408102, 2507507, 2704302, 
                                     2800308, 3205309, 4205407, 4314902, 5002704,
                                     5103403, 5208707),
                       name_muni=c('salvador', 'sao paulo','rio de janeiro', 'recife',
                                   'fortaleza', 'distrito federal', 'curitiba', 
                                   'belo horizonte', 'belem', 'porto velho', 'rio branco', 
                                   'manaus', 'boa vista', 'macapa', 'palmas', 'sao luis',
                                   'teresina', 'natal', 'joao pessoa', 'maceio', 'aracaju', 
                                   'vitoria', 'florianopolis', 'porto alegre', 'campo grande', 
                                   'cuiaba', 'goiania'),
                       abrev_state=c('BA', 'SP', 'RJ', 'PE', 'CE', 'DF', 'PR', 'MG', 'PA', 'RO',
                                     'AC', 'AM', 'RR', 'AP', 'TO', 'MA', 'PI', 'RN', 'PB', 'AL',
                                     'SE', 'ES', 'SC', 'RS', 'MS', 'MT', 'GO'), 
                       espg = c(31984, 31983, 31983, 31985, 31984, 31983, 31982, 31983, 31982, 
                                31980, 31979, 31980, 31980, 31982, 31982, 31983, 31983,
                                31985, 31985, 31985, 31984, 31984, 31982, 31982, 31981,
                                31981, 31982),
                       sigla_muni = c("ssa", "spo", "rio", "rec", "for", "dis", "cur", 
                                      "bho", "bel", "por", "rbr", "man", "boa", "mac", 
                                      "pal", "sls", "ter", "nat", "joa", "mco", "ara", 
                                      "vit", "flo", "poa", "cam", "cui", "goi"))

munis_df_rms <- data.frame(code_muni = c(1501402, 3106200, 4106902, 5300108, 
                                         2304400, 2611606, 3304557, 2927408, 
                                         3550308),
                           name_muni=c("belém", "belo horizonte", "curitiba", 
                                       "distrito federal", "fortaleza", "recife",
                                       "rio de janeiro", "salvador", "sço paulo"),
                           abrev_state=c("PA", "mg", "PR", "df", "CE", 
                                         "PE", "RJ", "BA", "SP"),
                           rms=c("rmb", "rmbh", "rmc", "ride", 
                                 "rmf", "rmr", "rmrj", "rms", "rmsp"),
                           espg = c(31982, 31983, 31982, 31983,
                                    31984, 31985, 31983, 31984, 31983 ),
                           shp = c("RM Belem", "RM Belo Horizonte", "RM Curitiba", 
                                   "RIDE Distrito Federal", "RM Fortaleza", "RM Recife",
                                   "RM_Rio_de_Janeiro", "RM_Salvador", "RM_Sao_Paulo"))

base_rms <- read_ods("./populacao/input/rms_pop.ods") %>% select(NOME_CATMETROPOL, COD_MUN)
base_rms2 <- base_rms %>% mutate(rm = case_when(
  NOME_CATMETROPOL == "Região Metropolitana de Belém" ~ "rmb",
  NOME_CATMETROPOL == "Região Metropolitana de Belo Horizonte" ~ "rmbh",
  NOME_CATMETROPOL == "Região Metropolitana de Curitiba" ~ "rmc",
  NOME_CATMETROPOL == "Região Integrada de Desenvolvimento do Distrito Federal e Entorno" ~ "ride",
  NOME_CATMETROPOL == "Região Metropolitana de Fortaleza" ~ "rmf",
  NOME_CATMETROPOL == "Região Metropolitana do Recife" ~ "rmr",
  NOME_CATMETROPOL == "Região Metropolitana do Rio de Janeiro" ~ "rmrj",
  NOME_CATMETROPOL == "Região Metropolitana de Salvador" ~ "rms",
  NOME_CATMETROPOL == "Região Metropolitana de São Paulo" ~ "rmsp")) 
base_rms2$rm[is.na(base_rms2$rm)] <- "-"

get_isochrone <- function(fromPlace, dist, walk_speed = 3.6, ...) {
  
  # convert to meters to sec
  x_speed <- walk_speed/3.6 # transform walk_speed in km/h to meter per second
  x_times <- dist/x_speed   # time to cover the distance considering the speed defined
  iso <- otp_isochrone(fromPlace = fromPlace, 
                       cutoffSec = x_times, 
                       ...) #
  
  # add distance information to the output
  iso <- iso %>% mutate(distance = dist[length(dist):1])
  
}

# Leitura das camadas geográficas
read_geodata <- function(ano) {
  
  tma_kml <- paste0("./apoio/TMA/TMA_", ano, ".kml")
  camadas <- c("BRT_Estacoes", "Metro_Trem_Barcas_Estacoes", "VLT_Monotrilho_Estacoes")
  tma_sf <- lapply(camadas, function(x) read_sf(tma_kml, layer = x))
  tma_sf <- tryCatch(Reduce('rbind', tma_sf) %>% st_transform(., 4989), error = function(e) NULL)
  tma_sf2 <- st_intersection(tma_sf, geo_br)
  tma_oprc <- tma_sf2[tma_sf2$Description %like% "Operacional",] %>% 
    .[.$Description %like% "Sim",] %>% st_transform(., 4989)
}

 is_rm <- TRUE
 target <- "rmsp"
 ano <- 2024

# Função para criar buffers realistas
create_real_distance_buffer <- function(target, is_rm = FALSE, ano) {
  otp_stop(FALSE)
  
  # Configurações do OTP
  router_name <- if (is_rm) target else subset(munis_df, code_muni == target)$sigla_muni
  otp_setup(
    otp = paste0(getwd(), "/otp/programs/otp.jar"), 
    dir = paste0(getwd(), "/otp/", ano), 
    router = router_name, 
    port = 8080, wait = FALSE
  )
  
  Sys.sleep(5)
  otp_rm <- otp_connect(router = router_name)
  Sys.sleep(2)
  
  # Filtrar dados geográficos
  tma_oprc <- if (is_rm) {
    read_geodata(ano) %>%
      filter(code_muni %in% base_rms2$COD_MUN[base_rms2$rm == target]) %>%
      st_transform(4326)
  } else {
    read_geodata(ano) %>%
      filter(code_muni == target) %>%
      st_transform(4326)
  }
  
  
  # Criar coordenadas
  tma_points <- tma_oprc %>%
    mutate(lat = unlist(map(tma_oprc$geometry, 1)),
           lon = unlist(map(tma_oprc$geometry, 2)),
           id_stop = 1:nrow(tma_oprc))
  
  coords <- purrr::map2(as.numeric(tma_points$lat), as.numeric(tma_points$lon), c)
  
  # Função de buffer segura
  
  
  
  get_isochrone_safe <- purrr::safely(get_isochrone)
  buffer <- purrr::map(coords, get_isochrone_safe, dist = 1000, mode = "WALK", otpcon = otp_rm)
  
  # Consolidação dos resultados
  b <- map_depth(buffer, 1, ~ .x[[1]])
  b_sf <- bind_rows(b) %>% st_sf(crs = 4326)
  
  # if you want to delete the empty polygons (isochrones that weren't calculated)
  b_sf <- b_sf[!st_is_empty(b_sf),,drop=FALSE]
  b_sf <- st_buffer(b_sf, 0) %>% st_union() 
  
  # Diretório de saída
  output_dir <- if (is_rm) "rms" else "capitais"
  router_name <- if(is_rm){
    target } else {
      subset(munis_df, code_muni == target)$name_muni
    }
  
  
  write_rds(b_sf, paste0("./pnt/output/", ano, "/buffer/rds/", output_dir, "/", router_name, "_buffer_", ano, ".rds"))
  st_write(b_sf, paste0("./pnt/output/", ano, "/buffer/shp/", output_dir, "/", router_name, "_buffer_", ano, ".shp"))
  
  write_rds(tma_points, paste0("./pnt/output/", ano, "/points/rds/", output_dir, "/", router_name, "_buffer_", ano, ".rds"))
  st_write(tma_points, paste0("./pnt/output/", ano, "/points/shp/", output_dir, "/", router_name, "_buffer_", ano, ".shp"))
  
  otp_stop(FALSE)
}

# Aplicar para municípios e regiões metropolitanas
pbmapply(safely(create_real_distance_buffer), munis_df$code_muni, MoreArgs = list(is_rm = FALSE, ano = 2020))
pbmapply(safely(create_real_distance_buffer), munis_df_rms$rms, MoreArgs = list(is_rm = TRUE, ano = 2020))











