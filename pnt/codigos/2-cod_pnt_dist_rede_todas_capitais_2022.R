#Passo-a-passo do calculo do PNT
#1. Instalar pacotes e definir diretorio
#2. Abrir arquivos necessarios
#3. Realizar calculo do PNT


#1. Instalar pacotes e definir diretorio ----
#1.1. Instalar pacotes
# install.packages('sf')
# install.packages('dplyr')
# install.packages('readr')
# install.packages('openxlsx')
# install.packages('pbapply')
# install.packages('beepr')
# install.packages('stringr')
# install.packages('tidyr')


#1.2 Abrir pacotes
library(sf)
library(dplyr)
library(readr)
library(openxlsx)
library(mapview)
library(pbapply)
library(beepr)
library(stringr)
library(tidyr)
library(readODS)
library(pbapply)
library(purrr)
library(rJava)
library(openxlsx)


#2. Abrir arquivos necessarios -----
#2.1. Abrir dados dos setores censitarios
#Baixar dados dos setores censitarios na pagina da MobiliDADOS
# Ir em https://mobilidados.org.br/database
# Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
# Baixar tabela de dados
# camadas <- read_rds('./apoio/setores_rms.rds') %>% 
#  mutate(Cod_setor=as.character(Cod_setor)) # camadas dos setores censit?rios

#2.2. Definir a regiao metropolitana que sera calculada
#Abrir dados da regiao metropolitana
#Criar tabela de referencia para puxar dados

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

munis_df_rms <- data.frame(code_muni = c(1501402, 3106200, 4106902, 5300108, 
                                         2304400, 2611606, 3304557, 2927408, 
                                         3550308),
                           name_muni=c("belém", "belo horizonte", "curitiba", 
                                       "distrito federal", "fortaleza", "recife",
                                       "rio de janeiro", "salvador", "são paulo"),
                           abrev_state=c("PA", "mg", "PR", "df", "CE", 
                                         "PE", "RJ", "BA", "SP"),
                           rms=c("rmb", "rmbh", "rmc", "ride", 
                                 "rmf", "rmr", "rmrj", "rms", "rmsp"),
                           espg = c(31982, 31983, 31982, 31983,
                                    31984, 31985, 31983, 31984, 31983 ),
                           shp = c("RM Belem", "RM Belo Horizonte", "RM Curitiba", 
                                   "RIDE Distrito Federal", "RM Fortaleza", "RM Recife",
                                   "RM_Rio_de_Janeiro", "RM_Salvador", "RM_Sao_Paulo"))

base_rms <- read_ods("./populacao/input/rms_pop.ods") %>% select(NOME_CATMETROPOL, COD_MUN)
base_rms2 <- base_rms %>% mutate(rm = case_when(
  NOME_CATMETROPOL == "Região Metropolitana de Belém" ~ "rmb",
  NOME_CATMETROPOL == "Região Metropolitana de Belo Horizonte" ~ "rmbh",
  NOME_CATMETROPOL == "Região Metropolitana de Curitiba" ~ "rmc",
  NOME_CATMETROPOL == "Região Integrada de Desenvolvimento do Distrito Federal e Entorno" ~ "ride",
  NOME_CATMETROPOL == "Região Metropolitana de Fortaleza" ~ "rmf",
  NOME_CATMETROPOL == "Região Metropolitana de Recife" ~ "rmr",
  NOME_CATMETROPOL == "Região Metropolitana do Rio de Janeiro" ~ "rmrj",
  NOME_CATMETROPOL == "Região Metropolitana de Salvador" ~ "rms",
  NOME_CATMETROPOL == "Região Metropolitana de São Paulo" ~ "rmsp")) 
base_rms2$rm[is.na(base_rms2$rm)] <- "-"

# Baixa a camada de setores censitários

# setores <- read_census_tract("all")

setores <- st_read("./apoio/input_censo/BR_setores_CD2022.shp" )


# Importa a base de dados de setores censitários

# dados <- read_rds('./apoio/dados_setores.rds')

dados <- read_rds("./apoio/dados_setores_2022.rds")

sf_use_s2(FALSE)

  # codigo <- 1501402
  # ano <- 2024
  # is_rm <- TRUE

