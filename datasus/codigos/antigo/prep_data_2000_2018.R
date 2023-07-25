library(geobr)
library(dplyr)
library(beepr)
library(sf)
library(gdata)
library(tidyverse)
library(stringi)
library(datasus)

setwd('D:/R')


# Download geobr
y <- 2010
state <- read_state(code_state = "all", year=y) %>% mutate(code_state = as.character(code_state)) %>%st_sf()
mesor <- read_meso_region(code_meso = "all", year=y)
munic <- read_municipality(code_muni = "all", year=y) %>% mutate(code_muni = as.character(code_muni)) %>%st_sf()
regio <- read_region(year = y)
beep()

write_rds(state, "D:/R/dados/IBGE/estados.rds")
write_rds(mesor, "D:/R/dados/IBGE/mesoregi�es.rds")
write_rds(munic, "D:/R/dados/IBGE/municipios.rds")
write_rds(regio, "D:/R/dados/IBGE/regi�es.rds")

#criar centroids
centroids_munic <- st_centroid(munic)
centroids_state <- st_centroid(state)
centroids_regio <- st_centroid(regio)

#incluir regioes nos centroides dos municipios
state_df <- as.data.frame(state)
centroids_munic <- left_join(centroids_muni, state_df %>% select(code_state, name_region))

#tabela correpondencia entre recortes territoriais
df <- lookup_muni('all') #baixar tabela com todos os dados para meso regioes, estados, municipios
df <- df %>% mutate(code_state = as.character(code_state))
df <- left_join(df, state_df %>% select(code_state, name_region))
df <- df %>% mutate(code_muni6 = substr(code_muni, 1, 6))

openxlsx::write.xlsx(df, "D:/R/dados/IBGE/tabela_correspondencia_recortes_geograficos.xlsx")

#pop_2018
pop_2018 <- st_read("D:/R/dados/IBGE/estimativas_pop/estimativa_dou_2018_20181019.ods",
               layer = 'Municípios')

colnames(pop_2018) <- as.character(unlist(pop_2018[2,]))# pegar nome das colunas
pop_2018 <- pop_2018[-c(1:2),]#eliminar linhas desnecessaria
pop_2018$code_muni = stri_join(pop_2018$`COD. UF`, pop_2018$`COD. MUNIC`, sep = "")
pop_2018$pop <- pop_2018$`POPULAÃ‡ÃƒO ESTIMADA`
pop_2018 <- pop_2018 %>% mutate(code_muni6 = substr(code_muni,1,6))%>% #transformar coluna em 6 digitos
  select(UF, code_muni6, code_muni, pop)

pop_2018[is.na(pop_2018)] <- 0 
names(pop_2018)


# total
total <- sim_obt10_mun(linha = "Município", #dados por municipio
                     coluna = "Ano do Óbito", #por ano de obito
                     conteudo = 2, #por local de ocorrencia
                     periodo = c(2000:2018), #periodo desejado
                     grupo_cid10 = c("Pedestre traumatizado em um acidente de transporte",
                                     "Ciclista traumatizado em um acidente de transporte",
                                     "Motociclista traumat em um acidente de transporte",
                                     "Ocupante triciclo motorizado traumat acid transp",
                                     "Ocupante automóvel traumat acidente transporte",
                                     "Ocupante caminhonete traumat acidente transporte",
                                     "Ocupante veíc transp pesado traumat acid transp",
                                     "Ocupante ônibus traumat acidente de transporte",
                                     "Outros acidentes de transporte terrestre")) #grupo cid10 desejado 


# modos ativos
ativo <- sim_obt10_mun(linha = "Município", #dados por municipio
                      coluna = "Ano do Óbito", #por ano de obito
                      conteudo = 2, #por local de ocorrencia
                      periodo = c(2000:2018), #periodo desejado
                      grupo_cid10 = c("Pedestre traumatizado em um acidente de transporte",
                                      "Ciclista traumatizado em um acidente de transporte"))

# motociclistas
motoc <- sim_obt10_mun(linha = "Município", #dados por municipio
                      coluna = "Ano do Óbito", #por ano de obito
                      conteudo = 2, #por local de ocorrencia
                      periodo = c(2000:2018), #periodo desejado
                      grupo_cid10 = "Motociclista traumat em um acidente de transporte") 


# automoveis
autom <- sim_obt10_mun(linha = "Município", #dados por municipio
                      coluna = "Ano do Óbito", #por ano de obito
                      conteudo = 2, #por local de ocorrencia
                      periodo = c(2000:2018), #periodo desejado
                      grupo_cid10 =   "Ocupante automóvel traumat acidente transporte")


# ônibus
onibus <- sim_obt10_mun(linha = "Município", #dados por municipio
                        coluna = "Ano do Óbito", #por ano de obito
                        conteudo = 2, #por local de ocorrencia
                        periodo = c(2000:2018), #periodo desejado
                        grupo_cid10 = "Ocupante ônibus traumat acidente de transporte")

