#Etapa 1: PreparaÃ§Ã£o de dados
###1. Instalar e abrir pacotes necessÃ¡rios
###2. Criar shapefile da RM
###3. Preparar dados demogrÃ¡ficos
###4. Unir os dados com os setores censitarios
###5. Realizar o cÃ¡lculo total de cada variÃ¡vel

#1. Instalar e abrir pacotes necessÃ¡rios --------------
#1.1. Instalar pacotes necessarios
install.packages("sf")
install.packages("openxlsx")
install.packages("tidyverse")
install.packages("readxl")

#1.2. Abrir pacotes necessarios
library(sf)
library(tidyverse)
library(openxlsx)
library(readxl)

#1.3. Definir local para salvar arquivos
setwd("C:/Users/Novo Colaborador/Desktop/Cod_R/PNT/RMS") #altere o caminho para a pasta onde deseja salvar os arquivos

#2. Criar shapefile da RM ---------------------------------------------------------------
#2.1 Importar shapefiles dO IBGE
#Importar shapes dos setores censitarios
download.file("ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_de_setores_censitarios__divisoes_intramunicipais/censo_2010/setores_censitarios_shp/ba/ba_setores_censitarios.zip", "BA_SetorCensitario_2010.zip", quiet = FALSE) #Alterar url conforme Estado da cidade ou regiÃ£o metropolitana desejada. Neste exemplo usamos a Bahia (BA).
unzip("BA_SetorCensitario_2010.zip", exdir="BA_setorcensitario_2010") #extrair arquivos baixando em formato zip

#Importar shapes dos municipios
download.file("ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2018/UFs/BA/ba_municipios.zip", "BA_municipios.zip", quiet = FALSE) #Alterar url conforme Estado da cidade ou regiÃ£o metropolitana desejada. Neste exemplo usamos a Bahia (BA).
unzip("BA_municipios.zip", exdir="BA_municipios") #Extrair arquivos baixados em formato zip

#2.2 Criar shapefiles da RM 
#Criar shape de municipios da RM
setores_ba <- st_read("./BA_setorcensitario_2010", layer="29SEE250GC_SIR") #Abrir municipios do Estado conforme dados baixados na etapa anterior. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn) e o nome do arquivo (layer)
setores_ba$CD_GEOCODM <- as.numeric(as.character(setores_rj$CD_GEOCODM)) #Transformar os dados da coluna de codigos de municipios (CD_GEOCODM) em valores numericos.
#str(setores_ba) #verificar setores do estado
setores_rms <- setores_ba[setores_ba$CD_GEOCODM %in% c("2905701", "2906501","2910057","2916104","2919207","2919926","2921005",
                                                       "2925204","2927408","2929206","2929503","2930709","2933208"), ] #Recortar os municpios do estado para manter somente aqueles inseridos na regiao metropolitana. Quando modificar o Estado, sera necessario alterar os codigos dos municipios que serao recortados. Caso deseje calcular para uma cidade especifica, inserir apenas seu codigo aqui.
#plot(setores_rms) #verificar setores da rm
#str(setores_rms) #verificar setores da rm
st_write(setores_rms, dsn ="./BA_shapes/setores_rms.shp", delete_dsn = TRUE) # Salvar shape dos municipios na pasta. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn). 


#3. Criar tabelas de dados dos setores censitarios ------------------------------------------------------------
#3.1. Importar dados do censo
download.file("ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/BA_20171016.zip", "BA_dados_censo_2010.zip", quiet = FALSE) #Alterar url conforme Estado da cidade ou regiÃ£o metropolitana desejada. Neste exemplo usamos a Bahia (BA).
unzip("BA_dados_censo_2010.zip", exdir="BA_dados_censo_2010") #Extrair arquivos baixados em formato zip

