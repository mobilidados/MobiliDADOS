library(extrafont)

extrafont::loadfonts(device = "postscript")
fonts()


temp_map2 <- 
  ggplot() + 
  geom_sf(data=state, fill= "#3d3d3d", colour = "grey40") +
  geom_sf(data=regio, fill= NA, colour = NA) +
  geom_point(data=centroid_datasus, 
             aes(x=lat, y=long, size=`2018`, color = `2018`), 
             stroke = 0,
             # fill="Pink",
             # pch= 21,
             shape = 19,
             alpha=(0.6))+
  scale_color_viridis(option="inferno", direction = -1) +
  theme(panel.background = element_rect(fill = "gray98", color = NA)) + 
  theme_map() +
  theme(rect = element_rect(fill = "3d3d3d", color = NA),
        axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_sf(xlim = c(st_bbox(regio)[[1]], st_bbox(regio)[[3]]),
           ylim = c(st_bbox(regio)[[2]], st_bbox(regio)[[4]])) # coord_cartesian Coordinates Zoom



temp_map2+
  facet_grid(~name_region)+
  coord_sf(xlim = c(st_bbox(regio)[[1]], st_bbox(regio)[[3]]),
           ylim = c(st_bbox(regio)[[2]], st_bbox(regio)[[4]])) # coord_cartesian Coordinates Zoom

rm(x)


x = 'Norte'


x = 'Nordeste'
plot <- function(x){
  # subset data
  centroids_muni  <- subset(centroid_datasus, name_region == x) # municicpio temporario
  estado     <- subset(state, name_region == x) #hex temporario
  region <- subset(regio, name_region == x) #municipios da UF temporario
  
  #plot
  ggplot() + 
    geom_sf(data=estado, fill= NA, colour = "grey40", alpha = .5) +
    geom_sf(data=region, fill= NA, colour = NA) +
    geom_point(data=centroids_muni, 
               aes(x=lat, y=long, size=`2018`, color = `2018`), 
               stroke = 0,
               # fill="Pink",
               # pch= 21,
               shape = 19,
               alpha=(0.6))+
    scale_color_viridis(option="inferno", direction = 1) +
    theme(panel.background = element_rect(fill = NA, color = NA)) + 
    theme_map() +
    theme(rect = element_rect(fill = NA, color = NA),
          axis.text = element_blank(), axis.ticks = element_blank(),
          legend.position ="none",
          text = element_text(family = "Fira Sans"),
          plot.title = element_text(size = 10, hjust = 0.5, vjust = 1, color = "white", face = "bold"),
          panel.background = element_rect(fill = NA, color = NA),
          plot.background = element_rect(fill = NA, color = NA)) +
    coord_sf(xlim = c(st_bbox(region)[[1]], st_bbox(region)[[3]]),
             ylim = c(st_bbox(region)[[2]], st_bbox(region)[[4]]))+
    labs(title = toupper(x))
}


plot_1 <- plot('Norte')
plot_2 <- plot('Nordeste')
plot_3 <- plot('Centro Oeste')
plot_4 <- plot('Sudeste')
plot_5 <- plot('Sul')


p1 <- ggplot()+
  geom_point(data=centroid_datasus, 
             aes(x=lat, y=long, size=`2018`, color = `2018`), 
             stroke = 0,
             # fill="Pink",
             # pch= 21,
             shape = 19,
             alpha=(0.6))+
  scale_color_viridis("mortes em 2018", option="inferno", direction = 1)+
  guides(fill = guide_colourbar(title.position = "top",
                                title.hjust = .5))+ #posicao titulo da legenda
  theme(#legend.title=element_text(vjust = 1, size=8),
        axis.text = element_blank(), axis.ticks = element_blank(),
        plot.background = element_rect(fill=NA, color = NA),
        legend.background = element_rect(fill=NA, color = NA),
        legend.box.background = element_rect(fill=NA, color = NA), #3d3d3d
        legend.text = element_text(family = "Fira Sans", color = "black"), 
        legend.title = element_text("black"),
        legend)+
  labs(size="mortes em 2018", x = "", y = "", colour = "black")

p1


g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)} #funcao para criar legenda


mylegend<-g_legend(p1) #aplicar funcao para criar legenda relevante

plot_fim <- plot_grid(plot_2, plot_1, mylegend, ncol = 3, nrow = 1)

bottom_row <- plot_grid(plot_5,plot_4, plot_3, 
  rel_widths = c(1),
  nrow = 1)+ 
  theme(plot.background = element_rect(fill=NA, color = NA)) #3d3d3d


plot_grid(plot_fim, bottom_row, nrow = 2,
          rel_heights = c(1, 1.3))
