# Carregar pacotes

library(stringr)
library(pbapply)
library(purrr)
library(dplyr)
library(sf)
library(readr)

# Definir diretório de trabalho

setwd('D:/Projetos/mobilidados/pnb_novo')

# Definir municípios a baixar

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
                                31981, 31982),
                       sigla_muni = c("ssa", "spo", "rio", "rec", "for", "dis", "cur", 
                                      "bho", "bel", "por", "rbr", "man", "boa", "mac", 
                                      "pal", "sls", "ter", "nat", "joa", "mco", "ara", 
                                      "vit", "flo", "poa", "cam", "cui", "goi"))

# to upper name_muni
munis_df$name_muni <- str_to_title(munis_df$name_muni)


# Definir caminho para a pasta com os geojsons dos ciclomapas

# cid <- 3550308 
# ano <- 2022


# Antes de começar jogar os arquivos de infra para a pasta de geofabrik
# Criar

filtrar_infra_ciclo <- function(cid, ano){
  
  message(paste0('Abrindo infra ciclo - ', subset(munis_df, code_muni==cid)$name_muni,"..."))
  
  infra_ciclo <- st_read(paste0('./infra_ciclo/',ano,'/infra_ciclo_', 
                                subset(munis_df, code_muni==cid)$name_muni,
                                '.geojson')) %>% st_cast("LINESTRING") # Ler o arquivo geojson baixado do ciclomapa e transforma polígono em "linestring"
  # Alguns dados no ciclomapa estão em forma de polígono. É necessário modificar para rodar.
  
  message(paste0('Ajustando infra ciclo - ', subset(munis_df, code_muni==cid)$name_muni,"..."))
  
  infra_ciclo_pnb <- infra_ciclo[(infra_ciclo$tipologia %in% 
                                    c('Ciclovia','Ciclofaixa')),]#filtra infraestrutura cicloviaria para considerar apenas ciclovias e ciclofaixas.
  
  infra_ciclo_pnb <- st_transform(infra_ciclo_pnb, 4326)#transforma projecao

  message(paste0('Salvando infra ciclo - ', subset(munis_df, code_muni==cid)$name_muni,"..."))
  
  # Por segurança salvar em dois formatos os arquivo de infraestrutura cicloviária filtrada
  
  st_write(infra_ciclo_pnb, paste0('./dados/infra_cicloviaria/geofabrik_filtrado/',ano,'/shp/', 
                                subset(munis_df, code_muni==cid)$name_muni,
                                '_filtrado.shp'))
  write_rds(infra_ciclo_pnb, paste0('./dados/infra_cicloviaria/geofabrik_filtrado/',ano,'/rds/',
                                   subset(munis_df, code_muni==cid)$name_muni,
                                   '_filtrado.rds'))
}

# Cria uma lista com os c?digos a serem iterados na função apply

list_code_muni <- munis_df$code_muni

# Aplica a função de filtrar a lista criada. o Safely é criado para evitar que os erros (cidades sem infra) não travem a função

pbmapply(safely(filtrar_infra_ciclo), list_code_muni, ano)

# Junta todos os arquivos rds e coloca em um único arquivo a ser exportado

lista_arquivos <- list.files(paste0("./dados/infra_cicloviaria/geofabrik_filtrado/",ano,"/rds"), pattern='*\\.rds', full.names = TRUE)

caps_lines <- do.call("rbind", lapply(lista_arquivos, read_rds))

# Exporta em dois formatos diferentes por segurança

st_write(caps_lines, paste0("./dados/infra_cicloviaria/geofabrik_filtrado/",ano,"/shp","/geofabrik_capitais_filtrado.shp"), append = TRUE)
write_rds(caps_lines, paste0("./dados/infra_cicloviaria/geofabrik_filtrado/",ano,"/rds","/geofabrik_capitais_filtrado.rds"))
