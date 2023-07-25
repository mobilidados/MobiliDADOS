# Abrir pacotes e definir diretorio ----
library(ggplot2)
library(sf)
library(cowplot)
library(sysfonts)
library(grid)
library(beepr)
library(geobr)
library(openxlsx)
library(dplyr)
library(data.table)
library(mapview)
library(tidyverse)
library(magrittr)
library(plyr)
library(datasus)
library(stringi)
library(ggsn)
library(BAMMtools)
library(viridis)
library(tidyr)


# Definir diretorio
setwd('/Users/mackook/Desktop/R')
setwd('D:/R')

# Arquivos ----

# Download geobr
y <- 2010
state <- read_state(code_state = "all", year=y) %>% mutate(code_state = as.character(code_state)) %>%st_sf()
mesor <- read_meso_region(code_meso = "all", year=y)
munic <- read_municipality(code_muni = "all", year=y) %>% mutate(code_muni = as.character(code_muni)) %>%st_sf()
regio <- read_region(year = y)
beep()


#criar centroids
centroids_muni <- st_centroid(munic)


#incluir regioes nos centroides
state_df <- as.data.frame(state)
centroids_muni <- left_join(centroids_muni, state_df %>% select(code_state, name_region))



# Preparar tabelas ----

# Tabela de referencia de codigod d
df <- lookup_muni('all') #baixar tabela com todos os dados para meso regioes, estados, municipios

# Download e abrir RMs #parece qye arquivo esta corrompido
download.file("ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/municipios_por_regioes_metropolitanas/Situacao_2010a2019/Composicao_RMs_RIDEs_AglomUrbanas_2018_12_31.xlsx", "RMs.xlsx", quiet = FALSE)
RMs <- st_read("RMs.ods", layer = 'Composição') %>%
  select(COD_MUN, NOME)

RMs <- read.xlsx("E:/R/RMs.xlsx", sheet = 1) %>% select(COD_MUN, NOME)

 
# Join e ajuste na tabela de referencia
df <- left_join(df, RMs, by = c('code_muni'='COD_MUN'))
df <- df %>% mutate(regiao_metro = NOME, NOME = NULL, code_muni6 = substr(code_muni, 1, 6))

## Deu ruim com abertura das RM
df <- df %>% mutate(code_muni6 = substr(code_muni, 1, 6))

df$code_muni6 <- as.character(df$code_muni6)
df <- df[,c(1, 15, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14)]
names(df)

# Tabela com dados de populacao
pop <- read.xlsx('./dados/datasus/MobiliDADOS _ Taxa de mortalidade em acidente de transporte nas RMs e capitais (total e por tipo de usuário).xlsx', sheet=2) 
colnames(pop) <- as.character(unlist(pop[1,]))# pegar nome das colunas

pop <- pop[-c(1),]#eliminar linhas desnecessaria
pop <- pop[,-c(2:22)] #eliminar colunas desnecessarias

pop <- pop %>% mutate(code_muni6 = substr(CD_MUN,1,6)) #transformar coluna em 6 digitos
pop <- pop %>% 
  mutate_at(vars(Pop_2000, Pop_2001, Pop_2003, Pop_2004, Pop_2005,
                 Pop_2006, Pop_2007, Pop_2008, Pop_2009, Pop_2010,
                 Pop_2011, Pop_2012, Pop_2013, Pop_2014, Pop_2015,
                 Pop_2016, Pop_2017), as.numeric)  #transformar dados em valor numericos
pop[is.na(pop)] <- 0 #remover na


