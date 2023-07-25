get_inter <- function(grupo_causas, ano, sexo = "all", cor_raca = "all", faixa_etaria = "all") {
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
                           var2 = c("Pedestres", "Ciclistas", "Ciclistas","Ocupantes de automóvel","Outros", "Outros", "Outros", "Outros", "Outros"))
  
  tryCatch({

    internacoes_temp <- datasus::sim_obt10_mun(linha = "Município",
                                      coluna = "Ano do Óbito",
                                      conteudo = 2, # Escolha por local de ocorrência.
                                      periodo = ano,
                                      grupo_cid10 = grupo_causas,
                                      sexo = sexo,
                                      cor_raca = cor_raca,
                                      faixa_etaria = faixa_etaria)
    internacoes_temp <- internacoes_temp[1:2]
    names(internacoes_temp) <- c("Município", "obitos")
    internacoes_temp$ano <- ano
    internacoes_temp$Município <- substr(internacoes_temp$Município, 1, 6)
    internacoes_temp <- internacoes_temp %>% janitor::clean_names()
    internacoes_temp <- internacoes_temp[!c(internacoes_temp$municipio == "TOTAL"), ]
    internacoes_temp$tipo <- lista_morb$var[lista_morb$grupo == grupo_causas]
    internacoes_temp$sexo <- sexo
    internacoes_temp$cor_raca <- cor_raca
    internacoes_temp$faixa_etaria <- faixa_etaria
    internacoes_temp$ano <- ano
    
    return(internacoes_temp)
  }, error = function(err) {
    # Stop execution and print the error message
    stop("An error occurred: ", err)
  })
}