#3. Realizar calculo do PNT ----
#3.1. Criar Funcao para aplicar PNT
PNT <- function(codigo, ano, is_rm = FALSE){
 
  message(paste0('ola, ', subset(munis_df, code_muni == codigo)$name_muni,'! =)', "\n"))
  Sys.sleep(3)
  print(Sys.time())
  
  message(paste0('abrindo setores...'))
  
  # Abrir dados geo censitários

  
  setores <- if (is_rm) setores %>% filter(CD_MUN %in% base_rms2[base_rms2$rm == munis_df_rms[munis_df_rms$code_muni == codigo,]$rms,]$COD_MUN) else setores %>% filter(CD_MUN == codigo)
  setores <- st_transform(setores, 4326) #transforma projecao
  message(paste0('abriu e ajustou setores - ', subset(munis_df, code_muni==codigo)$name_muni,"\n"))
  setores <- setores %>% mutate(Ar_m2 = unclass(st_area(.)))
  
  message(paste0('abriu e ajustou setores - ', subset(munis_df, code_muni==codigo)$name_muni,"\n"))
  
  # Abrir dados tabulares censitários
  if (is_rm) {
    dados <- dados %>%
      mutate(CD_SETOR = as.character(CD_SETOR)) %>%
      filter(CD_MUN %in% base_rms2[base_rms2$rm == munis_df_rms[munis_df_rms$code_muni == codigo, ]$rms, ]$COD_MUN)
  } else {
    dados <- dados %>%
      mutate(CD_SETOR = as.character(CD_SETOR)) %>%
      filter(CD_MUN == codigo)
  }
  
  message(paste0('abriu dados censitarios - ', subset(munis_df, code_muni==codigo)$name_muni,"\n"))
  
  
  
  # Juntar geo com dados censitários
  
  dados_cid <- left_join(setores, dados, by = c('CD_SETOR' = 'CD_SETOR')) %>% st_sf() %>% st_transform(4326) %>% 
    st_set_precision(1000) %>% st_make_valid()
  
  dados_cid <- dados_cid %>%
    mutate(across(c(pop, branco, preto, amarelo, pardo, indigena,
                    homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
                    mulher_branca, mulher_preta,mulher_amarela, mulher_parda, mulher_indigena, negro, mulher_negra, homem_negro), 
                  ~ as.numeric(as.character(.))))
  
  message(paste0('setores e dados foram unidos - ', subset(munis_df, code_muni==codigo)$name_muni,"\n"))
  
  message(paste0('abrindo buffer ...',"\n"))
  
  TMA_buf <- read_rds(
    if (is_rm) {
      paste0('./pnt/output/', ano, '/buffer/rds/rms/', 
             subset(munis_df_rms, code_muni == codigo)$rms, 
             '_buffer_', ano, '.rds')
    } else {
      paste0('./pnt/output/', ano, '/buffer/rds/capitais/', 
             subset(munis_df, code_muni == codigo)$name_muni, 
             '_buffer_', ano, '.rds')
    }
    )
  #buffer com distancia real
  TMA_buf <- st_transform(TMA_buf, 4326)

  
  # Recortar setores pelo buffer
  setores_entorno <- st_intersection(dados_cid, TMA_buf) %>% st_collection_extract("POLYGON")
  
  message(paste0('recortou setores no entorno - ', subset(munis_df, code_muni==codigo)$name_muni,"\n"))
  
  # Cálculo do total de cada variável no entorno da infraestrutura cicloviária
  setores_entorno <- setores_entorno %>%
    mutate(ar_int = unclass(st_area(.)), 
           rt = as.numeric(ar_int / Ar_m2)) %>% 
    mutate(across(c(pop, branco, preto, amarelo, pardo, indigena,
                    homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
                    mulher_branca, mulher_preta,mulher_amarela, mulher_parda, mulher_indigena, negro, mulher_negra, homem_negro), 
                  ~ as.numeric(as.character(.)))) %>% 
    mutate_at(vars(pop, branco, preto, amarelo, pardo, indigena,
                   homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
                   mulher_branca, mulher_preta,mulher_amarela, mulher_parda, mulher_indigena, negro, mulher_negra, homem_negro), 
              list(int = ~ . * rt))
  Sys.sleep(5)
  
  # Gravar buffer em SHP
  st_write(
    select(setores_entorno, pop, branco, preto, amarelo, pardo, indigena,
           homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
           mulher_branca, mulher_preta,mulher_amarela, mulher_parda, mulher_indigena, negro, mulher_negra, homem_negro), 
    paste0('./pnt/output/', ano, '/entorno/shp/', 
           if (is_rm) "rms/" else "capitais/", 
           if (is_rm) subset(munis_df_rms, code_muni == codigo)$rms else subset(munis_df, code_muni == codigo)$name_muni, 
           '_network_buffer_entorno.shp'), append = FALSE
  )
  
  # Gravar buffer em GeoJSON
  st_write(
    select(setores_entorno,pop, branco, preto, amarelo, pardo, indigena,
           homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
           mulher_branca, mulher_preta,mulher_amarela, mulher_parda, mulher_indigena, negro, mulher_negra, homem_negro), 
    paste0('./pnt/output/', ano, '/entorno/geojson/', 
           if (is_rm) "rms/" else "capitais/", 
           if (is_rm) subset(munis_df_rms, code_muni == codigo)$rms else subset(munis_df, code_muni == codigo)$name_muni, 
           '_network_buffer_entorno.geojson'),
    delete_dsn = TRUE
  )
  
  # Gravar buffer em RDS
  write_rds(
    select(setores_entorno, pop, branco, preto, amarelo, pardo, indigena,
           homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
           mulher_branca, mulher_preta,mulher_amarela, mulher_parda, mulher_indigena, negro, mulher_negra, homem_negro), 
    paste0('./pnt/output/', ano, '/entorno/rds/', 
           if (is_rm) "rms/" else "capitais/", 
           if (is_rm) subset(munis_df_rms, code_muni == codigo)$rms else subset(munis_df, code_muni == codigo)$name_muni, 
           '_network_buffer_entorno.rds')
  ) 
  Sys.sleep(5)
  
  total_entorno <- c((sum(setores_entorno$pop_int, na.rm = TRUE)), 
                     (sum(setores_entorno$branco_int, na.rm = TRUE)),
                     (sum(setores_entorno$preto_int, na.rm = TRUE)),
                     (sum(setores_entorno$amarelo_int, na.rm = TRUE)), 
                     (sum(setores_entorno$pardo_int, na.rm = TRUE)), 
                     (sum(setores_entorno$indigena_int, na.rm = TRUE)), 
                     (sum(setores_entorno$homem_branco_int, na.rm = TRUE)),
                     (sum(setores_entorno$homem_preto_int, na.rm = TRUE)),
                     (sum(setores_entorno$homem_amarelo_int, na.rm = TRUE)), 
                     (sum(setores_entorno$homem_pardo_int, na.rm = TRUE)), 
                     (sum(setores_entorno$homem_indigena_int, na.rm = TRUE)), 
                     (sum(setores_entorno$mulher_branca_int, na.rm = TRUE)),
                     (sum(setores_entorno$mulher_preta_int, na.rm = TRUE)),
                     (sum(setores_entorno$mulher_amarela_int, na.rm = TRUE)),
                     (sum(setores_entorno$mulher_parda_int, na.rm = TRUE)),
                     (sum(setores_entorno$mulher_indigena_int, na.rm = TRUE)),
                     (sum(setores_entorno$negro_int, na.rm = TRUE)),
                     (sum(setores_entorno$mulher_negra, na.rm = TRUE)),
                     (sum(setores_entorno$homem_negro_int, na.rm = TRUE))) #Realizar a soma total de cada variavel
  
  #Calculo do total de cada variavel na cidade analisada
  total_cidade <- c((sum(dados_cid$pop, na.rm = TRUE)), 
                    (sum(dados_cid$branco, na.rm = TRUE)),
                    (sum(dados_cid$preto, na.rm = TRUE)),
                    (sum(dados_cid$amarelo, na.rm = TRUE)), 
                    (sum(dados_cid$pardo, na.rm = TRUE)),
                    (sum(dados_cid$indigena, na.rm = TRUE)),  
                    (sum(dados_cid$homem_branco, na.rm = TRUE)),
                    (sum(dados_cid$homem_preto, na.rm = TRUE)),
                    (sum(dados_cid$homem_amarelo, na.rm = TRUE)), 
                    (sum(dados_cid$homem_pardo, na.rm = TRUE)),
                    (sum(dados_cid$homem_indigena, na.rm = TRUE)), 
                    (sum(dados_cid$mulher_branca, na.rm = TRUE)), 
                    (sum(dados_cid$mulher_preta, na.rm = TRUE)),
                    (sum(dados_cid$mulher_amarela, na.rm = TRUE)),
                    (sum(dados_cid$mulher_parda, na.rm = TRUE)),
                    (sum(dados_cid$mulher_indigena, na.rm = TRUE)),
                    (sum(dados_cid$negro, na.rm = TRUE)),
                    (sum(dados_cid$mulher_negra, na.rm = TRUE)),
                    (sum(dados_cid$homem_negro, na.rm = TRUE))) #Realizar a soma total de cada variavel
  
  #Calculo do resultado final
  Resultados_pnt <-rbind(total_entorno, total_cidade, round(100*(total_entorno/total_cidade),2))
  row.names(Resultados_pnt)<- c("total_entorno","total_rm", "resultado_%") #Nomeia as linhas da tabela criada
  colnames(Resultados_pnt)<- c("pop", "branco","preto","amarelo","pardo","indigena",
                               "homem_branco","homem_preto","homem_amarelo","homem_pardo","homem_indigena", 
                               "mulher_branca","mulher_preta", "mulher_amarela", "mulher_parda","mulher_indigena",
                               "negro", "mulher_negra", "homem_negro") #Nomear as colunas da tabela criada
  print(Resultados_pnt) #Verfica tabela
  
  Resultados_pnt_final <- as.data.frame(t(Resultados_pnt))
  Resultados_pnt_final$cidade <- str_to_title(subset(munis_df, code_muni==codigo)$name_muni)
  Resultados_pnt_final <- tibble::rownames_to_column(Resultados_pnt_final, "indicador")
  
  print(Resultados_pnt_final) #Verfica tabela final
  
  write.csv2(
    Resultados_pnt_final, 
    paste0('./pnt/resultados/', ano, '/', 
           if (is_rm) "rms/" else "capitais/", 
           if (is_rm) subset(munis_df_rms, code_muni == codigo)$rms else subset(munis_df, code_muni == codigo)$name_muni, 
           '_pnt_', ano, '.csv'), 
    row.names = FALSE
  )
  
  message(paste0('salvou resultados - ', subset(munis_df, code_muni==codigo)$name_muni, "\n"))
  
  Sys.sleep(5)
  
}


