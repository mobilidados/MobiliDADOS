#Passo-a-passo do calculo do PNB

# file.remove("C:\\Users\\T-Gamer\\AppData\\Local\\Temp\\RtmpcdrMrW\\metadata_geobr.csv")

# Carregar pacotes
library(sf)
library(dplyr)
library(readr)
library(openxlsx)
library(mapview)
library(pbapply)
library(beepr)
library(stringr)
library(tidyr)
library(lwgeom)
library(purrr)
library(tibble)
library(geobr)

# DDefnir diretorio

setwd('D:/Projetos/mobilidados/pnb_novo')

##1.4. Criar tabela de referencia para capitais


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



# i <- "spo"


# Baixa a camada de setores censitários

setores <- read_census_tract("all")

# Importa a base de dados de setores censitários

dados <- read_rds('D:/Projetos/Mobilidados/pnb/dados/BasePNT/dados_setores.rds')

# ano <- 2022

# Criar funcao para calculo do PNB

PNB  <- function(i){
  
  message(paste0('Ola, ', subset(munis_df, sigla_muni==i)$name_muni,'! =)', "\n"))
  
  #Abrir infraestrutura cicloviaria
  buf <- read_rds(paste0('./dados/infra_cicloviaria/buffer/',ano,'/rds/', 
                         subset(munis_df, sigla_muni==i)$name_muni, 
                         '_network_buffer.rds'))   #buffer com distancia real
  buf <- st_transform(buf,  4326)
  buf <- buf %>% st_set_precision(1000000) %>% st_make_valid() #corrigir shapes que podem possuir algum defeito de feicao
  
  #Abrir dados geo censitarios
  setores <- setores %>% filter(code_muni == subset(munis_df, sigla_muni==i)$code_muni)
  setores <- st_transform(setores, 4326) #transforma projecao
  message(paste0('abriu e ajustou setores - ', subset(munis_df, sigla_muni==i)$name_muni,"\n"))
  setores <- setores %>% mutate(Ar_m2 = unclass(st_area(.)))
  
  #Abrir dados tabulares censitarios
  
  dados <- dados %>% 
    mutate(Cod_setor=as.character(Cod_setor))%>% filter(Cod_municipio==subset(munis_df, sigla_muni==i)$code_muni)
  message(paste0('abriu dados censitarios - ', subset(munis_df, sigla_muni==i)$name_muni,"\n"))
  
  #Juntar geo com dados censitarios
  
  dados_cid <- left_join(setores, dados, by = c('code_tract'='Cod_setor')) %>% st_sf()
  dados_cid <- st_transform(dados_cid, 4326) #transforma projecao
  dados_cid <- dados_cid %>% st_set_precision(1000000) %>% st_make_valid() #corrigir shapes que podem possuir algum defeito de feicao
  message(paste0('setores e dados foram unidos - ', subset(munis_df, sigla_muni==i)$name_muni,"\n"))
  
  #Recortar setores pelo buffer
  setores_entorno <- st_intersection(dados_cid, buf) %>% st_collection_extract("POLYGON")  #recortar setores dentro da area de entorno das estacoes
  message(paste0('recortou setores no entorno - ', subset(munis_df, sigla_muni==i)$name_muni,"\n"))
  

  
  #Calculo do total de cada variavel no entorno da infraestrutura cicloviaria
  setores_entorno <- setores_entorno %>%
    mutate(ar_int = unclass(st_area(.)), #cria area inserida no entorno da estacao
           rt = as.numeric(ar_int/Ar_m2)) %>% #cria proporcao entre area inserida no entorno da estacao e area total de cada 
    mutate_at(.vars = vars(Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Negros_Mulher,
                           Negros_Homem, Renda_Mulher_0_1,Renda_Homem_0_1, Renda_Mulher_2SM,
                           Pessoa_0_1, Pessoa_0_meio, Pessoa_meio_1, Pessoa_1_3, Pessoa_3_mais), 
              funs(int = . * rt)) #criar variaveis proximas das estacoes
  
  Sys.sleep(5) #coloca para dormir 5 segundos
  
  
  #Gravar buffer em shp
  st_write(select(setores_entorno, Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Negros_Mulher,
                  Negros_Homem, Renda_Mulher_0_1,Renda_Homem_0_1, Renda_Mulher_2SM,
                  Pessoa_0_1, Pessoa_0_meio, Pessoa_meio_1, Pessoa_1_3, Pessoa_3_mais), (paste0('./dados/infra_cicloviaria/buffer_entorno/',ano,'/shp/', 
                                    subset(munis_df, sigla_muni==i)$name_muni, 
                                    '_network_buffer_entorno.shp')), append = TRUE)
  
  #Gravar buffer em shp
  st_write(select(setores_entorno, Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Negros_Mulher,
                  Negros_Homem, Renda_Mulher_0_1,Renda_Homem_0_1, Renda_Mulher_2SM,
                  Pessoa_0_1, Pessoa_0_meio, Pessoa_meio_1, Pessoa_1_3, Pessoa_3_mais), (paste0('./dados/infra_cicloviaria/buffer_entorno/',ano,'/geojson/', 
                                                                                             subset(munis_df, sigla_muni==i)$name_muni, 
                                                                                             '_network_buffer_entorno.geojson')), append = TRUE) 
  #Gravar buffer em rds
  write_rds(select(setores_entorno, Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Negros_Mulher,
                   Negros_Homem, Renda_Mulher_0_1,Renda_Homem_0_1, Renda_Mulher_2SM,
                   Pessoa_0_1, Pessoa_0_meio, Pessoa_meio_1, Pessoa_1_3, Pessoa_3_mais), (paste0('./dados/infra_cicloviaria/buffer_entorno/',ano,'/rds/', 
                                                                                             subset(munis_df, sigla_muni==i)$name_muni, 
                                                                                             '_network_buffer_entorno.rds'))) 
  
  Sys.sleep(5)
  
  total_entorno <- c((sum(setores_entorno$Pop_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_0_meio_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_meio_1_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_1_3_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_3_mais_int, na.rm = TRUE)), 
                     (sum(setores_entorno$Negros_Mulher_int, na.rm = TRUE)),
                     (sum(setores_entorno$Negros_Homem_int, na.rm = TRUE)),
                     (sum(setores_entorno$Renda_Mulher_0_1_int, na.rm = TRUE)),
                     (sum(setores_entorno$Renda_Homem_0_1_int, na.rm = TRUE)),
                     (sum(setores_entorno$Renda_Mulher_2SM_int, na.rm = TRUE)),
                     (sum(setores_entorno$Pessoa_0_1_int, na.rm = TRUE)),
                     (sum(setores_entorno$Pessoa_0_meio_int, na.rm = TRUE)),
                     (sum(setores_entorno$Pessoa_meio_1_int, na.rm = TRUE)),
                     (sum(setores_entorno$Pessoa_1_3_int, na.rm = TRUE)),
                     (sum(setores_entorno$Pessoa_3_mais_int, na.rm = TRUE))) #Realizar a soma total de cada variavel
  
  #Calculo do total de cada variavel na cidade analisada
  total_cidade <- c((sum(dados_cid$Pop, na.rm = TRUE)), 
                    (sum(dados_cid$DR_0_meio, na.rm = TRUE)), 
                    (sum(dados_cid$DR_meio_1, na.rm = TRUE)), 
                    (sum(dados_cid$DR_1_3, na.rm = TRUE)), 
                    (sum(dados_cid$DR_3_mais, na.rm = TRUE)), 
                    (sum(dados_cid$Negros_Mulher, na.rm = TRUE)),
                    (sum(dados_cid$Negros_Homem, na.rm = TRUE)),
                    (sum(dados_cid$Renda_Mulher_0_1, na.rm = TRUE)),
                    (sum(dados_cid$Renda_Homem_0_1, na.rm = TRUE)),
                    (sum(dados_cid$Renda_Mulher_2SM, na.rm = TRUE)),
                    (sum(dados_cid$Pessoa_0_1, na.rm = TRUE)),
                    (sum(dados_cid$Pessoa_0_meio, na.rm = TRUE)),
                    (sum(dados_cid$Pessoa_meio_1, na.rm = TRUE)),
                    (sum(dados_cid$Pessoa_1_3, na.rm = TRUE)),
                    (sum(dados_cid$Pessoa_3_mais, na.rm = TRUE))) #Realizar a soma total de cada variavel
  
  #Calculo do resultado final
  Resultados_pnb <-rbind(total_entorno, total_cidade, round(100*(total_entorno/total_cidade),2))
  row.names(Resultados_pnb)<- c("total_entorno","total_rm", "resultado_%") #Nomeia as linhas da tabela criada
   colnames(Resultados_pnb)<- c("Pop", "DR_0_meio","DR_meio_1","DR_1_3","DR_3_mais", "Negros_Mulher","Negros_Homem",
                                "Renda_Mulher_1SM","Renda_Homem_1SM", "Renda_Mulher_2SM",
                                "Pessoa_0_1", "Pessoa_0_meio", "Pessoa_meio_1", "Pessoa_1_3", "Pessoa_3_mais" ) #Nomear as colunas da tabela criada
  print(Resultados_pnb) #Verfica tabela
  
  Resultados_pnb_final <- as.data.frame(t(Resultados_pnb))
  Resultados_pnb_final$cidade <- str_to_title(subset(munis_df, sigla_muni==i)$name_muni)
  Resultados_pnb_final <- tibble::rownames_to_column(Resultados_pnb_final, "indicador")
  
  print(Resultados_pnb_final) #Verfica tabela final
  
  
  write.csv2(Resultados_pnb_final, paste0('./resultados/',ano,'/network/', 
                                          subset(munis_df, sigla_muni==i)$name_muni, '_pnb_',ano,'.csv'), row.names = FALSE)#salvar resultado final
  
  
  message(paste0('salvou resultados - ', subset(munis_df, code_muni==i)$name_muni,"\n"))
  
  
  Sys.sleep(5)
  
}

