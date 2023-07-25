library(geobr)
library(dplyr)
library(beepr)
library(sf)
library(gdata)
library(tidyverse)
library(stringi)
library(datasus)
library(openxlsx)
library(extrafont)
library(ggplot2)
library(viridis)
library(ggthemes)
library(data.table)
library(cowplot)
library(BAMMtools)

setwd("D:/R/")

extrafont::loadfonts(device = "pdf")
fonts()

# Preparar dados----

# Abrir arquivos
state <- read_rds("./dados/IBGE/estados.rds")
mesor <- read_rds("./dados/IBGE/mesoregiões.rds")
munic <- read_rds("./dados/IBGE/municipios.rds")
regio <- read_rds("./dados/IBGE/regiões.rds")

# join
total <- read.xlsx("./dados/datasus/mortes/total_mortes_2000_2018.xlsx")%>%
  mutate(code_muni = as.character(code_muni))

munic <- munic %>% mutate(code_muni = as.character(code_muni))

muni_total <- left_join(munic %>% select(code_muni, geom), total, by = "code_muni")
names(muni_total)

#criar centroids
centroids <- st_centroid(muni_total)

#pop_2018
pop_2018 <- st_read("./dados/IBGE/estimativas_pop/estimativa_dou_2018_20181019.ods",
                    layer = 'Municípios')

colnames(pop_2018) <- as.character(unlist(pop_2018[2,]))# pegar nome das colunas
names(pop_2018)
pop_2018 <- pop_2018[-c(1:2),]#eliminar linhas desnecessaria

pop_2018 <- pop_2018 %>% mutate(code_muni = stri_join(`COD. UF`, `COD. MUNIC`, sep = ""), #criar coluna com codigo do municipio
                                pop_2018 = as.numeric(as.character(`POPULAÃ???ÃfO ESTIMADA`)),
                                code_muni6 = substr(code_muni,1,6)) %>% #transformar coluna em 6 digitos
  select(UF, code_muni6, code_muni, pop_2018, `POPULAÃ???ÃfO ESTIMADA`)

pop_2018 <- pop_2018 %>% mutate(POP_ESTIMADA = `POPULAÃ???ÃfO ESTIMADA`, `POPULAÃ???ÃfO ESTIMADA` = NULL)

pop_2018[is.na(pop_2018)] <- 0 
sum(pop_2018$pop)
names(pop_2018)
View(pop_2018)

#correcao tabela 2018
a <- pop_2018 %>% filter(pop_2018 == 0)
a$code_muni


View(state)
tab <- data.frame(UF = c('RO', 'AM', 'AM', 'AM', 
                         'AM', 'PA', 'MA', 'RN',
                         'PB', 'PB', 'PE', 'BA',
                         'BA', 'BA'),
                  code_muni = c(110020,130255,130360,130426,
                                130430,150375,210750,241200,
                                250850,251650,261200,290920,
                                291200,293320), 
                  code_muni6 = c(1100205,1302553,1303601,1304260,
                                 1304302,1503754,2107506,2412005,
                                 2508505,2516508,2612000,2909208
                                 ,2912004,2933208),
                  pop_2018 = c(519513, 314147, 24436, 13387, 
                               16383, 8899, 120621, 101102, 
                               7371, 15185, 10103, 15801,
                               9427, 42706),
                  POP_ESTIMADA = c(519513, 314147, 24436, 13387, 
                                     16383, 8899, 120621, 101102, 
                                     7371, 15185, 10103, 15801,
                                     9427, 42706))

tab <- tab %>% mutate(code_muni6 = as.character(code_muni6),
                      code_muni = as.character(code_muni),
                      POP_ESTIMADA = as.factor(POP_ESTIMADA))

pop_2018 <- pop_2018 %>% filter(pop_2018!=0)
pop_2018 <- rbind(pop_2018, tab)

write.xlsx(pop_2018, "./dados/IBGE/estimativas_pop/estimativa_dou_2018_corrigido.xlsx")

pop_2018 <- read.xlsx("./dados/IBGE/estimativas_pop/estimativa_dou_2018_corrigido.xlsx")

#select variaveis de centroids
centroids_2018 <- centroids %>% select(code_muni, name_muni, code_state, 
                                       code_micro, code_meso, name_region, `2018`)
# join com pop
centroids_2018 <- left_join(centroids_2018, pop_2018) 

# calculo 
centroids_2018 <- centroids_2018 %>% mutate(tx_mort_2018 = round(100000*(`2018`/pop_2018),1),
                                            lat = unlist(map(centroids_2018$geom,1)),
                                            long = unlist(map(centroids_2018$geom,2)))

min(centroids_2018$tx_mort_2018)
centroids_2018[is.na(centroids_2018)] <- 0

