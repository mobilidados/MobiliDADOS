# define directory
setwd('F:/Projetos/mobilidados/pnt_verificação')

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

camadas_2019 <- c("BRT_Stations", "Metro_Rail_Ferry_Stations", "Monorail_LRT_Stations")


# Download the the brazilian geo features

geo_br <- read_municipality() %>% st_transform(., 4989)

# Read TMA KMZ file 
tma_kml <- "F:/Projetos/Mobilidados/TMA/TMA_2019.kml"
tma_sf <- lapply(camadas_2019, function(x) {
  read_sf(tma_kml, layer = x)
})

tma_sf_2 <- tryCatch(Reduce('rbind', tma_sf) %>% st_transform(., 4989), error=function(e) NULL) 

# Intersect with geo_br in order to manage the features without the necessity to split the main kml column

tma_sf_3 <- st_intersection(tma_sf_2,geo_br)

# Filter only Operational TMA

tma_oprc_2019 <- tma_sf_3[tma_sf_3$Description %like% "Operational",] %>% 
  .[.$Description %like% "Yes",] %>% st_transform(., 4989)


camadas_2020 <- c("BRT_Estacoes", "Metro_Trem_Barcas_Estacoes", "VLT_Monotrilho_Estacoes")

# Download the the brazilian geo features

geo_br <- read_municipality() %>% st_transform(., 4989)

# Read TMA KMZ file 
tma_kml <- "F:/Projetos/Mobilidados/TMA/TMA_2020.kml"
tma_sf <- lapply(camadas_2020, function(x) {
  read_sf(tma_kml, layer = x)
})

tma_sf_2 <- tryCatch(Reduce('rbind', tma_sf) %>% st_transform(., 4989), error=function(e) NULL) 

# Intersect with geo_br in order to manage the features without the necessity to split the main kml column

tma_sf_3 <- st_intersection(tma_sf_2,geo_br)

# Filter only Operational TMA


tma_oprc_2020 <- tma_sf_3[tma_sf_3$Description %like% "Operacional",] %>% 
  .[.$Description %like% "Sim",] %>% st_transform(., 4989)


tma_2019 <- tma_oprc_2019$name_muni %>% table() %>% as.data.frame() %>% arrange(desc(Freq))

tma_2020 <- tma_oprc_2020$name_muni %>% table() %>% as.data.frame() %>% arrange(desc(Freq))





left_join(tma_2020, tma_2019, c("." = ".")) %>% 
  replace_na(list(Freq.x = 0, Freq.y = 0)) %>% 
  mutate(diferenca = Freq.x - Freq.y) %>% subset(diferenca != 0) %>% arrange(desc(diferenca))

tma_2019_export <- left_join(subset(tma_desagregado_2019[tma_desagregado_2019$RTTMA == "Yes",], name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")),
                      subset(as_data_frame(tma_desagregado_2020[tma_desagregado_2020$RTTMA == "Sim",]), name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")), c("Segmento" = "Segmento"))


tma_2020_export <- left_join(subset(as_data_frame(tma_desagregado_2020[tma_desagregado_2020$RTTMA == "Sim",]), name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")),
                      subset(tma_desagregado_2019[tma_desagregado_2019$RTTMA == "Yes",], name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")), c("Segmento" = "Segmento"))


tma_desagregado_2019 <- tma_sf_3 %>% subset(name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")) %>%
  dplyr::mutate(Description = gsub('<br><br>', '<br>', Description)) %>%
  # split on <br>
  tidyr::separate(., col = Description, 
                  into = c('Modo', 'Cidade_n', 'Corredor', 'Segmento','Segregacao', 'Situação', 
                           'Ano', 'RTTMA', 'TMA_Info'), 
                  sep = '<br>') %>%  dplyr::mutate_at(vars(1:14), funs(gsub('^.*: ', '', .)))


tma_desagregado_2020 <- tma_sf_3 %>% subset(name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")) %>%
  dplyr::mutate(Description = gsub('<br><br>', '<br>', Description)) %>%
  # split on <br>
  tidyr::separate(., col = Description, 
                  into = c('Modo', 'Cidade_n', 'Corredor', 'Segmento','Segregacao', 'Situação', 
                           'Ano', 'RTTMA', 'TMA_Info'), 
                  sep = '<br>') %>%  dplyr::mutate_at(vars(1:14), funs(gsub('^.*: ', '', .)))


write.csv2(tma_desagregado_2019, "./resultados/0_comparacao_anual/tma_desagregado_2019.csv", row.names = FALSE)
write.csv2(tma_desagregado_2020, "./resultados/0_comparacao_anual/tma_desagregado_2020.csv", row.names = FALSE)

xxx <- subset(tma_desagregado_2019[tma_desagregado_2019$RTTMA == "Yes",], 
       name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")) %>% mutate(novo = paste(Cidade_n, Corredor, Segmento, Segregacao))

yyy <- subset(tma_desagregado_2020[tma_desagregado_2020$RTTMA == "Sim",], 
                     name_muni %in% c("Rio De Janeiro" , "Belo Horizonte" , "Brasília" , "Fortaleza" , "Sorocaba" , "Feira De Santana")) %>% mutate(novo = paste(Modo, Corredor, Segmento, Segregacao)) %>% mutate(novo = paste(Cidade_n, Corredor, Segmento, Segregacao))



