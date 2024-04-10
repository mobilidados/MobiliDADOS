library(readxl)


bbox <- read_excel("D:/Projetos/mobilidados/outros/boundingbox.xlsx", sheet=1)

bbox$left <- as.numeric(bbox$left)
bbox$bottom <- as.numeric(bbox$bottom)
bbox$right <- as.numeric(bbox$right)
bbox$top <- as.numeric(bbox$top)



for(i in 1:nrow(bbox)){

dir.create(sprintf("pnb/network/pbf/%s", bbox$capital_sigla[i]))
dir.create(sprintf("pnb/network/pbf/%s/temp", bbox$capital_sigla[i]))

command <- sprintf("osmium extract pnb/network/pbf/brazil-231231.osm.pbf -b %f,%f,%f,%f -s complete_ways -v -o pnb/network/pbf/%s/temp/city.pbf",
                   bbox$left[i], bbox$bottom[i],  bbox$right[i], bbox$top[i], bbox$capital_sigla[i])

system(command)

# Linha de comando 1: osmconvert
command2 <- sprintf("osmconvert pnb/network/pbf/%s/temp/city.pbf -o=pnb/network/pbf/%s/temp/city.o5m", bbox$capital_sigla[i], bbox$capital_sigla[i])
cat(command2, "\n")
system(command2)

# Linha de comando 2: osmfilter para city.o5m
command3 <- sprintf("osmfilter pnb/network/pbf/%s/temp/city.o5m --keep=\"highway=\" -o=pnb/network/pbf/%s/temp/cityhighways.o5m", bbox$capital_sigla[i], bbox$capital_sigla[i])
cat(command3, "\n")
system(command3)

# Linha de comando 3: osmfilter para cityhighways.o5m
command4 <- sprintf("osmfilter pnb/network/pbf/%s/temp/cityhighways.o5m --drop=\"area=yes highway=link =motor =proposed =construction =abandoned =platform =raceway service=parking_aisle =driveway =private foot=no\" -o=pnb/network/pbf/%s/temp/citywalk.o5m", bbox$capital_sigla[i], bbox$capital_sigla[i])
cat(command4, "\n")
system(command4)

command5 <- sprintf("osmconvert pnb/network/pbf/%s/temp/citywalk.o5m -o=pnb/network/pbf/%s/malha_viaria_%s.pbf", bbox$capital_sigla[i], bbox$capital_sigla[i],bbox$capital[i])
cat(command5, "\n")
system(command5)

# unlink(sprintf("pnb/network/pbf/%s/temp",bbox$capital_sigla[i]), recursive = TRUE)

}
