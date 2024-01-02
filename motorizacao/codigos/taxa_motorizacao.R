# Essa sequência de códigos pressupõe um tratamento manual dos inputs utilizados
# O download e a importa??o dos dados ser?o automatizados

#https://www.gov.br/infraestrutura/pt-br/assuntos/transito/conteudo-denatran/estatisticas-frota-de-veiculos-senatran

# Load necessary packages
library(readr)
library(janitor)
library(dplyr)
library(stringr)
library(tidyr)

# Verifica se a pasta "output" existe
if (!dir.exists("motorizacao/output")) {
  # Se não existir, cria a pasta "output"
  dir.create("motorizacao/output")
}

# Function to read and process datasets for a given year
read_process_dataset <- function(year) {
  filepath <- paste0("./motorizacao/trabalhado/frota_auto_", year, ".csv")
  data <- read.csv2(filepath, header = TRUE, fileEncoding = "Latin1", nrows = 5570) %>%
    clean_names() %>%
    mutate(ano = year)
  return(data)
}

# Function to combine all datasets into one
combine_datasets <- function(datasets) {
  combined_data <- do.call(rbind, datasets) %>%
    replace(is.na(.), 0)
  return(combined_data)
}

# Function to clean and format the combined dataset
clean_format_dataset <- function(data) {
  data$cod_munic <- str_pad(data$cod_munic, width = 5, side = "left", pad = 0)
  data$cod_mun7 <- str_c(data$cod_uf, data$cod_munic)
  data$cod_mun6 <- str_sub(data$cod_mun7, 1, -2)
  data <- data %>%
    mutate(across(everything(), ~replace(., is.na(.), 0))) %>%
    mutate(
      motocicleta = as.numeric(motocicleta),
      automovel = as.numeric(automovel),
      caminhonete = as.numeric(caminhonete),
      camioneta = as.numeric(camioneta),
      motoneta = as.numeric(motoneta),
      utilitario = as.numeric(utilitario),
      motorizados = automovel+ caminhonete+ camioneta+ motocicleta+ motoneta+ utilitario
    ) %>%
    select(cod_uf, uf, cod_mun6, cod_mun7, nome_do_municipio, motorizados, automovel, caminhonete, camioneta, motocicleta, motoneta, utilitario, ano)
  rownames(data) <- NULL
  return(data)
}

# Function to calculate motorization rates
calculate_motorization_rates <- function(data) {
  motorization <- data %>%
    mutate(tx_moto = motocicleta / populacao * 1000, tx_motorizados = motorizados / populacao * 1000) %>%
    select(cod_uf, uf, cod_mun6, cod_mun7, municipio, capitais, NOME_CATMETROPOL, tx_moto, tx_motorizados, ano)
  return(motorization)
}

# Function to calculate motorization rates for rms
calculate_motorization_rates_rms <- function(data) {
  motorization <- data %>%
    mutate(tx_moto = motocicleta / populacao * 1000, tx_motorizados = motorizados / populacao * 1000) %>%
    select(NOME_CATMETROPOL, tx_moto, tx_motorizados, ano)
  return(motorization)
}

# Function to filter and select data for specific regions
filter_select_regions <- function(data, regions) {
  filtered_data <- data %>% filter(NOME_CATMETROPOL %in% regions)
  return(filtered_data)
}

# Main script
periodo <- 2001:2022
datasets <- lapply(periodo, read_process_dataset)
combined_data <- combine_datasets(datasets)
formatted_data <- clean_format_dataset(combined_data)

pop <- read.csv2("./populacao/output/csv/tabela_pop_rm3.csv", encoding = 'latin1')
pop$ano <- as.numeric(pop$ano)
pop$municipio_codigo <- as.character(pop$municipio_codigo)

frota_pop_data <- left_join(
  select(formatted_data, cod_uf, uf,cod_mun6, cod_mun7, motorizados, automovel, caminhonete, camioneta, motocicleta, motoneta, utilitario, ano),
  select(pop, municipio_codigo, municipio, capitais, NOME_CATMETROPOL, ano, valor),
  by = c("cod_mun7" = "municipio_codigo", "ano")
) %>% rename(populacao = valor)

