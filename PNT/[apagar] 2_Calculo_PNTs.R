#Visao Geral
  ###1. Instalar e abrir pacotes necessarios
  ###2. Importação dos dados demograficos e de estacoes de TMA
  ###3. Criar a area no entorno das estacoes de TMA e recortar os setores censitarios inseridos nesta area
  ###4. Calcular os dados totais de cada variável para a RM/Cidade e os dados dentro da area no entorno das estacoes
  ###5. Realizar calculo final dos indicadores de PNT com as variaveis criadas nos passos anteriores.


#1. Instalar e abrir pacotes necessarios

#1.1. Instalar pacotes necessários
install.packages("sf")
install.packages("tidyverse")
install.packages("openxlsx")

#.2. Abrir pacotes necessários
library(sf)
library(tidyverse)
library(openxlsx)


#1.3. Definir local para salvar arquivos
setwd("C:/Users/Novo Colaborador/Desktop/Cod_R/")

#2. Importação dos dados demograficos e de estacoes de TMA --------------------------------------------------------------

#2.1. Importar shapefiles necessários
TMA_stations <- st_read("./PNT/Estações 2018/RMS/RMS_Stations_RT_2018.shp") #Abrir shape de estacoes de TMA
Setores <- st_read("./PNT/RMS/BA_shapes/setores_dados_rms.shp") #Abrir shape de setores censitarios com dados criado no codigo anterior

#Verificar projecao dos shapes
(st_crs(TMA_stations) ==  st_crs(Setores))

#Reprojetar shapes, somente se necessario
TMA_stations <- st_transform(TMA_stations, 31983)
Setores <- st_transform(Setores, 31983)
(st_crs(TMA_stations) ==  st_crs(Setores))

#Verificar visualizacao dos arquivos importados - remover
plot(TMA_stations)
plot(Setores)

#verificar estrutura dos arquivos importados - remover
str(TMA_stations)
str(Setores)

#3. Criar a área no entorno das estações de TMA e recortar os setores censitarios inseridos nesta área ------------------------------------------------

#3.1. Criar buffer a partir das estacoes e dissolver
TMA_buf_1000m <- st_buffer(TMA_stations, dist = 1000) %>% st_union() #Criar buffer de 1000m no entorno das estacoes
st_write(TMA_buf_1000m, dsn = "/PNT/RMS/BA_shapes/TMA_buf_1000m.shp", delete_dsn = TRUE) #Salvar arquivos, se desejado
plot(TMA_buf_1000m) #Verificar arquivo de buffer criado
Setores$Ar <- as.numeric(st_area(Setores)) #Criar coluna com area dos setores censitarios em m2 

#3.2. Recortar setores censitarios pela area do buffer
Setores_1000m <- st_intersection(st_buffer(Setores, 0), TMA_buf_1000m)
st_write(Setores_1000m, dsn = "./PNT/RMS/BA_shapes/Setores_1000m.shp", delete_dsn = TRUE) #Salvar setores recortados - se desejado


#4. Calcular os dados totais de cada variável para a RM/Cidade e os dados dentro da area no entorno das estações --------------------------------------------------------------------

#Calcular total de cada variável na RM
#pop: populacao
#DR_0_meio: domicilios com renda per capita até meio salario minimo
#DR_meio_1: domicilios com renda per capita entre meio e 1 salario minimo
#DR_1_3: domicilios com renda per capita entre 1 e 3 salarios minimos
#DR_3_mais: domicilios com renda per capita acima de 3 salarios minimos
#Mulheres_negras: mulheres negras 
#Mulheres_RR_ate_2SM: mulherescom renda abaixo de 2 salarios minimos responsáveis de domicilios 

