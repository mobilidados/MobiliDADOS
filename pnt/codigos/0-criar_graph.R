# código para criar os objetos graph para as capitais do país
# Para criar os objetos graph é preciso que as pastas estejam com o caminho correto para a construção.
## Para maiores detalhes ver documentação do otp_build_graph
### No final das contas é necessário colocar o arquivo no formato PBF (malha viária do OSM)
### na pasta referente a cada município dentro da pasta mãe "graph"

# Carregar os pacotes necessários

library(readr)
library(dplyr)
library(opentripplanner)
library(data.table)
library(sf)
library(purrr)
library(beepr)
library(mapview)
library(pbapply)
library(beepr)

# Listar os municípios para criar os arquivos graph

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


# Caminho para o arquivo java a ser carregado pelo opt

path_otp <- "F:/Projetos/mobilidados/pnb_novo/otp/programs/otp.jar"

# Caminho para o diretório com as pastas preparadas com as malhas viárias dentro

dir <- "F:/Projetos/mobilidados/pnb_novo/otp/2021"

# For loop para criar todos os arquivos graphs em cada pasta.

for(i in munis_df_rms$rms){
  Sys.sleep(3) # Coloca o sistema para "dormir" por 3 segundos por segurança. Caso contrário pode travar

otp_build_graph(otp = path_otp, dir = dir, memory = 10240, router =  i)
}

Sys.sleep(3)# Coloca o sistema para "dormir" por 3 segundos por segurança. Caso contrário pode travar }


beep(3) #Aviso quando acabar o cálculo.
