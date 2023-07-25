# Carrega os pacotes necess?rios
# ? importante tomar cuidado, pois o pacote saiu do CRAN.
# Caso exita outro pacote semelhante ? prefer?vel utilzar

# Esse pacote faz scrap dessa p?gnina:
# http://tabnet.datasus.gov.br/cgi/deftohtm.exe?sim/cnv/obt10br.def
# Caso exista alguma d?vida ir direto ao site conferir


library(devtools)
library(datasus)
library(pbapply)
library(beepr)
library(dplyr)
library(geobr)
library(readODS)
library(sidrar)
library(purrr)
library(stringr)
library(janitor)
library(tidyr)
library(stringr)
library(data.table)
library(readr)
library(sidrar)
library(stringr)

# install_github("rpradosiqueira/datasus", force = T)

# Seleciona a esta??o de trabalho

setwd("D:/Projetos/Mobilidados/datasus_verificacao")

# Cria um dataframe de apoio para baixar os dados

lista_obt <- data.frame(grupo = c("Pedestre traumatizado em um acidente de transporte", 
                             "Ciclista traumatizado em um acidente de transporte",
                             "Motociclista traumat em um acidente de transporte", 
                             "Ocupante automóvel traumat acidente transporte",
                             "Ocupante ônibus traumat acidente de transporte",
                             "Ocupante triciclo motorizado traumat acid transp",
                             "Ocupante caminhonete traumat acidente transporte",
                             "Ocupante veíc transp pesado traumat acid transp",
                             "Outros acidentes de transporte terrestre"),
                   var = c("Pedestres", "Ciclistas", "Motociclistas","Ocupantes de automóvel", "Onibus", "Triciclo", "Caminhonete", "Pesado", "Outro_veic"),
                   var2 = c("Pedestres", "Ativo", "Ativo","Ocupantes de automóvel","Outros", "Outros", "Outros", "Outros", "Outros"))


# Fun??o para baixar os dados referentes ao n?mero de obitos por Grupo Cid

tabela_base <- get_sidra(x = 6579, # código da tabela
                   variable = 9324, # Código da variável
                   geo = "City", # Site
                   period = "2020")

tabela_base <- tabela_base[,c(6,7)]

tabela_base <- tabela_base %>% clean_names()

tabela_base$municipio_codigo <- substr(tabela_base$municipio_codigo,1,6)



periodo <- c(2000:2020)
sexo <- c("Masc", "Fem", "Ign")
raca <- c("Branca", "Preta", "Amarela", "Parda", "Indígena", "Ignorado")
fx_et <- c("Menor 1 ano",
           "1 a 4 anos",
           "5 a 9 anos",
           "10 a 14 anos",
           "15 a 19 anos",
           "20 a 29 anos",
           "30 a 39 anos",
           "40 a 49 anos",
           "50 a 59 anos",
           "60 a 69 anos",
           "70 a 79 anos",
           "80 anos e mais",
           "Idade ignorada")


# e <- 2000
# i <- "Pedestre traumatizado em um acidente de transporte"

pegar_dados_mun <- function(i){
  tabela_b <- tabela_base
  for(p in periodo){
    tabela_inter <- sim_obt10_mun(linha = "Município", # Dados por municipio.
                                coluna = "Ano do Óbito", # Dados por ano de óbito.
                                conteudo = 2, # Escolha por local de ocorrência.
                                periodo = p, # Período desejado. Bom verificar qual é o útimo ano disponível
                                grupo_cid10 = i,
                                sexo = "all",
                                cor_raca = "all",
                                faixa_etaria= "all")   #grupo cid10 desejado 
    tabela_inter$Município <- substr(tabela_inter$Município,1,6)
    tabela_inter <- tabela_inter[-1,]
    tabela_inter <- tabela_inter[,-3]
    tabela_inter <- tabela_inter %>% clean_names()
    tabela_b <- left_join(tabela_b,tabela_inter, c("municipio_codigo" = "municipio"))
    
  }
  if (length(i) == 1) {
    tipo <- lista_obt$var[lista_obt$grupo == i]
  } else if (length(i) >= 2 & length(i) <= 8) {
    tipo <- unique(lista_obt$var2[lista_obt$grupo %in% i])
  } else if (length(i) == 9) {
    tipo <- "Total"
  }
  
  if (exists("tipo")) {
    tabela_b$tipo <- tipo
  }
  return(tabela_b)
}

# tab_constr <- do.call(rbind,pblapply(lista_obt$grupo, pegar_dados_mun))

tab_constr <- pegar_dados_mun(lista_obt$grupo)

tab_outros <- pegar_dados_mun(lista_obt$grupo[lista_obt$var2=="Outros"])

tab_ativo <- pegar_dados_mun(lista_obt$grupo[lista_obt$var2=="Ativo"])

tab_cada <- do.call(rbind ,pblapply(lista_obt$grupo[c(1:4)],pegar_dados_mun))


tab_todos <- rbind(tab_constr, tab_outros,tab_cada)

names(tab_todos) <- sub("^x", "", names(tab_todos))

# tab_todos <- tab_todos %>% mutate(tipo2 = case_when(tipo == "Pedestres" ~ "Ativo",
#                                             tipo == "Ciclistas" ~ "Ativo",
#                                             tipo == "Motociclistas" ~ "Motociclistas",
#                                             tipo =="Ocupantes de automóvel" ~ "Ocupantes de automóvel",
#                                             tipo == "Onibus" ~ "Outros",
#                                             tipo == "Triciclo" ~ "Outros",
#                                             tipo == "Caminhonete" ~ "Outros",
#                                             tipo == "Pesado" ~ "Outros",
#                                             tipo == "Outro_veic" ~ "Outros"))



