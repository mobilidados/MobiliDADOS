get_mun <- function() {
  #Função para baixar a lista com nomes e códigos de todos os municípios do Brasil
  
  #Baixa a lista de municípios
  tabela_base <- sidrar::get_sidra(x = 6579, # código da tabela
                                   variable = 9324, # Código da variável
                                   geo = "City", # Site
                                   period = "2020")
  
  #Limpa a base de dados
  tabela_base <- tabela_base[,c(6,7)] %>% janitor::clean_names()
  tabela_base$municipio_codigo <- substr(tabela_base$municipio_codigo,1,6)
  tabela_base
}




