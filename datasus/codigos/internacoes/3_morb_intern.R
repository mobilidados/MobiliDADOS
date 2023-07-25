


##############

# 
# 
# linha = "Munic\u00EDpio"
# coluna = "N\u00e3o ativa"
# conteudo = "Internações"
# periodo = c("fibr0801.dbf", "fibr0802.dbf")
# municipio = "all"
# capital = "all"
# cir = "all"
# macrorregiao_de_saude = "all"
# microrregiao_ibge = "all"
# ride = "all"
# territorio_da_cidadania = "all"
# mesorregiao_pndr = "all"
# amazonia_legal = "all"
# semiarido = "all"
# faixa_de_fronteira = "all"
# zona_de_fronteira = "all"
# municipio_de_extrema_pobreza = "all"
# carater_atendimento = "all"
# regime="all"
# grande_grup_causas= "all"
# grupo_causas= "all"
# categoria_causas= "all"
# faixa_etaria= "1 a 4 anos"
# faixa_etaria_detalhada= "all"
# sexo= "all"
# cor_raca= "all"



morb_intern <- function(linha = "Munic\u00EDpio", coluna = "N\u00e3o ativa", conteudo = "Internações", periodo = "last", municipio = "all",
                          capital = "all", cir = "all", macrorregiao_de_saude = "all", microrregiao_ibge = "all", ride = "all",
                          territorio_da_cidadania = "all", mesorregiao_pndr = "all", amazonia_legal = "all", semiarido = "all",
                          faixa_de_fronteira = "all", zona_de_fronteira = "all", municipio_de_extrema_pobreza = "all",
                          carater_atendimento = "all", regime="all",grande_grup_causas= "all",grupo_causas="all",categoria_causas= "all",
                        faixa_etaria= "all",faixa_etaria_detalhada= "all",sexo= "all",cor_raca= "all"){
  

library(dplyr)
  
page <- xml2::read_html("http://tabnet.datasus.gov.br/cgi/deftohtm.exe?sih/cnv/fibr.def")


#### DF ####
linha.df <- data.frame(id = page %>% rvest::html_nodes("#L option") %>% rvest::html_text() %>% trimws(),
                       value = page %>% rvest::html_nodes("#L option") %>% rvest::html_attr("value"))
linha.df[] <- lapply(linha.df, as.character)


coluna.df <- data.frame(id = page %>% rvest::html_nodes("#C option") %>% rvest::html_text() %>% trimws(),
                        value = page %>% rvest::html_nodes("#C option") %>% rvest::html_attr("value"))
coluna.df[] <- lapply(coluna.df, as.character)


conteudo.df <- data.frame(id = page %>% rvest::html_nodes("#I option") %>% rvest::html_text() %>% trimws(),
                        value = page %>% rvest::html_nodes("#I option") %>% rvest::html_attr("value"))

periodos.df <- data.frame(id = page %>% rvest::html_nodes("#A option") %>% rvest::html_text() %>% trimws(),
                          value = page %>% rvest::html_nodes("#A option") %>% rvest::html_attr("value"))

municipios.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S1 option") %>% rvest::html_text() %>% readr::parse_number(),
                                             value = page %>% rvest::html_nodes("#S1 option") %>% rvest::html_attr("value")))

capital.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S2 option") %>% rvest::html_text() %>% readr::parse_number(),
                                          value = page %>% rvest::html_nodes("#S2 option") %>% rvest::html_attr("value")))

cir.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S3 option") %>% rvest::html_text() %>% readr::parse_number(),
                                      value = page %>% rvest::html_nodes("#S3 option") %>% rvest::html_attr("value")))

macrorregiao_de_saude.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S4 option") %>% rvest::html_text() %>% readr::parse_number(),
                                                        value = page %>% rvest::html_nodes("#S4 option") %>% rvest::html_attr("value")))

microrregiao_ibge.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S5 option") %>% rvest::html_text() %>% readr::parse_number(),
                                                    value = page %>% rvest::html_nodes("#S5 option") %>% rvest::html_attr("value")))

ride.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S6 option") %>% rvest::html_text() %>% readr::parse_number(),
                                       value = page %>% rvest::html_nodes("#S6 option") %>% rvest::html_attr("value")))

territorio_da_cidadania.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S7 option") %>% rvest::html_text() %>% readr::parse_number(),
                                                          value = page %>% rvest::html_nodes("#S7 option") %>% rvest::html_attr("value")))

