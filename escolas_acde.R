library(sf)
library(dplyr)
library(readxl)
library(stringr)
layers <- st_layers("C:/Users/rebec/Downloads/Entrevistas ACDE 2.0.kml")
print(layers)
escolas_implantadas <- st_read("C:/Users/rebec/Downloads/Entrevistas ACDE 2.0.kml", layer = "Escolas Implantadas")
escolas_a_implantar <- st_read("C:/Users/rebec/Downloads/Entrevistas ACDE 2.0.kml", layer = "Escolas a implantar")
escolas_lista_espera <- st_read("C:/Users/rebec/Downloads/Entrevistas ACDE 2.0.kml", layer = "Escolas Lista de Espera")
escolas_implantadas[,2] <- "implantadas"
escolas_a_implantar[,2] <- "a_implantar"
escolas_lista_espera[,2] <- "lista_espera"
escolas <- rbind(escolas_implantadas, escolas_a_implantar,escolas_lista_espera)


escolas[12,1] <- "CIEP Professora Célia Martins Menna Barreto"
professor <- read_excel("C:/Users/rebec/Downloads/Professor_Entrega.xlsx", sheet = "Banco_Entrega")
infantil <- read_excel("C:/Users/rebec/Downloads/Infantil_Entrega.xlsx", sheet = "Banco_Entrega")
cuidador <- read_excel("C:/Users/rebec/Downloads/Cuidador_Entrega.xlsx", sheet = "Banco_Entrega")

#colocando a E.M. Domingos Bebiano nos 3 bancos de dados
professor$Escola <- str_replace(professor$Escola, "Outro", "E.M. DOMINGOS BEBIANO")
infantil$`Nome da escola` <- str_replace(infantil$`Nome da escola`, "Outro", "E.M. DOMINGOS BEBIANO")
cuidador$Escola <- str_replace(cuidador$Escola, "Outro", "E.M. DOMINGOS BEBIANO")

