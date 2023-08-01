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
  group_by(ano, municipio, tipo, cor_raca) %>%
  summarise(total = sum(obitos)) %>%
  bind_rows(., group_by(., municipio, ano, cor_raca) %>%
              summarise(tipo = "total", total = sum(total, na.rm = TRUE))) %>%
  arrange(municipio, ano)

combined_data2$cor_raca <- combined_data2$cor_raca %>% as.character()

result <- combined_data2 %>% 
  mutate(tipo = case_when(
    tipo %in% c("Outro_veic", "Pesado", "Onibus", "Caminhonete", "Triciclo") ~ "Outros",
    tipo == "total" ~ "Total",
    TRUE ~ tipo
  ),
  cor_raca = case_when(
    cor_raca %in% c("Preta", "Parda") ~ "Negra",
    TRUE ~ cor_raca
  )
  ) %>%
  group_by(ano, municipio,tipo, cor_raca) %>%
  summarise(total=sum(total))

# Read population data again
pop <- read.csv2("./populacao/output/csv/tabela_pop_rm3.csv", encoding = 'latin1') %>%
  mutate(ano = as.character(ano),
         COD_MUN = as.character(COD_MUN))

# Join population data with result data
result <- left_join(pop, result, by = c("ano" = "ano", "COD_MUN" = "municipio")) %>%
  mutate(tipo = ifelse(is.na(tipo), "Total", tipo),
         cor_raca = ifelse(is.na(cor_raca), "Vazio", cor_raca))

tot_mun <- result %>%
  select(-valor) %>%
  pivot_wider(names_from = "cor_raca", values_from = "total") %>%
  mutate(Total = rowSums(select(., Branca, Negra, Ignorado, Amarela, Indígena, Vazio), na.rm = TRUE),
         perc_negre = Negra/Total*100)  %>%
  mutate(tipo = factor(tipo, levels = c("Total", "Ocupantes de automóvel", "Ciclistas",  "Motociclistas","Pedestres", "Outros"))) %>%
  arrange(tipo, municipio_codigo)




# Pivot the data for absolute numbers
abs_mun <- tot_mun %>% select(-c(Branca, Ignorado, Amarela, Indígena, Vazio, Total,  perc_negre)) %>% pivot_wider(names_from = "ano", values_from = "Negra")

perc_mun <- tot_mun %>% select(-c(Branca, Ignorado, Amarela, Indígena, Vazio, Total,  Negra)) %>% pivot_wider(names_from = "ano", values_from = "perc_negre")


tot_rms <- result %>%
  select(-valor) %>%
  group_by(NOME_CATMETROPOL, ano, tipo, cor_raca) %>%
  summarise(total = sum(total)) %>%
  pivot_wider(names_from = "cor_raca", values_from = "total") %>% 
  rowwise() %>%
  mutate(Total = sum(Amarela, Branca, Ignorado, Negra, Indígena, Vazio, na.rm = TRUE),
         perc_negre = Negra / Total * 100) %>%
  mutate(tipo = factor(tipo, levels = c("Total", "Ocupantes de automóvel", "Ciclistas",  "Motociclistas","Pedestres", "Outros"))) %>%
  arrange(tipo, desc(NOME_CATMETROPOL))

  

# Pivot the data for absolute numbers
abs_rms <- tot_rms %>% select(-c(Branca, Ignorado, Amarela, Indígena, Vazio, Total,  perc_negre)) %>% pivot_wider(names_from = "ano", values_from = "Negra")

perc_rms <- tot_rms %>% select(-c(Branca, Ignorado, Amarela, Indígena, Vazio, Total,  Negra)) %>% pivot_wider(names_from = "ano", values_from = "perc_negre")




write.csv2(perc_mun, "./datasus/output/obitos/final/perc_negres_capitais.csv", row.names = FALSE)
write.csv2(abs_mun, "./datasus/output/obitos/final/negres_capitais.csv", row.names = FALSE)
write.csv2(perc_rms, "./datasus/output/obitos/final/perc_negres_rms.csv", row.names = FALSE)
write.csv2(abs_rms, "./datasus/output/obitos/final/negres_rms.csv", row.names = FALSE)