head(centroids_2018)
str(centroids_2018)
View(centroids_2018$tx_mort_2018)



# Mapa por mesoregiao ----
muni_pop_total <- left_join(muni_total, pop_2018, by = "code_muni")
muni <- setDT(muni_pop_total) 

mesor_tot <- muni[, .(`2018` = sum(`2018`, na.rm = T),
                      Pop = sum(pop_2018, na.rm = T)), by = code_meso]

mesor_fim <- left_join(mesor, mesor_tot,  by = "code_meso") 
mesor_fim <- mesor_fim %>% mutate(tx_mort_2018 = round(100000*(`2018`/Pop),1))

mesor_fim[is.na(mesor_fim)] <- 0 

# criar jenks
natural.interval_inc <- getJenksBreaks(mesor_fim$tx_mort_2018, 20)
mesor_fim$tx_mort_2018brks <- as.numeric(cut(mesor_fim$tx_mort_2018, 
                                             breaks=natural.interval_inc, 
                                             include.lowest = F))
mesor_fim[is.na(mesor_fim)] <- 0 

write_rds(mesor_fim, "./dados/datasus/mesoregioes/meso_dados.rds")
mesor_fim <- read_rds("./dados/datasus/mesoregioes/meso_dados.rds")

# mapa fundo escuro ----
plot_meso <- ggplot() + 
  geom_sf(data=state, fill= NA, colour = NA, alpha = .5) +
  geom_sf(data=mesor_fim, aes(fill = tx_mort_2018), colour = alpha("white", 0.3), size = 0.2)+
  scale_fill_viridis("Mortes por 100 mil hab", option="magma", direction = -1
                     # , labels=c("","","","","")
                     ) +
  geom_sf(data=regio, fill= NA, colour = "white") +
  theme_map()+
  theme(title = element_text(size = 9, color = "white"),
        # legend.position = "top",        
        legend.title = element_text(size = 8, color = "white"),
        legend.text = element_text(color = "white"),
        rect = element_rect(fill = "transparent", color = NA),
        panel.background = element_rect(fill = "transparent"),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.border = element_blank())+
  # guides(fill = guide_colourbar(title.position = "top"))+
  labs(title = "Mortes em acidentes de transportes por 100 mil habitantes em 2018",
       caption="Fonte: MobiliDADOS.org.br")

plot_meso


# mapa fundo branco ----
plot_meso <- ggplot() + 
  geom_sf(data=state, fill= NA, colour = NA, alpha = .5) +
  geom_sf(data=mesor_fim, aes(fill = tx_mort_2018), colour = alpha("white", 0.3), size = 0.2)+
  scale_fill_viridis("Mortes por 100 mil hab", option="magma", direction = -1
                     # , labels=c("","","","","")
  ) +
  geom_sf(data=regio, fill= NA, colour = "white") +
  theme_map()+
  theme(title = element_text(size = 9),
        # legend.position = "top",        
        legend.title = element_text(size = 9),
        # legend.text = element_text(color = "white"),
        rect = element_rect(fill = "transparent", color = NA),
        panel.background = element_rect(fill = "transparent", color = NA),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.border = element_blank())+
  # guides(fill = guide_colourbar(title.position = "top"))+
  labs(title = "Mortes em acidentes de transportes por 100 mil habitantes em 2018",
       caption="Fonte: MobiliDADOS.org.br")

plot_meso


# Grafico por regiao ----
morte_reg <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/regiao_mortes_modo_2000_2018.xlsx")
head(morte_reg)

# transform dataframe format
data_long <- gather(morte_reg, ano, mortes, `2000`:`2018`) %>% filter(Modo != "total")
data_long <- data_long %>% filter(ano == 2018) %>%
  mutate(Modo = ifelse(Modo == "ativo", "Pedestres e ciclistas", Modo)) %>%
  mutate(Modo = ifelse(Modo == "motociclistas", "Motociclistas", Modo)) %>%
  mutate(Modo = ifelse(Modo == "automóvel", "Outros", Modo)) %>%
  mutate(Modo = ifelse(Modo == "ônibus", "Outros", Modo)) %>%
  mutate(Modo = ifelse(Modo == "outros", "Outros", Modo))

data_long$Modo <- factor(data_long$Modo,
                         levels = c('Pedestres e ciclistas', 'Motociclistas', 'Outros'), 
                         ordered = TRUE)

options(scipen = 999) # remover exp


