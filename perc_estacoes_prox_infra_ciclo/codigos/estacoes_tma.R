library(sf)
library(dplyr)
library(geobr)
library(stringr)
library(data.table)
library(geobr)
library(readr)
library(pbapply)
library(purrr)
library(dplyr)
library(mapview)
library(tidyr)

sf_use_s2(FALSE)

geo_br <- read_municipality() %>% st_transform(., 4989)


# Munis_df Capitais ----
munis_df <- data.frame(code_muni = c(2927408, 3550308, 3304557, 2611606, 
                                     2304400, 5300108, 4106902,
                                     3106200, 1501402, 1100205, 1200401,
                                     1302603, 1400100, 1600303, 1721000, 2111300,
                                     2211001, 2408102, 2507507, 2704302, 2800308,
                                     3205309, 4205407, 4314902, 5002704,
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
                                31981, 31982))


# i <- 3304557
# name_muni <- 'rio de janeiro'

ano <- 2023

# Leitura das camadas geográficas
read_geodata <- function(ano) {
  
  tma_kml <- paste0("./apoio/TMA/TMA_", ano, ".kml")
  camadas <- c("BRT_Estacoes", "Metro_Trem_Barca_Estacoes", "VLT_Monotrilho_Estacoes")
  tma_sf <- lapply(camadas, function(x) read_sf(tma_kml, layer = x))
  tma_sf <- tryCatch(Reduce('rbind', tma_sf) %>% st_transform(., 4989), error = function(e) NULL)
  tma_sf2 <- st_intersection(tma_sf, geo_br)
  tma_oprc <- tma_sf2[tma_sf2$Description %like% "Operacional",] %>% 
    .[.$Description %like% "Sim",] %>% st_transform(., 4989)
}

get_tma_bike <- function(i){
  
  buffer <- read_rds(paste0("./pnb/dados/infra_cicloviaria/pnb/buffer/",ano,"/rds/", 
                            subset(munis_df, code_muni==i)$name_muni,  "_network_buffer.rds")) %>% st_transform(., 4989) 
  
  tma_sf_2 <- read_geodata(ano)
  
  tma_oprc <- tma_sf_2[tma_sf_2$code_muni==i,] 
  
  tma_oprc_2 <- st_intersection(buffer,tma_oprc) %>% st_as_sf()
  
  tma_bike <- data.frame(tma_station = nrow(tma_oprc),
                         tma_near_bike = nrow(tma_oprc_2),
                         perc_tma_bike = round(nrow(tma_oprc_2)/nrow(tma_oprc)*100,0),
                         mun = subset(munis_df, code_muni==i)$name_muni)
  
  return(tma_bike)
}

lista_mun <- munis_df$code_muni

output_list <- do.call("rbind", pblapply(lista_mun, safely(get_tma_bike)))

output_list2 <- output_list[sapply(output_list, function(x) !inherits(x, "error"))] %>% 
  .[sapply(., (function(x) !inherits(x, "NULL")))] 


caps_tma_bike <- Reduce("rbind", output_list2)

caps_tma_bike[is.na(caps_tma_bike$perc_tma_bike),] <- 0

caps_tma_bike <- caps_tma_bike %>% arrange(desc(perc_tma_bike),desc(tma_station))

ordem <- c("belem", "belo horizonte", "distrito federal", "curitiba", "fortaleza", "goiania", "porto alegre",
           "recife", "rio de janeiro", "salvador", "sao paulo", "teresina") 

ordem2 <- c("tma_station", "tma_near_bike", "perc_tma_bike")

caps_tma_bike <- caps_tma_bike %>% filter(tma_station > 0) %>% pivot_longer(!mun, names_to = "indicador", values_to = "resultado")  %>%
  mutate(mun = factor(mun, levels = ordem),
         indicador = factor(indicador, levels = ordem2)) %>% 
  arrange(mun, indicador) 

write.csv2(caps_tma_bike, paste0("./perc_estacoes_prox_infra_ciclo/resultados/",ano, "/caps_tma_bike",ano,".csv"), row.names = FALSE)


get_tma_bike(3304557)











