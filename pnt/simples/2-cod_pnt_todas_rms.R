#Passo-a-passo do calculo do PNT
#1. Instalar pacotes e definir diretorio
#2. Abrir arquivos necessarios
#3. Realizar calculo do PNT


#1. Instalar pacotes e definir diretorio ----
#1.1. Instalar pacotes
install.packages('sf')
install.packages('dplyr')
install.packages('readr')
install.packages('openxlsx')
install.packages('pbapply')
install.packages('beepr')
install.packages('stringr')
install.packages('tidyr')


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

# Defnir diretorio
setwd('/Users/mackook/Desktop/R/') #altere o caminho para a pasta onde deseja salvar os arquivos
setwd('E:/R/') #abrir no via HD externo no pc


#2. Abrir arquivos necessarios -----
#2.1. Abrir estacoes 
# Antes de abir o arquivo necessario baixar as estacoes:
   #Neste link http://bit.ly/TMABrasil , acessando o menu 'Fazer download do arquivo kml' e selecionando Mapa inteiro. Necessario abrir, juntar e salvar todas as estacoes no Qgis em shp
   #Para baixar as estacoes ja organizadas em um unico shapefile, ir em https://plataforma.mobilidados.org.br/database e acessar 'Corredores de media e alta capacidade'
estacoes <- st_read('./dados/infra_transporte/tma/2019/estacoes_2019.shp') #inserir o nome do arquivo no qual salvou as estacoes para abri-lo
estacoes$Ano <- as.numeric(as.character(estacoes$Year)) #transforma a coluna de ano em valor numerico

#2.2. Abrir dados dos setores censitarios
#Baixar dados dos setores censitarios na pagina da MobiliDADOS
# Ir em https://mobilidados.org.br/database
# Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
# Baixar tabela de dados
dados <- read_rds('./dados/IBGE/dados_setores/3_tabela_pais/dados_setores.rds') %>% 
  mutate(Cod_setor=as.character(Cod_setor))

#2.3. Definir a regiao metropolitana que sera calculada
#Abrir dados da regiao metropolitana
#Criar tabela de referencia para puxar dados
munis_df <- data.frame(rm = c('rmb','rmbh','rmc','ride','rmf','rmr','rmrj','rms','rmsp'),
                       espg = c(31982,31983,31982,31983,31984,31985,31983,31984,31983))