# Aplicar funcao para calcular PNB nas capitais
# criar lista de codigos dos municipios
list_sigla_muni <- munis_df$sigla_muni

# Aplicar funcao para calcular PNB para todas as capitais
start_time <- Sys.time() # horario de inicio da funcao

pblapply(list_sigla_muni, safely(PNB)) # aplicar fundao

end_time <- Sys.time() # horario de fim da funcao

# Aplicar funcao para calcular PNB para uma capital
# PNB("bho")

# Juntar em tabela unica para MobiliDADOS database
ano <- 2022
# Criar tabela unica
# Criar lista
files <- list.files(path = paste0('./resultados/',ano,'/network'),
                    pattern = "*.csv", full.names = TRUE)

# Ler e juntar
juntos <- do.call("rbind", lapply(files, read.csv2))

names(juntos) <- c("indicador", "total_entorno", "total", "resultado", "territorio")


ordem <- c("Aracaju", "Belem", "Belo Horizonte", "Boa Vista", "Distrito Federal", "Campo Grande","Cuiaba","Curitiba",
          "Florianopolis",  "Fortaleza", "Goiania","Joao Pessoa","Macapa","Maceio","Manaus", "Natal","Palmas",
          "Porto Alegre","Porto Velho", "Recife","Rio Branco", "Rio De Janeiro", "Salvador","Sao Luis", "Sao Paulo",
          "Teresina","Vitoria") 
