setwd('/Users/mackook/Desktop/R/dados/IBGE/Tabelas_UF/')


#SP_Capital ----
Bas <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/Basico_SP1.xls')
Basico <- Bas[,-c(2:3,5:11, 13:19, 21:22, 24:33)]
names(Basico)

Ent1 <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/Entorno01_SP1.xls')
Ent_01 <- Ent1[,-c(2:4, 6:12, 14:21, 23:40, 42, 44, 46:58, 60, 62, 64:222)]
Ent_01 <- lapply(Ent_01, as.numeric)
Ent_01 <- as.data.frame(Ent_01)
names(Ent_01)


Dom2 <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/Domicilio02_SP1.xls')
Dom_02 <- Dom2[,-c(5:134)]
Dom_02 <- lapply(Dom_02, as.numeric)
Dom_02 <- as.data.frame(Dom_02)
names(Dom_02)

Pes_03 <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/Pessoa03_SP1.xls')
Pess03 <- Pes_03[,-c(3,9:169,171,173:174,176,178:179,181,183:184,186,188:199,201,203:204,206,208:209,211,213:214,216,218:219,
                     221,223:224,226,228:229,231,233:234,236,238:239,241,243:244,246,248:253)]
Pess03 <- lapply(Pess03, as.numeric)
Pess03 <- as.data.frame(Pess03)
names(Pess03)

Pes_05 <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/Pessoa05_SP1.xls')
Pess05 <- Pes_05 [,-c(3:8,10,12)]
Pess05 <- lapply(Pess05, as.numeric)
Pess05 <-  as.data.frame(Pess05)
names(Pess05)

Dom_Rda <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/DomicilioRenda_SP1.xls')
DomRda <- Dom_Rda [,-c(3:6)]
DomRda <- lapply(DomRda, as.numeric)
DomRda <-  as.data.frame(DomRda)
names(DomRda)

Resp_Rd <- read_xls('./0_originais/SP Capital/Base informacoes setores2010 universo SP_Capital/EXCEL/ResponsavelRenda_SP1.xls')
RespRd <- Resp_Rd [,-c(3:46,50:134)]
RespRd <- lapply(RespRd, as.numeric)
RespRd <-  as.data.frame(RespRd)
names(RespRd)

# ('Cod_UF', 'Cod_municipio', 'Cod_setor', 'DomRend_V003', 'BA_V002',
#   'Dom2_V002', 'Pess3_V002','Pess3_V003', 'Pess3_V004', 'Pess3_V005',
#   'Pess3_V006','Pess3_V168', 'Pess3_V170', 'Pess3_V173', 'Pess3_V175',
#   'Pess3_V178','Pess3_V180', 'Pess3_V183', 'Pess3_V185', 'Pess3_V198',
#   'Pess3_V200','Pess3_V203', 'Pess3_V205', 'Pess3_V208', 'Pess3_V210',
#   'Pess3_V213','Pess3_V215', 'Pess3_V218', 'Pess3_V220', 'Pess3_V223',
#   'Pess3_V225','Pess3_V228', 'Pess3_V230', 'Pess3_V233', 'Pess3_V235',
#   'Pess3_V238','Pess3_V240', 'Pess3_V243', 'Pess3_V245', 'Pess5_V007',
#   'Pess5_V009','RespRend_V045','RespRend_V046', 'RespRend_V047', 'DomRend_V005',
#   'DomRend_V006', 'DomRend_V007', 'DomRend_V008', 'DomRend_V009', 'DomRend_V010',
#   'DomRend_V011', 'DomRend_V012', 'DomRend_V013', 'DomRend_V014',
#   'Ent01_V020', 'Ent01_V022', 'Ent01_V024', 'Ent01_V038', 'Ent01_V040', 'Ent01_V042')) 

Basico <- Basico %>% setNames(c(names(.)[1:4], paste0("BA_", names(.)[5]))) 
str(Basico)

Ent_01 <- Ent_01 %>% setNames(c(names(.)[1], paste0("Ent01_", names(.)[-1]))) 
Ent_01$Ent01_Situacao_setor
Ent_01$Ent01_Cod_municipio <- NULL
str(Ent_01)

Pess03 <- Pess03 %>% setNames(c(names(.)[1], paste0("Pess03_", names(.)[-1])))
Pess03$Pess03_Situacao_setor <- NULL
str(Pess03)

Dom_02 <- Dom_02 %>% setNames(c(names(.)[1], paste0("Dom_02_", names(.)[-1]))) %>%
  mutate(Dom_02_Situacao_setor = NULL, Dom_02_V001 = NULL)
