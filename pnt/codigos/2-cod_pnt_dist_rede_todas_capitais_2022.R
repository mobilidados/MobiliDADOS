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

# Defnir diretorio
setwd('D:/Projetos/mobilidados/pnt_verificação') #altere o caminho para a pasta onde deseja salvar os arquivos



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

sf_use_s2(FALSE)

 i <- 3304557
 j <- 2022

#3. Realizar calculo do PNT ----
#3.1. Criar Funcao para aplicar PNT
PNT <- function(i, j) {
 
  message(paste0('ola, ', subset(munis_df, code_muni == i)$name_muni,'! =)', "\n"))
  Sys.sleep(3)
  print(Sys.time())
  
  message(paste0('abrindo setores...'))
  
  #Abrir setores censitarios
  setores <- read_rds('./apoio/setores_rms.rds') %>% 
    filter(code_muni == i) %>%
    mutate(Ar_m2 = unclass(st_area(.)), Cod_setor = as.character(Cod_setor))
  setores <- st_transform(setores, 4326) #transforma projecao
  setores <- st_transform(setores, subset(munis_df, code_muni == i)$espg) #transforma projecao
  setores <- st_buffer(setores,0)
  #Se desejar analisar apenas um municipio da Regiao Metropolitana
  #dados <- dados %>% filter(CD_GEOCODM == 1501402) #altere o codigo para o municipio que deseja analisar, este se refere a Belem
  Sys.sleep(3)
  
  message(paste0('abrindo dados dos setores...'))
  
  #Abrir dados censitarios
  # Baixar arquivos dos setores censitarios na pagina da MobiliDADOS
  # Ir em https://mobilidados.org.br/database
  # Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
  dados_cen <- read_rds('D:/Projetos/mobilidados/pnb/dados/BasePNT/dados_setores.rds') %>% 
    mutate(Cod_setor=as.character(Cod_setor))
  
  message(paste0('incluindo dados nos setores ...'))
  
  #Juntar setores com dados censitarios
  setores_dados <- left_join(setores, dados_cen, by = 'Cod_setor') %>% st_sf()
  setores_dados <- setores_dados %>% st_set_precision(1000000) %>% 
    st_make_valid() %>% #corrige shapes que podem possuir algum defeito de feicao
    st_transform(., 4326)
  setores_dados <- st_transform(setores_dados, subset(munis_df, code_muni == i)$espg) #transforma projecao
  
  message(paste0('abrindo buffer ...',"\n"))
  
  TMA_buf <- read_rds(paste0('./output/', j,'/buffer/rds/capitais/', subset(munis_df, code_muni == i)$name_muni, '_buffer_',j, '.rds'))   #buffer com distancia real
  TMA_buf <- st_transform(TMA_buf, 4326)
  TMA_buf <- st_transform(TMA_buf, subset(munis_df, code_muni == i)$espg)
  
  
  
  #### PAREI AQUI!!!!
  
  message(paste0('recortando setores...',"\n"))
  
  # setores_dados <- st_transform(setores_dados, 4326) #transforma projecao
  # setores_dados <- st_transform(setores_dados, subset(munis_df, code_muni == i)$espg) #transforma projecao
  setores_entorno <- st_intersection(setores_dados, TMA_buf) #recorta setores dentro da area de entorno das estacoes
  beep()
  
  setores_entorno <- setores_entorno %>%
    mutate(Ar_int = unclass(st_area(.)), #cria area inserida no entorno da estacao
           rt = as.numeric(Ar_int/Ar_m2)) %>% #cria proporcao entre area inserida no entorno da estacao e area total de cada 
    mutate_at(.vars = vars(Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Negros_Mulher,
                           Negros_Homem, Renda_Mulher_0_1,Renda_Homem_0_1, Renda_Mulher_2SM, 
                           Pessoa_0_1, Pessoa_0_meio, Pessoa_meio_1, Pessoa_1_3, Pessoa_3_mais, homem_branco, mulher_branca,
                           Negros,brancas), 
              funs(int = . * rt))
  
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
                     (sum(setores_entorno$Pessoa_3_mais_int, na.rm = TRUE)),
                     (sum(setores_entorno$homem_branco_int, na.rm = TRUE)),
                     (sum(setores_entorno$mulher_branca_int, na.rm = TRUE)),
                     (sum(setores_entorno$Negros_int, na.rm = TRUE)),
                     (sum(setores_entorno$brancas_int, na.rm = TRUE))) #realiza a soma total de cada variavel
  
  total_rm <- c((sum(setores_dados$Pop, na.rm = TRUE)), 
                (sum(setores_dados$DR_0_meio, na.rm = TRUE)), 
                (sum(setores_dados$DR_meio_1, na.rm = TRUE)), 
                (sum(setores_dados$DR_1_3, na.rm = TRUE)), 
                (sum(setores_dados$DR_3_mais, na.rm = TRUE)), 
                (sum(setores_dados$Negros_Mulher, na.rm = TRUE)), 
                (sum(setores_dados$Negros_Homem, na.rm = TRUE)),
                (sum(setores_dados$Renda_Mulher_0_1, na.rm = TRUE)),
                (sum(setores_dados$Renda_Homem_0_1, na.rm = TRUE)),
                (sum(setores_dados$Renda_Mulher_2SM, na.rm = TRUE)),
                (sum(setores_dados$Pessoa_0_1, na.rm = TRUE)),
                (sum(setores_dados$Pessoa_0_meio, na.rm = TRUE)),
                (sum(setores_dados$Pessoa_meio_1, na.rm = TRUE)),
                (sum(setores_dados$Pessoa_1_3, na.rm = TRUE)),
                (sum(setores_dados$Pessoa_3_mais, na.rm = TRUE)),
                (sum(setores_dados$homem_branco, na.rm = TRUE)),
                (sum(setores_dados$mulher_branca, na.rm = TRUE)),
                (sum(setores_dados$Negros, na.rm = TRUE)),
                (sum(setores_dados$brancas, na.rm = TRUE))) #realiza a soma total de cada variavel
  
  
  Resultados_pnt <-rbind(total_entorno, total_rm, round(100*(total_entorno/total_rm),2))
  colnames(Resultados_pnt)<- c('Pop', 'DR_0_meio', 'DR_meio_1', 'DR_1_3', 'DR_3_mais', 'Negros_Mulher',
                               'Negros_Homem', 'Renda_Mulher_0_1','Renda_Homem_0_1', 'Renda_Mulher_2SM', 
                               'Pessoa_0_1', 'Pessoa_0_meio', 'Pessoa_meio_1', 'Pessoa_1_3', 'Pessoa_3_mais', 
                               "homem_branco", "mulher_branca", "Negros", "brancas") #nomeia as colunas da tabela criada
  row.names(Resultados_pnt)<- c("total_entorno","total_rm", "resultado_%") #nomeia as linhas da tabela criada
  
  message(paste0('e o resultado do PNT eh...',"\n"))
  
  print(Resultados_pnt) #se desejar verficar a tabela, rode esta linha de codigo
  
  message(paste0('ajustando tabela...',"\n"))
  
  Resultados_pnt_final <- as.data.frame(t(Resultados_pnt))
  Resultados_pnt_final$capital <- subset(munis_df, code_muni == i)$name_muni
  Resultados_pnt_final <- tibble::rownames_to_column(Resultados_pnt_final)
  names(Resultados_pnt_final) <- c("indicador", "total_entorno", "total","resultado", "territorio")
  print(Resultados_pnt_final) #Verfica tabela final
  
  
  beep()
  Sys.sleep(3)
  
  write.xlsx(Resultados_pnt_final, 
             paste0('./resultados/', j, '/capitais/', subset(munis_df, code_muni == i)$name_muni, '_resultados_pnt.xlsx'),
             rowNames = FALSE) #salva os resultados finais na pasta com o nome da RM
  Sys.sleep(3)
  
  st_write(select(setores_entorno,
                  code_tract,zone,code_muni,name_muni,name_neighborhood,code_neighborhood,
                  code_subdistrict,name_subdistrict,code_district,name_district,code_state,Cod_setor,
                  Ar_m2,Cod_UF,Nome_da_UF,Cod_RM,Nome_da_RM,Cod_municipio,Nome_do_municipio,Situacao_setor,
                  Tipo_setor,Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Negros_Mulher,
                               Negros_Homem, Renda_Mulher_0_1,Renda_Homem_0_1, Renda_Mulher_2SM, 
                               Pessoa_0_1, Pessoa_0_meio, Pessoa_meio_1, Pessoa_1_3, Pessoa_3_mais, 
                  Negros, brancas),  
           paste0('./output/', j, '/entorno/capitais/shp/', subset(munis_df, code_muni == i)$name_muni, '_entorno.shp'), append = TRUE)
  write_rds(setores_entorno,  
           paste0('./output/', j, '/entorno/capitais/rds/', subset(munis_df, code_muni == i)$name_muni, '_entorno.rds'))
  
  beep()
  Sys.sleep(6)
  
}


