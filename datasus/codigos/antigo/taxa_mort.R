####1. Preparação: instalar e abrir pacotes, definir local para salvar arquivos
####2. Criar shapefile da RM
####3. Criar tabelas de dados dos setores censitarios
####4. Unir dados com shapeflies dos setores censitarios

####1. Preparação: instalar e abrir pacotes, definir local para salvar arquivos --------------
setwd('/Users/mackook/Desktop/R')

### Abrir pacotes necessários
install_github("rpradosiqueira/datasus", force = T)
library(datasus)
install.packages('stringi')
library(stringi)
source('./codigos/setup.R')


####2. Abrir e limpar tabelas necessarias

### Abrir tabela e limpar tabelas de populacao e regiao metropolitanas
## Para evitar probelmas de codificacao, preferir arquivos no formato .ods
# Abrir tabela de populacao
pop <- st_read("./pop.ods") # de onde pegou isso??
names(pop)

#Incluir regioes na tabela de RMs
pop$REGIAO <- ifelse(pop$UF %in% c(11, 12, 13, 14, 15, 16, 17), 'Norte',
                     ifelse(pop$UF %in% c(21, 22, 23, 24, 25, 26, 27, 28, 29), 'Nordeste',
                            ifelse(pop$UF %in% c(41, 42, 43), 'Sul',
                                   ifelse(pop$UF %in% c(31, 32, 33, 35),'Sudeste',
                                          ifelse(pop$UF %in% c(50, 51, 52, 53), 'Centro-Oeste', 'NA')))))

pop <- pop[,c(5, 2, 1, 3, 4)] # Ordenar colunas da tabela de pop

# Baixar dados da composicao das RMs, para nao ter probelmas com a codificacao eh recomendado baixar no formado .ODS - atentar para a última atualizacao do IBGE
download.file("ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/municipios_por_regioes_metropolitanas/Situacao_2010a2019/Composicao_RMs_RIDEs_AglomUrbanas_2018_12_31.ods", "RMs.ods", quiet = FALSE)
RMs <- st_read("RMs.ods", layer = 'Composição') %>%
  select(COD_MUN, NOME_MUN, NOME) %>%
  mutate(CD_MUN = substr(COD_MUN, 0, 6), UF = substr(COD_MUN, 0, 2)) 
names(RMs)

head(RMs)
RMs <- RMs[,c(5, 2, 1, 3, 4)] # Ordenar colunas da tabela de pop

#Mudar nomes das colunas
RMs$MUNI <- RMs$NOME_MUN 
RMs$RM <- RMs$NOME
RMs$NOME <- NULL
RMs$COD_MUN <- NULL
RMs$NOME_MUN <- NULL
head(RMs)

#Incluir regioes na tabela de RMs
RMs$REGIAO <- ifelse(RMs$UF %in% c(11, 12, 13, 14, 15, 16, 17), 'Norte',
                     ifelse(RMs$UF %in% c(21, 22, 23, 24, 25, 26, 27, 28, 29), 'Nordeste',
                            ifelse(RMs$UF %in% c(41, 42, 43), 'Sul',
                                   ifelse(RMs$UF %in% c(31, 32, 33, 35),'Sudeste',
                                          ifelse(RMs$UF %in% c(50, 51, 52, 53), 'Centro-Oeste', 'NA')))))
head(RMs)
RMs <- RMs[,c(5, 2, 1, 3, 4)]



#Colunas: CD_MUN -> codigo com 6 numeros do municipio
#         MUNICIPIO -> nome do municipio
#         CAPITAL -> Se o municipio e capital

###2 Baixar dados do DataSus ----

#Morte de pedestres
ped <- sim_obt10_mun(linha = "Município", #dados por municipio
                     coluna = "Ano do Óbito", #por ano de óbito
                     conteudo = 2, #por local de ocorrência
                     periodo = c(2000:2017), #período desejado
                     grupo_cid10 = "Pedestre traumatizado em um acidente de transporte" #grupo cid10 desejado 
                     ) 