str(Dom_02)

Pess05 <- Pess05 %>% setNames(c(names(.)[1], paste0("Pess05_", names(.)[-1]))) %>%
  mutate(Pess05_Situacao_setor = NULL)
str(Pess05)

DomRda <- DomRda %>% setNames(c(names(.)[1], paste0("DomRda_", names(.)[-1]))) %>%
  mutate(DomRda_Situacao_setor = NULL)
str(DomRda)

RespRd <- RespRd %>% setNames(c(names(.)[1], paste0("RespRd_", names(.)[-1]))) %>%
  mutate(RespRd_Situacao_setor = NULL)
str(RespRd)


a   <- left_join(Basico, Ent_01, by= 'Cod_setor')
b   <- left_join(a, Dom_02, by= 'Cod_setor')
c   <- left_join(b, Pess03, by= 'Cod_setor')
d   <- left_join(c, Pess05, by= 'Cod_setor')
e   <- left_join(d, DomRda, by= 'Cod_setor')
fim <- left_join(e, RespRd, by= 'Cod_setor')


str(fim)
names(fim)
write.xlsx(fim, './0_originais/SP Capital/SP_dados_intermediario.xlsx')



#SP_Exceto_Capital ----
Bas <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/Basico_SP2.xls')
Basico <- Bas[,-c(2:3,5:11, 13:19, 21:22, 24:33)]
names(Basico)

Ent1 <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/Entorno01_SP2.xls')
Ent_01 <- Ent1[,-c(2, 4:21, 23, 25, 27:39, 41, 43, 45:203)]
Ent_01 <- lapply(Ent_01, as.numeric)
Ent_01 <- as.data.frame(Ent_01)
names(Ent_01)


Dom2 <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/Domicilio02_SP2.xls')
Dom_02 <- Dom2[,-c(5:134)]
Dom_02 <- lapply(Dom_02, as.numeric)
Dom_02 <- as.data.frame(Dom_02)
names(Dom_02)

Pes_03 <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/Pessoa03_SP2.xls')
Pess03 <- Pes_03[,-c(3,9:169,171,173:174,176,178:179,181,183:184,186,188:199,201,203:204,206,208:209,211,213:214,216,218:219,
                     221,223:224,226,228:229,231,233:234,236,238:239,241,243:244,246,248:253)]
Pess03 <- lapply(Pess03, as.numeric)
Pess03 <- as.data.frame(Pess03)
names(Pess03)

Pes_05 <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/Pessoa05_SP2.xls')
Pess05 <- Pes_05 [,-c(3:8,10,12)]
Pess05 <- lapply(Pess05, as.numeric)
Pess05 <-  as.data.frame(Pess05)
names(Pess05)

Dom_Rda <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/DomicilioRenda_SP2.xls')
DomRda <- Dom_Rda [,-c(3:6)]
DomRda <- lapply(DomRda, as.numeric)
DomRda <-  as.data.frame(DomRda)
names(DomRda)

Resp_Rd <- read_xls('./0_originais/SP Exceto a Capital/Base informacoes setores2010 universo SP_Exceto_Capital/EXCEL/ResponsavelRenda_SP2.xls')
RespRd <- Resp_Rd [,-c(3:46,50:134)]
RespRd <- lapply(RespRd, as.numeric)
RespRd <-  as.data.frame(RespRd)
names(RespRd)

# ('Cod_UF', 'Cod_municipio', 'Cod_setor', 'DomRend_V003', 'BA_V002',
#   'Dom2_V002', 'Pess3_V002','Pess3_V003', 'Pess3_V004', 'Pess3_V005',
#   'Pess3_V006','Pess3_V168', 'Pess3_V170', 'Pess3_V173', 'Pess3_V175',
#   'Pess3_V178','Pess3_V180', 'Pess3_V183', 'Pess3_V185', 'Pess3_V198',
#   'Pess3_V200','Pess3_V203', 'Pess3_V205', 'Pess3_V208', 'Pess3_V210',
#   'Pess3_V213','Pess3_V215', 'Pess3_V218', 'Pess3_V220', 'Pess3_V223',
#   'Pess3_V225','Pess3_V228', 'Pess3_V230', 'Pess3_V233', 'Pess3_V235',
#   'Pess3_V238','Pess3_V240', 'Pess3_V243', 'Pess3_V245', 'Pess5_V007',
#   'Pess5_V009','RespRend_V045','RespRend_V046', 'RespRend_V047', 'DomRend_V005',
#   'DomRend_V006', 'DomRend_V007', 'DomRend_V008', 'DomRend_V009', 'DomRend_V010',
#   'DomRend_V011', 'DomRend_V012', 'DomRend_V013', 'DomRend_V014',
#   'Ent01_V020', 'Ent01_V022', 'Ent01_V024', 'Ent01_V038', 'Ent01_V040', 'Ent01_V042')) 

