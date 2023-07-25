get_inter <- function(grupo_causas, ano, sexo = "all", cor_raca = "all", faixa_etaria = "all") {
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
  
  tryCatch({

    internacoes_temp <- morb_intern(
      grupo_causas = grupo_causas,
      periodo = periodo_df$output_vector[periodo_df$output_year == ano],
      sexo = sexo,
      cor_raca = cor_raca,
      faixa_etaria = faixa_etaria
    )
    internacoes_temp$ano <- ano

    internacoes_temp$Município <- substr(internacoes_temp$Município, 1, 6)
    internacoes_temp <- internacoes_temp %>% clean_names()
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