beep()
#Morte de ciclistas
cic <- sim_obt10_mun(linha = "Município", #dados por municipio
                     coluna = "Ano do Óbito", #por ano de óbito
                     conteudo = 2, #por local de ocorrência
                     periodo = c(2000:2017), #período desejado
                     grupo_cid10 = "Ciclista traumatizado em um acidente de transporte" #grupo cid10 desejado 
) 

#Morte de motocilistas
mot <- sim_obt10_mun(linha = "Município", #dados por municipio
                     coluna = "Ano do Óbito", #por ano de óbito
                     conteudo = 2, #por local de ocorrência
                     periodo = c(2000:2017), #período desejado
                     grupo_cid10 = "Motociclista traumat em um acidente de transporte" #grupo cid10 desejado 
) 

#Morte de ocupante de automóveis
aut <- sim_obt10_mun(linha = "Município", #dados por municipio
                     coluna = "Ano do Óbito", #por ano de óbito
                     conteudo = 2, #por local de ocorrência
                     periodo = c(2000:2017), #período desejado
                     grupo_cid10 = "Ocupante automóvel traumat acidente transporte" #grupo cid10 desejado 
) 

#Morte de ocupante de ônibus
oni <- sim_obt10_mun(linha = "Município", #dados por municipio
                     coluna = "Ano do Óbito", #por ano de óbito
                     conteudo = 2, #por local de ocorrência
                     periodo = c(2000:2017), #período desejado
                     grupo_cid10 = "Ocupante ônibus traumat acidente de transporte" #grupo cid10 desejado 
) 

#Mortes totais
tot <- sim_obt10_mun(linha = "Município", #dados por municipio
                               coluna = "Ano do Óbito", #por ano de óbito
                               conteudo = 2, #por local de ocorrência
                               periodo = c(2000:2017), #período desejado
                               grupo_cid10 = c("Pedestre traumatizado em um acidente de transporte",
                                               "Ciclista traumatizado em um acidente de transporte",
                                               "Motociclista traumat em um acidente de transporte",
                                               "Ocupante triciclo motorizado traumat acid transp",
                                               "Ocupante automóvel traumat acidente transporte",
                                               "Ocupante caminhonete traumat acidente transporte",
                                               "Ocupante veíc transp pesado traumat acid transp",
                                               "Ocupante ônibus traumat acidente de transporte",
                                               "Outros acidentes de transporte terrestre")#grupo cid10 desejado 
                               ) 
# "Pedestre traumatizado em um acidente de transporte",
# "Ciclista traumatizado em um acidente de transporte",
# "Motociclista traumat em um acidente de transporte",
# "Ocupante triciclo motorizado traumat acid transp",
# "Ocupante automóvel traumat acidente transporte",
# "Ocupante caminhonete traumat acidente transporte",
# "Ocupante veíc transp pesado traumat acid transp",
# "Ocupante ônibus traumat acidente de transporte",
# "Outros acidentes de transporte terrestre",

###3 Join tabelas de mortes com dados ----

#Limpar tabelas
#Separar coluna do codigo do municipio com 6 digitos e nome do municipio
ped$CD_MUN <- as.character(substr(ped$Município, 0, 6)) #Criar coluna com o codigo de seis digitos do municipio na tabela do DataSUS
ped$Município <- substr(ped$Município, 8, 100) #coluna com nome do municipio

cic$CD_MUN <- as.character(str_sub(cic$Município, end = 6)) #Criar coluna com o codigo de seis digitos do municipio na tabela do DataSUS
cic$Município <- substr(cic$Município, 8, 100) #coluna com nome do municipio

aut$CD_MUN <- as.character(str_sub(aut$Município, end = 6)) #Criar coluna com o codigo de seis digitos do municipio na tabela do DataSUS
aut$Município <- substr(aut$Município, 8, 100) #coluna com nome do municipio

oni$CD_MUN <- as.character(str_sub(oni$Município, end = 6)) #Criar coluna com o codigo de seis digitos do municipio na tabela do DataSUS
oni$Município <- substr(oni$Município, 8, 100) #coluna com nome do municipio