#3.2. Abrir tabelas necessarias
#Antes de abrir as tabelas no R sera necessario transformar as tabelas baixadas de xls para xlsx
basico <- read.xlsx("./BA_dados_censo_2010/BA/Base informa???oes setores2010 universo BA/EXCEL/Basico_BA.xlsx", sheet = 1, colNames = TRUE) #Dados de populacao
Pessoa03 <- read.xlsx("./BA_dados_censo_2010/BA/Base informa???oes setores2010 universo BA/EXCEL/Pessoa03_BA.xlsx", sheet = 1, colNames = T) #Dados de genero
Pessoa05 <- read.xlsx("./BA_dados_censo_2010/BA/Base informa???oes setores2010 universo BA/EXCEL/Pessoa05_BA.xlsx", sheet = 1, colNames = T) #Dados de genero
ResponsavelRenda <- read.xlsx("./BA_dados_censo_2010/BA/Base informa???oes setores2010 universo BA/EXCEL/ResponsavelRenda_BA.xlsx", sheet = 1, colNames = T) #Dados de de renda do responsavel por domicilio
DomicilioRenda <- read.xlsx("./BA_dados_censo_2010/BA/Base informa???oes setores2010 universo BA/EXCEL/DomicilioRenda_BA.xlsx", sheet = 1, colNames = T) #Dados de renda per capita por domicilio
#Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn)

###Verificar estrutura das tabelas (remover)
str(basico)
str(Pessoa03)
str(Pessoa05)
str(ResponsavelRenda)
str(DomicilioRenda)

#3.3. Selecionar dados necessarios
#Dados populacao
basico$pop<-basico$V002 #Criar variavel populaÃ§Ã£o a partir da tabela basico
setores_pop<-basico[,-c(2:33)] #Manter somente dado da populacao
str(setores_pop) #Verificar tabela
write.xlsx(setores_pop, "./BA_dados_tratados/BA_setores_pop.xlsx") #Salvar tabela. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn). 

#Dados mulheres
Pessoa05 <- Pessoa05[,-c(2:8,10,12)]#Manter somente dados necessarios na tabela Pessoa05
str(Pessoa05) #remover
Pessoa03 <- Pessoa03[,-c(2:169, 248:253, 171, 173:174, 176, 178:179, 181, 183:184, 186, 188:199, 201, 203:204, 206, 208:209, 211, 213:214, 216, 218:219, 221, 223:224, 226, 228:229, 231, 233:234, 236, 238:239, 241, 243:244, 246, 248:249, 251)]#manter somente dados necessarios na tabela Pessoa03
str(Pessoa03) #remover
tabela_mulheres_negras = merge(Pessoa05, Pessoa03, by="Cod_setor") #Criar tabela unica com dados de mulheres negras
tabela_mulheres_negras <-as.data.frame(sapply(tabela_mulheres_negras, as.numeric)) #Transformar todas as colunas em valores numericos
tabela_mulheres_negras$Mulheres_negras <- rowSums(tabela_mulheres_negras[,2:31]) #Criar nova coluna com a soma total de mulheres negras
setores_mulheres_negras <- tabela_mulheres_negras[,-c(2:31)] #Manter somente dados necessarios
str(setores_mulheres_negras) #Verificar estrutura da tabela - remover
write.xlsx(setores_mulheres_negras, "./BA_dados_tratados/BA_setores_mulheres_negras.xlsx") #Salvar tabela final. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn). 

#Dados mulheres com renda ate 2 salarios minimos (SM) responsaveis por domicilio
ResponsavelRenda <-ResponsavelRenda[,-c(3:46, 50:134)] #Manter somente dados necessarios na tabela ResponsavelRenda
ResponsavelRenda <- as.data.frame(sapply(ResponsavelRenda, as.numeric)) #Transformar todas as colunas em valores numericos
str(ResponsavelRenda) #verificar estrutura da tabela - remover
ResponsavelRenda$Mulheres_RR_ate_2SM <- rowSums(ResponsavelRenda[,3:5]) #Criar nova coluna com a soma total de mulheres com renda ate 2 SM responsaveis por domicilio
setores_rr <- ResponsavelRenda[,-c(2:5)]#Manter somente dados necessarios
str(setores_rr) #verif - remover
write.xlsx(setores_rr, "./BA_dados_tratados/BA_setores_rr.xlsx") #Salvar tabela final. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn). 

#Dados renda per capita por domicilio 
#O codigo abaixo transforma valores em numeros e muda a ordem das colunas para facilitar calculos, importante rodar o codigo nesta ordem
DomicilioRenda$V5 <- as.numeric(DomicilioRenda$V005)
DomicilioRenda$V6 <-  as.numeric(DomicilioRenda$V006)
DomicilioRenda$V7 <-  as.numeric(DomicilioRenda$V007)
DomicilioRenda$V14 <-  as.numeric(DomicilioRenda$V014)
DomicilioRenda$V8 <- as.numeric(DomicilioRenda$V008)
DomicilioRenda$V9 <- as.numeric(DomicilioRenda$V009)
DomicilioRenda$V10 <- as.numeric(DomicilioRenda$V010)
DomicilioRenda$V11 <- as.numeric(DomicilioRenda$V011)
DomicilioRenda$V12 <- as.numeric(DomicilioRenda$V012)
DomicilioRenda$V13 <- as.numeric(DomicilioRenda$V013)
DomicilioRenda<-DomicilioRenda[,-c(2:16)] #Manter somente dados necessarios
str(DomicilioRenda) #verificar estrutura da tabela - remover