final_data <- frota_pop_data %>% select(1:4, 13, 14, 15, 5:11, 14, 12, 16)
final_data$NOME_CATMETROPOL[is.na(final_data$NOME_CATMETROPO)] <- "-"

final_data <- final_data %>% mutate(across(motorizados:utilitario, ~replace_na(., 0)))

motorization_capitals <- calculate_motorization_rates(final_data)
motorization_capitals <- motorization_capitals[motorization_capitals$capitais=="Sim",]
motorization_capitals <- motorization_capitals[!is.na(motorization_capitals$cod_uf), ]

motorization_base <- calculate_motorization_rates(final_data)

motorization_base2 <- pivot_wider(
  select(motorization_base, cod_mun7, tx_motorizados, ano),
  names_from = ano,
  values_from = tx_motorizados
)

motorization_base2 <- motorization_base[motorization_base$ano=="2022", c(1:7)] %>%
  left_join(motorization_base2, c("cod_mun7"="cod_mun7"))

motor_abs <- final_data
motor_abs2 <- pivot_wider(
  select(motor_abs, cod_mun7, motorizados, ano),
  names_from = ano,
  values_from = motorizados
)

motor_abs2 <- motor_abs[motor_abs$ano=="2022", c(1:7)] %>%
  left_join(motor_abs2, c("cod_mun7"="cod_mun7"))

motorization_rms <- final_data %>%
  select(7:ncol(final_data)) %>%
  group_by(NOME_CATMETROPOL, ano) %>%
  summarise(across(everything(), ~ sum(., na.rm = TRUE)))


rms_sel <- c("Região Metropolitana de Belém","Região Metropolitana de Belo Horizonte",
             "Região Metropolitana de Curitiba","Região Integrada de Desenvolvimento do Distrito Federal e Entorno",
             "Região Metropolitana de Fortaleza", "Região Metropolitana de Porto Alegre","Região Metropolitana de Recife",
             "Região Metropolitana do Rio de Janeiro","Região Metropolitana de Salvador","Região Metropolitana de São Paulo")

motorization_rms_total <- calculate_motorization_rates_rms(motorization_rms)
motorization_rms_total <- filter_select_regions(motorization_rms_total, rms_sel)

# Pivot the datasets to have years as columns
motorization_capitals_pivot_moto <- pivot_wider(select(motorization_capitals,-tx_motorizados), names_from = ano, values_from = tx_moto)
motorization_capitals_pivot_motorizado <- pivot_wider(select(motorization_capitals,-tx_moto), names_from = ano, values_from = tx_motorizados )
motorization_rms_pivot_moto <- pivot_wider(select(motorization_rms_total,-tx_motorizados), names_from = ano, values_from = tx_moto)
motorization_rms_pivot_motorizado <- pivot_wider(select(motorization_rms_total,-tx_moto), names_from = ano, values_from = tx_motorizados)

# Save the data

# decimal mark = "."

write.csv(motorization_capitals_pivot_moto , "./motorizacao/output/motorization_capitals_pivot_moto.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv(motorization_capitals_pivot_motorizado , "./motorizacao/output/motorization_capitals_pivot_motorizado2.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv(motorization_rms_pivot_moto , "./motorizacao/output/motorization_rms_pivot_moto.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv(motorization_rms_pivot_motorizado , "./motorizacao/output/motorization_rms_pivot_motorizado.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv(motorization_base2 , "./motorizacao/output/motorization_base.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv(motor_abs2 , "./motorizacao/output/motor_abs.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv(final_data, "./motorizacao/output/final_data.csv", fileEncoding = "latin1", row.names = FALSE)

# decimal mark = ","

write.csv2(motorization_capitals_pivot_moto , "./motorizacao/output/motorization_capitals_pivot_moto.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv2(motorization_capitals_pivot_motorizado , "./motorizacao/output/motorization_capitals_pivot_motorizado2.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv2(motorization_rms_pivot_moto , "./motorizacao/output/motorization_rms_pivot_moto.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv2(motorization_rms_pivot_motorizado , "./motorizacao/output/motorization_rms_pivot_motorizado.csv", fileEncoding = "latin1", row.names = FALSE)
write.csv2(final_data, "./motorizacao/output/final_data.csv", fileEncoding = "latin1", row.names = FALSE)