# Importar dados  datasus ----
# total
tot <- sim_obt10_mun(linha = "Município", #dados por municipio
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
ativ <- sim_obt10_mun(linha = "Município", #dados por municipio
                      coluna = "Ano do Óbito", #por ano de obito
                      conteudo = 2, #por local de ocorrencia
                      periodo = c(2000:2018), #periodo desejado
                      grupo_cid10 = c("Pedestre traumatizado em um acidente de transporte",
                                      "Ciclista traumatizado em um acidente de transporte"))

# motociclistas
moto <- sim_obt10_mun(linha = "Município", #dados por municipio
                      coluna = "Ano do Óbito", #por ano de obito
                      conteudo = 2, #por local de ocorrencia
                      periodo = c(2000:2018), #periodo desejado
                      grupo_cid10 = "Motociclista traumat em um acidente de transporte") 


#automoveis
auto <- sim_obt10_mun(linha = "Município", #dados por municipio
                 coluna = "Ano do Óbito", #por ano de obito
                 conteudo = 2, #por local de ocorrencia
                 periodo = c(2000:2018), #periodo desejado
                 grupo_cid10 =   "Ocupante automóvel traumat acidente transporte")


# outros
outros <- sim_obt10_mun(linha = "Município", #dados por municipio
                        coluna = "Ano do Óbito", #por ano de obito
                        conteudo = 2, #por local de ocorrencia
                        periodo = c(2000:2018), #periodo desejado
                        grupo_cid10 = c("Ocupante triciclo motorizado traumat acid transp",
                                        "Ocupante caminhonete traumat acidente transporte",
                                        "Ocupante veíc transp pesado traumat acid transp",
                                        "Ocupante ônibus traumat acidente de transporte",
                                        "Outros acidentes de transporte terrestre"))

beep()

# transforma NA em 0
tot[is.na(tot)] <- 0
ativ[is.na(ativ)] <- 0
moto[is.na(moto)] <- 0
auto[is.na(auto)] <- 0
outros[is.na(outros)] <- 0
outros[is.na(outros)] <- 0

beepr::beep()

# tot <- tot[-c(1),]
# ativ <- ativ[-c(1),]
# moto <- moto[-c(1),]
# auto <- auto[-c(1),]
# outros <- outros[-c(1),]

head(tot,2)
head(ativ,2)
head(moto,2)
head(auto,2)
head(outros,2)

# ajuste nas tabelas
tot_brasil    <- tot    %>% filter(Município == "TOTAL") %>% mutate(tipo = "total")
ativ_brasil   <- ativ   %>% filter(Município == "TOTAL") %>% mutate(tipo = "ativo") 
moto_brasil   <- moto   %>% filter(Município == "TOTAL") %>% mutate(tipo = "motociclistas")
auto_brasil   <- auto   %>% filter(Município == "TOTAL") %>% mutate(tipo = "automóveis")
outros_brasil <- outros %>% filter(Município == "TOTAL") %>% mutate(tipo = "outros")

# juntar tabela unica brasil
fim_brasil <- rbind(tot_brasil, ativ_brasil, moto_brasil, auto_brasil, outros_brasil) #tabela unica Brasil
fim_brasil$tipo <- factor(fim_brasil$tipo) # coluna como fator
fim_brasil$Município <- NULL #eliminar coluna
fim_brasil$Total <- NULL #eliminar coluna
fim_brasil <- fim_brasil[,c(20, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)] #reordenar colunas

# data_long
data_long <- gather(fim_brasil, ano, mortes, '2000':'2018') %>% filter(tipo != "total")

# Graficos -----

# grafico por usuario todos os anos
ggplot(data_long, aes(x = ano, y = mortes))+
  geom_col(aes(fill = tipo), width = 0.7)+
  scale_fill_viridis_d(option="F", direction = -1) +
  theme(rect = element_rect(fill = "transparent"),
        text = element_text(family = "Fira Sans"),
        axis.line.x = element_line(colour = "black", size = 0.2),
        legend.text = element_text(size = 12, family = "Fira Sans"),
        axis.text.y = element_text(size = 10, family = "Fira Sans", face="bold"),
        axis.text.x = element_text(size = 12, family = "Fira Sans"),
        strip.text = element_text(size = 8, family = "Fira Sans"),
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_blank()) 


# grafico por usuario acumulado
# ggplot(total_brasil, aes(x = tipo, y = tot))+
#   geom_col(aes(fill = tipo), width = 0.7)+
#   scale_fill_viridis_d(option="F", direction = -1) +
#   theme(rect = element_rect(fill = "transparent"),
#         text = element_text(family = "Fira Sans"),
#         axis.line.x = element_line(colour = "black", size = 0.2),
#         legend.text = element_text(size = 12, family = "Fira Sans"),
#         axis.text.y = element_text(size = 10, family = "Fira Sans", face="bold"),
#         axis.text.x = element_text(size = 12, family = "Fira Sans"),
#         strip.text = element_text(size = 8, family = "Fira Sans"),
#         panel.background = element_rect(fill = "transparent"),
#         plot.background = element_blank()) 

# mapa centroids
centroids <- centroids_muni %>% mutate(code_muni6 = substr(code_muni, 1, 6)) # criar coluna com 6 digitos
tot <- tot %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL) #criar coluna de 6 digitos

