# Load necessary libraries
library(dplyr)
library(purrr)
library(stringr)
library(tidyr)

# Read population data
pop <- read.csv2("./populacao/output/csv/base_bruta.csv", encoding = "latin1") %>%
  mutate(ano = ano, COD_MUN = as.character(COD_MUN)) %>%
  rename(municipio_nome = municipio)

# Get list of RDS files
folder_path <- "./datasus/output/obitos/temp"
file_list <- list.files(path = folder_path, pattern = "\\.rds$", full.names = TRUE)

# Read all RDS files and combine them into one data frame
combined_data <- file_list %>%
  map(readRDS) %>%
  bind_rows() %>% left_join(pop, by = c("ano", "municipio" = "COD_MUN"))

# Manipulate the combined data
combined_data2 <- combined_data %>%
  mutate(ano = as.character(ano)) %>%
  group_by(ano, municipio, tipo) %>%
  summarise(total = sum(obitos)) %>%
  bind_rows(., group_by(., municipio, ano) %>%
              summarise(tipo = "total", total = sum(total, na.rm = TRUE))) %>%
  arrange(municipio, ano)

result <- combined_data2 %>% 
  mutate(tipo = case_when(
    tipo == "Outro_veic" | tipo == "Pesado" | tipo == "Onibus" | tipo == "Caminhonete" | tipo == "Triciclo" ~ "Outros",
    tipo == "total" ~ "Total",
    TRUE ~ tipo  # If none of the above conditions match, keep the original value
  ))   

# Read population data again
pop <- read.csv2("./populacao/output/csv/tabela_pop_rm3.csv", encoding = 'latin1') %>%
  mutate(ano = as.character(ano),
         COD_MUN = as.character(COD_MUN))

# Join population data with result data
result <- left_join(pop, result, by = c("ano" = "ano", "COD_MUN" = "municipio"))

# Group and summarize the result data
result <- result %>%
  group_by_at(vars("cod_uf", "uf", "municipio_codigo", "COD_MUN","municipio", "capitais","NOME_CATMETROPOL","ano","valor", "tipo")) %>%
  summarise(total = sum(total, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(tipo = ifelse(is.na(tipo), "Total", tipo))


# Calculate mortality rates and pivot the data
tx_mun <- result %>%
  mutate(tx_mort = total/valor*100000)

tx_mun <- tx_mun %>% select(-valor, -total) %>% pivot_wider(names_from = "ano", values_from = "tx_mort") 

tx_mun <- tx_mun %>%
  mutate(tipo = factor(tipo, levels = c("Total", "Ocupantes de automóvel", "Ciclistas",  "Motociclistas","Pedestres", "Outros"))) %>%
  arrange(tipo, municipio_codigo)

# Pivot the data for absolute numbers
abs_mun <- result %>% select(-valor) %>% pivot_wider(names_from = "ano", values_from = "total")

abs_mun <- abs_mun %>%
  mutate(tipo = factor(tipo, levels = c("Total", "Ocupantes de automóvel", "Ciclistas",  "Motociclistas","Pedestres", "Outros"))) %>%
  arrange(tipo, municipio_codigo)

# Duplicate data for tx_capitais_relat and tx_capitais_absl
tx_capitais_relat <- tx_mun 
tx_capitais_absl <- abs_mun

# Manipulate data for pop_rms and tx_rms
pop_rms <- pop %>% group_by(NOME_CATMETROPOL, ano) %>%
  summarise(valor=sum(valor, na.rm = TRUE))

tx_rms <-  result %>%
  group_by(NOME_CATMETROPOL, ano,tipo) %>%
  summarise(total = sum(total,na.rm = TRUE)) 

tx_rms <- left_join(pop_rms, tx_rms, c("NOME_CATMETROPOL", "ano"))

# Calculate mortality rates for tx_rms_mort and pivot the data
tx_rms_mort <- tx_rms %>%
  mutate(tipo = factor(tipo, levels = c("Total", "Ocupantes de automóvel", "Ciclistas",  "Motociclistas","Pedestres", "Outros"))) %>%
  arrange(tipo, desc(NOME_CATMETROPOL)) %>%
  mutate(tx_mort = total/valor*100000)

rms_rlt <- tx_rms_mort %>% select(-total, -valor) %>% pivot_wider(names_from = "ano", values_from = "tx_mort")
abs_rms <- tx_rms_mort %>% select(-valor, -tx_mort) %>% pivot_wider(names_from = "ano", values_from = "total")

# Write data to CSV files
write.csv2(result, "./datasus/output/obitos/final/base_trabalhada.csv", row.names = FALSE)
write.csv2(combined_data, "./datasus/output/obitos/final/base_completa.csv", row.names = FALSE)
write.csv2(tx_capitais_relat, "./datasus/output/obitos/final/tx_capitais_relat.csv", row.names = FALSE)
write.csv2(tx_capitais_absl, "./datasus/output/obitos/final/tx_capitais_absl.csv", row.names = FALSE)
write.csv2(rms_rlt, "./datasus/output/obitos/final/tx_rms_relat.csv", row.names = FALSE)
write.csv2(abs_rms, "./datasus/output/obitos/final/tx_rms_absl.csv", row.names = FALSE)