mot$CD_MUN <- as.character(str_sub(mot$Município, end = 6)) #Criar coluna com o codigo de seis digitos do municipio na tabela do DataSUS
mot$Município <- substr(mot$Município, 8, 100) #coluna com nome do municipio

tot$CD_MUN <- as.character(str_sub(tot$Município, end = 6)) #Criar coluna com o codigo de seis digitos do municipio na tabela do DataSUS
tot$Município <- substr(tot$Município, 8, 100) #coluna com nome do municipio

#Verificar colunas e dados
head(ped)
head(cic)
head(oni)
head(mot)
head(aut)
head(tot)

#Salvar se necessario
#write.xlsx(ped, './resultados/datasus/pedestres.xlsx')
#write.xlsx(cic, './resultados/datasus/ciclistas.xlsx')
#write.xlsx(oni, './resultados/datasus/onibus.xlsx')
#write.xlsx(mot, './resultados/datasus/motociclistas') 
#write.xlsx(aut, './resultados/datasus/auto')
#write.xlsx(tot, './resultados/datasus/total')


##Join pop com RMs
muni_pop_rm <- left(pop, RMs, by = "CD_MUN")

#Join dados com  pop e nome das RMs ## substituir por muni_pop_rm
v2_ped <- left_join(RMs, ped, by = "CD_MUN")
v2_cic <- left_join(RMs, cic, by = "CD_MUN")
v2_oni <- left_join(RMs, oni, by = "CD_MUN")
v2_mot <- left_join(RMs, mot, by = "CD_MUN")
v2_aut <- left_join(RMs, aut, by = "CD_MUN")
v2_tot <- left_join(RMs, tot, by = "CD_MUN")

head(v2_ped)
head(v2_cic)
head(v2_oni)
head(v2_mot)
head(v2_aut)
head(v2_tot)

unique(v2_tot$RM)
View(v2_tot)

popRM <- left_join(pop, RM, by = "CD_MUN") #unir tabela de populacao e RMs
View(popRM) #verificar estrutura

df <- left_join(popRM, ped, by = "CD_MUN") #unir tabela populacao com RM e dataSUS
str(df)
print(df)
write.xlsx(df2, './teste9.xlsx') #salvar com valores do datasus e valores da populacao
View(df)

df["tx_mort_2000"] <- round((df$`2000`/df$Pop_2000)*100000, digits = 1)
df["tx_mort_2001"] <- round((df$`2001`/df$Pop_2001)*100000, digits = 1)
df["tx_mort_2002"] <- round((df$`2002`/df$Pop_2002)*100000, digits = 1)
df["tx_mort_2003"] <- round((df$`2003`/df$Pop_2003)*100000, digits = 1)
df["tx_mort_2004"] <- round((df$`2004`/df$Pop_2004)*100000, digits = 1)
df["tx_mort_2005"] <- round((df$`2005`/df$Pop_2005)*100000, digits = 1)
df["tx_mort_2006"] <- round((df$`2006`/df$Pop_2006)*100000, digits = 1)
df["tx_mort_2007"] <- round((df$`2007`/df$Pop_2007)*100000, digits = 1)
df["tx_mort_2008"] <- round((df$`2008`/df$Pop_2008)*100000, digits = 1)
df["tx_mort_2009"] <- round((df$`2009`/df$Pop_2009)*100000, digits = 1)
df["tx_mort_2010"] <- round((df$`2010`/df$Pop_2010)*100000, digits = 1)
df["tx_mort_2011"] <- round((df$`2011`/df$Pop_2011)*100000, digits = 1)
df["tx_mort_2012"] <- round((df$`2012`/df$Pop_2012)*100000, digits = 1)
df["tx_mort_2013"] <- round((df$`2013`/df$Pop_2013)*100000, digits = 1)
df["tx_mort_2014"] <- round((df$`2014`/df$Pop_2014)*100000, digits = 1)
df["tx_mort_2015"] <- round((df$`2015`/df$Pop_2015)*100000, digits = 1)
df["tx_mort_2016"] <- round((df$`2016`/df$Pop_2016)*100000, digits = 1)
df["tx_mort_2017"] <- round((df$`2017`/df$Pop_2017)*100000, digits = 1)
str(df)
print(df)
View(df)

