#Passo-a-passo do calculo do PNT
#1. Definir diretorio e instalar pacotes 
#2. Conectar com OTP, abrir e limpar dados necessarios
#3. Criar areas no entorno das estacoes de transporte
#Desenvolvido por ITDP Brasil com apoio de https://github.com/kauebraga


#1. Definir diretorio e instalar pacotes 
#1.1. Definir diretorio
setwd('C:/Users/berna/Desktop/tutorial_pnt')

#1.2.instalar pacote necessarios
install.packages('readr') #leitura e manipulacoes de dados em formato rds
install.packages('dplyr') #leitura e operacoes com base de dados
install.packages('sf') #leitura e manipulacoes de dados georreferenciados
install.packages('mapview') #visualizacoes de dados georreferenciados
install.packages('beepr') #aviso sonoro de conclusao de tarefa
install.packages('openxlsx') #leitura de manipulacao de tabelas xls
install.packages('data.table') #leitura e operacoes com tabelas
install.packages('purrr') #otimizacao de funcoes e manipulacao de vetores
install.packages('devtools') #ferramentas de desenvolvimento
devtools::install_local("./misc/opentripplanner-master_mode.zip") #interface com OpenTripPlanner (OTP) para roteamento de viagem

#1.3. Carregar pacotes necessarios
library(readr)
library(dplyr)
library(data.table)
library(sf)
library(mapview)
library(beepr)
library(purrr)
library(opentripplanner)

#1.4. Importar e preparar OTP
# Download do arquivo OTP, precisa estar com conexao a internet para para baixar na primeira vez
opentripplanner::otp_dl_jar(path = "./otp/programs") #download OTP sera necessario somente uma vez
beep()

# Construir graph da rmb a partir da malha de rua.pbf - fazer uma unica vez
opentripplanner::otp_build_graph(otp = "otp/programs/otp.jar", 
                                 memory = 3000, #indica quantos MB de memória você quer dedicar para a geração do arquivo
                                 dir = "otp", 
                                 router = "rmb") #inserir sigal da cidade ou rm que esta na pasta graphs
beep()

#2. Conectar com OTP, abrir e limpar dados necessarios
#2.1. Abrir OTP
# otp_stop()
otp_setup(otp = "otp/programs/otp.jar", 
          dir = "otp", 
          router = 'rmb', 
          port = 8080, 
          wait = FALSE)

#2.2. Conectar com malha da regiao metropolitana de Belem
otp_rm <- otp_connect(router = 'rmb')
beep()

#2.3. Abrir e filtrar estacoes de transporte de media e alta capacidade para regiao e cidade desejada
tma_rm <- sf::st_read('./dados/estacoes_2019.shp') %>%
  mutate(Year = as.numeric(as.character(Year))) %>% #transformar a coluna de ano em valor numerico
  filter(Year < 2020, RT == 'Yes', Status == 'Operational', #filtrar estacoes de media e alta capacidade
         City == 'Belém') %>% #mudar nome da cidade para nucleo da RM
  sf::st_transform(., 4326) #transformar projecao


#2.4. Limpar arquivo com latitude e longitude das estacoes
coords_tma_rm <- setDT(tma_rm) %>% select(City, Mode, Station, Year, Y, X) #criar arquivo com coordenadas
coords_tma_rm <- coords_tma_rm[, id_stop := 1:.N] #criar coluna de id das estacoes
coords_tma_rm <- coords_tma_rm[, .(lat = Y, lon = X), by = id_stop] #renomear colunas

# Visualizar se estacoes estao corretas
coords_tma_rm_sf <- st_as_sf(coords_tma_rm, coords = c("lon", "lat"), crs = 4326)
mapview::mapview(coords_tma_rm_sf)

# Criar lista de coordenadas para OTP rotear areas de entorno
coords_list <- purrr::map2(as.numeric(coords_tma_rm$lon), as.numeric(coords_tma_rm$lat), c)

message('stations lat lon - ok')

#3. Criar areas no entorno das estacoes de transporte
#3.1. Criar funcao para gerar areas no entorno das estacoes de transporte
get_isochrone <- function(fromPlace, dist, walk_speed = 3.6, ...) {
  
  # Converter para metros por segundo
  x_speed <- walk_speed/3.6
  x_times <- dist/x_speed
  
  iso <- otp_isochrone(fromPlace = fromPlace,
                       cutoffSec = x_times,
                       walkSpeed = x_speed,
                       ...)
  
  # Adiciionar a informação da distancia considerada no arquivo final
  iso <- iso %>% mutate(distance = dist[length(dist):1])
  
}

# Transformar funcao para criar areas no entorno das estacoes'
get_isochrone_safe <- purrr::safely(get_isochrone)

#3.2. Aplicar funcao para criar entorno das estacoes a partir do OTP
buffer <- lapply(coords_list, get_isochrone_safe, 
                 dist = c(1000), #definir distancia
                 mode = "WALK", #definir modo de deslocamento
                 otpcon = otp_rm, #conectar com OTP para rotear na malha de vias
                 walk_speed = 3.6) #definir velocidade 

# Extrair feicoes do entorno
b <- map_depth(buffer, 1, function(x) x[[1]])

# Juntar todas as feicoes e dissolver em unico arquivo georreferenciado
b_sf <- bind_rows(b) %>% as_tibble()%>%
  st_sf(crs = 4326) %>% mutate(distance = as.character(distance)) %>%
  st_buffer(., 0) %>% st_union()

# visualizar a area do entorno
mapview(b_sf)+mapview(coords_tma_rm_sf)

# salvar
write_rds(b_sf, './dados/rmb_buffer_2019.rds')