# gráfico fundo escuro ----
graph <- ggplot(data_long, aes(x = name_region, y = mortes))+
  geom_col(aes(fill = Modo), width = 0.7)+
  scale_fill_manual(
    values = c("#FDDC9EFF", #pedestres e ciclistas
               "#FD9969FF", #motociclistas
               "#231151FF")) + 
  theme_map()+
    # scale_fill_viridis_d(option="D", direction = -1) +
  theme(rect = element_rect(fill = "transparent", color = NA),
        text = element_text(color = "white"),
        title = element_text(size = 9, face="bold", color = "white"),
        legend.position = "bottom",
        axis.line.y = element_line(colour = "black", size = 0.2, color = "white"),
        axis.line.x = element_line(colour = "black", size = 0.2, color = "white"),
        legend.text = element_text(size = 8, color = "white"),
        axis.text.y = element_text(size = 8, face="bold", color = "white"),
        axis.text.x = element_text(size = 8, color = "white"),
        strip.text = element_text(size = 8, color = "white"),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.border = element_blank())+ 
  labs(x = "", y = "", title = "Vítimas de acidentes de transporte por região em 2018",
       caption="Fonte: MobiliDADOS.org.br")

graph


# grafico fundo claro ----
graph<- ggplot(data_long, aes(x = name_region, y = mortes))+
  geom_col(aes(fill = Modo), width = 0.7)+
  scale_fill_manual(
    values = c("#FDDC9EFF", #pedestres e ciclistas
               "#FD9969FF", #motociclistas
               "#231151FF")) + 
  theme_map()+
  # scale_fill_viridis_d(option="D", direction = -1) +
  theme(rect = element_rect(fill = "transparent", color = NA),
        # text = element_text(color = "white"),
        title = element_text(size = 9, face="bold"),
        legend.position = "bottom",
        axis.line.y = element_line(colour = "black", size = 0.2),
        axis.line.x = element_line(colour = "black", size = 0.2),
        legend.text = element_text(size = 8),
        axis.text.y = element_text(size = 8, face="bold"),
        axis.text.x = element_text(size = 8),
        strip.text = element_text(size = 8),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.border = element_blank())+ 
  labs(x = "", y = "", title = "Vítimas de acidentes de transporte por região em 2018",
       caption="Fonte: MobiliDADOS.org.br")

graph

#inset
# x <-'Norte'
# ggm3 <-  ggplot() + 
#   geom_sf(data = state, fill = "white", color = "grey70", size = 0.2) + 
#   geom_sf(data = (state %>% filter(name_region==x)), fill = "red", color = NA, size = 0.05) +
#   theme_void()
# 
# gg_inset_map <-  ggdraw() +
#   draw_plot(plot_Nor) +
#   draw_plot(ggm3, x = 0, y = 0.65, width = 0.2, height = 0.2)




# Grafico para país ----
morte_reg <- openxlsx::read.xlsx("D:/R/dados/datasus/mortes/regiao_mortes_modo_2000_2018.xlsx")
morte <- setDT(morte_reg)


morte <- morte[, .(`2000` = sum(`2000`, na.rm = T), `2001` = sum(`2001`, na.rm = T),
                 `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                 `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                 `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                 `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                 `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                 `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                 `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                 `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                 `2018` = sum(`2018`, na.rm = T)), by = Modo]

morte_reg <- write.xlsx(morte_reg, "./dados/datasus/mortes/brasil_mortes_modo_2000_2018.xlsx")

morte <- setDT(morte)
morte_brasil <- morte[, .(Modo = 'TOTAL', `2000` = sum(`2000`, na.rm = T), 
                          `2001` = sum(`2001`, na.rm = T),
                          `2002` = sum(`2002`, na.rm = T), `2003` = sum(`2003`, na.rm = T),
                          `2004` = sum(`2004`, na.rm = T), `2005` = sum(`2005`, na.rm = T),
                          `2006` = sum(`2006`, na.rm = T), `2007` = sum(`2007`, na.rm = T),
                          `2008` = sum(`2008`, na.rm = T), `2009` = sum(`2009`, na.rm = T),
                          `2010` = sum(`2010`, na.rm = T), `2011` = sum(`2011`, na.rm = T),
                          `2012` = sum(`2012`, na.rm = T), `2013` = sum(`2013`, na.rm = T),
                          `2014` = sum(`2014`, na.rm = T), `2015` = sum(`2015`, na.rm = T), 
                          `2016` = sum(`2016`, na.rm = T), `2017` = sum(`2017`, na.rm = T),
                          `2018` = sum(`2018`, na.rm = T))]

morte_brasil <- rbind(morte, morte_brasil)
morte_brasil <- write.xlsx(morte_brasil, "./dados/datasus/mortes/brasil_mortes_2000_2018.xlsx")

morte <- read.xlsx("./dados/datasus/mortes/brasil_mortes_2000_2018.xlsx")