#Calcular variaveis por faixa de renda
DomicilioRenda$DR_0_meio <- rowSums(DomicilioRenda[,2:5]) #Domicilios com renda per capita de 0 a meio SM
DomicilioRenda$DR_meio_1 <- DomicilioRenda$V8 #Domicilios com renda per capita de meio a 1 SM
DomicilioRenda$DR_1_3 <- rowSums(DomicilioRenda[7:8]) #Domicilios com renda per capita de 1 a 3 SM
DomicilioRenda$DR_3_mais <- rowSums(DomicilioRenda[9:11]) #Domicilios com renda per capita acima de 3 SM
str(DomicilioRenda) #verificar resultados - remover
setores_dr <- DomicilioRenda[,-c(2:11)] #verificar estrutura da tabela- remover
str(setores_dr) #verificar resultados - remover
write.xlsx(setores_dr, "./BA_dados_tratados/BA_setores_dr.xlsx") #Salvar tabela final. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn). 

#Verificar estrutura de todas as tabelas criadas - avaliar deposi de rodar codigo
str(setores_pop)
str(setores_rr)
str(setores_mulheres_negras)
str(setores_dr)

#3.4. Unir dados em tabela populacao e renda
tabela_pop_rr = merge(setores_pop, setores_rr, by="Cod_setor") #Unir tabela com dados de populacao com tabela com dados de responsavel e renda
tabela_pop_rr_dr = merge(tabela_pop_rr, setores_dr, by="Cod_setor") #Unir tabela anterior com tabela com dados de domicilio e renda
setores_pop_rr_dr_mneg = merge(tabela_pop_rr_dr, setores_mulheres_negras, by="Cod_setor") #Unir tabela anterior com dados de mulheres negras, resultando em tabela final dos dados demograficos
str(setores_pop_rr_dr_mneg) # Verificar estrutura da tabela final

#4. Unir os dados com os setores censitarios -----------------------------------------
setores_rms$Cod_setor<- as.numeric(as.character(setores_rms$CD_GEOCODI)) #Transformar os dados da coluna de codigos de municipios (CD_GEOCODI) em valores numerico
str(setores_rms) #remover
setores_dados <- left_join(setores_rms, setores_pop_rr_dr_mneg, by="Cod_setor") #Unir shapefile dos setores censitarios com tabela final dos dados demograficos
str(setores_dados) #remover
st_write(setores_dados, dsn ="./BA_shapes/setores_dados_rms.shp", delete_dsn = TRUE) #Salvar tabela final. Quando modificar o Estado sera necessario alterar o caminho da pasta onde estÃ£o os dados (dsn). 

#5. Realizar o cÃ¡lculo total de cada variÃ¡vel ----------------------------------------------------
total_rm<- c((sum(setores_dados$Pop, na.rm = TRUE)), 
             (sum(setores_dados$DR_0_meio, na.rm = TRUE)), 
             (sum(setores_dados$DR_meio_1, na.rm = TRUE)), 
             (sum(setores_dados$DR_1_3, na.rm = TRUE)), 
             (sum(setores_dados$DR_3_mais, na.rm = TRUE)), 
             (sum(setores_dados$Mulheres_negras, na.rm = TRUE)), 
             (sum(setores_dados$Mulheres_RR_ate_2SM, na.rm = TRUE))) #Realizar a soma total de cada variavel
Resultados_rm<-rbind(total_rm) #Criar uma tabela com as variaveis criadas na linha anterior
colnames(Resultados_rm)<- c("Pop", "DR_0_meio","DR_meio_1",
                            "DR_1_3","DR_3_mais","M_Negras","M_RR_ate_2SM") #Nomear as colunas da tabela criada
print(Resultados_rm) #Visualizar resultado final

####------------------------------- Fim da Etapa 1 -------------------------------------------
