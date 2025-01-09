# Load libraries
library(readr)
library(janitor)
library(dplyr)
library(stringr)
library(readODS)
library(sidrar)
library(tidyr)
library(googledrive)

# drive_auth()

# Verifica se a pasta "output" existe
if (!dir.exists("populacao/output")) {
  # Se não existir, cria a pasta "output"
  dir.create("populacao/output")
  dir.create("populacao/output/csv")
  dir.create("populacao/output/rds")
}


start <- Sys.time()

# create csv and rds path to store the file

csv_path <- "./populacao/output/csv/"
rds_path <- "./populacao/output/rds/"

# create csv and rds folder

try(dir.create("populacao"))
try(dir.create("populacao/output"))
try(dir.create(csv_path))
try(dir.create(rds_path))
try(dir.create("populacao/input"))



file_downlod_path <- "https://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/municipios_por_regioes_metropolitanas/Situacao_2020a2029/Composicao_RMs_RIDEs_AglomUrbanas_2021_v2.ods"
destfile <- paste0("./populacao/input", "/rms_pop.ods")
download.file(file_downlod_path, destfile = destfile, mode = "wb")

# csv and rds path to gdrive
csv_path_gdrive <- "1XLHrG9tqG6RZRjYjanRlK2PKBj7cg-Lv"
rds_path_gdrive <- "1RLXY2Vqw-WPU_G72NLTajxPiLTZvc_DQ"


# Function for importing data
import_data <- function() {
  base_rms <- read_ods("./populacao/input/rms_pop.ods")%>%
    arrange(desc(DATA)) %>%
    distinct(COD_MUN, .keep_all = TRUE) %>%
    arrange(DATA) %>% 
    mutate(COD_MUN = as.character(substr(COD_MUN, 1, 6)) ) %>% select(NOME_CATMETROPOL, COD_MUN)
  return(base_rms)
}


# Function for downloading population data
download_pop_data <- function() {
  
  anos <- anos %>% as.character() 
  
  tabela_pop <- NULL
  
  for(i in anos){
    tmp <- get_sidra(x = 6579, variable = 9324, geo = "City", period = i)
    tabela_pop <- rbind(tabela_pop, tmp)
  }
  
  return(tabela_pop)
  return(anos)
}

# Function for downloading census data separately
download_census_data <- function() {
  tabela_pop_2000 <- get_sidra(x = 200, variable = 93, geo = "City", period = "2000", classific = c("c2"), category = list(0))
  tabela_pop_2010 <- get_sidra(x = 1378, variable = 93, geo = "City", period = "2010", classific = c("c1"), category = list(0))
  tabela_pop_2007 <- get_sidra(x = 793, geo = "City", period = "2007")
  tabela_pop_2022 <- get_sidra(x = 4709, variable = 93, geo = "City", period = "2022", category = list(0))
  
  return(list(tabela_pop_2000, tabela_pop_2010, tabela_pop_2007,tabela_pop_2022))
}

# Function for merging all data
merge_all_data <- function(tabela_pop, tabela_pop_2000, tabela_pop_2010, tabela_pop_2007,tabela_pop_2022) {
  tabela_pop_f <- rbind(tabela_pop, tabela_pop_2010[,1:11], tabela_pop_2007, tabela_pop_2000[,1:11],tabela_pop_2022[,1:11])
  return(tabela_pop_f)
}
clean_and_format_data <- function(tabela_pop_f, base_rms, capitais) {
  
  capitais <- c(1100205,1200401,1302603,1400100,1501402,1600303,
                1721000,2111300,2211001,2304400,2408102,2507507,
                2611606,2704302,2800308,2927408,3106200,3205309,
                3304557,3550308,4106902,4205407,4314902,5002704,
                5103403,5208707,5300108)
  
  tabela_pop_rm <- tabela_pop_f %>% 
    clean_names() %>% 
    mutate(
      uf = str_sub(municipio, -2, -1),
      municipio = str_sub(municipio, 1, -6),
      COD_MUN = str_sub(municipio_codigo, 1, -2)
    )
  
  ordem <- 2000:tail(anos, 1)
  
  tabela_pop_rm3 <- tabela_pop_rm %>% 
    mutate(ano = factor(ano, levels = ordem)) %>% 
    arrange(ano)
  
  tabela_pop_rm <- tabela_pop_rm3 %>% 
    left_join(base_rms, by = c("COD_MUN" = "COD_MUN")) %>% 
    mutate(
      capitais = if_else(municipio_codigo %in% capitais, "Sim", "Não"),
      cod_uf = str_sub(municipio_codigo, 1, 2),
      COD_MUN = str_sub(municipio_codigo, 1, -2)
    )
  
  
  
  tabela_pop_rm2 <- tabela_pop_rm %>% 
    select(cod_uf, uf, municipio_codigo, COD_MUN, municipio, capitais, NOME_CATMETROPOL, ano, valor) %>% 
    pivot_wider(names_from = ano, values_from = valor, values_fill = NULL) %>% 
    mutate(across(everything(), as.character)) %>% 
    mutate(NOME_CATMETROPOL = replace_na(NOME_CATMETROPOL, "-"))
  
  tabela_pop_rm2 <- tabela_pop_rm2 %>%
    mutate(across(matches("^20[0-2][0-9]$"), as.numeric))
  
  tabela_pop_rm2$'2023' <- round(tabela_pop_rm2$'2022' + (tabela_pop_rm2$'2024' - tabela_pop_rm2$'2022') / 2,digits = 0)
  
  tabela_pop_rm2 <- tabela_pop_rm2 %>%
    relocate(`2023`, .before = `2024`)
  
  tabela_pop_rm <- tabela_pop_rm2 %>%
    relocate(`2023`, .before = `2024`) %>% 
    pivot_longer(cols = matches("^20[0-2][0-9]$"),
                 names_to = "ano",
                 values_to = "valor")
  
  tabela_pop_rm3 <- tabela_pop_rm %>% 
    select(cod_uf, uf, municipio_codigo, COD_MUN, municipio, capitais, NOME_CATMETROPOL, ano, valor) %>% 
    mutate(NOME_CATMETROPOL = replace_na(NOME_CATMETROPOL, "-"))
  
  tabela_pop_capitais <- tabela_pop_rm2 %>% 
    filter(capitais == "Sim")
  
  pop_capitais_final <- tabela_pop_capitais[match(capitais, tabela_pop_capitais$municipio_codigo), ]
  
  tabela_pop_rms_final <- tabela_pop_rm3 %>% 
    group_by(NOME_CATMETROPOL, ano) %>% 
    summarise(valor = sum(valor, na.rm = TRUE)) %>% 
    pivot_wider(names_from = ano, values_from = valor)
  
  rms_sel <- c(
    "Região Metropolitana de Belém", "Região Metropolitana de Belo Horizonte",
    "Região Metropolitana de Curitiba", "Região Integrada de Desenvolvimento do Distrito Federal e Entorno",
    "Região Metropolitana de Fortaleza", "Região Metropolitana de Recife",
    "Região Metropolitana do Rio de Janeiro", "Região Metropolitana de Salvador",
    "Região Metropolitana de São Paulo"
  )
  
  tabela_pop_rms_final2 <- tabela_pop_rms_final %>% 
    filter(NOME_CATMETROPOL %in% rms_sel) %>% 
    arrange(match(NOME_CATMETROPOL, rms_sel))

  
  list(tabela_pop_rm2, tabela_pop_rm3, tabela_pop_capitais, tabela_pop_rms_final2, tabela_pop_rms_final)
}