mesorregiao_pndr.df <- suppressWarnings(data.frame(id = page %>% rvest::html_nodes("#S8 option") %>% rvest::html_text() %>% readr::parse_number(),
                                                   value = page %>% rvest::html_nodes("#S8 option") %>% rvest::html_attr("value")))

amazonia_legal.df <- data.frame(id = page %>% rvest::html_nodes("#S9 option") %>% rvest::html_text() %>% trimws(),
                                value = page %>% rvest::html_nodes("#S9 option") %>% rvest::html_attr("value"))
amazonia_legal.df[] <- lapply(amazonia_legal.df, as.character)

semiarido.df <- data.frame(id = page %>% rvest::html_nodes("#S10 option") %>% rvest::html_text() %>% trimws(),
                           value = page %>% rvest::html_nodes("#S10 option") %>% rvest::html_attr("value"))
semiarido.df[] <- lapply(semiarido.df, as.character)

faixa_de_fronteira.df <- data.frame(id = page %>% rvest::html_nodes("#S11 option") %>% rvest::html_text() %>% trimws(),
                                    value = page %>% rvest::html_nodes("#S11 option") %>% rvest::html_attr("value"))
faixa_de_fronteira.df[] <- lapply(faixa_de_fronteira.df, as.character)

zona_de_fronteira.df <- data.frame(id = page %>% rvest::html_nodes("#S12 option") %>% rvest::html_text() %>% trimws(),
                                   value = page %>% rvest::html_nodes("#S12 option") %>% rvest::html_attr("value"))
zona_de_fronteira.df[] <- lapply(zona_de_fronteira.df, as.character)

municipio_de_extrema_pobreza.df <- data.frame(id = page %>% rvest::html_nodes("#S13 option") %>% rvest::html_text() %>% trimws(),
                                              value = page %>% rvest::html_nodes("#S13 option") %>% rvest::html_attr("value"))

municipio_de_extrema_pobreza.df[] <- lapply(municipio_de_extrema_pobreza.df, as.character)

carater_atendimento.df <- data.frame(id = page %>% rvest::html_nodes("#S14 option") %>% rvest::html_text() %>% trimws(),
                                  value = page %>% rvest::html_nodes("#S14 option") %>% rvest::html_attr("value"))

regime.df <- data.frame(id = page %>% rvest::html_nodes("#S15 option") %>% rvest::html_text() %>% trimws(),
                     value = page %>% rvest::html_nodes("#S15 option") %>% rvest::html_attr("value"))

grande_grup_causas.df <- data.frame(id = page %>% rvest::html_nodes("#S16 option") %>% rvest::html_text() %>% trimws(),
                                 value = page %>% rvest::html_nodes("#S16 option") %>% rvest::html_attr("value"))

grupo_causas.df <- data.frame(id = page %>% rvest::html_nodes("#S17 option") %>% rvest::html_text() %>% trimws(),
                           value = page %>% rvest::html_nodes("#S17 option") %>% rvest::html_attr("value"))

categoria_causas.df <- data.frame(id = page %>% rvest::html_nodes("#S18 option") %>% rvest::html_text() %>% trimws(),
                               value = page %>% rvest::html_nodes("#S18 option") %>% rvest::html_attr("value"))

faixa_etaria.df <- data.frame(id = page %>% rvest::html_nodes("#S19 option") %>% rvest::html_text() %>% trimws(),
                              value = page %>% rvest::html_nodes("#S19 option") %>% rvest::html_attr("value"))
faixa_etaria.df[] <- lapply(faixa_etaria.df, as.character)

faixa_etaria_detalhada.df <- data.frame(id = page %>% rvest::html_nodes("#S20 option") %>% rvest::html_text() %>% trimws(),
                                        value = page %>% rvest::html_nodes("#S20 option") %>% rvest::html_attr("value"))
faixa_etaria_detalhada.df[] <- lapply(faixa_etaria_detalhada.df, as.character)

sexo.df <- data.frame(id = page %>% rvest::html_nodes("#S21 option") %>% rvest::html_text() %>% trimws(),
                      value = page %>% rvest::html_nodes("#S21 option") %>% rvest::html_attr("value"))
sexo.df[] <- lapply(sexo.df, as.character)