# outros
outros <- sim_obt10_mun(linha = "Município", #dados por municipio
                        coluna = "Ano do Óbito", #por ano de obito
                        conteudo = 2, #por local de ocorrencia
                        periodo = c(2000:2018), #periodo desejado
                        grupo_cid10 = c("Ocupante triciclo motorizado traumat acid transp",
                                        "Ocupante caminhonete traumat acidente transporte",
                                        "Ocupante veíc transp pesado traumat acid transp",
                                        "Outros acidentes de transporte terrestre"))

beep()

# transforma NA em 0
total[is.na(total)] <- 0
ativo[is.na(ativo)] <- 0
motoc[is.na(motoc)] <- 0
autom[is.na(autom)] <- 0
onibus[is.na(onibus)] <- 0
outros[is.na(outros)] <- 0

# ajustes coluns code_muni6
tot <- tot %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)
ativ <- ativ %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)
moto <- moto %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)
auto <- auto %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)
onibus <- onibus %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)
outros <- outros %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)


tot    <- left_join(df,tot   )
ativ   <- left_join(df,ativ  )
moto   <- left_join(df,moto  )
auto   <- left_join(df,auto  )
onibus <- left_join(df,onibus)
outros <- left_join(df,outros)

View(tot)
head(tot,3)
head(ativ,3)
head(moto,3)
head(auto,3)
head(onibus,3)
head(outros,3)


#salvar
openxlsx::write.xlsx(tot   , "D:/R/dados/datasus/mortes/total_mortes_2000_2018.xlsx")
openxlsx::write.xlsx(ativ  , "D:/R/dados/datasus/mortes/ativo_mortes_2000_2018.xlsx")
openxlsx::write.xlsx(moto  , "D:/R/dados/datasus/mortes/moto_mortes_2000_2018.xlsx")
openxlsx::write.xlsx(auto  , "D:/R/dados/datasus/mortes/auto_mortes_2000_2018.xlsx")
openxlsx::write.xlsx(onibus, "D:/R/dados/datasus/mortes/onib_mortes_2000_2018.xlsx")
openxlsx::write.xlsx(outros, "D:/R/dados/datasus/mortes/outros_mortes_2000_2018.xlsx")



# mortes por usuários por regiao
total <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/total_mortes_2000_2018.xlsx") %>% mutate(code_muni = as.character(code_muni), tipo = "total")
ativo <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/ativo_mortes_2000_2018.xlsx") %>% mutate(code_muni = as.character(code_muni), tipo = "ativo")
motoc <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/moto_mortes_2000_2018.xlsx")  %>% mutate(code_muni = as.character(code_muni), tipo = "motociclistas")
autom <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/auto_mortes_2000_2018.xlsx")  %>% mutate(code_muni = as.character(code_muni), tipo = "automóveis")
onibu <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/onib_mortes_2000_2018.xlsx")  %>% mutate(code_muni = as.character(code_muni), tipo = "ônibus")
outro <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/outros_mortes_2000_2018.xlsx")%>% mutate(code_muni = as.character(code_muni), tipo = "outros")


tot <- setDT(total) #%>% select(code_muni, `2018`, name_region)
ati <- setDT(ativo) #%>% select(code_muni, `2018`, name_region)
mot <- setDT(motoc) #%>% select(code_muni, `2018`, name_region)
aut <- setDT(autom) #%>% select(code_muni, `2018`, name_region)
oni <- setDT(onibu) #%>% select(code_muni, `2018`, name_region)
out <- setDT(outro) #%>% select(code_muni, `2018`, name_region)

ati_reg <- ati[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                   `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                   `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                   `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                   `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                   `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                   `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                   `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                   `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                   `2018` = sum(`2018`, na.rm = T),Modo = "ativo"), by = name_region]

mot_reg <- mot[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                   `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                   `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                   `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                   `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                   `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                   `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                   `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                   `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                   `2018` = sum(`2018`, na.rm = T),Modo = "motociclistas"), by = name_region]

aut_reg <- aut[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                   `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                   `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                   `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                   `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                   `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                   `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                   `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                   `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                   `2018` = sum(`2018`, na.rm = T),Modo = "automóvel"), by = name_region]

oni_reg <- oni[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                   `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                   `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                   `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                   `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                   `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                   `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                   `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                   `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                   `2018` = sum(`2018`, na.rm = T),Modo = "ônibus"), by = name_region]

out_reg <- out[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                   `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                   `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                   `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                   `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                   `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                   `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                   `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                   `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                   `2018` = sum(`2018`, na.rm = T),Modo = "outros"), by = name_region]

fim_reg <- rbind(ati_reg, mot_reg, aut_reg, oni_reg, out_reg)
openxlsx::write.xlsx(fim_reg, "D:/R/dados/datasus/mortes/regiao_mortes_Modo_2000_2018.xlsx")



tot_reg <- tot[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                   `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                   `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                   `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                   `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                   `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                   `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                   `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                   `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                   `2018` = sum(`2018`, na.rm = T),Modo = "total"), by = name_region]

openxlsx::write.xlsx(tot_reg, "D:/R/dados/datasus/mortes/regiao_mortes_2000_2018.xlsx")

