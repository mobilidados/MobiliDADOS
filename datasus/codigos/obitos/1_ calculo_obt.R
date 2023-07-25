# Source the required R scripts

source("./datasus/codigos/obitos/0_get_inter.R")

# Load the required libraries
library(sidrar)
library(janitor)
library(stringr)
library(readr)
library(purrr)
library(R.utils) 
library(beepr)

# Create a data frame to store the list of morbidities
lista_morb <- data.frame(grupo = c("Pedestre traumatizado em um acidente de transporte", 
                                   "Ciclista traumatizado em um acidente de transporte",
                                   "Motociclista traumat em um acidente de transporte", 
                                   "Ocupante automóvel traumat acidente transporte",
                                   "Ocupante ônibus traumat acidente de transporte",
                                   "Ocupante triciclo motorizado traumat acid transp",
                                   "Ocupante caminhonete traumat acidente transporte",
                                   "Ocupante veíc transp pesado traumat acid transp",
                                   "Outros acidentes de transporte terrestre"),
                         var = c("Pedestres", "Ciclistas", "Motociclistas","Ocupantes de automóvel", "Onibus", "Triciclo", "Caminhonete", "Pesado", "Outro_veic"),
                         var2 = c("Pedestres", "Ciclistas", "Motociclistas","Ocupantes de automóvel","Outros", "Outros", "Outros", "Outros", "Outros"))




anos <- 2022
sexo <- c("Masc", "Fem", "Ign")
faixa_etaria <- c("Menor 1 ano", "1 a 4 anos", "5 a 9 anos", "10 a 14 anos", 
            "15 a 19 anos", "20 a 29 anos", "30 a 39 anos", "40 a 49 anos", 
            "50 a 59 anos", "60 a 69 anos", "70 a 79 anos", "80 anos e mais", 
            "Idade ignorada")
cor_raca <- c("Branca", "Preta", "Parda", "Amarela", "Indígena", "Ignorado")


# grupo_causas <- "Pedestre traumatizado em um acidente de transporte"
# sexo <- "Masc"
# faixa_etaria <- "Menor 1 ano"
# cor_raca <- "Branca"
# ano <- 2008
# # 
# get_inter(grupo_causas = grupo_causas, ano =  ano, sexo = sexo, cor_raca = cor_raca, faixa_etaria =  faixa_etaria)


# Loop over the years

for (ano in anos) {
  # Create a data frame with all combinations of parameters for the current year
  params <- expand.grid(
    grupo = lista_morb$grupo,
    ano = ano,
    sexo = sexo,
    faixa_etaria = faixa_etaria,
    cor_raca = cor_raca
  )
  
  # Filter params for the desired year
  params_year <- params
  
  # Create an empty list to store the data frames for the desired year
  df_year_list <- list()
  
  # Get the total number of iterations
  total_iterations <- nrow(params_year)
  
  # Define a recursive function to handle retries
  get_inter_retry <- function(j, params_year) {
    tryCatch({
      withTimeout({
        df <- get_inter(
          grupo_causas = params_year$grupo[j],
          ano = params_year$ano[j],
          sexo = params_year$sexo[j],
          cor_raca = params_year$cor_raca[j],
          faixa_etaria = params_year$faixa_etaria[j]
        )
        return(df)
      }, timeout = 60)  # Set the timeout to 60 seconds
    }, TimeoutException = function(e) {
      print(paste("Iteration", j, "timed out after 60 seconds. Retrying..."))
      Sys.sleep(60)  # Add a delay before retrying
      return(get_inter_retry(j, params_year))  # Retry the same iteration
    }, error = function(e) {
      return(NULL)  # Return NULL on error
    })
  }
  
  # Loop over the rows of params_year
  for (j in seq_len(total_iterations)) {
    df <- get_inter_retry(j, params_year)
    
    if (!is.null(df)) {
      df_year_list[[j]] <- df
      # Calculate the percent of completion
      percent_complete <- round(j / total_iterations * 100, 2)
      print(paste("Iteration", j, "for year", ano, "completed successfully. Completion:", percent_complete, "%"))
    } else {
      print(paste("Iteration", j, "for year", ano, "returned null or encountered an error. Skipping to next iteration."))
    }
    
    # Add a delay between interactions
    Sys.sleep(1)  # Adjust the delay time as needed
  }
  
  
  # Combine the data frames for the desired year into a single data frame
  df_year <- do.call(rbind, df_year_list)
  
  # Create a temporary file path for the desired year
  temp_file <- paste0("../datasus/codigos/obitos/output/obitos/temp/morb_data_", ano, ".rds")
  
  # Write the data frame to the temporary file in R-specific binary format
  saveRDS(df_year, temp_file)
  
  Sys.sleep(20) 
  
  beep(3)
  Sys.sleep(20) 
}
