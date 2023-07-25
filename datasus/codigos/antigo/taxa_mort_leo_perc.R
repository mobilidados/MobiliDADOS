setwd("F:/Projetos/Mobilidados/datasus_verificacao")

num_mort_mun <- read.csv2("./output/num_mort_mun.csv", header = TRUE)
num_mort_mun_negres <- read.csv2("./output/num_mort_mun_negres.csv", header = TRUE)

tab_morte_rm <- read.csv2("./output/tab_morte_rm.csv", header = TRUE)
tab_morte_rm_negres <- read.csv2("./output/tab_morte_rm_negres.csv", header = TRUE)


perc_morte_negres <- cbind(num_mort_mun_negres[c(1:8)],num_mort_mun_negres[-c(1:8)]/num_mort_mun[-c(1:8)]*100)

perc_morte_negres[is.na(perc_morte_negres)] <- 0


perc_morte_negres_rm <- cbind(tab_morte_rm[c(1:2)],tab_morte_rm_negres[-c(1:2)]/tab_morte_rm[-c(1:2)]*100)


perc_morte_negres_rm[is.na(perc_morte_negres_rm)] <- 0

write.csv2(perc_morte_negres, "F:/Projetos/mobilidados/datasus_verificacao/output/perc_morte_negres.csv", row.names = FALSE)
write.csv2(perc_morte_negres_rm, "F:/Projetos/mobilidados/datasus_verificacao/output/perc_morte_negres_rm.csv", row.names = FALSE)
