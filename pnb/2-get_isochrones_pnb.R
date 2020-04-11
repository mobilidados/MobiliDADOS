library(readr)
library(dplyr)
library(opentripplanner)
library(data.table)
library(sf)
library(purrr)
library(beepr)
library(mapview)
library(pblapply)


# define directory
setwd('E:/R/codigos/tt_isochrones-master')
setwd('E:/R/')


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

sort(munis_df$name_muni)

# function to get isocrhones based on distance
# walk speed on meters/second
# dist on meters
get_isochrone <- function(fromPlace, dist, walk_speed = 3.6, ...) {
  
  # convert from meters to sec
  x_speed <- walk_speed/3.6
  x_times <- dist/x_speed
  
  iso <- otp_isochrone(fromPlace = fromPlace,
                       cutoffSec = x_times,
                       walkSpeed = x_speed,
                       ...)
  
  # add distance information to the output
  iso <- iso %>% mutate(distance = dist[length(dist):1])
  
}

# open infra ciclo points
infra_ciclo <- st_read('E:/R/dados/infra_transporte/infra_cicloviaria/2019/pontos/ciclomapa_coords_capitais.shp')

# cut relevant city 
coords<- function(i){
  muni <- read_rds("E:/R/dados/IBGE/br_municipios/capitais_muni.rds")%>%
    st_transform(., 4326) %>% filter(code_muni == i)
  
  coords_infra_ciclo_muni <- st_intersection(infra_ciclo, muni)

  coords_infra_ciclo <- fread("E:/R/dados/infra_transporte/infra_cicloviaria/2019/pontos//ciclomapa_coords_capitais.txt")
  coords_infra_ciclo <- coords_infra_ciclo %>% filter(id_points %in% coords_infra_ciclo_muni$id_points)
  
  return(coords_infra_ciclo)
}
  
coords_infra_ciclo <- coords(5300108)
beep()

# run this to make sure no o'ther instance of otp is running on the background
otp_stop()

# run this and wait until the message "INFO (GrizzlyServer.java:153) Grizzly server running." show up
# may take a few minutes for a big city
i = 5300108
otp_setup(otp = "otp/programs/otp.jar", 
          dir = "otp", router = paste0("", subset(munis_df, code_muni==i)$sigla_muni, ""), 
          port = 8080, wait = FALSE)

# register the router
otp_cid <- otp_connect(router = paste0("", subset(munis_df, code_muni==i)$sigla_muni, ""))

# create lists of coordinates
coords_list <- purrr::map2(as.numeric(coords_infra_ciclo$lat), as.numeric(coords_infra_ciclo$lon), c)

# apply isochrones to list of coordinates
# the function purrr::safely avoids breaking the 'map' function if something goes wrong 
get_isochrone_safe <- purrr::safely(get_isochrone)

buffer <- purrr::map(coords_list, get_isochrone_safe, 
                     dist = c(300),
                     mode = "WALK",
                     otpcon = otp_cid,
                     walk_speed = 3.6)
beep()

# extract the first element (the sf data.frame itself)
buf <- map_depth(buffer, 1, function(x) x[[1]])

# bind output and transform to sf
buf_sf <- rbindlist(buf) %>% st_sf(crs = 4326) %>% 
  mutate(distance = as.character(distance)) %>%
  st_buffer(., 0) %>% st_union()

# if you want to delete the empty polygons (isochrones that weren't calculated)
buf_sf <- buf_sf[!st_is_empty(buf_sf),,drop=FALSE]

mapview(buf_sf)

readr::write_rds(buf_sf, paste0('./output/pnb/2019/', 
                                subset(munis_df, code_muni==i)$name_muni, 
                                '_network_buffer.rds'))
