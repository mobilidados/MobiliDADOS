library(dplyr)
library(readr)

#Leitura de arquivos do Censo 2022


raca <-read.csv2("./apoio/input_censo/Agregados_por_setores_cor_ou_raca_BR.csv")


basico <-read.csv2("./apoio/input_censo/Agregados_por_setores_basico_BR.csv")

basico <- basico[basico$v0003 >= 5,]


racafinal <- bind_cols(raca$CD_SETOR,raca$V01317,raca$V01318,raca$V01319,raca$V01320,raca$V01321,raca$V01322,raca$V01323,
                       raca$V01324,raca$V01325,raca$V01326,raca$V01327,raca$V01328,raca$V01329,raca$V01330,raca$V01331)

names(racafinal) <- c("CD_SETOR", "branco", "preto","amarelo", "pardo", "indigena",
                      "homem_branco", "homem_preto", "homem_amarelo", "homem_pardo", "homem_indigena", 
                      "mulher_branca", "mulher_preta","mulher_amarela", "mulher_parda", "mulher_indigena")

racafinal <- racafinal %>% left_join(basico[,c("CD_SETOR","CD_MUN","v0001")], c("CD_SETOR" = "CD_SETOR"))
racafinal <- racafinal %>% left_join(basico[,c("CD_SETOR","v0003")], c("CD_SETOR" = "CD_SETOR"))

# racafinal2 <- racafinal %>%
#  mutate(across(c(branco, negro, pardo, amarelo, indigena), ~na_if(., "X")))

racafinal2 <- racafinal %>%
  mutate(across(
    c(branco, preto,amarelo, pardo,indigena, homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
      mulher_branca, mulher_preta, mulher_amarela, mulher_parda, mulher_indigena),
    as.character
  )) %>%
  mutate(across(
    c(branco, preto, amarelo, pardo , indigena, homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
      mulher_branca, mulher_preta, mulher_amarela, mulher_parda, mulher_indigena),
    ~ if_else(. == "X", "1", .)
  )) %>%
  mutate(across(
    c(branco, preto, amarelo, pardo , indigena, homem_branco, homem_preto, homem_amarelo, homem_pardo, homem_indigena, 
      mulher_branca, mulher_preta, mulher_amarela, mulher_parda, mulher_indigena), as.numeric))

colnames(racafinal2)[which(names(racafinal2) == "v0001")] <- "pop"
colnames(racafinal2)[which(names(racafinal2) == "v0003")] <- "domi"


racafinal2$mulher_negra <- racafinal2$mulher_preta  + racafinal2$mulher_parda
racafinal2$homem_negro <- racafinal2$homem_preto + racafinal2$homem_pardo 
racafinal2$negro <- racafinal2$mulher_negra + racafinal2$homem_negro



write_rds(racafinal2, "./apoio/dados_setores_2022.rds")
