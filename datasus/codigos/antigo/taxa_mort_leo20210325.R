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
                   var = c("pedestre", "ciclista", "motocicleta","auto", "onibus", "triciclo", "caminhonete", "pesado", "outro_veic"))

# Fun??o para baixar os dados referentes ao n?mero de obitos por Grupo Cid

tabela_base <- get_sidra(x = 6579, # código da tabela
                   variable = 9324, # Código da variável
                   geo = "City", # Site
                   period = "2020")

tabela_base <- tabela_base[,c(6,7)]

tabela_base <- tabela_base %>% clean_names()

tabela_base$municipio_codigo <- substr(tabela_base$municipio_codigo,1,6)



periodo <- c(2000:2020)

# e <- 2000
# i <- "Pedestre traumatizado em um acidente de transporte"

pegar_dados_mun <- function(i){
  for(e in periodo){
    tabela_bai <- sim_obt10_mun(linha = "Município", # Dados por municipio.
                                coluna = "Ano do Óbito", # Dados por ano de óbito.
                                conteudo = 2, # Escolha por local de ocorrência.
                                periodo = e, # Período desejado. Bom verificar qual é o útimo ano disponível
                                grupo_cid10 = i)   #grupo cid10 desejado 
    tabela_bai$Município <- substr(tabela_bai$Município,1,6)
    tabela_bai <- tabela_bai[-1,]
    tabela_bai <- tabela_bai[,-3]
    tabela_bai <- tabela_bai %>% clean_names()
    tabela_base <- left_join(tabela_base,tabela_bai, c("municipio_codigo" = "municipio"))
  }
  return(tabela_base)
}

pblapply(lista_obt$grupo, pegar_dados_mun)

beep(8)

Sys.sleep(20)



ativo <- sim_obt10_mun(linha = "Município", # Dados por municipio.
              coluna = "Ano do Óbito", # Dados por ano de ?bito.
              conteudo = 2, # Escolha por local de ocorr?ncia.
              periodo = periodo, # Per?odo desejado. Bom verificar qual ? o ?timo ano dispon?vel
              grupo_cid10 = c("Pedestre traumatizado em um acidente de transporte",
              "Ciclista traumatizado em um acidente de transporte")) %>% print(.,row.names = FALSE)

Sys.sleep(20)

total_outros <- sim_obt10_mun(linha = "Município", # Dados por municipio.
                       coluna = "Ano do óbito", # Dados por ano de ?bito.
                       conteudo = 2, # Escolha por local de ocorr?ncia.
                       periodo = periodo, # Per?odo desejado. Bom verificar qual ? o ?timo ano dispon?vel
                       grupo_cid10 = c("Ocupante ?nibus traumat acidente de transporte",
                                       "Ocupante triciclo motorizado traumat acid transp",
                                       "Ocupante caminhonete traumat acidente transporte",
                                       "Ocupante ve?c transp pesado traumat acid transp",
                                       "Outros acidentes de transporte terrestre")) %>% print(.,row.names = FALSE)

Sys.sleep(20)



total <- sim_obt10_mun(linha = "Município", # Dados por municipio.
                       coluna = "Ano do óbito", # Dados por ano de ?bito.
                       conteudo = 2, # Escolha por local de ocorr?ncia.
                       periodo = periodo, # Per?odo desejado. Bom verificar qual ? o ?timo ano dispon?vel
                       grupo_cid10 = lista_obt$grupo) %>% print(.,row.names = FALSE)
Sys.sleep(20)

lista2 <- c("pedestre", "ciclista", "motocicleta","auto", "onibus", "triciclo", 
            "caminhonete", "pesado", "outro_veic", "ativo", "total_outros",
            "total")



# Seprando os C?digos dos Munic?pios e retirar linha de total

for(i in lista2){
  
  assign(i, get(i) %>% mutate(code_muni6 = substr(Munic?pio, 1, 6), Munic?pio = NULL, Total = NULL, tipo = i) %>% .[-1,],
         envir = .GlobalEnv)
}

Sys.sleep(20)

tab_todos <- do.call(rbind, mget(lista2))

# tab_todos %>% pivot_longer(!c("code_muni6","tipo"), names_to = "ano", values_to = "valor")


pop <- readRDS("F:/Projetos/mobilidados/populacao/output/tabela_pop.rds")

# pop %>% mutate(junt = str_c(COD_MUN,"-",ano))


tab_todos2 <- tab_todos %>% left_join(select(pop, 1:7), c("code_muni6"="COD_MUN")) %>% 
  select(c("cod_uf","uf","code_muni6","municipio","capitais","NOME","tipo",
           "2000","2001", "2002","2003","2004","2005","2006","2007",
           "2008","2009","2010","2011","2012","2013","2014","2015",
           "2016","2017","2018","2019", "2020"))

Sys.sleep(20)
# Todas as mortes

tab_todos2_pop <- tab_todos2[,c(1:7)] %>% left_join(pop[,c(4,8:28)], c("code_muni6" = "COD_MUN"))

i <- 2001

#taxa de mortalidade
Sys.sleep(20)
for(i in 2000:2020){
  
  assign(paste0("taxa_mort_mun", i),  tab_todos2[, as.character(i)]/tab_todos2_pop[,as.character(i)]*100000, envir = .GlobalEnv)
  
}

taxa_semi_final_mun <- do.call(cbind,mget(ls(pattern = "*taxa_mort_mun")))
taxa_final_mun <- cbind(tab_todos2_pop[,c(1:7)], taxa_semi_final_mun)




Sys.sleep(20)

lista3 <- c("total", "pedestre" , "ciclista", "motocicleta", "auto", "total_outros")


