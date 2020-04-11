library(stringr)
library(pbapply)
library(tableschema.r)

setwd('E:/R/')

#DF e Vitoria nao foram baixadas do Ciclomapa em funcao de erro do app
munis_df <- data.frame(code_muni = c(2927408, 2611606, 1501402, 1200401, 
                                     1302603, 1400100, 1600303, 1721000, 
                                     2211001, 2507507, 2704302, 2800308, 
                                     3205309, 5002704, 5103403, 5208707),
                       name_muni=c('salvador', 'recife', 'belem', 'rio branco', 
                                   'manaus', 'boa vista', 'macapa', 'palmas',
                                   'teresina', 'joao pessoa', 'maceio', 'aracaju', 
                                   'vitoria', 'campo grande', 'cuiaba', 'goiania'))

# to upper name_muni
munis_df$name_muni <- str_to_title(munis_df$name_muni)

i= 2927408
rm(i)


filtrar_infra_ciclo <- function(i){
  
  message(paste0('Abrindo infra ciclo - ', subset(munis_df, code_muni==i)$name_muni,"..."))
  
  infra_ciclo <- st_read(paste0('./dados/infra_transporte/infra_cicloviaria/2019/vias/ciclomapa_ajustado/ciclomapa-', 
                                subset(munis_df, code_muni==i)$name_muni,
                                '.shp')) %>% mutate(type = as.character(type))
  
  
  message(paste0('Ajustando infra ciclo - ', subset(munis_df, code_muni==i)$name_muni,"..."))
  
  infra_ciclo_pnb <- infra_ciclo[(infra_ciclo$type %in% 
                                    c('Ciclovia','Ciclofaixa','Ciclorota', 'Calçada compartilhada')),]#filtra infraestrutura cicloviaria para considerar apenas ciclovias, ciclofaixas e ciclorotas
  
  infra_ciclo_pnb <- st_transform(infra_ciclo_pnb, 4326)#transforma projecao
  unique(infra_ciclo_pnb$type)
  mapview(infra_ciclo) + mapview(infra_ciclo_pnb)
  
  message(paste0('Salvando infra ciclo - ', subset(munis_df, code_muni==i)$name_muni,"..."))
  
  st_write(infra_ciclo_pnb, paste0('./dados/infra_transporte/infra_cicloviaria/2019/vias/ciclomapa_filtrado/ciclomapa-', 
                                subset(munis_df, code_muni==i)$name_muni,
                                '_filtrado.shp'))
  
  # 
  # write_rds(infra_ciclo_pnb, paste0('E:/R/dados/infra_transporte/infra_cicloviaria/2019/vias/filtrado/', 
  #                          subset(munis_df, code_muni==i)$name_muni,
  #                          '_infra_ciclo_filtrada.rds'))
  
}

list_code_muni <- munis_df$code_muni
pblapply(list_code_muni, filtrar_infra_ciclo)


# cities did not work. need to open on QGIS and save again all together:
# sao paulo, rio de janeiro, fortaleza, distrito federal, curitiba, 
# belo horizonte, porto velho, sao luis, florianopolis, porto alegre
name_muni=c('sao paulo', 'rio de janeiro', 'fortaleza', 'distrito federal', 
            'curitiba', 'belo horizonte',  'porto velho', 'sao luis', 
            'natal', 'florianopolis', 'porto alegre')
sort(munis_df$name_muni)
sort(name_muni)