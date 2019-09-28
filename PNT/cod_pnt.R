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
install.packages('lwgeom')
install.packages('mapview')

#1.2 Abrir pacotes
library(sf)
library(dplyr)
library(readr)
library(openxlsx)
library(lwgeom)
library(mapview)

# Defnir diretorio
setwd('/Users/mackook/Desktop/Tutorial_PNT') #altere o caminho para a pasta onde deseja salvar os arquivos


#2. Abrir arquivos necessarios ----

#2.1. Definir a regiao metropolitana que sera calculada
#Abrir dados da regiao metropolitana
#Criar tabela de referencia para puxar dados
munis_df <- data.frame(code_muni = c(1500800,1501402,1501501,1502400,1504422,1506351,1506500),
                       name_muni=c('ananindeua','belem','benevides','castanhal','marituba','santa barbara do para','santa izabel do para'),
                       rm=c('rmb','rmb','rmb','rmb','rmb','rmb','rmb'),
                       espg = c(31982,31982,31982,31982,31982,31982,31982))
#As tabelas para as 9 regioes metropolitanas estao disponiveis na paginas do GITHUB da MobiliDADOS

#2.2. Abrir estacoes 
# Antes de abir o arquivo necessario baixar as estacoes:
   #Neste link http://bit.ly/TMABrasil , acessando o menu 'Fazer download do arquivo kml' e selecionando Mapa inteiro. Necessario abrir, juntar e salvar todas as estacoes no Qgis em shp
   #Para baixar as estacoes ja organizadas em um unico shapefile, ir em https://mobilidados.org.br/database e acessar 'Corredores de media e alta capacidade'
estacoes <- st_read('./estacoes/estacoes_2018.shp') #inserir o nome do arquivo no qual salvou as estacoes para abri-lo
estacoes$Ano <- as.numeric(as.character(estacoes$Year)) #transforma a coluna de ano em valor numerico

##2.2. Abrir setores e juntar com dados
# Baixar arquivos dos setores censitarios na pagina da MobiliDADOS
   # Ir em https://mobilidados.org.br/database
   # Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
setores <- read_rds(paste0('./', unique(munis_df$rm), '/setores_', unique(munis_df$rm), '.rds')) %>% st_sf() #inserir o nome do arquivo no qual salvou os setores para abri-lo
setores <- setores %>% st_set_precision(1000000) %>% lwgeom::st_make_valid() #corrigir shapes que podem possuir algum defeito de feicao
#Se desejar analisar apenas um municipio da Regiao Metropolitana
#dados <- dados %>% filter(CD_GEOCODM == 1501402) #altere o codigo para o municipio que deseja analisar, este se refere a Belem

#Baixar dados dos setores censitarios na pagina da MobiliDADOS
# Ir em https://mobilidados.org.br/database
# Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
# Baixar tabela de dados
dados <- read.xlsx('./dados_ibge/dados_censo.xlsx') %>% mutate(Cod_setor=as.character(Cod_setor))

#Unir setores com dados do IBGE
setores_dados <- left_join(setores, dados, by = 'Cod_setor') %>% st_sf()
names(setores_dados)

#3. Realizar calculo do PNT ----

#3.1. Criar Funcao para aplicar PNT

PNT_ano <- function(i) {
 TMA_estacoes <- estacoes %>% filter(Ano<(i+1), Status =='Operational', RT == 'Yes') #filtra as estacoes de TMA por ano de referencia

 TMA_estacoes<- st_transform(TMA_estacoes, unique(munis_df$espg)) #transforma projecao

 TMA_buf <- st_buffer(TMA_estacoes, 1000) %>% st_union  #cria buffer de 1.000 m
 
 setores_dados <- st_transform(setores_dados, unique(munis_df$espg)) #transforma projecao

 setores_entorno <- st_intersection(setores_dados, TMA_buf) #recorta setores dentro da area de entorno das estacoes
 
 setores_entorno <- setores_entorno %>%
   mutate(ar_int = unclass(st_area(.)), #cria area inserida no entorno da estacao
          rt = as.numeric(ar_int/Ar_m2)) %>% #cria proporcao entre area inserida no entorno da estacao e area total de cada 
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
 
 Resultados_rm <-rbind(total_entorno, total_rm, round(100*(total_entorno/total_rm),0))
 colnames(Resultados_rm)<- c("Pop", "DR_0_meio","DR_V008","DR_1_3","DR_3_mais", "M_Negras", "M_2SM") #nomeia as colunas da tabela criada
 row.names(Resultados_rm)<- c("total_entorno","total_rm", "resultado_%") #nomeia as linhas da tabela criada
 print(Resultados_rm) #se desejar verficar a tabela, rode esta linha de codigo
 
 write.xlsx(Resultados_rm, paste0('./', toupper (unique(munis_df$rm)), '/Resultados_PNT_', i, '_.xlsx')) #salva os resultados finais na pasta com o nome da RM 
}

#3.2. Aplicar funcao com o ano escolhido 
PNT_ano(2018) #se desejar calcular para outro ano, basta trocar