#Padronizando as bases
professor$Escola <- str_replace(professor$Escola, "\\(em implantação\\)", "")
infantil$`Nome da escola` <- str_replace(infantil$`Nome da escola`, "\\(em implantação\\)", "")
cuidador$Escola <- str_replace(cuidador$Escola, "\\(em implantação\\)", "")
escolas$Name <- toupper(escolas$Name)
escolas$Name <- str_replace(escolas$Name, "ESCOLA MUNICIPAL", "E. M.")
escolas <- escolas %>% rename(Escola = Name)
infantil <- infantil %>% rename(Escola = `Nome da escola`)
escolas$Escola <- str_replace(escolas$Escola, "E. M. MAESTRO FRANCISCO BRAGA", "E.M. MAESTRO FRANCISCO BRAGA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. PADRE JOSÉ DE ANCHIETA", "E.M. PADRE JOSÉ DE ANCHIETA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. CLÁUDIO IGNÁCIO DE OLIVEIRA", "E.M. CLAUDIO IGNACIO DE OLIVEIRA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. MEM DE SÁ", "E.M. MEM DE SÁ")
escolas$Escola <- str_replace(escolas$Escola, "E. M. ALBERTO BARTH", "E.M. ALBERTO BARTH")
escolas$Escola <- str_replace(escolas$Escola, "E. M. MENEZES VIEIRA", "E.M. MENEZES VIEIRA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. LOPES TROVÃO", "E.M. LOPES TROVÃO")
escolas$Escola <- str_replace(escolas$Escola, "E. M. ROSA DO POVO", "E.M. ROSA DO POVO")
escolas$Escola <- str_replace(escolas$Escola, "E. M. GUILHERME SILVEIRA", "E.M. GUILHERME DA SILVEIRA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. PRESIDENTE ARTHUR BERNARDES", "E.M. PRESIDENTE ARTHUR BERNARDES")
escolas$Escola <- str_replace(escolas$Escola, "E. M. WALDIR AZEVEDO FRANCO", "E.M. WALDIR AZEVEDO FRANCO")
escolas$Escola <- str_replace(escolas$Escola, "CIEP PROFESSORA CÉLIA MARTINS MENNA BARRETO", "CIEP PROFESSORA CELIA MARTINS MENNA BARRETO")
escolas$Escola <- str_replace(escolas$Escola, "E. M. EDMUNDO BITTENCOURT", "E.M. EDMUNDO BITTENCOURT")
escolas$Escola <- str_replace(escolas$Escola, "CIEP NAÇÃO RUBRO NEGRA", "CIEP NAÇÃO RUBRO NEGRA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. CLEMENTINO FRAGA", "E.M. CLEMENTINO FRAGA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. MOACYR PADILHA", "E.M. MOACYR PADILHA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. AFFONSO TAUNAY", "E.M. AFFONSO TAUNAY")
escolas$Escola <- str_replace(escolas$Escola, "E. M. PRIMÁRIO YÓLIS DA SILVA", "E.M. YOLIS DA SILVA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. ANITA GARIBALDI", "E.M. ANITA GARIBALDI")
escolas$Escola <- str_replace(escolas$Escola, "E. M. FLORIANO PEIXOTO", "E.M. FLORIANO PEIXOTO")
escolas$Escola <- str_replace(escolas$Escola, "E. M. MIGUEL ÂNGELO", "E.M. MIGUEL ANGELO")
escolas$Escola <- str_replace(escolas$Escola, "E. M. HEITOR BELTRÃO", "E.M. HEITOR BELTRÃO")
escolas$Escola <- str_replace(escolas$Escola, "E. M. PARAGUAI", "E.M. PARAGUAI")
escolas$Escola <- str_replace(escolas$Escola, "E. M. MESTRE WALDEMIRO", "E.M. MESTRE WALDEMIRO")
escolas$Escola <- str_replace(escolas$Escola, "CIEP CORONEL SARMENTO", "CIEP CORONEL SARMENTO")
escolas$Escola <- str_replace(escolas$Escola, "CIEP RUBENS GOMES", "CIEP RUBENS GOMES")
escolas$Escola <- str_replace(escolas$Escola, "CIEP METALÚRGICO BENEDITO CERQUEIRA", "CIEP METALURGICO BENEDITO CERQUEIRA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. CARDEAL ARCOVERDE", "E.M. CARDEAL ARCOVERDE")
escolas$Escola <- str_replace(escolas$Escola, "E. M. PADRE DEHON", "E.M. PADRE DEHON")
escolas$Escola <- str_replace(escolas$Escola, "E. M. CHURCHILL", "E.M. CHURCHILL")
escolas$Escola <- str_replace(escolas$Escola, "E. M. JORGE DE LIMA", "E.M. JORGE DE LIMA")
escolas$Escola <- str_replace(escolas$Escola, "CIEP LAMARTINE BABO", "CIEP LAMARTINE BABO")
escolas$Escola <- str_replace(escolas$Escola, "CIEP HERIVELTO MARTINS", "CIEP HERIVELTO MARTINS")
escolas$Escola <- str_replace(escolas$Escola, "E. M. BRASIL", "E.M. BRASIL")
escolas$Escola <- str_replace(escolas$Escola, "E. M. ALBERTO DE OLIVEIRA", "E.M. ALBERTO DE OLIVEIRA")
escolas$Escola <- str_replace(escolas$Escola, "E. M. DOMINGOS BEBIANO", "E. M. DOMINGOS BEBIANO")

professor$Escola <- trimws(professor$Escola)
cuidador$Escola <- trimws(cuidador$Escola)
infantil$Escola <- trimws(infantil$Escola)
escolas$Escola <- trimws(escolas$Escola)

#Bases finais
professor <- professor %>% left_join(escolas, c("Escola"="Escola"))
cuidador <- cuidador %>% left_join(escolas, c("Escola"="Escola"))
infantil <- infantil %>% left_join(escolas, c("Escola"="Escola"))

#Tirando a dimensão z
professor_final <- professor %>%
  st_as_sf()

professor_final <- st_zm(professor_final)

#Exportando em shp
st_write(professor_final, "C:/Users/rebec/Downloads/professor_final.shp")

#Teste
teste <- professor[c("Escola", "geometry")] %>% unique()
teste1 <- cuidador[c("Escola", "geometry")] %>% unique()
teste2 <- infantil[c("Escola", "geometry")] %>% unique()