ordem2 <- c("total", "total_entorno", "resultado")
ordem3 <- c("Pop",'DR_0_meio', 'DR_meio_1', 'DR_1_3', 'DR_3_mais', "Negros_Mulher","Renda_Mulher_1SM")


capitais_pnb_db1 <- juntos %>% 
  pivot_longer(!c(indicador,territorio), names_to = "tipo", values_to = "valor") %>% subset(indicador %in% ordem3) %>%
  mutate(territorio = factor(territorio, levels = ordem),
         tipo = factor(tipo, levels = ordem2),
         indicador = factor(indicador, levels = ordem3),
         ano = ano) %>% arrange(indicador,tipo,territorio) %>% select(territorio, indicador, tipo, valor, ano) 


capitais_pnb_db2 <- juntos %>% 
  pivot_longer(!c(indicador,territorio), names_to = "tipo", values_to = "valor") %>% subset(indicador %in% ordem3 & tipo == "resultado") %>%
  mutate(territorio = factor(territorio, levels = ordem),
         tipo = factor(tipo, levels = ordem2),
         indicador = factor(indicador, levels = ordem3),
         ano = ano) %>% arrange(indicador,tipo,territorio) %>% select(territorio, indicador, tipo, valor, ano) 

capitais_pnb_upload <- juntos[,c("indicador","resultado","territorio")] %>% 
  pivot_wider(names_from = "indicador", values_from = "resultado")

write.csv2(capitais_pnb_db1, paste0("./resultados/",ano,"/network/consolidado/capitais_pnb_db1.csv"), row.names = FALSE)
write.csv2(capitais_pnb_db2, paste0("./resultados/",ano,"/network/consolidado/capitais_pnb_db2.csv"), row.names = FALSE)
write.csv2(capitais_pnb_upload, paste0("./resultados/",ano,"/network/consolidado/capitais_pnb_upload.csv"), row.names = FALSE)
