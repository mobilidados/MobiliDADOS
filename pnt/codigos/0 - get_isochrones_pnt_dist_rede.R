# define directory
setwd('D:/Projetos/mobilidados/pnt_verificação')

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



sf_use_s2(FALSE)

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

base_rms <- read_ods("D:/Projetos/Mobilidados/datasus_verificacao/dados/Composicao_RMs_RIDEs_AglomUrbanas_2020_06_30.ods") %>% select(NOME, COD_MUN)
base_rms2 <- base_rms %>% mutate(rm = case_when(
  NOME == "Região Metropolitana de Belém" ~ "rmb",
  NOME == "Região Metropolitana de Belo Horizonte" ~ "rmbh",
  NOME == "Região Metropolitana de Curitiba" ~ "rmc",
  NOME == "Região Integrada de Desenvolvimento do Distrito Federal e Entorno" ~ "ride",
  NOME == "Região Metropolitana de Fortaleza" ~ "rmf",
  NOME == "Região Metropolitana do Recife" ~ "rmr",
  NOME == "Região Metropolitana do Rio de Janeiro" ~ "rmrj",
  NOME == "Região Metropolitana de Salvador" ~ "rms",
  NOME == "Região Metropolitana de São Paulo" ~ "rmsp")) 
base_rms2$rm[is.na(base_rms2$rm)] <- "-"


# Select only the needed layers

#camadas <- c("BRT_Stations", "Metro_Rail_Ferry_Stations", "Monorail_LRT_Stations")
camadas <- c("BRT_Estacoes", "Metro_Trem_Barcas_Estacoes", "VLT_Monotrilho_Estacoes")

# Download the the brazilian geo features

geo_br <- read_municipality() %>% st_transform(., 4989)

# Read TMA KMZ file 
tma_kml <- "D:/Projetos/Mobilidados/TMA/TMA_2022.kml"
tma_sf <- lapply(camadas, function(x) {
  read_sf(tma_kml, layer = x)
})

tma_sf_2 <- tryCatch(Reduce('rbind', tma_sf) %>% st_transform(., 4989), error=function(e) NULL) 

# Intersect with geo_br in order to manage the features without the necessity to split the main kml column

tma_sf_3 <- st_intersection(tma_sf_2,geo_br)


teste <- tma_sf_3 %>%
  dplyr::mutate(Description = gsub('<br><br>', '<br>', Description)) %>%
  # split on <br>
  tidyr::separate(., col = Description, 
                  into = c('Descricao', 'Modo', 'Cidade_n', 'Corredor', 'Segmento','Segregacao', 'Situação', 
                           'Ano', 'RTTMA', 'TMA_Info'), 
                  sep = '<br>') %>%  dplyr::mutate_at(vars(1:14), funs(gsub('^.*: ', '', .)))

#Foi utilizado para corrigir células defeituosas em ediçães passadas

#teste[1023,5] <- "Terminal Cecap"
#teste[1023,6] <- "Terminal"
#teste[1023,7] <- "Operacional"
#teste[1023,8] <- 2012
#teste[1023,8] <- "2012"
#teste[1023,9] <- "Sim"
#teste[1023,10] <- "NA"


teste$Ano <- teste$Ano %>% as.numeric()

teste$Descricao <- NULL

# Filter only Operational TMA

tma_oprc <- teste[teste$Situação == "Operacional",] %>% 
  .[.$Ano <= 2022,] %>% .[.$RTTMA == "Sim",] %>% st_transform(., 4989)



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

rm <- "rmrj"
ano <- 2022

create_real_distance_buffer <- function(rm, ano){
  
otp_stop(FALSE) 

path <- "D:/Projetos/mobilidados/pnb_novo/"

otp_setup(otp = paste0(path, "otp/programs/otp.jar"), 
          dir =  paste0(path, "otp/2022"), 
          router = paste0("", rm, ""), 
          port = 8080, wait = FALSE)

Sys.sleep(5)

# connect otp to rmrj
otp_rm <- otp_connect(router = paste0("", rm, ""))

Sys.sleep(2)

message('otp - ok')

tma_ciclo_ponts2 <- tma_oprc %>% 
  filter(code_muni %in% base_rms2$COD_MUN[base_rms2$rm == rm]) %>% #MUDAR NOME DA CIDADE PARA NUCLEO DA RM
  st_transform(., 4326)


tma_ciclo_ponts3 <- tma_ciclo_ponts2 %>%
  mutate(lat = unlist(map(tma_ciclo_ponts2$geometry,1)),
         lon = unlist(map(tma_ciclo_ponts2$geometry,2)),
         id_stop = 1:nrow(tma_ciclo_ponts2))

coords_tma_rm <- tma_ciclo_ponts3 
coords_tma_rm <- setDT(tma_ciclo_ponts3)
coords_tma_rm <- coords_tma_rm[, id_stop := 1:.N]
coords_tma_rm <- coords_tma_rm[, .(lat = lat,
                                   lon = lon), 
                               by = id_stop]  


# create lists of coordinates 
coords_list2 <- purrr::map2(as.numeric(coords_tma_rm$lat),as.numeric(coords_tma_rm$lon), c)

message('stations lat lon - ok')

get_isochrone_safe <- purrr::safely(get_isochrone)

# apply isochrones to list of coordinates
buffer <- purrr::map(coords_list2, get_isochrone_safe, 
                 dist = 1000,
                 mode = "WALK",
                 otpcon = otp_rm,
                 walk_speed = 3.6)

message('individual buffer - ok')

Sys.sleep(5)

# extract the first element (the sf data.frame itself)
b <- map_depth(buffer, 1, function(x) x[[1]])

# bind output and transform to sf
b_sf <- bind_rows(b) %>% as_tibble()%>% st_sf(crs = 4326) %>% mutate(distance = as.character(distance))

# if you want to delete the empty polygons (isochrones that weren't calculated)
b_sf <- b_sf[!st_is_empty(b_sf),,drop=FALSE]
b_sf <- st_buffer(b_sf, 0) %>% st_union() 

mapview(b_sf)

write_rds(b_sf, paste0('./output/', ano, '/buffer/rds/rms/', rm, '_buffer_', ano, '.rds'))
st_write(b_sf, paste0('./output/', ano, '/buffer/shp/rms/', rm, '_buffer_', ano, '.shp'))

write_rds(tma_ciclo_ponts2, paste0('./output/', ano, '/points/rds/', rm, '_buffer_', ano,'.rds'))
st_write(tma_ciclo_ponts2, paste0('./output/', ano, '/points/shp/', rm, '_buffer_', ano, '.shp'))

Sys.sleep(5)

otp_stop(FALSE)

}


pbmapply(safely(create_real_distance_buffer), munis_df_rms$rms, 2022)