cor_raca.df <- data.frame(id = page %>% rvest::html_nodes("#S22 option") %>% rvest::html_text() %>% trimws(),
                          value = page %>% rvest::html_nodes("#S22 option") %>% rvest::html_attr("value"))
cor_raca.df[] <- lapply(cor_raca.df, as.character)



cir.df[1,1] <- macrorregiao_de_saude.df [1,1] <-microrregiao_ibge.df[1,1] <- ride.df[1,1] <- "all"
territorio_da_cidadania.df[1,1] <- mesorregiao_pndr.df[1,1] <- amazonia_legal.df[1,1] <- "all"
semiarido.df[1,1] <- faixa_de_fronteira.df[1,1] <- zona_de_fronteira.df[1,1] <- "all"
municipio_de_extrema_pobreza.df[1,1] <- carater_atendimento.df[1,1] <- regime.df[1,1] <- municipios.df[1,1] <- capital.df[1,1] <- "all"
grande_grup_causas.df[1,1] <- grupo_causas.df[1,1] <- categoria_causas.df[1,1] <- "all"
faixa_etaria.df[1,1] <- faixa_etaria_detalhada.df[1,1] <- sexo.df[1,1] <- cor_raca.df[1,1] <- "all"




#### ERROR HANDLING ####
if (linha != "Munic\u00edpio") {
  
  if (!is.character(linha)) stop("The 'linha' argument must be a character element")
  
  if(length(linha) != 1) stop("The 'linha' argument must have only one element")
  
  if (!(all(linha %in% linha.df$id))) {
    
    if (!(all(linha %in% linha.df$value))) {
      
      stop("The 'linha' argument is misspecified")
      
    }
    
  }
  
}

if (coluna != "N\u00e3o ativa") {
  
  if (!is.character(coluna)) stop("The 'coluna' argument must be a character element")
  
  if(length(coluna) != 1) stop("The 'coluna' argument must have only one element")
  
  if (!(all(coluna %in% coluna.df$id))) {
    
    if (!(all(coluna %in% coluna.df$value))) {
      
      stop("The 'coluna' argument is misspecified")
      
    }
    
  }
  
}

if (conteudo != 1 & conteudo != 2) {
  
  if (is.numeric(conteudo)) stop("The only numeric elements allowed are 1 or 2")
  
  if(length(conteudo) != 1) stop("The 'coluna' argument must have only one element")
  
  if (!(all(conteudo %in% conteudo.df$id2))) {
    
    if (!(all(conteudo %in% conteudo.df$value))) {
      
      stop("The 'conteudo' argument is misspecified")
      
    }
    
  }
  
}

if (periodo[1] != "last") {
  
  if (is.character(periodo)) {
    periodo <- periodo
  }
  
  if (!(all(periodo %in% periodos.df$value))) stop("The 'periodo' argument is misspecified")
  
}

if (any(municipio != "all")) {
  
  municipio <- as.character(municipio)
  
  if (!(all(municipio %in% municipios.df$value))) stop("Some element in 'municipio' argument is wrong")
  
}

if (any(capital != "all")) {
  
  capital <- as.character(capital)
  
  if (!(all(capital %in% capital.df$id))) stop("Some element in 'capital' argument is wrong")
  
}

if (any(cir != "all")) {
  
  cir <- as.character(cir)
  
  if (!(all(cir %in% cir.df$id))) stop("Some element in 'cir' argument is wrong")
  
}

if (any(macrorregiao_de_saude != "all")) {
  
  macrorregiao_de_saude <- as.character(macrorregiao_de_saude)
  
  if (!(all(macrorregiao_de_saude %in% macrorregiao_de_saude.df$id))) stop("Some element in 'macrorregiao_de_saude' argument is wrong")
  
}

if (any(microrregiao_ibge != "all")) {
  
  microrregiao_ibge <- as.character(microrregiao_ibge)
  
  if (!(all(microrregiao_ibge %in% microrregiao_ibge.df$id))) stop("Some element in 'microrregiao_ibge' argument is wrong")
  
}

if (any(ride != "all")) {
  
  ride <- as.character(ride)
  
  if (!(all(ride %in% ride.df$id))) stop("Some element in 'ride' argument is wrong")
  
}

