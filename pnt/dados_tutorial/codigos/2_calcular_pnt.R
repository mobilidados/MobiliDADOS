#Passo-a-passo do calculo do PNT
#1. Definir diretorio, instalar e carregar pacotes
#2. Abrir arquivos necessarios
#3. Realizar calculo do PNT


#1. Instalar pacotes e definir diretorio
#1.1. Defnir diretorio
setwd('C:/Users/berna/Desktop/tutorial_pnt') # alterar o caminho para a pasta onde deseja salvar os arquivos

#1.2. Instalar pacotes
install.packages('readr') # leitura e manipulacoes de dados em formato rds
install.packages('dplyr') # leitura e operacoes com base de dados
install.packages('sf') # leitura e manipulacoes de dados georreferenciados
install.packages('mapview') # visualizacoes de dados georreferenciados
install.packages('beepr') # aviso sonoro de conclusao de tarefa
install.packages('openxlsx') # leitura de manipulacao de tabelas xls

#1.3. Abrir pacotes
library(readr)
library(dplyr)
library(sf)
library(mapview)
library(beepr)
library(openxlsx)

#2. Abrir arquivos necessarios

#2.1. Abrir dados dos setores censitarios
# Baixar dados dos setores censitarios na pagina da MobiliDADOS em https://mobilidados.org.br/database
# Acessar pasta 'Dados das regioes metropolitanas por setor censitario'
dados <- read_rds('./dados/dados_setores.rds') %>% mutate(Cod_setor=as.character(Cod_setor))
View(dados)

#2.2. Definir a regiao metropolitana que sera calculada
# Abrir dados da regiao metropolitana de Belem
# Criar tabela de referencia para puxar dados
munis_df <- data.frame(code_muni = c(1500800,1501402,1501501,1502400,1504422,1506351,1506500),
                       name_muni=c('ananindeua','belem','benevides','castanhal','marituba','santa barbara do para','santa izabel do para'),
                       rm=c('rmb','rmb','rmb','rmb','rmb','rmb','rmb'),
                       espg = c(31982,31982,31982,31982,31982,31982,31982))
# As tabelas para as 9 regioes metropolitanas estao disponiveis 
# no repositorio da MobiliDADOS no GITHUB: https://github.com/mobilidados/MobiliDADOS/tree/master/apoio

# Abrir setores e juntar com dados
setores_dados <- left_join(read_rds(paste0('./dados/setores_', unique(munis_df$rm), '.rds')), dados, by = 'Cod_setor') %>%
  st_transform(., 4326)
mapview(setores_dados)

#3. Realizar calculo do PNT
#3.1. Criar Funcao para aplicar PNT
# i  <- 2019
PNT_ano <- function(i) {
  
  message(paste0('Ola, ', unique(munis_df$rm),'! =)', "\n"))
  
  TMA_buf <- read_rds(paste0('./dados/', unique(munis_df$rm), '_buffer_', i, '.rds')) # abrir buffer com distancia real
  TMA_buf <- st_transform(TMA_buf, 4326) # transforma projecao
  
  setores_dados <- setores_dados %>% st_set_precision(1000000) %>% sf::st_make_valid() # corrigir shapes que podem possuir algum defeito de feicao
  
  setores_entorno <- st_intersection(setores_dados, TMA_buf) # recortar setores dentro da area de entorno das estacoes
  
  message(paste0('Recorte dos setores realizado.',"\n"))
  
  setores_entorno <- setores_entorno %>%
    mutate(Ar_int = unclass(st_area(.)), # criar area inserida no entorno da estacao
           rt = as.numeric(Ar_int/Ar_m2)) %>% # criar proporcao entre area inserida no entorno da estacao e area total de cada 
    mutate_at(.vars = vars(Pop, DR_0_meio, DR_meio_1, DR_1_3, DR_3_mais, M_Negras , M_2SM), 
              funs(int = . * rt))
  
  total_entorno <- c((sum(setores_entorno$Pop_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_0_meio_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_meio_1_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_1_3_int, na.rm = TRUE)), 
                     (sum(setores_entorno$DR_3_mais_int, na.rm = TRUE)), 
                     (sum(setores_entorno$M_Negras_int, na.rm = TRUE)), 
                     (sum(setores_entorno$M_2SM_int, na.rm = TRUE))) # realizar a soma total de cada variavel na area de entorno das estacoes
  
  total_rm <- c((sum(setores_dados$Pop, na.rm = TRUE)), 
                (sum(setores_dados$DR_0_meio, na.rm = TRUE)), 
                (sum(setores_dados$DR_meio_1, na.rm = TRUE)), 
                (sum(setores_dados$DR_1_3, na.rm = TRUE)), 
                (sum(setores_dados$DR_3_mais, na.rm = TRUE)), 
                (sum(setores_dados$M_Negras, na.rm = TRUE)), 
                (sum(setores_dados$M_2SM, na.rm = TRUE))) # realizar a soma total de cada variavel na regiao metropolitana de belem
  
  
  Resultados_rm <-rbind(total_entorno, total_rm, round(100*(total_entorno/total_rm),0)) #juntar dados em tabela unica
  colnames(Resultados_rm)<- c("Pop", "DR_0_meio","DR_meio_1","DR_1_3","DR_3_mais", "M_Negras", "M_2SM") # nomear as colunas da tabela criada
  row.names(Resultados_rm)<- c("total_entorno","total_rm", "resultado_%") # nomear as linhas da tabela criada
  
  message(paste0('E o resultado do PNT eh...',"\n"))
  
  print(Resultados_rm) # se desejar verficar a tabela, rode esta linha de codigo
  
  write.xlsx(Resultados_rm, paste0('./resultados/resultados_pnt_', unique(munis_df$rm),'_', i, '_dist_real.xlsx')) # salvar os resultados finais na pasta com o nome da RM  
}

#3.2. Aplicar funcao com o ano escolhido 
PNT_ano(2019) # se desejar calcular para outro ano, basta trocar
