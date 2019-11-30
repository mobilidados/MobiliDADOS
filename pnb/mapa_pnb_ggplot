## Etapas para criar mapas de PNB no ggplot
#1. Abrir pacotes
#2. Abrir arquivos
#3. Rodar funcao

# Codigo para criar mapa de PNB
#1. Abrir pacotes necessarios ----
library(readr)
library(rgdal)
library(sf)
library(RColorBrewer)
library(ggplot2)
library(dplyr)
library(mapview)
library(beepr)
library(ggsn)

setwd('/Users/mackook/Desktop/R/')


#2. Abrir arquivos ----
#Abrir infra de transporte
infra_ciclo <- st_read('./dados/infra_transporte/infra_cicloviaria/2019/infra_ciclo_filtrada_2019.shp')

#Abrir municipio
muni_br <- st_read("./dados/IBGE/br_municipios/BRMUE250GC_SIR.shp")
muni_br$CD_GEOCMU <- as.numeric(as.character(muni_br$CD_GEOCMU)) #transformar coluna em numero

#Criar tabela munis_df
munis_df <- data.frame(code_muni = c(2927408, 3550308, 3304557, 2611606, 2304400, 5300108, 4106902,
                                     3106200, 1501402, 1100205, 1200401, 1302603, 1400100, 1600303, 
                                     1721000, 2111300, 2211001, 2408102, 2507507, 2704302, 2800308,
                                     3205309, 4205407, 4314902, 5002704, 5103403, 5208707),
                       name_muni=c('salvador', 'sao paulo','rio de janeiro', 'recife', 'fortaleza', 
                                   'distrito federal', 'curitiba', 'belo horizonte', 'belem', 'porto velho', 
                                   'rio branco', 'manaus', 'boa vista', 'macapa', 'palmas', 'sao luis',
                                   'teresina', 'natal', 'joao pessoa', 'maceio', 'aracaju', 'vitoria', 
                                   'florianopolis', 'porto alegre', 'campo grande', 'cuiaba', 'goiania'),
                       abrev_state=c('BA', 'SP', 'RJ', 'PE', 'CE', 'DF', 'PR', 'MG', 'PA', 'RO',
                                     'AC', 'AM', 'RR', 'AP', 'TO', 'MA', 'PI', 'RN', 'PB', 'AL',
                                     'SE', 'ES', 'SC', 'RS', 'MS', 'MT', 'GO'), 
                       espg = c(31984, 31983, 31983, 31985, 31984, 31983, 31982, 31983, 31982, 31980, 
                                31979, 31980, 31980, 31982, 31982, 31983, 31983, 31985, 31985, 31985, 
                                31984, 31984, 31982, 31982, 31981, 31981, 31982))


#3. Rodar funcao ----
mapa_pnb <- function(i){
  
  message(paste0('ola, ', i,"\n"))
  
  #abrir muni da uf
  muni_uf <- st_read('./dados/IBGE/br_municipios/BRMUE250GC_SIR.shp')%>%
    mutate(UF = substr(CD_GEOCMU,0,2)) %>% filter(UF == substr((subset(munis_df, name_muni==i)$code_muni),0,2))
  muni_uf <- st_transform(muni_uf, 4326)
  muni <- muni_br %>% filter(CD_GEOCMU==subset(munis_df, name_muni==i)$code_muni)
  muni <- st_transform(muni, 4326)
  
  
  #selecionar infra ciclo apenas da cidade desejada
  infra_ciclo <- st_transform(infra_ciclo, 4326)
  infra_ciclo_muni <- st_intersection(infra_ciclo, muni)
  
  infra_ciclo_muni <- st_transform(infra_ciclo_muni, 3857)
  infra_ciclo_buf <- st_buffer(infra_ciclo_muni, 300) %>% st_union()
  infra_ciclo_buf <- st_transform(infra_ciclo_buf, 4326)
  
  #abrir setores
  setores <- st_read(paste0('./dados/capitais/setores_dados/shp/', i, '_setores_dados.shp'))
  setores <- st_transform(setores, 4326)

  message(paste0('municipio, infra ciclo e setores de ', i," abertos"))
  
  mapview(infra_ciclo_muni) + mapview(muni_uf) + 
    mapview(muni) +   mapview(setores) +   mapview(infra_ciclo_muni) + mapview(infra_ciclo_buf)
  
  #criar mapa PNB
  PNB <- ggplot()+
    geom_sf(data=muni_uf, fill="gray85", colour = "gray89", alpha = 0.2)+
    geom_sf(data=muni, fill="gray85", colour = "black", alpha = 0.4)+
    geom_sf(data=setores, aes(fill = cut_number(Dens,9)), colour=NA, alpha = 0.6) +
    scale_fill_brewer('Dens', palette = "Reds")+
    scalebar(setores, dist = 5, dist_unit = "km", location = "bottomleft",
             transform = TRUE, model = "WGS84", st.dist = 0.03, st.bottom = TRUE, 
             st.size = 3, border.size = 0.1)+
    theme(line = element_blank(),                          # remove axis lines ..
          axis.text=element_blank(),                       # .. tickmarks..
          axis.title=element_blank(),                      # .. axis labels..
          panel.background = element_blank())+
    geom_sf(data = infra_ciclo_buf, fill="blue", colour = "black", size = 0.05, alpha = 0.02)+           # mudar espessura da linha
    geom_sf(data = infra_ciclo_muni, colour = "darkturquoise", size = 0.5)+           # mudar espessura da linha
    coord_sf(expand = F, xlim = c(st_bbox(muni)[[1]]-0.05, st_bbox(muni)[[3]]+0.05),
             ylim = c(st_bbox(muni)[[2]]-0.07, st_bbox(muni)[[4]]+0.05)) #Zoom
  
  message(paste0('mapa de ', i," criado"))
  
  #salvar
  ggsave(PNB, 
         file= paste0('./outros/mapas/PNB/', i, '.png'), 
         dpi = 1500, width = 21, height = 15, units = 'cm')
  beepr::beep()
}

mapa_pnb("salvador")

#size_infra_ciclo: 
#belem = 0.5; 
#belo horizonte, fortaleza, recife, curitiba, salvador, sao paulo, rio de janeiro = 1.5
