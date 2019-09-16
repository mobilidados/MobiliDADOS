#Passo a passo do codigo para calcular PNT
###1. Instalar e abrir pacotes necessarios
###2. Definir local para salvar arquivos e criar tabela de referencia
###3. Preparar dados demograficos
###4. Preparar dados dos corredores de transporte
###5. Realizar calculo do PNT

###1. Instalar e abrir pacotes necessarios ----------------------------------------------------------------------------
#1.1. Instalar pacotes necessarios
install.packages("sf")
install.packages("readr")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("mapview")
update.packages("geobr")
update.packages("pbapply")
install.packages("data.table")
install.packages("openxlsx")
install.packages("bit64")

#1.2. Abrir pacotes necessarios
library(sf)
library(readr)
library(tidyverse)
library(dplyr)
library(mapview)
library(geobr)
library(pbapply)
library(data.table)
library(openxlsx)
library(bit64)


###2. Definir local para salvar arquivos e criar tabela de referencia --------------------------------------------------

#2.1. Definir local para salvar arquivos
setwd('/Users/mackook/Desktop/Treinamento_MDR') #Alterar o caminho para a pasta onde deseja salvar os arquivos

#2.2 Criar tabela de cidades da RM que sera analisada
munis_df <- data.frame(code_muni = c(1500800,1501402,1501501,1502400,1504422,1506351,1506500),
                       name_muni=c('ananindeua','belém','benevides','castanhal','marituba','santa bárbara do pará','santa izabel do pará'),
                       abrev_state=c('PA','PA','PA','PA','PA','PA','PA'),
                       rm=c('rmb','rmb','rmb','rmb','rmb','rmb','rmb'),
                       espg = c(31982,31982,31982,31982,31982,31982,31982),
                       shp = c('RM_Belem','RM_Belem','RM_Belem','RM_Belem',
                               'RM_Belem','RM_Belem','RM_Belem'))

#2.3. Criar pastas para salvar arquivos
lapply( paste0('./', unique(munis_df$rm)), dir.create) #cria pasta da rm
lapply( paste0('./', unique(munis_df$rm), '/municipios'), dir.create) #cria pasta do municipio
lapply( paste0('./', unique(munis_df$rm), '/setores'), dir.create) #cria pasta do setor

###3. Preparar dados demograficos ------------------------------------------------------------------------------------------
#3.1. Fazer download de shapefiles dos municipios e setores censitarios ----------------------------------------------------

download_municipios_setores <- function(i){
  
  message(paste0('baixando dados ', subset(munis_df, code_muni==i)$name_muni,"\n")) #aplica mensagem para identificar municipios que esta sendo baixado
  
  # Download de arquivos
  muni_sf <- geobr::read_municipality(code_muni=i, year=2010) #download do shape do municipio
  ct_sf <- geobr::read_census_tract(code_tract=i, year=2010) #download do shape do setor censitario
  
  # salvar municipios
  readr::write_rds(muni_sf, paste0('./', subset(munis_df, code_muni==i)$rm, '/municipios/municipio_', subset(munis_df, code_muni==i)$name_muni,'.rds')) #salva arquivo do municipio
  
  # salvar setores censitarios
  readr::write_rds(ct_sf, paste0('./', subset(munis_df, code_muni==i)$rm, '/setores/setores_', subset(munis_df, code_muni==i)$name_muni,'.rds')) #salva arquivo do setor
  
} #funcao para fazer download dos municipios e setores censitarios

juntar_municipios_por_rm <- function (i) {
  
  files <- list.files(path = paste0('./', subset(munis_df, code_muni==i)$rm, '/municipios'),
                      pattern = "\\.rds$", full.names = TRUE) #cria lista com todos os arquivos na pasta municipios
  
  juntos <- do.call("rbind", lapply(files, read_rds)) #le e junta arquivos da pasta municipios 
  readr::write_rds(juntos, paste0('./', subset(munis_df, code_muni==i)$rm, '/municipios/municipios_',subset(munis_df, code_muni==i)$rm,'.rds')) #salva arquivo com todos os municipios
  
} #funcao para juntar municipios da mesma regiao metropolitana

