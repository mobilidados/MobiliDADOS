# Percentual de pessoas próximas da rede de transporte de média e alta capacidade - PNT

### O que é o indicador?
O indicador mensura o percentual da população de uma cidade ou região metropolitana que reside em um raio de até 1 km de uma estação do sistema de transporte público de média e alta capacidade. O dado é obtido por recursos de geoprocessamento, considerando a distribuição da população no território e a localização das estações e terminais de transporte público de média e alta capacidade. Na plataforma MobiliDADOS, este indicador é calculado considerando recorte de faixa de renda, gênero e raça e gênero e renda.

O indicador pode ser utilizado para fins comparativos entre cidades ou regiões metropolitanas, para avaliar a distribuição da infraestrutura de média e alta capacidade no território e acompanhar a evolução da proximidade da população aos sistemas de transporte existentes ou em planejamento.

O ideal é que o indicador apresente tendência de crescimento ao longo do tempo


#### Fonte dos dados necessários para cacular o indicador
- [Shapefile dos setores censitários do IBGE](https://bit.ly/2Y6T4In) 
- [Dados por setores censitários do IBGE](https://bit.ly/2hr75s0)
- [Estações de transporte média e alta capacidade mapeadas pela ITDP](https://www.google.com/maps/d/u/0/viewer?mid=1iQ9q4KBuH2T2O0972VURU_Ak76s&ll=-29.651371798676887%2C-34.02013055808925&z=3)



### Cálculo do indicador
Para calcular o PNT é necessário rodar dois códigos:

  **1_Preparacao_de_dados.R**

Neste código, você prepara os shapefiles dos setores censitários fornecidos pelo IBGE agregando os dados demográficos necessários para realizar o cálculo do indicador. Esta preparação contempla a organização de dados da população total, de domicílios por faixa de renda, de mulheres negras e de mulheres com renda até dois salários mínimos responsáveis por domicílio.

Passo-a-passo do código 1:
1. Instalar e abrir todos os pacotes necessários;
2. Criar o shapefile dos municípios da região metropolitana;
3. Preparar os dados demográficos da região metropolitana;
| Variáveis que serão criadas | Dados do IBGE necessários |
|--------|-----------|
|Populacao | Quantidade de moradores em domicílios particulares permanentes ou população residente em domicílios particulares permanentes. A variável V002 extraída da tabela Basico|


4. Unir os dados demográficos com os shapefiles dos setores censitarios;
5. Realizar o cálculo total de cada variável para a RM (ou cidade) selecionada.

  **2_Calculo_PNTs.R**

Este código abre os shapefiles das estações transporte de média e alta capacidade (TMA) para criar a área no entorno de cada estação e calcular a população residente a partir dos resultados gerados na primeira etapa. Este cálculo pode ser realizado tanto para uma região metropolitana (RM) como para uma cidade específica.

Passo-a-passo do código 2:
1. Instalar e abrir todos os pacotes necessários para o cálculo;
2. Importar os dados das estações TMA;
3. Criar a área no entorno das estações de TMA e recortar os setores censitarios inseridos nesta área;
4. Calcular os dados totais de cada variável para a RM/Cidade e os dados dentro da area no entorno das estações;
5. Realizar cálculo final dos indicadores de PNT com as variáveis criadas nos passos anteriores.

Nos códigos desta pasta apresentamos um exemplo de cálculo da Região Metropolitana de Salvador(RMS). 


### Fontes e Referências
- [MobiliDADOS](https://mobilidados.org.br/)
- [Ficha dos indicadores da MobiliDADOS](https://docs.google.com/spreadsheets/d/1Q5QuhNEcaMmNY9Wzke7DQ_ERiqcDiP6uGNtD5MwSsaY/edit#gid=0)
- [Link para vídeo Tutorial](INSERIR LINK)
- [Estudo ITDP Global](https://itdpdotorg.wpengine.com/wp-content/uploads/2016/10/People-Near-Transit.pdf)
- [Post PNT](https://itdpbrasil.org/pnt/)
- [Publicação Ministério das Cidades com dados de PNT](http://www.cidades.gov.br/images/stories/ArquivosSEMOB/ArquivosPDF/relatorio-indicadores-efetividade-pnmu.pdf)
- [Baixar R](https://www.rstudio.com/products/rstudio/download/#download) 
- [Baixar R Studio](https://cran.rstudio.com/) 


### Glossário

| Termo | Descrição |
|-------|-----------|
| Setor censitário | Unidade territorial de coleta das operações censitárias, definido pelo IBGE, com limites físicos identificados, em áreas contínuas e respeitando a divisão político-administrativa do Brasil.|
| Shapefile | Formato de arquivo contendo dados geoespaciais em forma de vetor usado por Sistemas de Informações Geográficas.|
| EPSG | Sigla para do Grupo Europeu de Pesquisa Petrolífera (European Petroleum Survey Group), que foi a entidade que organizou por meio desses códigos numéricos os Sistemas de Referência de Coordenadas (SRC) do mundo. Os EPSG das regiões metropolitanas e capitais presentes da MobiliDADOS estão detalhadas a seguir: EPSG 31983 para Belo Horizonte, Distrito Federal, Rio De Janeiro e Sao Paulo, EPSG 31985 para Recife, EPSG 31982 para Belem, EPSG 31984 para Fortaleza.|

Transporte de média e alta capacidade: [Inserir inforgráfico]