#Filtrar e selecionar colunas
df_capitais <- df %>%
  filter(CAPITAL == "Capital") %>%
  select(CD_MUN, MUNICIPIO, CAPITAL, RM, tx_mort_2000, tx_mort_2001, tx_mort_2002, tx_mort_2003, tx_mort_2004,
         tx_mort_2005, tx_mort_2006, tx_mort_2007, tx_mort_2008, tx_mort_2009, tx_mort_2010, tx_mort_2011, tx_mort_2012,
         tx_mort_2013, tx_mort_2014, tx_mort_2015, tx_mort_2016, tx_mort_2017)
names(df_capitais)
View(df_capitais)

write.xlsx(df_capitais, './tx_pedestres_capitais.xlsx') #salvar com valores do datasus e valores da populacao

df_RMs <- setDT(df)[, .(pop_2000 = sum(as.numeric(Pop_2000)), pop_2001 = sum(as.numeric(Pop_2001)),
                        pop_2002 = sum(as.numeric(Pop_2002)), pop_2003 = sum(as.numeric(Pop_2003)),
                        pop_2004 = sum(as.numeric(Pop_2004)), pop_2005 = sum(as.numeric(Pop_2005)),
                        pop_2006 = sum(as.numeric(Pop_2006)), pop_2007 = sum(as.numeric(Pop_2007)),
                        pop_2008 = sum(as.numeric(Pop_2008)), pop_2009 = sum(as.numeric(Pop_2009)),
                        pop_2010 = sum(as.numeric(Pop_2010)), pop_2011 = sum(as.numeric(Pop_2011)),
                        pop_2012 = sum(as.numeric(Pop_2012)), pop_2013 = sum(as.numeric(Pop_2013)),
                        pop_2014 = sum(as.numeric(Pop_2014)), pop_2015 = sum(as.numeric(Pop_2015)),
                        pop_2016 = sum(as.numeric(Pop_2016)), pop_2017 = sum(as.numeric(Pop_2017)),
                        morte_2000 = sum(`2000`, na.rm=T), morte_2001 = sum(`2001`, na.rm=T),
                        morte_2002 = sum(`2002`, na.rm=T), morte_2003 = sum(`2003`, na.rm=T),
                        morte_2004 = sum(`2004`, na.rm=T), morte_2005 = sum(`2005`, na.rm=T),
                        morte_2006 = sum(`2006`, na.rm=T), morte_2007 = sum(`2007`, na.rm=T),
                        morte_2008 = sum(`2008`, na.rm=T), morte_2009 = sum(`2009`, na.rm=T),
                        morte_2010 = sum(`2010`, na.rm=T), morte_2011 = sum(`2011`, na.rm=T),
                        morte_2012 = sum(`2012`, na.rm=T), morte_2013 = sum(`2013`, na.rm=T),
                        morte_2014 = sum(`2014`, na.rm=T), morte_2015 = sum(`2015`, na.rm=T),
                        morte_2016 = sum(`2016`, na.rm=T), morte_2017 = sum(`2017`, na.rm=T)), by= RM]

#Bel <- df_RMs %>% filter(RM == 'Região Metropolitana de Belém')