juntar_setores_por_rm <- function (i) {
  
  files <- list.files(path = paste0('./', subset(munis_df, code_muni==i)$rm, '/setores'),
                      pattern = "\\.rds$", full.names = TRUE) #cria lista com todos os arquivos na pasta setores
  
  juntos <- do.call("rbind", lapply(files, read_rds)) #le e junta arquivos da pasta setores
  
  #salvar
  readr::write_rds(juntos, paste0('./', subset(munis_df, code_muni==i)$rm, '/setores/setores_',subset(munis_df, code_muni==i)$rm,'.rds')) #salva arquivo com todos os setores
  
} #funcao para juntar setores censitarios da mesma regiao metropolitana

#aplicar as funcoes 
list_muni_codes <- munis_df$code_muni #criar lista de municipios para aplicar as funcoes

pblapply(list_muni_codes, download_municipios_setores) #aplicar funcao para fazer download dos municipios e setores censitarios
pblapply(list_muni_codes, juntar_municipios_por_rm) #aplicar funcao para juntar municipios
pblapply(list_muni_codes, juntar_setores_por_rm) #aplicar funcao para juntar setores censitarios

# Testar visualizacao
setores_rm <- read_rds(paste0('./', unique(munis_df$rm), '/setores/setores_', unique(munis_df$rm), '.rds')) #abre setores da rm
munis_rm <- read_rds(paste0('./', unique(munis_df$rm), '/municipios/municipios_', unique(munis_df$rm), '.rds')) #abre munis da rm
mapview(munis_rm) #visualiza municipios da rm
mapview(setores_rm) #visualiza setores da rm

#3.2. Preparar dados do censo ----------------------------------------------------------------------------------------------
#3.2.1. Abrir dados do censo e selecionar variaveis mais importantes
dados <- data.table::fread ('./dados/dados_censo2010A.csv',
                            select=c('Cod_UF', 'Cod_municipio', 'Cod_setor', 'DomRend_V003', 'BA_V002',
                                     'Dom2_V002', 'Pess3_V002','Pess3_V003', 'Pess3_V004', 'Pess3_V005', 
                                     'Pess3_V006','Pess3_V168', 'Pess3_V170', 'Pess3_V173', 'Pess3_V175', 
                                     'Pess3_V178','Pess3_V180', 'Pess3_V183', 'Pess3_V185', 'Pess3_V198', 
                                     'Pess3_V200','Pess3_V203', 'Pess3_V205', 'Pess3_V208', 'Pess3_V210', 
                                     'Pess3_V213','Pess3_V215', 'Pess3_V218', 'Pess3_V220', 'Pess3_V223', 
                                     'Pess3_V225','Pess3_V228', 'Pess3_V230', 'Pess3_V233', 'Pess3_V235', 
                                     'Pess3_V238','Pess3_V240', 'Pess3_V243', 'Pess3_V245', 'Pess5_V007', 
                                     'Pess5_V009','RespRend_V045','RespRend_V046', 'RespRend_V047', 'DomRend_V005',
                                     'DomRend_V006', 'DomRend_V007', 'DomRend_V008', 'DomRend_V009', 'DomRend_V010',
                                     'DomRend_V011', 'DomRend_V012', 'DomRend_V013', 'DomRend_V014')) #abre tabela dados censo somente com dados necessarios

#3.1.2. Calcular variaveis necessarias
dados$Pop <- as.numeric(dados$BA_V002) #Cria coluna com populacao
dados$Renda_total <- as.numeric(dados$DomRend_V003) #Cria coluna com renda total
dados$Renda_per_capita <- as.numeric(dados$Renda_total/dados$Pop) #Cria coluna com renda per capita
dados$DR_0_meio <- rowSums(cbind(dados$DomRend_V005, dados$DomRend_V006,dados$DomRend_V007, dados$DomRend_V014)) #Cria coluna com domicilios com renda per capita  ate 1/2 salario minimo
dados$DR_meio_1 <- as.numeric(dados$DomRend_V008) #Cria coluna com domicilios com renda per capita entre 1/2 e 1 salario minimo
dados$DR_1_3 <- rowSums(cbind(dados$DomRend_V009, dados$DomRend_V010)) #Cria coluna com domicilios com renda per capita entre 1 e 3 salarios minimos
dados$DR_3_mais <- rowSums(cbind(dados$DomRend_V011, dados$DomRend_V012, dados$DomRend_V013))  #Cria coluna com domicilios com renda per capita acima de 3 salarios minimos
dados$Mulheres_negras <- rowSums(dados[,12:41]) #Cria coluna de mulheres negras
dados$Mulheres_RR_2_SM <- rowSums(dados[,42:44]) #Cria coluna de mulheres com renda ate 2 salarios minimos responsaveis por domicilio