# join
centroid_datasus <- left_join(centroids, tot, by = "code_muni6") 

# separar lat lon
centroid_datasus <- centroid_datasus %>% mutate(lat = unlist(map(centroid_datasus$geom,1)),
                                                long = unlist(map(centroid_datasus$geom,2)))

# criar jenks
natural.interval_inc <- getJenksBreaks(centroid_datasus$`2018`, 20)
centroid_datasus$`2018brks` <- as.numeric(cut(centroid_datasus$`2018`, 
                                          breaks=natural.interval_inc, 
                                          include.lowest = F))

# eliminar NA
centroid_datasus[is.na(centroid_datasus)] <- 0


#teste centroides

temp_map2 <- 
  ggplot() + 
  geom_sf(data = state, fill = NA, colour = "grey40") +
  geom_point(data = centroid_datasus, 
             aes(x = lat, y = long, size =`2018`, color = `2018`), 
             stroke = 0, shape = 19, alpha = 0.7)+
  scale_color_viridis(option="inferno", direction = -1) +
  theme(panel.background = element_rect(fill = "gray98", color = NA)) + 
  theme_map() +
  theme(rect = element_rect(fill = "3d3d3d", color = NA),
        axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_sf(xlim = c(st_bbox(state)[[1]], st_bbox(state)[[3]]),
           ylim = c(st_bbox(state)[[2]], st_bbox(state)[[4]])) # coord_cartesian Coordinates Zoom

temp_map2

#teste meso
munic <- munic %>% mutate(code_muni6 = substr(code_muni, 1, 6))
munic_datasus <- left_join(munic, tot, by = "code_muni6")

natural.interval_inc <- getJenksBreaks(munic_datasus$`2018`, 20)
munic_datasus$`2018brks` <- as.numeric(cut(munic_datasus$`2018`, 
                                              breaks=natural.interval_inc, 
                                              include.lowest = F))
munic_datasus[is.na(centroid_datasus)] <- 0

head(munic_datasus)


temp_map2 <- 
  ggplot() + 
  # geom_sf(data=worldMap, fill="white", color="gray90") +
  geom_sf(data=state, fill= NA, colour = "gray89") +
  #    geom_sf(data=st_buffer(munis_centroids, dist =.5), fill="steelblue4", color="gray95", alpha=.8) + # 'springgreen4' steelblue4
  geom_sf(data= munic_datasus, aes(fill = munic_datasus$`2018brks`), color = NA) + # 'springgreen4' steelblue4
  scale_fill_viridis(option="inferno", direction = 1) +
  theme(panel.background = element_rect(fill = "gray98", color = NA)) + 
  theme_map() +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_sf(xlim = c(st_bbox(state)[[1]], st_bbox(state)[[3]]),
           ylim = c(st_bbox(state)[[2]], st_bbox(state)[[4]])) # coord_cartesian Coordinates Zoom


# mapa por regiao diferente

# Ajustar tabela datasus
tot <- tot %>% mutate(code_muni6 = substr(Município, 1, 6), Município = NULL, Total = NULL)
mortes_tot <- left_join(df, tot, by = ('code_muni'='code_muni6'))
mortes_tot <- left_join(mortes_tot, pop, by = ('code_muni6'='code_muni6'))
mortes_tot[is.na(mortes_tot)] <- 0

head(mortes_tot,4)
names(mortes_tot)

# Download geobr
y <- 2010
state <- read_state(code_state = "all", year=y) %>% mutate(code_state = as.character(code_state)) %>%st_sf()
mesor <- read_meso_region(code_meso = "all", year=y)
munic <- read_municipality(code_muni = "all", year=y) %>% mutate(code_muni = as.character(code_muni)) %>%st_sf()
regio <- read_region(year = y)

mapview(state) + mapview(mesor) + mapview(micro) + mapview(munic)

# Datasus por muni ----
datasus_muni <- mortes_tot %>% 
  mutate(tx_mort_2000 = 100000*(`2000`/Pop_2000), #tx_mort_2001 = 100000*(`2001`/Pop_2001),
         #tx_mort_2002 = 100000*(`2002`/Pop_2002), tx_mort_2003 = 100000*(`2003`/Pop_2003),
         #tx_mort_2004 = 100000*(`2004`/Pop_2004), tx_mort_2005 = 100000*(`2005`/Pop_2005),
         #tx_mort_2006 = 100000*(`2006`/Pop_2006), tx_mort_2007 = 100000*(`2007`/Pop_2007),
         #tx_mort_2008 = 100000*(`2008`/Pop_2008), tx_mort_2009 = 100000*(`2009`/Pop_2009),
         #tx_mort_2010 = 100000*(`2010`/Pop_2010), tx_mort_2011 = 100000*(`2011`/Pop_2011),
         #tx_mort_2012 = 100000*(`2012`/Pop_2012), tx_mort_2013 = 100000*(`2013`/Pop_2013),
         #tx_mort_2014 = 100000*(`2014`/Pop_2014), tx_mort_2015 = 100000*(`2015`/Pop_2015), 
         #tx_mort_2016 = 100000*(`2016`/Pop_2016), 
         tx_mort_2017 = 100000*(`2017`/Pop_2017))

head(datasus_muni)
str(datasus_muni)

# Datasus por muni
munic$code_muni6 <- substr(munic$code_muni, 1, 6)
munic_datasus <- left_join(munic, datasus_muni, by = 'code_muni6')
munic_datasus[is.na(munic_datasus)] <- 0
munic_datasus <- munic_datasus %>% 
  mutate(code_muni.y = NULL, name_muni.y = NULL, code_state.y = NULL, 
         code_muni = code_state.x, name_muni = name_muni.x, code_state = code_state.x, 
         code_muni.x = NULL, name_muni.x = NULL, code_state.x = NULL)
str(munic_datasus)
head(munic_datasus)
names(munic_datasus)
munic_datasus_fim <- munic_datasus[,-c(1,3:49,53:55)]
names(munic_datasus_fim)
mapview(munic_datasus_fim)

natural.interval <- getJenksBreaks(munic_datasus_fim$tx_mort_2017, 10)  
munic_datasus_fim$tx_mort_2017_brks <-as.numeric(cut(munic_datasus_fim$tx_mort_2017, breaks=natural.interval, include.lowest = F))
munic_datasus_fim$tx_mort_2017_brks[is.na(munic_datasus_fim$tx_mort_2017_brks)] <- 1
unique(munic_datasus_fim$tx_mort_2017_brks)

# Datasus por UF ----
state_datasus <- ddply(datasus_muni, .(code_state), numcolwise(sum))
state_datasus$code_state <- as.character(state_datasus$code_state)
names(state_datasus)
state_datasus <- left_join(state, state_datasus, by = 'code_state') 
names(state_datasus)
state_datasus <- state_datasus[,-c(2:7,10:24,27:41,43:44)]
head(state_datasus)
str(state)

# Taxa de mortalidade por UF
state_datasus_fim <- state_datasus %>% 
  mutate (tx_mort_2000 = 100000*(`2000`/Pop_2000), #tx_mort_2001 = 100000*(`2001`/Pop_2001),
          #         tx_mort_2002 = 100000*(`2002`/Pop_2002), tx_mort_2003 = 100000*(`2003`/Pop_2003),
          #         tx_mort_2004 = 100000*(`2004`/Pop_2004), tx_mort_2005 = 100000*(`2005`/Pop_2005),
          #         tx_mort_2006 = 100000*(`2006`/Pop_2006), tx_mort_2007 = 100000*(`2007`/Pop_2007),
          #         tx_mort_2008 = 100000*(`2008`/Pop_2008), tx_mort_2009 = 100000*(`2009`/Pop_2009),
          #         tx_mort_2010 = 100000*(`2010`/Pop_2010), tx_mort_2011 = 100000*(`2011`/Pop_2011),
          #         tx_mort_2012 = 100000*(`2012`/Pop_2012), tx_mort_2013 = 100000*(`2013`/Pop_2013),
          #         tx_mort_2014 = 100000*(`2014`/Pop_2014), tx_mort_2015 = 100000*(`2015`/Pop_2015), tx_mort_2016 = 100000*(`2016`/Pop_2016), 
          tx_mort_2017 = 100000*(`2017`/Pop_2017))
head(state_datasus_fim)
mapview(state_datasus_fim)

natural.interval <- getJenksBreaks(state_datasus_fim$tx_mort_2017, 5)  
state_datasus_fim$tx_mort_2017_brks <-as.numeric(cut(state_datasus_fim$tx_mort_2017, breaks=natural.interval, include.lowest = F))
state_datasus_fim$tx_mort_2017_brks[is.na(state_datasus_fim$tx_mort_2017_brks)] <- 1
unique(state_datasus_fim$tx_mort_2017_brks)

# Datasus por meso ----
names(datasus_muni)
datasus_muni <- datasus_muni %>% mutate(tx_mort_2000 = NULL, tx_mort_2017 = NULL)
meso_datasus <- ddply(datasus_muni, .(code_meso), numcolwise(sum))
names(meso_datasus)
meso_datasus <- left_join(mesor, meso_datasus, by = 'code_meso') 
meso_datasus <- meso_datasus[,-c(3:4,6:21,24:38)]

# Taxa mortalidade mesoregiao
meso_datasus_fim <- meso_datasus %>% 
  mutate (tx_mort_2000 = 100000*(`2000`/Pop_2000), #tx_mort_2001 = 100000*(`2001`/Pop_2001),
          #         tx_mort_2002 = 100000*(`2002`/Pop_2002), tx_mort_2003 = 100000*(`2003`/Pop_2003),
          #         tx_mort_2004 = 100000*(`2004`/Pop_2004), tx_mort_2005 = 100000*(`2005`/Pop_2005),
          #         tx_mort_2006 = 100000*(`2006`/Pop_2006), tx_mort_2007 = 100000*(`2007`/Pop_2007),
          #         tx_mort_2008 = 100000*(`2008`/Pop_2008), tx_mort_2009 = 100000*(`2009`/Pop_2009),
          #         tx_mort_2010 = 100000*(`2010`/Pop_2010), tx_mort_2011 = 100000*(`2011`/Pop_2011),
          #         tx_mort_2012 = 100000*(`2012`/Pop_2012), tx_mort_2013 = 100000*(`2013`/Pop_2013),
          #         tx_mort_2014 = 100000*(`2014`/Pop_2014), tx_mort_2015 = 100000*(`2015`/Pop_2015), tx_mort_2016 = 100000*(`2016`/Pop_2016), 
          tx_mort_2017 = 100000*(`2017`/Pop_2017))
names(meso_datasus_fim)

natural.interval <- getJenksBreaks(meso_datasus_fim$tx_mort_2017, 10)  
meso_datasus_fim$tx_mort_2017_brks <-as.numeric(cut(meso_datasus_fim$tx_mort_2017, breaks=natural.interval, include.lowest = F))
meso_datasus_fim$tx_mort_2017_brks[is.na(meso_datasus_fim$tx_mort_2017_brks)] <- 1
unique(meso_datasus_fim$tx_mort_2017_brks)

# Datasus por regiao ----
mapview(regio)
names(regio)
state_datasus <- as.data.frame(state_datasus)
state_datasus <- left_join(state, state_datasus, by = "code_state")

regiao_datasus <- ddply(state_datasus, .(code_region), numcolwise(sum))
regiao_datasus <- left_join(regio, regiao_datasus, by = 'code_region')
names(regiao_datasus)
regiao_datasus <- regiao_datasus [,-c(4)]

#Taxa mortalidade regiao
regiao_datasus_fim <- regiao_datasus %>% 
  mutate (tx_mort_2000 = 100000*(`2000`/Pop_2000), #tx_mort_2001 = 100000*(`2001`/Pop_2001),
          #         tx_mort_2002 = 100000*(`2002`/Pop_2002), tx_mort_2003 = 100000*(`2003`/Pop_2003),
          #         tx_mort_2004 = 100000*(`2004`/Pop_2004), tx_mort_2005 = 100000*(`2005`/Pop_2005),
          #         tx_mort_2006 = 100000*(`2006`/Pop_2006), tx_mort_2007 = 100000*(`2007`/Pop_2007),
          #         tx_mort_2008 = 100000*(`2008`/Pop_2008), tx_mort_2009 = 100000*(`2009`/Pop_2009),
          #         tx_mort_2010 = 100000*(`2010`/Pop_2010), tx_mort_2011 = 100000*(`2011`/Pop_2011),
          #         tx_mort_2012 = 100000*(`2012`/Pop_2012), tx_mort_2013 = 100000*(`2013`/Pop_2013),
          #         tx_mort_2014 = 100000*(`2014`/Pop_2014), tx_mort_2015 = 100000*(`2015`/Pop_2015), tx_mort_2016 = 100000*(`2016`/Pop_2016), 
          tx_mort_2017 = 100000*(`2017`/Pop_2017))
names(regiao_datasus_fim)

#jenks nao funciona para regiao

# Plot ----
# No plot axis
no_axis <- theme(line = element_blank(),
                 axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank(),
                 plot.title = element_text(size=20, hjust = 0.5),
                 panel.background = element_blank())

# Plot individuais ----
names(regiao_datasus_fim)
a <- ggplot() + geom_sf(data=regiao_datasus_fim, col = 'black', size = 0.1) + no_axis 
beep()

regiao_2017 <- ggplot() + 
  geom_sf(data=regiao_datasus_fim, aes(fill = `tx_mort_2017`), col = NA, size = 0.0001) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#f5e1e4', high = '#8a0000') +
  # guides(fill = guide_colourbar(title.position = "bottom",
  #                               title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis #+ labs(subtitle="RegiÃµes", size=8)

ggsave(regiao_2017, filename = "./resultados/mapas/datasus/plot_datasus_regiao_2017.png", dpi = 1000, width = 15, height = 10, units = 'cm')
beep()

state_2017 <- ggplot() + 
  geom_sf(data = state_datasus_fim, aes(fill = state_datasus_fim$tx_mort_2017_brks ), colour=NA,  size = 0.0001) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#f5e1e4', high = '#8a0000')+
  guides(fill = guide_colourbar(title.position = "bottom",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis #+ labs(subtitle="Estados", size=8)

ggsave(state_2017, filename = "./resultados/mapas/datasus/plot_datasus_state_2017.png", dpi = 1000, width = 15, height = 10, units = 'cm')
beep()

meso_2017 <- ggplot() + 
  geom_sf(data = meso_datasus_fim, aes(fill = meso_datasus_fim$tx_mort_2017_brks), colour=NA, size = 0.0001) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#f5e1e4', high = '#8a0000')+  
  guides(fill = guide_colourbar(title.position = "bottom",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis #+ labs(subtitle="MesoregiÃµes", size=8)

ggsave(meso_2017, filename = "./resultados/mapas/datasus/plot_datasus_meso_2017.png", dpi = 1000, width = 15, height = 10, units = 'cm')
beep()

munic_2017 <- ggplot() + 
  geom_sf(data = munic_datasus_fim, aes(fill = munic_datasus_fim$tx_mort_2017_brks), colour=NA,  size = 0.0001) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#f5e1e4', high = '#8a0000')+
  guides(fill = guide_colourbar(title.position = "bottom",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis #+ labs(subtitle="Municipios", size=8)

ggsave(munic_2017, filename = "./resultados/mapas/datasus/plot_datasus_muni_2017.png", dpi = 1000, width = 15, height = 10, units = 'cm')
beep()


#red = #9c0005
#blue = #0b057d

# Juntar plots individuais ----
# add annotation
t1 <- ggdraw() + draw_label("Taxa de mortalidade 2017", size = 25, fontface='bold') #criar titulo
t2 <- ggdraw() + draw_label("Fonte: IBGE, Datasus e geobr", size = 10, fontface='bold') #criar titulo

p <- plot_grid (#t1, NULL, 
                regiao_2017, state_2017, 
                meso_2017, munic_2017, 
                #NULL, t2,
                ncol = 2, nrow = 2, 
               rel_heights = c(1,1))



# Save plot
ggsave(p, filename = "./resultados/mapas/datasus/plot_datasus.png", dpi = 500, width = 15, height = 10, units = 'cm')
beepr::beep()