# tab_todos_sum <- tab_todos %>% select(-c(1:5)) %>% group_by(NOME, tipo) %>% summarise_all(sum,na.rm = TRUE) %>%
#  mutate(tipo = factor(tipo, levels = lista3)) %>% arrange(tipo, desc(NOME)) # catar


rm(list = setdiff(ls(), c("periodo","tab_todos")))

# tab_todos %>% pivot_longer(!c("code_muni6","tipo"), names_to = "ano", values_to = "valor")


pop <- readRDS("D:/Projetos/mobilidados/populacao/output/tabela_pop.rds")

# pop %>% mutate(junt = str_c(COD_MUN,"-",ano))


tab_todos2 <- tab_todos[-2] %>% left_join(select(pop, 1:7), c("municipio_codigo"="COD_MUN")) %>% 
  select(c("cod_uf","uf","municipio_codigo","municipio","capitais","NOME","tipo",
           paste(periodo))) # catar


# Todas as mortes

tab_todos2_pop <- tab_todos2[,c(1:7)] %>% left_join(pop[,c("COD_MUN", paste(periodo))], c("municipio_codigo" = "COD_MUN"))




# create an empty object to store the results
tab_final <- NULL


# loop through the 'periodo' variable
for (i in periodo) {
  # calculate 'tab_inter' for each period
  tab_inter <- tab_todos2[, as.character(i)] / tab_todos2_pop[, as.character(i)] * 100000
  # convert 'tab_inter' to a data frame and rename the column to the period
  tab_inter <- data.frame(i = tab_inter)
  names(tab_inter)[1] <- i
  # check if 'tab_final' is empty
  if (is.null(tab_final)) {
    tab_final <- tab_inter
  } else {
    tab_final <- bind_cols(tab_final, tab_inter)
  }
}


# view the final data frame
tab_final

taxa_final_mun <- cbind(tab_todos2_pop[,c(1:7)],tab_final) # catar




lista3 <- c("Total", "Pedestres" , "Ciclistas", "Motociclistas", "Ocupantes de automóvel", "Outros")


# lista4 <- c("code_muni6","tipo", "taxa_mort_mun2000","taxa_mort_mun2001", "taxa_mort_mun2002", "taxa_mort_mun2003", "taxa_mort_mun2004",
#        "taxa_mort_mun2005","taxa_mort_mun2006", "taxa_mort_mun2007", "taxa_mort_mun2008", "taxa_mort_mun2009",
#        "taxa_mort_mun2010", "taxa_mort_mun2011","taxa_mort_mun2012", "taxa_mort_mun2013", "taxa_mort_mun2014",
#        "taxa_mort_mun2015", "taxa_mort_mun2016", "taxa_mort_mun2017", "taxa_mort_mun2018", "taxa_mort_mun2019",
#        "taxa_mort_mun2020")
 



# taxa_final_mun[!(is.na(taxa_final_mun[,8:26]) | taxa_final_mun[,8:26]==""), ]

# filtro <- apply(taxa_final_mun[,8:26], 1, function(x) all(is.na(x)))

# teste2 <- taxa_final_mun[!filtro,]




tab_morte_rm <- tab_todos2 %>% select(-c(1:5)) %>% group_by(NOME, tipo) %>% summarise_all(sum,na.rm = TRUE) %>%
  mutate(tipo = factor(tipo, levels = lista3)) %>% arrange(tipo, desc(NOME)) # catar

tab_pop_rm <- pop %>% select(-c(1:6)) %>% group_by(NOME) %>% summarise_all(sum,na.rm = TRUE) %>% arrange(desc(NOME)) 

tab_pop_rm_prep <- tab_morte_rm[,1:2] %>% left_join(tab_pop_rm, c("NOME"="NOME"))

# create an empty object to store the results
tab_final_rm <- NULL

# loop through the 'periodo' variable
for (i in periodo) {
  # calculate 'tab_inter' for each period
  tab_inter <- tab_morte_rm[, as.character(i)]/tab_pop_rm_prep[,as.character(i)]*100000
  # convert 'tab_inter' to a data frame and rename the column to the period
  tab_inter <- data.frame(i = tab_inter)
  names(tab_inter)[1] <- i
  # check if 'tab_final' is empty
  if (is.null(tab_final)) {
    tab_final_rm <- tab_inter
  } else {
    tab_final_rm <- bind_cols(tab_final_rm, tab_inter)
  }
}


# view the final data frame
tab_final_rm

taxa_final_rms <- cbind(tab_pop_rm_prep[,c(1:2)],tab_final_rm) # catar


# Corrigir o NA em RMs


write.csv2(basao, "F:/Projetos/mobilidados/datasus_verificacao/output/taxa_mort_mun.csv", row.names = FALSE)
write.csv2(basao2, "F:/Projetos/mobilidados/datasus_verificacao/output/num_mort_mun.csv", row.names = FALSE)
write.csv2(taxa_final_rm, "F:/Projetos/mobilidados/datasus_verificacao/output/taxa_final_rm.csv", row.names = FALSE)
write.csv2(tab_morte_rm, "F:/Projetos/mobilidados/datasus_verificacao/output/tab_morte_rm.csv", row.names = FALSE)
