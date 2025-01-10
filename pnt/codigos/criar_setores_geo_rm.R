library(geobr)
library(dplyr)
library(readr)
library(beepr)
library(sf)
library(mapview)

setwd('F:/Projetos/mobilidados/pnt_verificação')

apoio_rm <- read_rds("apoio/apoio_rm.rds")

setores_uf <- read_census_tract("all",2010)
beep()

rm <- setores_uf %>% filter(code_muni %in% apoio_rm$code_muni)


setores <- rm %>% mutate(Cod_setor = code_tract, Ar_m2 = unclass(st_area(.)))
mapview(setores)

write_rds(setores, './apoio/setores_rms.rds')


# Fazer parte 2


rm <- read_municipality("all") %>% filter(code_muni %in% apoio_rm$code_muni) %>% left_join(apoio_rm, c("code_muni" = "code_muni"))

lista <- rm$rm %>% unique()

for(i in lista){
  assign(paste0("borda_",i), filter(rm, rm == i) %>% st_buffer(.0005) %>% st_union(), envir = .GlobalEnv)  
}

metro <- read_metro_area(year = 2018)

filter(rm, rm == "rmrj") %>% ms_simp(.0005)