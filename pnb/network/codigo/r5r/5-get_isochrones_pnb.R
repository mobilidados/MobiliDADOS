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

# define directory

setwd('D:/Projetos/mobilidados/pnb_novo')
sf_use_s2(FALSE)


#munis_df
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


# ano <- 2022

# Caminho para o arquivo java a ser carregado pelo opt

path_otp <- "./otp/programs/otp.jar"

# Caminho para o diretório com as pastas preparadas com as malhas viárias dentro

dir <- paste0("./otp/",ano)

# open infra ciclo points

infra_ciclo_existente <- st_read(paste0("dados/infra_cicloviaria/geofabrik_pontos/", ano, "/geofabrik_coords_capitais.shp")) %>% st_make_valid() # o make valid é importante, pois do contrário as feições podem conter problemas.

# Carrega a base de camadas dos municípios brasileiros

muni <- read_municipality()

# mun <- munis_df$code_muni[1]

get_iso <- function(mun){

  # function to get isocrhones based on distance
  # walk speed on meters/second
  # dist on meters  

get_isochrone <- function(fromPlace, dist, walk_speed = 3.6, ...) {
    
    # convert from meters to sec
    x_speed <- walk_speed/3.6
    x_times <- dist/x_speed
    
    iso <- otp_isochrone(fromPlace = fromPlace,
                         cutoffSec = x_times,
                         ...)
    
    # add distance information to the output
    iso <- iso %>% mutate(distance = dist[length(dist):1])
    
}

# cut relevant city 
coords<- function(mun){
  muni <- muni%>%
    st_transform(., 4326) %>% filter(code_muni == mun)
  
  coords_infra_ciclo_muni <- st_intersection(infra_ciclo_existente, muni)

  coords_infra_ciclo <- fread(paste0("./dados/infra_cicloviaria/geofabrik_pontos/", ano, "/geofabrik_coords_capitais.txt"))
  coords_infra_ciclo <- coords_infra_ciclo %>% filter(id_points %in% coords_infra_ciclo_muni$id_points)
  
}

# Retira as coordenadas
 
coords_infra_ciclo <- coords(mun)

# run this to make sure no other instance of otp is running on the background
otp_stop(FALSE)

Sys.sleep(10) # sistema dorme por seguran?a durante 10 segundos. Do contr?rio trava. 

# Monta a aplicação

otp_setup(otp = path_otp, 
          dir = dir, router = paste0("", subset(munis_df, code_muni==mun)$sigla_muni, ""), 
          port = 8080, wait = FALSE)

# delay between two instructions
Sys.sleep(5)

# register the router
otp_cid <- otp_connect(router = paste0("", subset(munis_df, code_muni==mun)$sigla_muni, ""))

# create lists of coordinates
coords_list <- purrr::map2(as.numeric(coords_infra_ciclo$lat), as.numeric(coords_infra_ciclo$lon), c)

# apply isochrones to list of coordinates
# the function purrr::safely avoids breaking the 'map' function if something goes wrong 

get_isochrone_safe <- purrr::safely(get_isochrone)

tic()

buffer <- purrr::map(coords_list, get_isochrone_safe, 
                     dist = c(300),
                     mode = "WALK",
                     otpcon = otp_cid,
                     walk_speed = 3.6)

toc()

Sys.sleep(3)

# extract the first element (the sf data.frame itself)
buf <- map_depth(buffer, 1, function(x) x[[1]][1])

# bind output and transform to sf
buf_sf <- rbindlist(buf) %>% st_sf(crs = 4326)  %>% st_buffer(0) %>% st_union()


# if you want to delete the empty polygons (isochrones that weren't calculated)
buf_sf <<- buf_sf[!st_is_empty(buf_sf),drop=FALSE]


# Salva em dois formatos diferentes por seguran?a

readr::write_rds(buf_sf, paste0('./dados/infra_cicloviaria/buffer/',ano,'/rds/', 
                                subset(munis_df, code_muni==mun)$name_muni, 
                                '_network_buffer.rds'))

st_write(buf_sf, paste0('./dados/infra_cicloviaria/buffer/',ano,'/shp/', 
                        subset(munis_df, code_muni==mun)$name_muni, 
                        '_network_buffer.shp'), append = TRUE)

Sys.sleep(10) # Pode ser importante para não travar a aplicação

}

# Carrega a lista de municípios

lista <- munis_df$code_muni

pblapply(lista, safely(get_iso)) # Roda o dado

beep(3) # Avisa que acabou




 # lista_arquivos <- list.files("./dados/infra_transporte/infra_cicloviaria/2020/buffer/rds", pattern='*\\.rds', full.names = TRUE)

# teste <- do.call("st_union", lapply(lista_arquivos,read_rds))

# st_write(teste, "teste.shp")

