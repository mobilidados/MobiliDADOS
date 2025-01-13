#Passo-a-passo do calculo do PNT
#1. Instalar pacotes e definir diretorio
#2. Abrir arquivos necessarios
#3. Realizar calculo do PNT


#1. Instalar pacotes e definir diretorio
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
setwd('E:/R') #altere o caminho para a pasta onde deseja salvar os arquivos


#2. Abrir arquivos necessarios

#2.1. Abrir dados dos setores censitarios
#Baixar dados dos setores censitarios na pagina da MobiliDADOS
# Ir em https://mobilidados.org.br/database
# Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
# Baixar tabela de dados
dados <- read_rds('./dados/IBGE/dados_setores/3_tabela_pais/dados_setores.rds') %>% 
  mutate(Cod_setor=as.character(Cod_setor))

#2.2. Definir a regiao metropolitana que sera calculada
#Abrir dados da regiao metropolitana
#Criar tabela de referencia para puxar dados
munis_df <- data.frame(code_muni = c(1500800,1501402,1501501,1502400,1504422,1506351,1506500),
                       name_muni=c('ananindeua','belem','benevides','castanhal','marituba','santa barbara do para','santa izabel do para'),
                       rm=c('rmb','rmb','rmb','rmb','rmb','rmb','rmb'),
                       espg = c(31982,31982,31982,31982,31982,31982,31982))
#As tabelas para as 9 regioes metropolitanas estao disponiveis na paginas do GITHUB da MobiliDADOS: https://github.com/mobilidados/MobiliDADOS/tree/master/PNT

# Criar funcao para juntar setores com dados do censo
juntar_setores_dados <- function (rm) {
  setores <- read_rds(paste0('./dados/regioes_metropolitanas/setores/setores_', rm, '.rds')) %>% st_sf() #inserir o nome do arquivo no qual salvou os setores para abri-lo
  setores <- setores %>% st_set_precision(1000000) %>% lwgeom::st_make_valid() #corrigir shapes que podem possuir algum defeito de feicao
  #Se desejar analisar apenas um municipio da Regiao Metropolitana
  #dados <- dados %>% filter(CD_GEOCODM == 1501402) #altere o codigo para o municipio que deseja analisar, este se refere a Belem
  
  #Unir setores com dados do IBGE
  juntar_com_dados <- left_join(setores, dados, by = 'Cod_setor') %>% st_sf()
  
}

setores_dados <- juntar_setores_dados(unique(munis_df$rm)) #junta setores com dados do censo rodando a funcao criada acima

setores_dados <- setores_dados %>% 
  st_set_precision(1000000) %>% 
  lwgeom::st_make_valid() %>% #corrige shapes que podem possuir algum defeito de feicao
  st_transform(., 4326)

# setores_dados <- left_join(setores, dados, by = 'Cod_setor')
# names(setores_dados)


#3. Realizar calculo do PNT

#3.1. Criar Funcao para aplicar PNT
PNT_ano <- function(i) {
 
  message(paste0('Ola, ', unique(munis_df$rm),'! =)', "\n"))
  
  TMA_buf <- read_rds(paste0('C:/Users/berna/Desktop/MobiliDADOS/tt_isochrones-master/output/', unique(munis_df$rm), '_buffer_', i, '.rds'))   #buffer com distancia real
  TMA_buf <- st_transform(TMA_buf, 4326)

  setores_dados <- setores_dados %>% st_set_precision(1000000) %>% lwgeom::st_make_valid() #corrigir shapes que podem possuir algum defeito de feicao
  
  setores_entorno <- st_intersection(setores_dados, TMA_buf) #recorta setores dentro da area de entorno das estacoes
  
  message(paste0('Recorte dos setores realizado.',"\n"))

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
  
  
  Resultados_rm <-rbind(total_entorno, total_rm, round(100*(total_entorno/total_rm),0))
  colnames(Resultados_rm)<- c("Pop", "DR_0_meio","DR_meio_1","DR_1_3","DR_3_mais", "M_Negras", "M_2SM") #nomeia as colunas da tabela criada
  row.names(Resultados_rm)<- c("total_entorno","total_rm", "resultado_%") #nomeia as linhas da tabela criada
  
  message(paste0('E o resultado do PNT eh...',"\n"))
  
  print(Resultados_rm) #se desejar verficar a tabela, rode esta linha de codigo
  
  write.xlsx(Resultados_rm, paste0('./resultados/resultados_pnt_', unique(munis_df$rm),'_', i, '_dist_real.xlsx')) #salva os resultados finais na pasta com o nome da RM  
}

#3.2. Aplicar funcao com o ano escolhido 
PNT_ano(2017) #se desejar calcular para outro ano, basta trocar
