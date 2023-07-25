#loda packages
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
library(Hmisc)
library(magrittr)
library(plyr)

#set directory
setwd('/Users/mackook/Desktop/R')

#open datasus data
datasus <- read.xlsx('./dados/datasus/MobiliDADOS _ Taxa de mortalidade em acidente de transporte nas RMs e capitais (total e por tipo de usuário).xlsx', sheet=2)
colnames(datasus) <- as.character(unlist(datasus[1,]))
datasus <- datasus[-1,] 
datasus_fim <- datasus %<>% mutate_if(is.character,as.numeric) %>%
  mutate(CD_MUN = as.character(CD_MUN), MUNICIPIO = NULL, CAPITAL = NULL, 
         RM = NULL, code_muni = CD_MUN, code_state = substr(CD_MUN, 1, 2))
str(datasus_fim)
head(datasus_fim)
class(datasus_fim)

#create mortality rates for munic
datasus_muni <- datasus_fim %>% 
  mutate(tx_mort_2000 = 100000*(`2000`/Pop_2000), tx_mort_2001 = 100000*(`2001`/Pop_2001),
         tx_mort_2002 = 100000*(`2002`/Pop_2002), tx_mort_2003 = 100000*(`2003`/Pop_2003),
         tx_mort_2004 = 100000*(`2004`/Pop_2004), tx_mort_2005 = 100000*(`2005`/Pop_2005),
         tx_mort_2006 = 100000*(`2006`/Pop_2006), tx_mort_2007 = 100000*(`2007`/Pop_2007),
         tx_mort_2008 = 100000*(`2008`/Pop_2008), tx_mort_2009 = 100000*(`2009`/Pop_2009),
         tx_mort_2010 = 100000*(`2010`/Pop_2010), tx_mort_2011 = 100000*(`2011`/Pop_2011),
         tx_mort_2012 = 100000*(`2012`/Pop_2012), tx_mort_2013 = 100000*(`2013`/Pop_2013),
         tx_mort_2014 = 100000*(`2014`/Pop_2014), tx_mort_2015 = 100000*(`2015`/Pop_2015),
         tx_mort_2016 = 100000*(`2016`/Pop_2016), tx_mort_2017 = 100000*(`2017`/Pop_2017))
datasus_muni <- datasus_muni[,-c(2:37)]
datasus_muni <- datasus_muni %>% mutate(CD_MUN = NULL)
str(datasus_muni)

# download data
y <- 2010
state <- read_state(code_state="all", year=y) %>% mutate(code_state = as.character(code_state)) %>%st_sf()
mesor <- read_meso_region(code_meso="all", year=y)
micro <- read_micro_region(code_micro="all", year=y)
munic <- read_municipality(code_muni="all", year=y) %>% mutate(code_muni = as.character(code_muni)) %>%st_sf()
beep()
str(munic)

#join munic with datasus
munic$code_muni <- substr(munic$code_muni, 1, 6)
munic_datasus <- left_join(munic, datasus_muni, by = 'code_muni')
munic_datasus[is.na(munic_datasus)] <- 0
str(munic_datasus)
head(munic_datasus)

#add data do state
state_datasus <- ddply(datasus_fim, .(code_state),numcolwise(sum))
str(state_datasus)
state_datasus <- left_join(state, state_datasus, by = 'code_state') 

#create mortality rates for state
state_datasus <- state_datasus %>% 
  mutate (tx_mort_2000 = 100000*(`2000`/Pop_2000), tx_mort_2001 = 100000*(`2001`/Pop_2001),
          tx_mort_2002 = 100000*(`2002`/Pop_2002), tx_mort_2003 = 100000*(`2003`/Pop_2003),
          tx_mort_2004 = 100000*(`2004`/Pop_2004), tx_mort_2005 = 100000*(`2005`/Pop_2005),
          tx_mort_2006 = 100000*(`2006`/Pop_2006), tx_mort_2007 = 100000*(`2007`/Pop_2007),
          tx_mort_2008 = 100000*(`2008`/Pop_2008), tx_mort_2009 = 100000*(`2009`/Pop_2009),
          tx_mort_2010 = 100000*(`2010`/Pop_2010), tx_mort_2011 = 100000*(`2011`/Pop_2011),
          tx_mort_2012 = 100000*(`2012`/Pop_2012), tx_mort_2013 = 100000*(`2013`/Pop_2013),
          tx_mort_2014 = 100000*(`2014`/Pop_2014), tx_mort_2015 = 100000*(`2015`/Pop_2015),
          tx_mort_2016 = 100000*(`2016`/Pop_2016), tx_mort_2017 = 100000*(`2017`/Pop_2017))
