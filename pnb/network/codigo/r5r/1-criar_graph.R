# código para criar os objetos graph para as capitais do país
# Para criar os objetos graph é preciso que as pastas estejam com o caminho correto para a construção.
## Para maiores detalhes ver documentação do otp_build_graph
### No final das contas é necessário colocar o arquivo no formato PBF (malha viária do OSM)
### na pasta referente a cada município dentro da pasta mmãe "graph"

# Carregar os pacotes necessários

library(readr)
library(dplyr)
library(r5r)
library(data.table)
library(sf)
library(purrr)
library(beepr)
library(mapview)
library(pbapply)
library(beepr)

options(java.parameters = '-Xmx2G')



# Listar os municípios para criar os arquivos graph

munis_df <- data.frame(code_muni = c(2927408, 3550308, 3304557, 2611606, 
                                     2304400, 5300108, 4106902,
                                     3106200, 1501402, 1100205, 1200401,
                                     1302603, 1400100, 1600303, 1721000, 2111300,
                                     2211001, 2408102, 2507507, 2704302, 2800308,
                                     3205309, 4205407, 4314902, 5002704,
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



setup_r5(data_path = "pnb/network/pbf/ara")

ano <- 2022

# Caminho para o diretório com as pastas preparadas com as malhas viárias dentro

dir <- paste0("./otp/",ano)


# For loop para criar todos os arquivos graphs em cada pasta.
# Antes disso copiar as pastas do geofrabrik para a pasta otp.

for(i in munis_df$sigla_muni){
  Sys.sleep(3) # Coloca o sistema para "dormir" por 3 segundos por segurança. Caso contrário pode travar

otp_build_graph(otp = path_otp, dir = dir, memory = 10240, router =  i)
}

Sys.sleep(3)# Coloca o sistema para "dormir" por 3 segundos por segurança. Caso contrário pode travar }


beep(3) #Aviso quando acabar o cálculo.

# Listar as regiões metropolitanas para criar os arquivos graph

munis_df_rms <- data.frame(code_muni = c(1501402, 3106200, 4106902, 5300108, 
                                         2304400, 2611606, 3304557, 2927408, 
                                         3550308),
                           name_muni=c("belém", "belo horizonte", "curitiba", 
                                       "distrito federal", "fortaleza", "recife",
                                       "rio de janeiro", "salvador", "sço paulo"),
                           abrev_state=c("PA", "mg", "PR", "df", "CE", 
                                         "PE", "RJ", "BA", "SP"),
                           rms=c("rmb", "rmbh", "rmc", "ride", 
                                 "rmf", "rmr", "rmrj", "rms", "rmsp"),
                           espg = c(31982, 31983, 31982, 31983,
                                    31984, 31985, 31983, 31984, 31983 ),
                           shp = c("RM Belem", "RM Belo Horizonte", "RM Curitiba", 
                                   "RIDE Distrito Federal", "RM Fortaleza", "RM Recife",
                                   "RM_Rio_de_Janeiro", "RM_Salvador", "RM_Sao_Paulo"))

# For loop para criar todos os arquivos graphs em cada pasta.
# Antes disso copiar as pastas do geofrabrik para a pasta otp.

for(i in munis_df_rms$rms){
  Sys.sleep(3) # Coloca o sistema para "dormir" por 3 segundos por segurança. Caso contrário pode travar
  
  otp_build_graph(otp = path_otp, dir = dir, memory = 10240, router =  i)
}