pbmapply(safely(PNT),munis_df_rms$code_muni,2022, is_rm = TRUE)
pbmapply(safely(PNT),munis_df$code_muni,2022, is_rm = FALSE)


#4.1. criar tabela unica
#criar lista

ano <- 2024

files <- list.files(path = paste0("./pnt/resultados/", ano, "/capitais"),
                    pattern = "\\.csv$", full.names = TRUE)


#ler e juntar
juntos <- do.call("rbind", lapply(files, read.csv2))


#4.2 criar tabela para database
# abrir tabela

ordem <- c("belem", "belo horizonte", "distrito federal", "curitiba", "fortaleza", "goiania", "porto alegre",
           "recife", "rio de janeiro", "salvador", "sao paulo", "teresina") 
ordem2 <- c("total_rm", "total_entorno", "resultado_.")
ordem3 <- c("Pop")


pnt_format_1 <- pivot_wider(juntos[,c(1,4,5)], names_from = indicador, values_from = resultado_.)


capitais_dados_upload  <- pnt_format_1 %>% mutate(territorio = factor(cidade, levels = ordem)) %>%
  arrange(cidade)  



capitais_pnt_db <- juntos[c(1,2,3,5)] %>% 
  pivot_longer(!c(indicador,cidade), names_to = "tipo", values_to = "valor") %>% subset(indicador == "pop") %>%
  mutate(territorio = factor(cidade, levels = ordem),
         tipo = factor(tipo, levels = ordem2),
         ano = ano) %>% arrange(cidade, indicador, tipo) %>% select(cidade, indicador, tipo, valor, ano) 


