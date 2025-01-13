# define directory
setwd('E:/R/codigos/tt_isochrones-master')
setwd('/Volumes/Seagate Expansion Drive/R/codigos/tt_isochrones-master')

# install from local machine
library(readr)
library(dplyr)
library(data.table)
library(sf)
library(mapview)
library(beepr)
library(opentripplanner)
library(purrr)

# create the function to get isochrones based on distance
get_isochrone <- function(fromPlace, dist, walk_speed = 3.6, ...) {
  
  # convert to meters to sec
  x_speed <- walk_speed/3.6 # transform walk_speed in km/h to meter per second
  x_times <- dist/x_speed   # time to cover the distance considering the speed defined
  iso <- otp_isochrone(fromPlace = fromPlace, 
                       cutoffSec = x_times,   
                       walkSpeed = x_speed,   
                       ...) #
  
  # add distance information to the output
  iso <- iso %>% mutate(distance = dist[length(dist):1])
  
}

# apply fucntion to rm 
# turn on localhost for rm

otp_stop() #parar OTP antes de rodar para outra RM

i = 'rms'
j = 2019

rm(i)

create_real_distance_buffer <- function(i, j){
  
  otp_setup(otp = "otp/programs/otp.jar", 
            dir = "otp", 
            router = i, 
            port = 8080, 
            wait = FALSE)
  
  # connect otp to rmrj
  otp_rm <- otp_connect(router = i)
  
  message('otp - ok')
  
  #filter and reproject stations
  tma <- st_read('E:/R/dados/infra_transporte/tma/2019/estacoes_2019.shp') %>%
    mutate(Year = as.numeric(as.character(Year))) %>% #transforma a coluna de ano em valor numerico
    filter(Year < (j+1), RT == 'Yes', Status == 'Operational')
  
  unique(tma$City)
  
  tma_rm <- tma %>% 
    filter(City %in% c('Salvador')) %>% #MUDAR NOME DA CIDADE PARA NUCLEO DA RM
    st_transform(., 4326)
  
  message('stations filtered - ok')
  
  #clean lat lon
  coords_tma_rm <- tma_rm %>% 
    select(City, Mode, Station, Year, Y, X)
  
  coords_tma_rm <- setDT(coords_tma_rm)
  coords_tma_rm <- coords_tma_rm[, id_stop := 1:.N]
  coords_tma_rm <- coords_tma_rm[, .(lat = Y,
                                     lon = X), 
                                 by = id_stop]
  
  # transform to sf (not really necessary to calculate isocrhone, just for test viz)
  coords_tma_rm_sf <- st_as_sf(coords_tma_rm, coords = c("lon", "lat"), crs = 4326)
  mapview::mapview(coords_tma_rm_sf)
  
  # create lists of coordinates 
  coords_list <- purrr::map2(as.numeric(coords_tma_rm$lon), as.numeric(coords_tma_rm$lat), c)
  
  message('stations lat lon - ok')
  
  get_isochrone_safe <- purrr::safely(get_isochrone)
  
  # apply isochrones to list of coordinates
  buffer <- lapply(coords_list, get_isochrone_safe, 
                   dist = 1000,
                   mode = "WALK",
                   otpcon = otp_rm,
                   walk_speed = 3.6)
  
  message('individual buffer - ok')
  
  
  # extract the first element (the sf data.frame itself)
  b <- map_depth(buffer, 1, function(x) x[[1]])
  
  # bind output and transform to sf
  b_sf <- bind_rows(b) %>% as_tibble()%>% st_sf(crs = 4326) %>% mutate(distance = as.character(distance))
  
  # if you want to delete the empty polygons (isochrones that weren't calculated)
  b_sf <- b_sf[!st_is_empty(b_sf),,drop=FALSE]
  b_sf <- st_buffer(b_sf, 0) %>% st_union() 
  
  mapview(b_sf)
  
  write_rds(b_sf, paste0('./output/pnt/', i, '_buffer_', j, '.rds'))
  
  mapview(buffer_sf)+mapview(coords_tma_rm_sf)
  
  beep()
}


create_real_distance_buffer('rms', 2019)
