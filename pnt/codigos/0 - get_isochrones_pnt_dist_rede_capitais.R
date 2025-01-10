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

# Filter only Operational TMA

tma_oprc <- tma_sf_3[tma_sf_3$Description %like% "Operacional",] %>% 
  .[.$Description %like% "Sim",] %>% st_transform(., 4989)


#fazer interseção com os dados de RM

teste <- tma_sf_3 %>%
  dplyr::mutate(Description = gsub('<br><br>', '<br>', Description)) %>%
  # split on <br>
  tidyr::separate(., col = Description, 
                  into = c('Descricao', 'Modo', 'Cidade_n', 'Corredor', 'Segmento','Segregacao', 'Situação', 
                           'Ano', 'RTTMA', 'TMA_Info'), 
                  sep = '<br>') %>%  dplyr::mutate_at(vars(1:14), funs(gsub('^.*: ', '', .)))


#teste[1023,5] <- "Terminal Cecap"
#teste[1023,6] <- "Terminal"
#teste[1023,7] <- "Operacional"
#teste[1023,8] <- 2012
#teste[1023,8] <- "2012"
#teste[1023,9] <- "Sim"
#teste[1023,10] <- "NA"


teste$Ano <- teste$Ano %>% as.numeric()
teste$Descricao <- NULL

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


mun <- 3304557
ano <- 2021

create_real_distance_buffer <- function(mun, ano){
  
otp_stop(FALSE) 

path <- "D:/Projetos/mobilidados/pnb_novo/"
  
otp_setup(otp = paste0(path, "otp/programs/otp.jar"), 
            dir =  paste0(path, "otp/2020"), 
            router = paste0("", subset(munis_df, code_muni==mun)$sigla_muni, ""), 
            port = 8080, wait = FALSE)
  
Sys.sleep(5)

# connect otp to rmrj
otp_rm <- otp_connect(router = paste0("", subset(munis_df, code_muni==mun)$sigla_muni, ""))

Sys.sleep(2)

message('otp - ok')

tma_ciclo_ponts2 <- tma_oprc %>% 
  filter(code_muni == mun) %>% #MUDAR NOME DA CIDADE PARA NUCLEO DA RM
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

write_rds(b_sf, paste0('./output/', ano, '/buffer/rds/capitais/', munis_df[munis_df$code_muni == mun,]$name_muni, '_buffer_', ano, '.rds'))
st_write(b_sf, paste0('./output/', ano, '/buffer/shp/capitais/', munis_df[munis_df$code_muni == mun,]$name_muni, '_buffer_', ano, '.shp'))

write_rds(tma_ciclo_ponts2, paste0('./output/', ano, '/points/rds/capitais/', munis_df[munis_df$code_muni == mun,]$name_muni, '_buffer_', ano,'.rds'))
st_write(tma_ciclo_ponts2, paste0('./output/', ano, '/points/shp/capitais/', munis_df[munis_df$code_muni == mun,]$name_muni, '_buffer_', ano, '.shp'))

Sys.sleep(5)

otp_stop(FALSE)

}

pbmapply(safely(create_real_distance_buffer), munis_df$code_muni, 2022)