# transform dataframe format
data_long_brasil <- gather(morte, ano, mortes, `2000`:`2018`) #%>% filter(tipo != "total")
str(data_long_brasil)

data_long_brasil <- data_long_brasil%>% 
  mutate(Modo = ifelse(Modo == "ativo", "Pedestres e ciclistas", Modo)) %>%
  mutate(Modo = ifelse(Modo == "motociclistas", "Motociclistas", Modo)) %>%
  mutate(Modo = ifelse(Modo == "automóvel", "Outros", Modo)) %>%
  mutate(Modo = ifelse(Modo == "ônibus", "Outros", Modo)) %>%
  mutate(Modo = ifelse(Modo == "outros", "Outros", Modo)) %>%
  filter(Modo != "TOTAL")

data_long_brasil$Modo <- factor(data_long_brasil$Modo,
                   levels = c('Pedestres e ciclistas', 'Motociclistas', 'Outros'), 
                   ordered = TRUE)

show_col(viridis_pal(alpha = 1, begin = 0, end = 1, direction = 1,
                     option = "magma")(15))

# gráfico fundo escuro ----
mortes_brasil <- ggplot(data_long_brasil, aes(x = ano, y = mortes))+
  geom_col(aes(fill = Modo), width = 0.7)+
  scale_fill_manual(
    values = c("#FDDC9EFF", #pedestres e ciclistas
               "#FD9969FF", #motociclistas
               "#231151FF")) + 
  # scale_fill_viridis_d(option="D", direction = -1) +
  theme(rect = element_rect(fill = "transparent", color = NA),
        text = element_text(color = "white"),
        axis.line.x = element_line(colour = "black", size = 0.2, color = "white"),
        axis.line.y = element_line(colour = "black", size = 0.2, color = "white"),
        legend.text = element_text(size = 8, color = "white"),
        legend.position = "bottom",
        title = element_text(size = 9, face="bold"),
        axis.text.y = element_text(size = 8, face="bold", color = "white"),
        axis.text.x = element_text(size = 8, color = "white"),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        strip.text = element_text(size = 8, color = "white"),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.border = element_blank())+
  labs(title = "Vítimas de acidentes de transportes entre 2000 e 2018", x = "", y = "",
       caption="Fonte: MobiliDADOS.org.br")

mortes_brasil


# gráfico fundo claro ----
mortes_brasil <- ggplot(data_long_brasil, aes(x = ano, y = mortes))+
  geom_col(aes(fill = Modo), width = 0.7)+
  scale_fill_manual(
    values = c("#FDDC9EFF", #pedestres e ciclistas
               "#FD9969FF", #motociclistas
               "#231151FF")) + 
  # scale_fill_viridis_d(option="D", direction = -1) +
  theme(rect = element_rect(fill = "transparent", color = NA),
        # text = element_text(color = "white"),
        axis.line.x = element_line(colour = "black", size = 0.2),
        axis.line.y = element_line(colour = "black", size = 0.2),
        legend.text = element_text(size = 8),
        legend.position = "bottom",
        title = element_text(size = 9, face="bold"),
        axis.text.y = element_text(size = 8, face="bold"),
        axis.text.x = element_text(size = 8),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        strip.text = element_text(size = 8),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.border = element_blank())+
  labs(title = "Vítimas de acidentes de transportes entre 2000 e 2018", x = "", y = "",
       caption="Fonte: MobiliDADOS.org.br")

mortes_brasil


# Grand finale ----
top_row <- plot_grid(plot_meso, graph, ncol = 2)

bottom_row <- plot_grid(mortes_brasil)
fim <- plot_grid(top_row, 
                 bottom_row, 
                 nrow = 2,
                 rel_heights = c(1, 1))



#fundo escuro
ggsave(fim, file = "./resultados/mapas/datasus/fundo_escuro_mortalidade_mesoregião_região_pais_2018.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

ggsave(plot_meso, file = "./resultados/mapas/datasus/fundo_escuro_mapa.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

ggsave(graph, file = "./resultados/mapas/datasus/fundo_escuro_regiões.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

ggsave(mortes_brasil, file = "./resultados/mapas/datasus/fundo_escuro_mortes_2000_2018.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

beep()

#fundo claro
ggsave(fim, file = "./resultados/mapas/datasus/fundo_claro_mortalidade_mesoregião_região_pais_2018.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

ggsave(plot_meso, file = "./resultados/mapas/datasus/fundo_claro_mapa.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

ggsave(graph, file = "./resultados/mapas/datasus/fundo_claro_regiões.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

ggsave(mortes_brasil, file = "./resultados/mapas/datasus/fundo_claro_mortes_2000_2018.png",
       dpi = 1000, width = 30, height = 18, units = 'cm', bg = 'transparent')

beep()

beep()