str(df_RMs)
df_mort <- setDT(df_RMs)[,.(tx_mort_2000 = round(100000*(morte_2000/pop_2000), 1),
                            tx_mort_2001 = round(100000*(morte_2001/pop_2001), 1),
                            tx_mort_2002 = round(100000*(morte_2002/pop_2002), 1),
                            tx_mort_2003 = round(100000*(morte_2003/pop_2003), 1),
                            tx_mort_2004 = round(100000*(morte_2004/pop_2004), 1),
                            tx_mort_2005 = round(100000*(morte_2005/pop_2005), 1),
                            tx_mort_2006 = round(100000*(morte_2006/pop_2006), 1),
                            tx_mort_2007 = round(100000*(morte_2007/pop_2007), 1),
                            tx_mort_2008 = round(100000*(morte_2008/pop_2008), 1),
                            tx_mort_2009 = round(100000*(morte_2009/pop_2009), 1),
                            tx_mort_2010 = round(100000*(morte_2010/pop_2010), 1),
                            tx_mort_2011 = round(100000*(morte_2011/pop_2011), 1),
                            tx_mort_2012 = round(100000*(morte_2012/pop_2012), 1),
                            tx_mort_2013 = round(100000*(morte_2013/pop_2013), 1),
                            tx_mort_2014 = round(100000*(morte_2014/pop_2014), 1),
                            tx_mort_2015 = round(100000*(morte_2015/pop_2015), 1),
                            tx_mort_2016 = round(100000*(morte_2016/pop_2016), 1),
                            tx_mort_2017 = round(100000*(morte_2017/pop_2017), 1)), by=RM]

df_9 <- df_mort %>%
  filter(RM %in% c("Região Metropolitana de Belém", "Região Metropolitana de Belo Horizonte", 
                   "Região Integrada de Desenvolvimento do Distrito Federal e Entorno", 
                   "Região Metropolitana de Curitiba", "Região Metropolitana de Fortaleza",
                   "Região Metropolitana de Recife", "Região Metropolitana de Salvador",
                   "Região Metropolitana de São Paulo", "Região Metropolitana do Rio de Janeiro")) 

write.xlsx(df_9, "./tx_pedestres_RMs.xlsx")

unique(df_mort$RM)

df_RMs$tx_mort_2000 <- round((df_RMs$morte_2000/df_RMs$Pop_2000)*100000, digits = 1)
df_RMs$tx_mort_2001 <- round((df_RMs$morte_2001/df_RMs$Pop_2001)*100000, digits = 1)
df_RMs$tx_mort_2002 <- round((df_RMs$morte_2002/df_RMs$Pop_2002)*100000, digits = 1)
df_RMs$tx_mort_2003 <- round((df_RMs$morte_2003/df_RMs$Pop_2003)*100000, digits = 1)
df_RMs$tx_mort_2004 <- round((df_RMs$morte_2004/df_RMs$Pop_2004)*100000, digits = 1)
df_RMs$tx_mort_2005 <- round((df_RMs$morte_2005/df_RMs$Pop_2005)*100000, digits = 1)
df_RMs$tx_mort_2006 <- round((df_RMs$morte_2006/df_RMs$Pop_2006)*100000, digits = 1)
df_RMs$tx_mort_2007 <- round((df_RMs$morte_2007/df_RMs$Pop_2007)*100000, digits = 1)
df_RMs$tx_mort_2008 <- round((df_RMs$morte_2008/df_RMs$Pop_2008)*100000, digits = 1)
df_RMs$tx_mort_2009 <- round((df_RMs$morte_2009/df_RMs$Pop_2009)*100000, digits = 1)
df_RMs$tx_mort_2010 <- round((df_RMs$morte_2010/df_RMs$Pop_2010)*100000, digits = 1)
df_RMs$tx_mort_2011 <- round((df_RMs$morte_2011/df_RMs$Pop_2011)*100000, digits = 1)
df_RMs$tx_mort_2012 <- round((df_RMs$morte_2012/df_RMs$Pop_2012)*100000, digits = 1)
df_RMs$tx_mort_2013 <- round((df_RMs$morte_2013/df_RMs$Pop_2013)*100000, digits = 1)
df_RMs$tx_mort_2014 <- round((df_RMs$morte_2014/df_RMs$Pop_2014)*100000, digits = 1)
df_RMs$tx_mort_2015 <- round((df_RMs$morte_2015/df_RMs$Pop_2015)*100000, digits = 1)
df_RMs$tx_mort_2016 <- round((df_RMs$morte_2016/df_RMs$Pop_2016)*100000, digits = 1)
df_RMs$tx_mort_2017 <- round((df_RMs$morte_2017/df_RMs$Pop_2017)*100000, digits = 1)

View(df_RMs)
str(df_RMs)

ped

