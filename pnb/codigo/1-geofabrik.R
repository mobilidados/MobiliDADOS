library(maptools)
library(sf)
library(readr)
library(osmextract)
library(mapview)
library(dplyr)
library(geobr)
library(stringr)
library(pbapply)


# A partir de uma certa versão do pacote sf é necessário rodar a linha abaixo.
# Do contrário os joins ou intersects irão falhar

sf_use_s2(FALSE)

# Faz a leitura da base de mapas de todos os municípios do Brasil

camadas <- read_municipality()

# Escolhe o ano

ano <- 2022

# Importa o arquivo pbf baixado do geofabrik.
# Note que essa é uma rotina que realiza a mesma rotina de classificação que o ciclomapa.org.br faz.
# Essa é uma leitura pesada, que pode sobrecarregar a memória ram do PC

infra <- oe_read(paste0("./otp/",ano,"/graphs/brazil.osm.pbf"),
                 layer = "lines",
                 extra_tags = c("cycleway","cycleway:left","cycleway:right","cycleway:both", "maxspeed", "bicycle"))


# Cria a função para a classificação das infraestruturas cicloviárias

get_infra_ciclo <- function(ano){


infra <- infra %>% mutate(tipologia = case_when(
  # Ciclovia
  highway == "cycleway" ~ "Ciclovia",
  cycleway ==  "track"~ "Ciclovia",
  cycleway_left ==  "track"~ "Ciclovia",
  cycleway_right ==  "track"~ "Ciclovia",
  cycleway ==  "opposite_track"~ "Ciclovia",
  cycleway_left ==  "opposite_track"~ "Ciclovia",
  cycleway_right ==  "opposite_track"~ "Ciclovia",
  # Ciclofaixa
  cycleway == "lane" ~ "Ciclofaixa",
  cycleway_left == "lane" ~ "Ciclofaixa",
  cycleway_right == "lane" ~ "Ciclofaixa",
  cycleway_both == "lane" ~ "Ciclofaixa",
  cycleway == "opposite_lane" ~ "Ciclofaixa",
  cycleway_right == "opposite_lane" ~ "Ciclofaixa",
  cycleway_left == "opposite_lane" ~ "Ciclofaixa",
  #Ciclorrota
  cycleway == "buffered_lane" ~ "Ciclorrota",
  cycleway_left == "buffered_lane"~ "Ciclorrota",
  cycleway_right == "buffered_lane"~ "Ciclorrota",
  cycleway == "shared_lane"~ "Ciclorrota",
  cycleway_left == "shared_lane"~ "Ciclorrota",
  cycleway_right == "shared_lane"~ "Ciclorrota",
  cycleway == "share_busway"~ "Ciclorrota",
  cycleway_left == "share_busway"~ "Ciclorrota",
  cycleway_right == "share_busway"~ "Ciclorrota",
  cycleway == "opposite_share_busway"~ "Ciclorrota",
  #Calçada Compartilhada
  highway == "footway" & bicycle == "designated" ~ "Calçada Compartilhada",
  highway == "pedestrian" & bicycle == "designated" ~ "Calçada Compartilhada",
  highway == "pedestrian" & bicycle == "yes" ~ "Calçada Compartilhada",
  cycleway == "sidepath" ~ "Calçada Compartilhada",
  cycleway_left == "sidepath" ~ "Calçada Compartilhada",
  cycleway_right == "sidepath" ~ "Calçada Compartilhada",
  #Baixa Velocidade
  maxspeed == "30" ~ "Baixa velocidade",
  maxspeed == "20" ~ "Baixa velocidade",
  highway == "living_street" & bicycle == "yes" ~ "Baixa velocidade",
  #Trilha
  highway == "track" & bicycle == "designated" ~ "Trilha",
  highway == "track" & bicycle == "yes" ~ "Trilha",
  highway == "path" & bicycle == "designated" ~ "Trilha",
  highway == "path" & bicycle == "yes" ~ "Trilha",
  #Proibido
  bicycle == "no" ~ "Proibido",
  bicycle == "dismount" ~ "Proibido"
))

# Recorta somente o necessário

infra <- infra %>% select("osm_id","name", "tipologia")

# tipos <- c("Ciclovia", "Ciclofaixa", "Ciclorrota", "Calçada Compartilhada", "Baixa velocidade", "Trilha", "Proibido")
# tipos_ciclo <- c("Ciclovia", "Ciclofaixa")

# Retira o que é NA

infra <- infra[!is.na(infra$tipologia),]

# Define a lista de municípios a serem trablahados.


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


# Importa somente as capitais

camadas <- camadas %>% filter(code_muni %in% munis_df$code_muni) %>% st_transform(4326)


# Faz a interseção entre as camadas dos municípios brasileiros com a base de capitais

infra_ciclo_capitais <- st_intersection(camadas,infra)

# Exporta os resultados em formato geojson para cada capital

for(i in munis_df$code_muni){
tryCatch({  
st_write(infra_ciclo_capitais[infra_ciclo_capitais$code_muni == i,],
         paste0("./pnb/infra_ciclo/",ano,"/infra_ciclo_",
                munis_df[munis_df$code_muni == i,]$name_muni, ".geojson"),append=TRUE)
},error=function(e){})
  
}
}

# Roda a função para o total das capitais do país

pblapply(ano, get_infra_ciclo)


# infra_pais <- infra %>% mutate(tamanho = st_length(geometry))

# infra_pais$tamanho <- as.numeric(str_replace(infra_pais$tamanho, " [m]",""))

# infra_pais_filtrado <- infra_pais %>% filter(tipologia %in% c("Ciclofaixa","Ciclovia"))

# camadas2 <- read_municipality() %>% st_transform(4326)

# infra_pais_filtrado_geo <- infra_pais_filtrado <- st_intersection(camadas2,infra_pais_filtrado)

# infra_pais_filtrado_geo$name_muni %>% unique %>% length()

# infra_pais_filtrado_geo2 <- infra_pais_filtrado_geo %>% group_by(name_muni,tipologia) %>% summarise(tamanho_total=sum(tamanho)) 

# final <- infra_pais_filtrado_geo2 %>% arrange(desc(tamanho_total))