if (any(territorio_da_cidadania != "all")) {
  
  territorio_da_cidadania <- as.character(as.numeric(territorio_da_cidadania))
  
  if (!(all(territorio_da_cidadania %in% territorio_da_cidadania.df$id))) stop("Some element in 'territorio_da_cidadania' argument is wrong")
  
}

if (any(mesorregiao_pndr != "all")) {
  
  mesorregiao_pndr <- as.character(as.numeric(mesorregiao_pndr))
  
  if (!(all(mesorregiao_pndr %in% mesorregiao_pndr.df$id))) stop("Some element in 'mesorregiao_pndr' argument is wrong")
  
}

if (any(amazonia_legal != "all")) {
  
  amazonia_legal <- as.character(amazonia_legal)
  
  if (!(all(amazonia_legal %in% amazonia_legal.df$id))) stop("The element in 'amazonia_legal' argument is wrong")
  
}

if (any(semiarido != "all")) {
  
  semiarido <- as.character(semiarido)
  
  if (!(all(semiarido %in% semiarido.df$id))) stop("The element in 'semiarido' argument is wrong")
  
}

if (any(faixa_de_fronteira != "all")) {
  
  faixa_de_fronteira <- as.character(faixa_de_fronteira)
  
  if (!(all(faixa_de_fronteira %in% faixa_de_fronteira.df$id))) stop("The element in 'faixa_de_fronteira' argument is wrong")
  
}

if (any(zona_de_fronteira != "all")) {
  
  zona_de_fronteira <- as.character(zona_de_fronteira)
  
  if (!(all(zona_de_fronteira %in% zona_de_fronteira.df$id))) stop("The element in 'zona_de_fronteira' argument is wrong")
  
}

if (any(municipio_de_extrema_pobreza != "all")) {
  
  municipio_de_extrema_pobreza <- as.character(municipio_de_extrema_pobreza)
  
  if (!(all(municipio_de_extrema_pobreza %in% municipio_de_extrema_pobreza.df$id))) stop("The element in 'municipio_de_extrema_pobreza' argument is wrong")
  
}

if (any(carater_atendimento != "all")) {
  
  causas_evitaveis <- as.character(causas_evitaveis)
  
  if (!(all(carater_atendimento %in% carater_atendimento.df$id))) {
    
    carater_atendimento <- as.character(carater_atendimento)
    
    if (!(all(carater_atendimento %in% carater_atendimento.df$value))) {
      
      stop("Some element in 'carater_atendimento' argument is wrong")
      
    }
    
  }
  
}


if (any(regime != "all")) {
  
  regime <- as.character(regime)
  
  if (!(all(regime %in% regime.df$id))) stop("Some element in 'regime' argument is wrong")
  
}

if (any(grande_grup_causas != "all")) {
  
  grande_grup_causas <- as.character(grande_grup_causas)
  
  if (!(all(grande_grup_causas %in% grande_grup_causas.df$id))) stop("Some element in 'grande_grup_causas' argument is wrong")
  
}

if (any(categoria_causas != "all")) {
  
  categoria_causas <- as.character(categoria_causas)
  
  if (!(all(categoria_causas %in% categoria_causas.df$id))) stop("Some element in 'categoria_causas' argument is wrong")
  
}

if (any(faixa_etaria != "all")) {
  
  if (!(all(faixa_etaria %in% faixa_etaria.df$id))) {
    
    faixa_etaria <- as.character(faixa_etaria)
    
    if (!(all(faixa_etaria %in% faixa_etaria.df$value))) {
      
      stop("Some element in 'faixa_etaria' argument is wrong")
      
    }
    
  }
  
}

if (any(faixa_etaria_detalhada != "all")) {
  
  if (!(all(faixa_etaria_detalhada %in% faixa_etaria_detalhada.df$id))) {
    
    faixa_etaria_detalhada <- as.character(faixa_etaria_detalhada)
    
    if (!(all(faixa_etaria_detalhada %in% faixa_etaria_detalhada.df$value))) {
      
      stop("Some element in 'faixa_etaria_detalhada' argument is wrong")
      
    }
    
  }
  
}

if (any(sexo != "all")) {
  
  if (!(all(sexo %in% sexo.df$id))) {
    
    sexo <- as.character(sexo)
    
    if (!(all(sexo %in% sexo.df$value))) {
      
      stop("Some element in 'sexo' argument is wrong")
      
    }
    
  }
  
}