#3. Realizar calculo do PNT ----
#3.1. Criar Funcao para aplicar PNT
PNT <- function(i, j) {
 
  message(paste0('ola, ', i,'! =)', "\n"))
  print(Sys.time())
  
  message(paste0('abrindo setores...'))
  
  #Abrir setores censitarios
  setores <- read_rds(paste0('./dados/regioes_metropolitanas/setores/setores_', 
                             i, '.rds' )) %>% 
    mutate(Ar_m2 = unclass(st_area(.)), Cod_setor = as.character(Cod_setor))
  setores <- st_transform(setores, 4326) #transforma projecao
  setores <- st_transform(setores, subset(munis_df, rm == i)$espg) #transforma projecao
  setores <- st_buffer(setores,0)
  #Se desejar analisar apenas um municipio da Regiao Metropolitana
  #dados <- dados %>% filter(CD_GEOCODM == 1501402) #altere o codigo para o municipio que deseja analisar, este se refere a Belem
  
  
  message(paste0('abrindo dados dos setores...'))
  
  #Abrir dados censitarios
  # Baixar arquivos dos setores censitarios na pagina da MobiliDADOS
  # Ir em https://mobilidados.org.br/database
  # Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
  dados <- read_rds('./dados/IBGE/dados_setores/3_tabela_pais/dados_setores.rds') %>% 
    mutate(Cod_setor=as.character(Cod_setor))
  
  message(paste0('incluindo dados nos setores ...'))
  
  #Juntar setores com dados censitarios
  setores_dados <- left_join(setores, dados, by = 'Cod_setor') %>% st_sf()
  setores_dados <- setores_dados %>% st_set_precision(1000000) %>% 
    lwgeom::st_make_valid() %>% #corrige shapes que podem possuir algum defeito de feicao
    st_transform(., 4326)
  setores_dados <- st_transform(setores_dados, subset(munis_df, rm == i)$espg) #transforma projecao
  
  message(paste0('filtrando estacoes e criando buffer ...',"\n"))
  
  TMA_estacoes <- estacoes %>% filter(Ano<(j+1), Status =='Operational', RT == 'Yes') #filtra as estacoes de TMA por ano de referencia
  TMA_estacoes<- st_transform(TMA_estacoes, subset(munis_df, rm == i)$espg) #transforma projecao
  TMA_buf <- st_buffer(TMA_estacoes, 1000) %>% st_union  #cria buffer de 1.000 m

  
  message(paste0('recortando setores...',"\n"))
  
  setores_dados <- st_transform(setores_dados, 4326) #transforma projecao
  setores_dados <- st_transform(setores_dados, subset(munis_df, rm == i)$espg) #transforma projecao
  setores_entorno <- st_intersection(setores_dados, TMA_buf) #recorta setores dentro da area de entorno das estacoes
  beep()
  
  setores_entorno <- setores_entorno %>%
    mutate(Ar_int = unclass(st_area(.)), #cria area inserida no entorno da estacao
           rt = as.numeric(Ar_int/Ar_m2)) %>% #cria proporcao entre area inserida no entorno da estacao e area total de cada 
    mutate_at(.vars = vars(Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, M_Negras , M_2SM), 
              funs(int = . * rt))
  
  total_entorno <- c((sum(setores_entorno$Pop_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_0_meio_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_meio_1_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_1_3_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_3_mais_int, na.rm = TRUE)), 
                     (sum(setores_entorno$M_Negras_int, na.rm = TRUE)), 
                     (sum(setores_entorno$M_2SM_int, na.rm = TRUE))) #realiza a soma total de cada variavel
  
  total_rm <- c((sum(setores_dados$Pop, na.rm = TRUE)), 
                (sum(setores_dados$DR_0_meio, na.rm = TRUE)), 
                (sum(setores_dados$DR_meio_1, na.rm = TRUE)), 
                (sum(setores_dados$DR_1_3, na.rm = TRUE)), 
                (sum(setores_dados$DR_3_mais, na.rm = TRUE)), 
                (sum(setores_dados$M_Negras, na.rm = TRUE)), 
                (sum(setores_dados$M_2SM, na.rm = TRUE))) #realiza a soma total de cada variavel
  
  
  Resultados_pnt <-rbind(total_entorno, total_rm, round(100*(total_entorno/total_rm),0))
  colnames(Resultados_pnt)<- c("Pop", "DR_0_meio","DR_meio_1","DR_1_3","DR_3_mais", "M_Negras", "M_2SM") #nomeia as colunas da tabela criada
  row.names(Resultados_pnt)<- c("total_entorno","total_rm", "resultado_%") #nomeia as linhas da tabela criada
  
  message(paste0('e o resultado do PNT eh...',"\n"))
  
  print(Resultados_pnt) #se desejar verficar a tabela, rode esta linha de codigo
  
  message(paste0('ajustando tabela...',"\n"))
  
  Resultados_pnt_final <- as.data.frame(t(Resultados_pnt))
  Resultados_pnt_final$rm <- i
  print(Resultados_pnt_final) #Verfica tabela final
  
  
  beep()
  write.xlsx(Resultados_pnt_final, 
             paste0('./resultados/pnt/', j, '/simples/', i, '_resultados_pnt.xlsx'),
             header = T, col.names = TRUE, row.names = TRUE) #salva os resultados finais na pasta com o nome da RM
  beep()
  print(Sys.time())
  
}

#3.2. Aplicar funcao com o ano escolhido 
#criar lista de codigos de todos os municipios
list_rm <- munis_df$rm

#aplicar funcao para calcular PNT de todas as rms
mapply(PNT,list_rm,2019)

#aplicar funcao para calcular PNT para uma rm
PNT('ride', 2019) #se desejar calcular para outro ano, basta trocar


#4. Juntar em tabela unica para MobiliDADOS database

#4.1. criar tabela unica
#criar lista
files <- list.files(path = './resultados/pnt/2019/simples',
                    pattern = "\\.xlsx$", full.names = TRUE)

ler <- lapply(files, read.xlsx)

#ler e juntar
juntos <- do.call("rbind", lapply(files, read.xlsx))

#salvar
write.xlsx(juntos, './resultados/pnt/2019/simples/consolidado/resultados_rm.xlsx')

#4.2 criar tabela para database
# abrir tabela
todos <- read.xlsx('./resultados/pnt/2019/simples/consolidado/resultados_rm.xlsx')
todos$rm <- as.factor(todos$rm) # transformar coluna de cidades em fator

todos_long <- gather(todos, variavel, valor, 2:4, factor_key=TRUE) # transfomar wide para long
write.xlsx(todos_long, './resultados/pnt/2019/simples/consolidado/resultados_capitais_database.xlsx') # salvar