#4.1. Calcular dados totais da RM
Total_dados_setores<- c((sum(Setores$pop, na.rm = TRUE)), 
                        (sum(Setores$DR_0_me, na.rm = TRUE)), 
                        (sum(Setores$DR_me_1, na.rm = TRUE)), 
                        (sum(Setores$DR_1_3, na.rm = TRUE)), 
                        (sum(Setores$DR_3_ms, na.rm = TRUE)), 
                        (sum(Setores$Mlhrs_n, na.rm = TRUE)), 
                        (sum(Setores$M_RR__2, na.rm = TRUE))) #Realizar a soma total de cada variavel
Total_dados_setores<-rbind(Total_dados_setores)#Criar uma tabela com as variaveis criadas na linha anterior
colnames(Total_dados_setores)<- c("pop","DR_0_meio","DR_meio_1","DR_1_3",
                                  "DR_3_mais","M_Negras","M_RR_ate_2SM")#Criar uma tabela com as variaveis criadas na linha anterior
print(Total_dados_setores) #Visualizar resultados



#4.2. Calcular dados na area de influencia do buffer
#Criar colunas com dados inseridos no buffer de 1000m
  #coluna rt: proporcao do setores censitarios inseridos na area coberta pelo buffer no entorno da estacao
  #colunas XX_int: quantidade de cada variavel (pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, M_Negras, M_RR_ate_2SM) inserida na area de cobertura do buffer 
Setores_1000m  <-
  Setores_1000m %>%
  mutate(Ar_int = unclass(st_area(.)),
         rt = as.numeric(Ar_int/Ar)) %>%
  mutate_at(.vars = vars(pop, DR_0_me, DR_me_1, DR_1_3, DR_3_ms, Mlhrs_n, M_RR__2), 
            funs(int = . * rt))#Funcao para criar coluna rt e colunas com total de cada variavel demografica inserida na area no entorno das estacoes
str(Setores_1000m) #verificar estrutura do arquivo

#Calcular total de cada variavel na area de influencia
total_1000m<- c((sum(Setores_1000m$pop_int, na.rm = TRUE)), 
                (sum(Setores_1000m$DR_0_me_int, na.rm = TRUE)), 
                (sum(Setores_1000m$DR_me_1_int, na.rm = TRUE)), 
                (sum(Setores_1000m$DR_1_3_int, na.rm = TRUE)), 
                (sum(Setores_1000m$DR_3_ms_int, na.rm = TRUE)), 
                (sum(Setores_1000m$Mlhrs_n_int, na.rm = TRUE)), 
                 (sum(Setores_1000m$M_RR__2, na.rm = TRUE)))#Realizar a soma total de cada variavel
Resultados_1000m<-rbind(total_1000m)#Criar uma tabela com as variaveis criadas na linha anterior
colnames(Resultados_1000m)<- c("Pop_int", "DR_0_meio_int","DR_meio_1_int",
                              "DR_1_3_int","DR_3_mais_int","M_Negras_int","M_RR_ate_2SM_int")#Nomear as colunas da tabela criada
print(Resultados_1000m)

#verificar coerencia dos calculos - se desejado
plot(Setores_1000m$rt)
plot(Setores_1000m$geometry)
hist(Setores_1000m$rt)


#5. Realizar cálculo final dos indicadores de PNT com as variáveis criadas nos passos anteriores -------------------------------------------------------------------------

Resultados_RM<-rbind(Resultados_1000m, Total_dados_setores, 100*(Resultados_1000m/Total_dados_setores))#Unir tabelas com dados agregados
colnames(Resultados_RM)<- c("pop", "DR_0_meio","DR_meio_1","DR_1_3","DR_3_mais","M_Negras","M_RR_ate_2SM_int")#Nomear as colunas da tabela criada
row.names(Resultados_RM)<- c("1000m_buf", "total_setores","%_1000m_buf")#Nomear as linhas da tabela criada
print(Resultados_RM) #verficar tabela
write.xlsx(Resultados_RM,"./PNT/RMS/Resultados_RMS.xlsx") #salvar arquivo final


#### ----------------------- Fim da Etapa 2 --------------------------------------