capitais_pnt_resultado <- juntos[c(5,4,1)] %>% subset(indicador == "pop") %>% 
 arrange(cidade, indicador) 

write.xlsx(capitais_dados_upload, paste0("./pnt/resultados/0_geral/capitais/capitais_dados_upload_", ano,".xlsx")) # salvar
write.xlsx(capitais_pnt_db, paste0("./pnt/resultados/0_geral/capitais/capitais_pnt_db_", ano,".xlsx")) # salvar



i <- 2010


for(i in 2010:2021){
  files <- list.files(path = paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/",i,"/capitais"),
                      pattern = "\\.xlsx$", full.names = TRUE)
  
  
  #ler e juntar
  juntos <- do.call("rbind", lapply(files, read.xlsx))
  
  
  #4.2 criar tabela para database
  # abrir tabela
  
  ordem <- c("belem", "belo horizonte", "distrito federal", "curitiba", "fortaleza", "goiania", "porto alegre",
             "recife", "rio de janeiro", "salvador", "sao paulo", "teresina") 
  ordem2 <- c("total", "total_entorno")
  ordem3 <- c("Pop",'DR_0_meio', 'DR_meio_1', 'DR_1_3', 'DR_3_mais', "Negros_Mulher","Renda_Mulher_0_1")
  
  
  pnt_format_1 <- pivot_wider(juntos[,c(1,4,5)], names_from = indicador, values_from = resultado)
  
  
  capitais_dados_upload  <- pnt_format_1 %>% mutate(territorio = factor(territorio, levels = ordem)) %>%
    arrange(territorio)  
  
  
  
  
  capitais_pnt_db <- juntos[c(1,2,3,5)] %>% 
    pivot_longer(!c(indicador,territorio), names_to = "tipo", values_to = "valor") %>% subset(indicador %in% ordem3) %>%
    mutate(territorio = factor(territorio, levels = ordem),
           tipo = factor(tipo, levels = ordem2),
           indicador = factor(indicador, levels = ordem3),
           ano = i) %>% arrange(territorio, indicador, tipo) %>% select(territorio, indicador, tipo, valor, ano) 
  
  
  capitais_pnt_resultado <- juntos[c(5,4,1)] %>% subset(indicador == "Pop") %>% 
    mutate(territorio = factor(territorio, levels = ordem),
           indicador = factor(indicador, levels = ordem3),
           ano = i) %>% arrange(territorio, indicador) %>% select(territorio, resultado, ano) 
  
  capitais_pnt_resultado2 <- juntos[c(5,4,1)] %>% subset(indicador %in% ordem3) %>% 
    mutate(territorio = factor(territorio, levels = ordem),
           indicador = factor(indicador, levels = ordem3),
           ano = i) %>% arrange(territorio, indicador) %>% select(territorio, resultado, indicador, ano) 
  
  write.xlsx(capitais_dados_upload, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/",i,"/0_consolidado/capitais_dados_upload_",i,".xlsx")) # salvar
  write.xlsx(capitais_pnt_db, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/",i,"/0_consolidado/capitais_pnt_db_",i,".xlsx")) # salvar
  write.xlsx(capitais_pnt_db, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais/capitais_pnt_db_",i,".xlsx")) # salvar
  write.xlsx(capitais_pnt_resultado, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/",i,"/0_consolidado/capitais_pnt_resultado_",i,".xlsx"))
  write.xlsx(capitais_pnt_resultado, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais//capitais_pnt_resultado_",i,".xlsx"))# salvar
  write.xlsx(capitais_pnt_resultado2, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais//capitais_pnt_tipo",i,".xlsx"))# salvar
  
}



files <- list.files(path = "D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais",
                    pattern = "capitais_pnt_db", full.names = TRUE)

files2 <- list.files(path = "D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais",
                     pattern = "capitais_pnt_resultado", full.names = TRUE)

files3 <- list.files(path = "D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais",
                     pattern = "capitais_pnt_tipo", full.names = TRUE)


#ler e juntar
juntos <- do.call("rbind", lapply(files, read.xlsx))

juntos2 <- do.call("rbind", lapply(files2, read.xlsx))

juntos3 <- do.call("rbind", lapply(files3, read.xlsx))

ordem <- c("belem", "belo horizonte", "distrito federal", "curitiba", "fortaleza", "goiania", "porto alegre",
           "recife", "rio de janeiro", "salvador", "sao paulo", "teresina") 

tab_final_1 <- juntos %>% pivot_wider(names_from = ano, values_from = valor) %>% 
  mutate(territorio = factor(territorio, levels = ordem)) %>% 
  arrange(territorio)


tab_final_2 <- juntos2 %>% pivot_wider(names_from = ano, values_from = resultado) %>% 
  mutate(territorio = factor(territorio, levels = ordem)) %>% 
  arrange(territorio)

tab_final_3 <- juntos3 %>% pivot_wider(names_from = ano, values_from = resultado) %>% 
  mutate(territorio = factor(territorio, levels = ordem)) %>% 
  arrange(territorio)



write.xlsx(tab_final_1, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais/tab_final_1.xlsx"))
write.xlsx(tab_final_2, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais/tab_final_2.xlsx"))
write.xlsx(tab_final_3, paste0("D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais/tab_final_3.xlsx"))
