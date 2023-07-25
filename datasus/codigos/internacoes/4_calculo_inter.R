# Source the required R scripts
source("./datasus/codigos/internacoes/1_get_mun.R")
source("./datasus/codigos/internacoes/0_periodo_df.R")
source("./datasus/codigos/internacoes/2_get_inter.R")
source("./datasus/codigos/internacoes/3_morb_intern.R")

# Load the required libraries
library(sidrar)
library(janitor)
library(stringr)
library(readr)
library(purrr)
library(beepr)
library(R.utils)  # for withTimeout function

# Create a data frame to store the list of morbidities
lista_morb <- data.frame(
  grupo = c("V01-V09 Pedestre traumatizado acid transporte",
            "V10-V19 Ciclista traumatizado acid transporte",
            "V20-V29 Motociclista traumatizado acid transp",
            "V30-V39 Ocup triciclo motor traum acid transp",
            "V40-V49 Ocup automóvel traum acid transporte",
            "V50-V59 Ocup caminhonete traum acid transporte",
            "V60-V69 Ocup veíc transp pesado traum acid tran",
            "V70-V79 Ocup ônibus traumatizado acid transport",
            "V80-V89 Outros acid transporte terrestre"),
  var = c("Pedestres", "Ciclistas", "Motociclistas","Triciclo","Ocupantes de automóvel","Caminhonete","Pesado", "Onibus", "Outro_veic"),
  var2 = c("Pedestres", "Ciclistas", "Motociclistas","Outros","Ocupantes de automóvel", "Outros", "Outros", "Outros", "Outros")
)

anos <- 2008:2022 # Replace with the actual range of years you want to iterate over
sexo <- c("Masc", "Fem", "Ign")
faixa_etaria <- c("Menor 1 ano", "1 a 4 anos", "5 a 9 anos", "10 a 14 anos", 
                  "15 a 19 anos", "20 a 29 anos", "30 a 39 anos", "40 a 49 anos", 
                  "50 a 59 anos", "60 a 69 anos", "70 a 79 anos", "80 anos e mais", 
                  "Idade ignorada")
cor_raca <- c("Branca", "Preta", "Parda", "Amarela", "Indígena", "Sem informação")

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
  temp_file <- paste0("./datasus/output/internacoes/temp/morb_data_", ano, ".rds")
  
  # Write the data frame to the temporary file in R-specific binary format
  saveRDS(df_year, temp_file)
  
  Sys.sleep(20) 
  
  beep(3)
  Sys.sleep(20) 
}