if (any(cor_raca != "all")) {
  
  if (!(all(cor_raca %in% cor_raca.df$id))) {
    
    cor_raca <- as.character(cor_raca)
    
    if (!(all(cor_raca %in% cor_raca.df$value))) {
      
      stop("Some element in 'cor_raca' argument is wrong")
      
    }
    
  }
  
}




 #### FILTERS APPLICATIONS ####

  #linha
  if (linha %in% linha.df$id) {
    linha <- dplyr::filter(linha.df, linha.df$id %in% linha)
    linha <- linha$value
  }

  if (!stringi::stri_enc_isascii(linha)) {
    form_linha <- paste0("Linha=", "Munic\\u00EDpio")
  } else {
    form_linha <- paste0("Linha=", linha)
  }

# coluna

  if (!stringi::stri_enc_isascii(coluna)) {
    
    temp <-  base::data.frame( a =  c("Não ativa", "Ano/mês atendimento", "Caráter atendimento", "Faixa Etária 1", "Faixa Etária 2", "Cor/raça"),
                               b =  c("--N%E3o-Ativa--", "Ano%2Fm%EAs_atendimento", "Car%E1ter_atendimento", "Faixa_Et%E1ria_1", "Faixa_Et%E1ria_2", "Cor%2Fra%E7a"))
    form_coluna <- temp$b[temp$a %in% coluna]
    form_coluna <- paste0("Coluna=", form_coluna)
    
    } else {
    form_coluna <-  coluna.df$value[coluna.df$id %in% coluna ]
    form_coluna <- paste0("Coluna=", form_coluna)
  }

  #conteudo
   
  if (!stringi::stri_enc_isascii(conteudo)) {
    temp <-  base::data.frame( a =  c("Internações", "Valor serviços hospitalares", "Valor serviços profissionais", "Valor médio AIH", "Valor médio intern", "Dias permanência","Média permanência", "Óbitos"),
                               b =  c("Interna%E7%F5es", "Valor_servi%E7os_hospitalares", "Valor_servi%E7os_profissionais", "Valor_m%E9dio_AIH", "Valor_m%E9dio_intern", "Dias_perman%EAncia", "M%E9dia_perman%EAncia", "%D3bitos"))
    form_conteudo <- temp$b[temp$a %in% conteudo]
    form_conteudo <- paste0("Incremento=", form_conteudo)
  } else {
    form_conteudo <-  conteudo.df$value[conteudo.df$id %in% conteudo ]
    form_conteudo <- paste0("Incremento=", form_conteudo)
  }

  #periodo