names(dados) # mostra nome das colunas da base dade dados
str(dados) # mostra estrutura da base dade dados
dados_pnt <- dados[,-c(4:54)] #mantem somente colunas necessarias
names(dados_pnt) # mostra nome das colunas da base dade dados
str(dados_pnt) # mostra estrutura da base dade dados
dados_pnt$Cod_setor <- as.character(dados_pnt$Cod_setor) #transforma em valor numerico

write_rds(dados_pnt, './dados/dados_pnt_v2.rds') #salva tabela com dados demograficos

###4. Preparar dados dos corredores de transporte ---------------------------------------------------------------------------

#4.1. Abrir estacoes de transporte mapeadas pelo ITDP -----------------------------------------------------------------------
# Antes de abir o arquivo necessario:
#Baixar o kml de todas as estacoes em https://www.google.com/maps/d/viewer?mid=1iQ9q4KBuH2T2O0972VURU_Ak76s&ll=-22.891436518219443%2C-43.19333559145247&z=10
#Abrir, juntar e salvar todas as estacoes no Qgis
Estacoes <- st_read('./dados/tma/Estacoes_2018.shp') 

#4.2. Selecionar apenas estacoes de transporte de media e alta capacidade ---------------------------------------------------
TMA_estacoes <- Estacoes %>% mutate(ID = row_number()) %>% 
  filter(RT=='Yes', Status=='Operational') # seleciona apenas estacoes de transporte de meida e alta capacidade
write_rds(TMA_estacoes, './dados/tma/TMA_Estacoes_2018.rds') #salva estacoes TMA

#visualizar mapa e tabela de atributos
mapview(TMA_estacoes) #visualiza arquivo criado
str(TMA_estacoes)

###5. Realizar calculo do PNT -----------------------------------------------------------------------------------------------
#5.1. Definir Regiao Metropolitana onde o calculo sera realizado ------------------------------------------------------------

# Para realizar os calculos deve-se reprojetar os setores e buffer para o mesmo sistema de projecao geografica
# Para isso usamos o EPSG, da sigla Sigla para do Grupo Europeu de Pesquisa Petrolifera (European Petroleum Survey Group), 
# que foi a entidade que organizou por meio desses codigos numericos os Sistemas de Referencia de Coordenadas (SRC) do mundo. 
# Os EPSG das regioes metropolitanas e capitais presentes da MobiliDADOS estao detalhadas a seguir: 
# EPSG 31983 para Belo Horizonte, Distrito Federal, Rio De Janeiro e Sao Paulo. 
# EPSG 31985 para Recife.
# EPSG 31982 para Belem e Curitiba.
# EPSG 31984 para Fortaleza e Salvador.
# Neste caso usamo a RM de Belém por meio do munis_df que rodamos no 2.2


#5.2. Quando e uma RM nova, e necessario juntar setores e dados reprojetar -------------------------------------------------------------------------------------

# Baixar arquivos dos setores censitarios na pagina da MobiliDADOS
# Ir em https://mobilidados.org.br/database
# Acessar pasta 'Dados das regiões metropolitanas por setor censitário'
# Baixar a região metropolitana desejada na pasta do drive e salvar na pasta dados

junta_rm_c_dados <- function(sigla) {
  
  message(paste0('leitura ', sigla)) #aplica mensagem para identificar rm que esta sendo lida
  
  setores_rm <- st_read(paste0('./dados/setores/', unique(munis_df$shp), '/', unique(munis_df$shp), '_setores.shp')) %>%
    st_transform(., as.numeric(unique(munis_df$espg))) %>% #transforma epsg
    rename(Cod_setor = Cod_str, Situacao_setor = Stc_str) %>% #transforma coluna em caractere
    mutate(Cod_setor = as.character(Cod_setor))
  
  message(paste0('leitura de dados')) 
  
  dados_pnt_rm <- read_rds('./dados/dados_pnt_v2.rds')%>% #abre tabela de dados
    filter(Cod_municipio %in% c(munis_df$code_muni)) %>% #filtra somente municipios necessarios
    mutate(Cod_setor = as.character(Cod_setor)) #transforma coluna em caractere
  
  message(paste0('unindo setores e dados')) 
  
  setores_rm_dados <- left_join(setores_rm, dados_pnt_rm, by = 'Cod_setor') #une setores com dados
  setores_rm_dados[is.na(setores_rm_dados)] <- 0 #elimina valores N/A
  
  message(paste0('salvando arquivos finais')) 
  
  write_rds(setores_rm_dados, paste0('./dados/setores/', unique(munis_df$shp), '/setores_', (unique(munis_df$rm)), '_dados.rds')) #salva setores com dados
  #st_write(setores_rm_dados, paste0('./', sigla, '/RM_Salvador_dados_setores_censitários_WGS84.shp')) #salva setores com dados
  
} #funcao para abrir e juntar setores