# Function for saving data
save_data <- function(tabela_pop_rm2, tabela_pop_rm3, tabela_pop_capitais, tabela_pop_rms_final2, tabela_pop_rms_final) {
  csv_folder <- csv_path
  rds_folder <- rds_path
  
  # Save data in CSV format
  write.csv2(tabela_pop_rm2, paste0(csv_folder, "tabela_pop_rm2.csv"), row.names = FALSE, fileEncoding = "latin1")
  write.csv2(tabela_pop_rm3, paste0(csv_folder, "tabela_pop_rm3.csv"), row.names = FALSE, fileEncoding = "latin1")
  write.csv2(tabela_pop_capitais, paste0(csv_folder, "tabela_pop_capitais.csv"), row.names = FALSE, fileEncoding = "latin1")
  write.csv2(tabela_pop_rms_final2, paste0(csv_folder, "tabela_pop_rms_final2.csv"), row.names = FALSE, fileEncoding = "latin1")
  write.csv2(tabela_pop_rms_final, paste0(csv_folder, "tabela_pop_rms_final.csv"), row.names = FALSE, fileEncoding = "latin1")
  
  # Save data in RDS format
  saveRDS(tabela_pop_rm2, paste0(rds_folder, "tabela_pop_rm2.rds"))
  saveRDS(tabela_pop_rm3, paste0(rds_folder, "tabela_pop_rm3.rds"))
  saveRDS(tabela_pop_capitais, paste0(rds_folder, "tabela_pop_capitais.rds"))
  saveRDS(tabela_pop_rms_final2, paste0(rds_folder, "tabela_pop_rms_final2.rds"))
  saveRDS(tabela_pop_rms_final, paste0(rds_folder, "tabela_pop_rms_final.rds"))
}


# Function for uploading data to Google Drive
upload_to_drive <- function(folder_id) {
  drive_upload(paste0(csv_path, "tabela_pop_rm2.csv"), path = as_id(folder_id), overwrite = TRUE)
  drive_upload(paste0(csv_path,"tabela_pop_rm3.csv"), path = as_id(folder_id), overwrite = TRUE)
  drive_upload(paste0(csv_path,"tabela_pop_capitais.csv"), path = as_id(folder_id), overwrite = TRUE)
  drive_upload(paste0(csv_path,"tabela_pop_rms_final2.csv"), path = as_id(folder_id), overwrite = TRUE)
  drive_upload(paste0(csv_path,"tabela_pop_rms_final.csv"), path = as_id(folder_id), overwrite = TRUE)
}


anos <- 2001:2024

# Now call each function in the order of data processing pipeline
base_rms <- import_data()
tabela_pop <- download_pop_data()
census_data <- download_census_data()
tabela_pop_f <- merge_all_data(tabela_pop, census_data[[1]], census_data[[2]], census_data[[3]],census_data[[4]])
final_data <- clean_and_format_data(tabela_pop_f, base_rms)
save_data(final_data[[1]], final_data[[2]], final_data[[3]], final_data[[4]], final_data[[5]])


# upload_to_drive(csv_path_gdrive)
# upload_to_drive(rds_path_gdrive)

end <- Sys.time()

time <- end - start
print(time)