suppressWarnings({
  periodo <- ifelse(periodo == "last", utils::head(periodos.df$value, 1), periodo)
})
  form_periodo <- dplyr::filter(periodos.df, periodos.df$value %in% periodo)
  form_periodo <- paste0("Arquivos=", form_periodo$value, collapse = "&")

  form_pesqmes1 <- "pesqmes1=Digite+o+texto+e+ache+f%E1cil"

  ####municipio
  ### refazer!!!
  if(municipio == "all"){
  form_municipio <- municipios.df[municipios.df$id %in% municipio,][2]
  form_municipio <- paste0("SMunic%EDpio=", form_municipio, collapse = "&")
  } else{
    form_municipio <- municipios.df$value[municipios.df$id %in% municipio]
    form_municipio <- paste0("SMunic%EDpio=", form_municipio, collapse = "&")
  }


  form_pesqmes2 <- "pesqmes2=Digite+o+texto+e+ache+f%E1cil"

  #capital
  
  form_capital <- dplyr::filter(capital.df, capital.df$id %in% capital)
  form_capital <- paste0("SCapital=", form_capital$value, collapse = "&")

  form_pesqmes3 <- "pesqmes3=Digite+o+texto+e+ache+f%E1cil"

  #cir
  form_cir <- dplyr::filter(cir.df, cir.df$id %in% cir)
  form_cir <- paste0("SRegi%E3o_de_Sa%FAde_%28CIR%29=", form_cir$value, collapse = "&")

  form_pesqmes4 <- "pesqmes4=Digite+o+texto+e+ache+f%E1cil"

  #macrorregiao_de_saude
  form_macrorregiao_de_saude <- dplyr::filter(macrorregiao_de_saude.df, macrorregiao_de_saude.df$id %in% macrorregiao_de_saude)
  form_macrorregiao_de_saude <- paste0("SMacrorregi%E3o_de_Sa%FAde=", form_macrorregiao_de_saude$value, collapse = "&")

  form_pesqmes5 <- "pesqmes5=Digite+o+texto+e+ache+f%E1cil"

  #microrregiao_ibge
  form_microrregiao_ibge <- dplyr::filter(microrregiao_ibge.df, microrregiao_ibge.df$id %in% microrregiao_ibge)
  form_microrregiao_ibge <- paste0("SMicrorregi%E3o_IBGE=", form_microrregiao_ibge$value, collapse = "&")

  form_pesqmes6 <- "pesqmes6=Digite+o+texto+e+ache+f%E1cil"

  #ride
  form_ride <- dplyr::filter(ride.df, ride.df$id %in% ride)
  form_ride <- paste0("SRegi%E3o_Metropolitana_-_RIDE=", form_ride$value, collapse = "&")

  form_pesqmes7 <- "pesqmes7=Digite+o+texto+e+ache+f%E1cil"

  #territorio_da_cidadania
  form_territorio_da_cidadania <- dplyr::filter(territorio_da_cidadania.df, territorio_da_cidadania.df$id %in% territorio_da_cidadania)
  form_territorio_da_cidadania <- paste0("STerrit%F3rio_da_Cidadania=", form_territorio_da_cidadania$value, collapse = "&")

  form_pesqmes8 <- "pesqmes8=Digite+o+texto+e+ache+f%E1cil"

  #mesorregiao_pndr
  form_mesorregiao_pndr <- dplyr::filter(mesorregiao_pndr.df, mesorregiao_pndr.df$id %in% mesorregiao_pndr)
  form_mesorregiao_pndr <- paste0("SMesorregi%E3o_PNDR=", form_mesorregiao_pndr$value, collapse = "&")

  #amazonia_legal
  form_amazonia_legal <- dplyr::filter(amazonia_legal.df, amazonia_legal.df$id %in% amazonia_legal)
  form_amazonia_legal <- paste0("SAmaz%F4nia_Legal=", form_amazonia_legal$value, collapse = "&")

  #semiarido
  form_semiarido <- dplyr::filter(semiarido.df, semiarido.df$id %in% semiarido)
  form_semiarido <- paste0("SSemi%E1rido=", form_semiarido$value, collapse = "&")

  #faixa_de_fronteira
  form_faixa_de_fronteira <- dplyr::filter(faixa_de_fronteira.df, faixa_de_fronteira.df$id %in% faixa_de_fronteira)
  form_faixa_de_fronteira <- paste0("SFaixa_de_Fronteira=", form_faixa_de_fronteira$value, collapse = "&")

  #zona_de_fronteira
  form_zona_de_fronteira <- dplyr::filter(zona_de_fronteira.df, zona_de_fronteira.df$id %in% zona_de_fronteira)
  form_zona_de_fronteira <- paste0("SZona_de_Fronteira=", form_zona_de_fronteira$value, collapse = "&")

  #municipio_de_extrema_pobreza
  form_municipio_de_extrema_pobreza <- dplyr::filter(municipio_de_extrema_pobreza.df, municipio_de_extrema_pobreza.df$id %in% municipio_de_extrema_pobreza)
  form_municipio_de_extrema_pobreza <- paste0("SMunic%EDpio_de_extrema_pobreza=", form_municipio_de_extrema_pobreza$value, collapse = "&")
  
  
  #carater_atendimento
  form_carater_atendimento <- dplyr::filter(carater_atendimento.df, carater_atendimento.df$id %in% carater_atendimento)
  form_carater_atendimento <- paste0("SCar%E1ter_atendimento=", form_carater_atendimento$value, collapse = "&")
  
  #regime
  form_regime <- dplyr::filter(regime.df, regime.df$id %in% regime)
  form_regime <- paste0("SRegime=", form_regime$value, collapse = "&")
  
  form_pesqmes16 <- "pesqmes16=Digite+o+texto+e+ache+f%E1cil"
  
  #grande_grup_causas
  form_grande_grup_causas <- dplyr::filter(grande_grup_causas.df, grande_grup_causas.df$id %in% grande_grup_causas)
  form_grande_grup_causas <- paste0("SGrande_Grup_Causas=", form_grande_grup_causas$value, collapse = "&")
  
  form_pesqmes17 <- "pesqmes17=Digite+o+texto+e+ache+f%E1cil"
  
  #grupo_causas
  form_grupo_causas <- dplyr::filter(grupo_causas.df, grupo_causas.df$id %in% grupo_causas)
  form_grupo_causas <- paste0("SGrupo_de_Causas=", form_grupo_causas$value, collapse = "&")
  
  form_pesqmes18 <- "pesqmes18=Digite+o+texto+e+ache+f%E1cil"
  
  #categoria_causas
  form_categoria_causas <- dplyr::filter(categoria_causas.df, categoria_causas.df$id %in% categoria_causas)
  form_categoria_causas <- paste0("SCategorias_Causas=", form_categoria_causas$value, collapse = "&")
  
  form_pesqmes19 <- "pesqmes19=Digite+o+texto+e+ache+f%E1cil"
  
  #faixa_etaria
  form_faixa_etaria <- dplyr::filter(faixa_etaria.df, faixa_etaria.df$id %in% faixa_etaria)
  form_faixa_etaria <- paste0("SFaixa_Et%E1ria_1=", form_faixa_etaria$value, collapse = "&")
  
  form_pesqmes20 <- "pesqmes20=Digite+o+texto+e+ache+f%E1cil"
  
  #faixa_etaria_detalhada
  
  form_faixa_etaria_detalhada <- dplyr::filter(faixa_etaria_detalhada.df, faixa_etaria_detalhada.df$id %in% faixa_etaria_detalhada)
  form_faixa_etaria_detalhada <- paste0("SFaixa_Et%E1ria_2=", form_faixa_etaria_detalhada$value, collapse = "&")

  #sexo
  form_sexo <- dplyr::filter(sexo.df, sexo.df$id %in% sexo)
  form_sexo <- paste0("SSexo=", form_sexo$value, collapse = "&")

  #cor_raca
  form_cor_raca <- dplyr::filter(cor_raca.df, cor_raca.df$id %in% cor_raca)
  form_cor_raca <- paste0("SCor%2Fra%E7a=", form_cor_raca$value, collapse = "&")


  form_data <- paste(form_linha, form_coluna, form_conteudo, form_periodo, form_pesqmes1, form_municipio,
                     form_pesqmes2, form_capital, form_pesqmes3, form_cir, form_pesqmes4, form_macrorregiao_de_saude,
                     form_pesqmes5, form_microrregiao_ibge, form_pesqmes6, form_ride, form_pesqmes7,
                     form_territorio_da_cidadania, form_pesqmes8, form_mesorregiao_pndr, form_amazonia_legal,
                     form_semiarido, form_faixa_de_fronteira, form_zona_de_fronteira, form_municipio_de_extrema_pobreza,
                     form_carater_atendimento, form_regime, form_pesqmes16, form_grande_grup_causas, form_pesqmes17,
                     form_grupo_causas,form_pesqmes18,form_categoria_causas,form_pesqmes19,form_faixa_etaria,
                     form_pesqmes20,form_faixa_etaria_detalhada,form_sexo,form_cor_raca,"formato=table&mostre=Mostra", sep = "&")

  
  form_data <- gsub("\\\\u00", "%", form_data)
  
  ##### REQUEST FORM AND DATA WRANGLING ####
  site <- httr::POST(url = "http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sih/cnv/fibr.def",
                     body = form_data)
  
  tabdados <- httr::content(site, encoding = "Latin1") %>%
    rvest::html_nodes(".tabdados tbody td") %>%
    rvest::html_text() %>%
    trimws()
  
  col_tabdados <- httr::content(site, encoding = "Latin1") %>%
    rvest::html_nodes("th") %>%
    rvest::html_text() %>%
    trimws()
  
  f1 <- function(x) x <- gsub("\\.", "", x)
  f2 <- function(x) x <- as.numeric(as.character(x))
  
  tabela_final <- as.data.frame(matrix(data = tabdados, nrow = length(tabdados)/length(col_tabdados),
                                       ncol = length(col_tabdados), byrow = TRUE))
  
  names(tabela_final) <- col_tabdados
  
  tabela_final[-1] <- lapply(tabela_final[-1], f1)
  tabela_final[-1] <- suppressWarnings(lapply(tabela_final[-1], f2))
  
  tabela_final
  
  ##############
  
  }