lista4 <- c("code_muni6","tipo", "taxa_mort_mun2000","taxa_mort_mun2001", "taxa_mort_mun2002", "taxa_mort_mun2003", "taxa_mort_mun2004",
        "taxa_mort_mun2005","taxa_mort_mun2006", "taxa_mort_mun2007", "taxa_mort_mun2008", "taxa_mort_mun2009",
        "taxa_mort_mun2010", "taxa_mort_mun2011","taxa_mort_mun2012", "taxa_mort_mun2013", "taxa_mort_mun2014",
        "taxa_mort_mun2015", "taxa_mort_mun2016", "taxa_mort_mun2017", "taxa_mort_mun2018", "taxa_mort_mun2019",
        "taxa_mort_mun2020")
 
 
Sys.sleep(20)

basao <- list() 

i <- "total"
 
for(i in lista3){
  basao[[i]] <- pop[,1:7] %>% left_join(taxa_final_mun[,lista4][taxa_final_mun$tipo == i,], c("COD_MUN"="code_muni6")) 
}

basao <- do.call(rbind, basao)

basao[1:5570,"tipo"] <- lista3[1]
basao[5571:11140,"tipo"] <- lista3[2]
basao[11141:16710,"tipo"] <- lista3[3]
basao[16711:22280,"tipo"] <- lista3[4]
basao[22281:27850,"tipo"] <- lista3[5]
basao[27851:33420,"tipo"] <- lista3[6]



# taxa_final_mun[!(is.na(taxa_final_mun[,8:26]) | taxa_final_mun[,8:26]==""), ]

# filtro <- apply(taxa_final_mun[,8:26], 1, function(x) all(is.na(x)))

# teste2 <- taxa_final_mun[!filtro,]




tab_morte_rm <- tab_todos2 %>% select(-c(1:5)) %>% group_by(NOME, tipo) %>% summarise_all(sum,na.rm = TRUE) %>%
  mutate(tipo = factor(tipo, levels = lista3)) %>% arrange(tipo, desc(NOME))

tab_pop_rm <- pop %>% select(-c(1:6)) %>% group_by(NOME) %>% summarise_all(sum,na.rm = TRUE) %>% arrange(desc(NOME)) 

tab_pop_rm_prep <- tab_morte_rm[,1:2] %>% left_join(tab_pop_rm, c("NOME"="NOME"))

for(i in 2000:2020){
  
  assign(paste0("tab_taxa_rm_", i),  tab_morte_rm[, as.character(i)]/tab_pop_rm_prep[,as.character(i)]*100000, envir = .GlobalEnv)
  
}

taxa_semi_final_rm <- do.call(cbind,mget(ls(pattern = "*tab_taxa_rm_")))
taxa_final_rm <- cbind(tab_pop_rm_prep[,c(1:2)], taxa_semi_final_rm)



for(i in 2000:2020){
  
  assign(paste0("num_morte_mun_", i),  tab_todos2[, as.character(i)], envir = .GlobalEnv)
  
}

num_semi_final_mun <- do.call(cbind,mget(ls(pattern = "*num_morte_mun_")))
num_final_mun <- cbind(tab_todos2_pop[,c(1:7)], num_semi_final_mun)

basao2 <- list()

for(i in lista3){
  basao2[[i]] <- pop[,1:7] %>% left_join(num_final_mun[,c(3,7:28)][num_final_mun$tipo == i,], c("COD_MUN"="code_muni6")) 
}

basao2 <- do.call(rbind, basao2)

basao2[1:5570,"tipo"] <- lista3[1]
basao2[5571:11140,"tipo"] <- lista3[2]
basao2[11141:16710,"tipo"] <- lista3[3]
basao2[16711:22280,"tipo"] <- lista3[4]
basao2[22281:27850,"tipo"] <- lista3[5]
basao2[27851:33420,"tipo"] <- lista3[6]


basao2 <- basao2 %>% mutate(tipo = case_when(tipo == lista3[1] ~ "Total",
                                   tipo == lista3[2] ~ "Pedestres",
                                   tipo == lista3[3] ~ "Ciclistas",
                                   tipo == lista3[4] ~ "Motociclistas",
                                   tipo == lista3[5] ~ "Ocupantes de autom?vel",
                                   tipo == lista3[6] ~ "Outros"))

basao <- basao %>% mutate(tipo = case_when(tipo == lista3[1] ~ "Total",
                                             tipo == lista3[2] ~ "Pedestres",
                                             tipo == lista3[3] ~ "Ciclistas",
                                             tipo == lista3[4] ~ "Motociclistas",
                                             tipo == lista3[5] ~ "Ocupantes de autom?vel",
                                             tipo == lista3[6] ~ "Outros"))

taxa_final_rm <- taxa_final_rm %>% mutate(tipo = case_when(tipo == lista3[1] ~ "Total",
                                           tipo == lista3[2] ~ "Pedestres",
                                           tipo == lista3[3] ~ "Ciclistas",
                                           tipo == lista3[4] ~ "Motociclistas",
                                           tipo == lista3[5] ~ "Ocupantes de autom?vel",
                                           tipo == lista3[6] ~ "Outros"))

basao[,1:8][is.na(basao[,1:8])] <- "-"


basao2[,1:8][is.na(basao2[,1:8])] <- "-"



write.csv2(basao, "F:/Projetos/mobilidados/datasus_verificacao/output/taxa_mort_mun.csv", row.names = FALSE)
write.csv2(basao2, "F:/Projetos/mobilidados/datasus_verificacao/output/num_mort_mun.csv", row.names = FALSE)
write.csv2(taxa_final_rm, "F:/Projetos/mobilidados/datasus_verificacao/output/taxa_final_rm.csv", row.names = FALSE)
write.csv2(tab_morte_rm, "F:/Projetos/mobilidados/datasus_verificacao/output/tab_morte_rm.csv", row.names = FALSE)