pbmapply(safely(PNT),munis_df$code_muni,2021)


#4.1. criar tabela unica
#criar lista
files <- list.files(path = "D:/Projetos/mobilidados/pnt_verificação/resultados/2021/capitais",
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
         ano = 2021) %>% arrange(territorio, indicador, tipo) %>% select(territorio, indicador, tipo, valor, ano) 


capitais_pnt_resultado <- juntos[c(5,4,1)] %>% subset(indicador == "Pop") %>% 
  mutate(territorio = factor(territorio, levels = ordem),
         indicador = factor(indicador, levels = ordem3),
         ano = 2021) %>% arrange(territorio, indicador) %>% select(territorio, resultado, ano) 

write.xlsx(capitais_dados_upload, "D:/Projetos/mobilidados/pnt_verificação/resultados/2021/0_consolidado/capitais_dados_upload_2021.xlsx") # salvar
write.xlsx(capitais_pnt_db, "D:/Projetos/mobilidados/pnt_verificação/resultados/2021/0_consolidado/capitais_pnt_db_2021.xlsx") # salvar
write.xlsx(capitais_pnt_db, "D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais/capitais_pnt_db_2021.xlsx") # salvar
write.xlsx(capitais_pnt_resultado, "D:/Projetos/mobilidados/pnt_verificação/resultados/2021/0_consolidado/capitais_pnt_resultado_2021.xlsx")
write.xlsx(capitais_pnt_resultado, "D:/Projetos/mobilidados/pnt_verificação/resultados/0_geral/capitais//capitais_pnt_resultado_2021.xlsx")# salvar


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