Basico <- Basico %>% setNames(c(names(.)[1:4], paste0("BA_", names(.)[5]))) 
str(Basico)

Ent_01 <- Ent_01 %>% setNames(c(names(.)[1], paste0("Ent01_", names(.)[-1]))) 
Ent_01$Ent01_Situacao_setor
Ent_01$Ent01_Cod_municipio <- NULL
str(Ent_01)

Pess03 <- Pess03 %>% setNames(c(names(.)[1], paste0("Pess03_", names(.)[-1])))
Pess03$Pess03_Situacao_setor <- NULL
str(Pess03)

Dom_02 <- Dom_02 %>% setNames(c(names(.)[1], paste0("Dom_02_", names(.)[-1]))) %>%
  mutate(Dom_02_Situacao_setor = NULL, Dom_02_V001 = NULL)
str(Dom_02)

Pess05 <- Pess05 %>% setNames(c(names(.)[1], paste0("Pess05_", names(.)[-1]))) %>%
  mutate(Pess05_Situacao_setor = NULL)
str(Pess05)

DomRda <- DomRda %>% setNames(c(names(.)[1], paste0("DomRda_", names(.)[-1]))) %>%
  mutate(DomRda_Situacao_setor = NULL)
str(DomRda)

RespRd <- RespRd %>% setNames(c(names(.)[1], paste0("RespRd_", names(.)[-1]))) %>%
  mutate(RespRd_Situacao_setor = NULL)
str(RespRd)


a   <- left_join(Basico, Ent_01, by= 'Cod_setor')
b   <- left_join(a, Dom_02, by= 'Cod_setor')
c   <- left_join(b, Pess03, by= 'Cod_setor')
d   <- left_join(c, Pess05, by= 'Cod_setor')
e   <- left_join(d, DomRda, by= 'Cod_setor')
fim <- left_join(e, RespRd, by= 'Cod_setor')


str(fim)
names(fim)
write.xlsx(fim, './0_originais/SP Exceto a Capital/SP2_dados_intermediario.xlsx')


#join_SP1_SP2 ----
SP1 <- read.xlsx('./0_originais/SP Capital/SP_dados_intermediario.xlsx')
SP2 <- read.xlsx('./0_originais/SP Exceto a Capital/SP2_dados_intermediario.xlsx')
SP <- rbind(SP1, SP2)

SP1<- SP1[,-c(6)]
names(SP1)
names(SP2)

write.xlsx(SP, './0_originais/SP_v2.xlsx')
names(SP)
str(SP)
SP <- SP %>% mutate(Cod_setor=as.character(Cod_setor))

final <- setDT(SP)[,.(Cod_UF = Cod_UF,
                      Cod_municipio = Cod_municipio,
                      Situacao_setor = Situacao_setor,
                      Pop = BA_V002,
                      DR_0_meio = sum(DomRda_V005, DomRda_V006, DomRda_V007, DomRda_V014, na.rm=T),
                      DR_meio_1 = DomRda_V008, 
                      DR_1_3 = sum(DomRda_V009, DomRda_V010),
                      DR_3_mais = sum(DomRda_V011, DomRda_V012, DomRda_V013),
                      M_Negras = sum(Pess03_V168, Pess03_V170, Pess03_V173, Pess03_V175, Pess03_V178, Pess03_V180,Pess03_V183, 
                                     Pess03_V185, Pess03_V198, Pess03_V200, Pess03_V203, Pess03_V205, Pess03_V208, Pess03_V210,
                                     Pess03_V213, Pess03_V215, Pess03_V218, Pess03_V220, Pess03_V223, Pess03_V225, Pess03_V228, 
                                     Pess03_V230, Pess03_V233, Pess03_V235, Pess03_V238, Pess03_V240, Pess03_V243, Pess03_V245, 
                                     Pess05_V007, Pess05_V009),
                      M_2SM = sum(RespRd_V045, RespRd_V046, RespRd_V047),
                      Perc_calc = 100*sum(Ent01_V020, Ent01_V022, Ent01_V024)/Ent01_V001,
                      Perc_ramp = 100*sum(Ent01_V038, Ent01_V040, Ent01_V042)/Ent01_V001), by=Cod_setor]

write.xlsx(final, './SP_dados.xlsx')