state_datasus <- state_datasus[,-c(2:41)]
names(state_datasus)

# No plot axis
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())


# individual plots
p_state_2000 <- ggplot() + 
  geom_sf(data=munic, fill=NA, color=NA, show.legend = FALSE) + 
  geom_sf(data=state_datasus, aes(fill = `tx_mort_2000`), colour = NA) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#0b057d', high = '#9c0005')+
  guides(fill = guide_colourbar(title.position = "top",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis +
  labs(subtitle="States 2000", size=8)

p_state_2017 <- ggplot() + 
  geom_sf(data=munic, fill=NA, color=NA, show.legend = FALSE) + 
  geom_sf(data=state_datasus, aes(fill = `tx_mort_2017`), colour = NA) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#0b057d', high = '#9c0005') +
  guides(fill = guide_colourbar(title.position = "top",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis +
  labs(subtitle="States 2017", size=8)

# p_mesor <- ggplot() + 
#   geom_sf(data=mesor, fill="#2D3E50", color="#FEBF57", size=.15, show.legend = FALSE) + 
#   theme_minimal() +
#   no_axis +
#   labs(subtitle="Meso regions", size=8)

# p_micro <- ggplot() + 
#   geom_sf(data=micro, fill="#2D3E50", color="#FEBF57", size=.15, show.legend = FALSE) + 
#   theme_minimal() +
#   no_axis +
#   labs(subtitle="Micro regions", size=8)

p_munic_2000 <- ggplot() + 
  geom_sf(data=munic, fill=NA, color=NA, show.legend = FALSE) + 
  geom_sf(data=munic_datasus, aes(fill = `tx_mort_2000`), colour = NA) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#0b057d', high = '#9c0005') +
  guides(fill = guide_colourbar(title.position = "top",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis +
  labs(subtitle="Municipalities 2000", size=8)

#red = #9c0005
#blue = #0b057d

p_munic_2017 <- ggplot() + 
  geom_sf(data=munic, fill=NA, color=NA, show.legend = FALSE) + 
  geom_sf(data=munic_datasus, aes(fill = `tx_mort_2017`), colour = NA) +
  scale_fill_gradient('Mortes em acidentes de transporte por 100 mil habitantes', low = '#0b057d', high = '#9c0005') +
  guides(fill = guide_colourbar(title.position = "top",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(legend.direction='horizontal',
        legend.position = "none",
        legend.title=element_text(vjust = 1, size=5)) +
  no_axis +
  labs(subtitle="Municipalities 2017", size=8)


# Arrange plots
# p <- plot_grid(p_state, p_mesor, p_micro, p_munic, ncol = 2) #+ p_micro, p_munic
p <- plot_grid(p_state_2000, p_state_2017, p_munic_2000, p_munic_2017, ncol = 2)

# add annotation
#sysfonts::font_add_google(name = "Roboto", family = "Roboto") # add special text font
t1 <- grid::textGrob(expression(bold("Fonte: IBGE, Datasus e geobr")), 
                     gp = gpar(fontsize=5, col="#2D3E50"), x = 0.1, y = .02)

#my_note <- annotation_custom(grobTree(t1, t2))
s <- p + t1

# Save plot
ggsave(s, filename = "./plot_datasus_intro_v2.png", width = 6, height = 6,  dpi = 300)
beepr::beep()
