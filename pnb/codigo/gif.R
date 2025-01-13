library(dplyr)
library(sf)
library(mapview)
library(ggplot2)
library(magick)
library(geobr)
library(stringr)
library(gganimate)
library(pbapply)

setwd("F:/Projetos/mobilidados/pnb_novo/")

munis_df <- data.frame(code_muni = c(2927408, 3550308, 3304557, 2611606, 
                                     2304400, 5300108, 4106902,
                                     3106200, 1501402, 1100205, 1200401,
                                     1302603, 1400100, 1600303, 1721000, 2111300,
                                     2211001, 2408102, 2507507, 2704302, 2800308,
                                     3205309, 4205407, 4314902, 5002704,
                                     5103403, 5208707),
                       name_muni=c('salvador', 'sao paulo','rio de janeiro', 'recife',
                                   'fortaleza', 'distrito federal', 'curitiba', 
                                   'belo horizonte', 'belem', 'porto velho', 'rio branco', 
                                   'manaus', 'boa vista', 'macapa', 'palmas', 'sao luis',
                                   'teresina', 'natal', 'joao pessoa', 'maceio', 'aracaju', 
                                   'vitoria', 'florianopolis', 'porto alegre', 'campo grande', 
                                   'cuiaba', 'goiania'),
                       abrev_state=c('BA', 'SP', 'RJ', 'PE', 'CE', 'DF', 'PR', 'MG', 'PA', 'RO',
                                     'AC', 'AM', 'RR', 'AP', 'TO', 'MA', 'PI', 'RN', 'PB', 'AL',
                                     'SE', 'ES', 'SC', 'RS', 'MS', 'MT', 'GO'), 
                       espg = c(31984, 31983, 31983, 31985, 31984, 31983, 31982, 31983, 31982, 
                                31980, 31979, 31980, 31980, 31982, 31982, 31983, 31983,
                                31985, 31985, 31985, 31984, 31984, 31982, 31982, 31981,
                                31981, 31982),
                       sigla_muni = c("ssa", "spo", "rio", "rec", "for", "dis", "cur", 
                                      "bho", "bel", "por", "rbr", "man", "boa", "mac", 
                                      "pal", "sls", "ter", "nat", "joa", "mco", "ara", 
                                      "vit", "flo", "poa", "cam", "cui", "goi"))
mun <- 3304557

b <- read_municipality()

create_gif <- function(mun){
  infra_total <- NULL
  
  for(ano in 2013:2021){
    tryCatch({  
      infra_ciclo <- st_read(paste0('./dados/infra_cicloviaria/geofabrik/',ano,'/infra_ciclo_', 
                                    subset(munis_df, code_muni==mun)$name_muni,
                                    '.geojson')) %>% st_cast("LINESTRING") %>% mutate(ano = ano) %>% 
        filter(tipologia %in% c('Ciclovia','Ciclofaixa'))
      infra_total <- rbind(infra_total,infra_ciclo)
    },error=function(e){})
    
  }
  
  
  
  
c <- b %>% filter(code_muni ==mun)
  
for(ano in 2013:2021){
    tryCatch({
      p <- ggplot(infra_total[infra_total$ano == ano,]) + 
        geom_sf(aes(color = tipologia), size = 1.2) +
        geom_sf(data = c, aes(), fill = NA, colour = "#000000",size = 0.1) +
        labs(title = paste0("Infraestrutura cicloviária de ",str_to_title(subset(munis_df, code_muni==mun)$name_muni)," (OSM) em ", ano)) +
        theme_void() 
      
      fp <- file.path(getwd(), paste0("./gif/",subset(munis_df, code_muni==mun)$sigla_muni,"/infra_",
                                      str_to_title(subset(munis_df, code_muni==mun)$name_muni) ,"_",ano, ".png"))
      ggsave(plot = p, 
             filename = fp, 
             device = "png",
             dpi = 320)
    },error=function(e){})
  }
  
imgs <- list.files(paste0("./gif/",subset(munis_df, code_muni==mun)$sigla_muni), full.names = TRUE)
img_list <- lapply(imgs, image_read)
  
  
## join the images together
img_joined <- image_join(img_list)
  
## animate at 2 frames per second
img_animated <- image_animate(img_joined, fps = 0.5)
  
  
image_write(image = img_animated,
              path = paste0("./gif/",subset(munis_df, code_muni==mun)$sigla_muni,"/infra_",
                            str_to_title(subset(munis_df, code_muni==mun)$name_muni), ".gif"))
  

}


pblapply(munis_df$code_muni,create_gif)


 for(i in munis_df$sigla_muni){
  dir.create(paste0("./gif/",i))
}