#aplicar funcao para juntar setores
junta_rm_c_dados(unique(munis_df$rm))

#Criar buffer de 1000m no entorno das estacoes
TMA_estacoes <- st_transform(TMA_estacoes, unique(munis_df$espg)) #transforma na espg da regiao metropolitana
TMA_buf_1000m <- st_buffer(TMA_estacoes, 1000)%>% st_union #cria buffer de 1000m, aqui podemos mostrar como usar distancia real
mapview(TMA_buf_1000m) #visualizacao do buffer

#Pegar dados no entorno das estacoes
setores_rm_dados <- read_rds(paste0('./dados/setores/', unique(munis_df$shp), '/setores_', unique(munis_df$rm), '_dados.rds')) %>% st_sf() #abre arquivo setores com dados
setores_rm_dados_1000m <- st_intersection(setores_rm_dados, TMA_buf_1000m) #corta setores pelo buffer
mapview(setores_rm_dados_1000m) #vizualiza arquivo de setores


#5.3. Calcular dados na area de influencia do area no entorno das estacoes -------------------------------------------------------

#Calcular total de cada variavel na regiao metropolitana
total_rm <- c((sum(setores_rm_dados$Pop, na.rm = TRUE)), 
              (sum(setores_rm_dados$DR_0_meio, na.rm = TRUE)), 
              (sum(setores_rm_dados$DR_meio_1, na.rm = TRUE)), 
              (sum(setores_rm_dados$DR_1_3, na.rm = TRUE)), 
              (sum(setores_rm_dados$DR_3_mais, na.rm = TRUE)), 
              (sum(setores_rm_dados$Mulheres_negras, na.rm = TRUE)), 
              (sum(setores_rm_dados$Mulheres_RR_2_SM, na.rm = TRUE))) #Realizar a soma total de cada variavel

#Calcular total de cada variavel na area de entorno das estacoes de TMA

#Criar variaveis no entorno das estacoes
setores_rm_dados_1000m <- setores_rm_dados_1000m %>%
  mutate(ar_int = unclass(st_area(.)), #cria area inserida no entorno da estacao
         rt = as.numeric(ar_int/ar_m2)) %>% #cria proporcao entre area inserida no entorno da estacao e area total de cada 
  mutate_at(.vars = vars(Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, Mulheres_negras , Mulheres_RR_2_SM), 
            funs(int = . * rt)) #Criar coluna com proporcao entre area coberta no entorno das estacoes e colunas com total de cada variavel demografica inserida na area no entorno das estacoes

#Calcula total de cada variavel
total_entorno <- c((sum(setores_rm_dados_1000m$Pop_int, na.rm = TRUE)), 
                   (sum(setores_rm_dados_1000m$DR_0_meio_int, na.rm = TRUE)), 
                   (sum(setores_rm_dados_1000m$DR_meio_1_int, na.rm = TRUE)), 
                   (sum(setores_rm_dados_1000m$DR_1_3_int, na.rm = TRUE)), 
                   (sum(setores_rm_dados_1000m$DR_3_mais_int, na.rm = TRUE)), 
                   (sum(setores_rm_dados_1000m$Mulheres_negras_int, na.rm = TRUE)), 
                   (sum(setores_rm_dados_1000m$Mulheres_RR_2_SM_int, na.rm = TRUE))) #Realizar a soma total de cada variavel

#5.4. Resultado Final ------------------------------------------------------------------------------------------------------------
Resultados_rm <-rbind(total_entorno, total_rm, round(100*(total_entorno/total_rm))) # cria tabela unica
colnames(Resultados_rm)<- c("pop", "DR_0_meio","DR_meio_1","DR_1_3","DR_3_mais","Mulheres_Negras","Mulheres_RR_ate_2SM") #Nomear as colunas da tabela criada
row.names(Resultados_rm)<- c("total_entorno", "total_rm","resultado_%") #Nomeia as linhas da tabela criada
print(Resultados_rm) #Verfica tabela, se desejado

write.xlsx(Resultados_rm,paste0('./', unique(munis_df$rm),'/pnt_resultados.xlsx')) #salva resultado final
