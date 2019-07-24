# Percentual de pessoas próximas da rede de transporte de média e alta capacidade - PNT

# O que é o indicador?

# Possíveis recortes?

# Dados necessários?

# Cálculo do indicador
Para calcular o PNT é necessário rodar dois códigos:

1_Preparacao_de_dados.R
Neste código, você prepara os shapefiles dos setores censitários fornecidos pelo IBGE agregando os dados demográficos necessários para realizar o cálculo do indicador. Esta preparação contempla a organização de dados da população total, de domicílios por faixa de renda, de mulheres negras e de mulheres com renda até dois salários mínimos responsáveis por domicílio.

2_Calculo_PNTs_Exemplo_RMS.R
Este código abre os shapefiles das estações transporte de média e alta capacidade (TMA) para criar a área no entorno de cada estação e calcular a população residente a partir dos resultados gerados na primeira etapa. Este cálculo pode ser realizado tanto para uma região metropolitana (RM) como para uma cidade específica.

Nos códigos desta pasta apresentamos um exemplo de cálculo da Região Metropolitana de Salvador(RMS). 

Passo-a-passo do código 1_Preparacao_de_dados.R
1. Instalar e abrir todos os pacotes necessários;
2. Criar o shapefile dos municípios da região metropolitana;
3. Preparar os dados demográficos da região metropolitana;
4. Unir os dados demográficos com os shapefiles dos setores censitarios;
5. Realizar o cálculo total de cada variável para a RM (ou cidade) selecionada.

Passo-a-passo do código 2_Calculo_PNTs.R
1. Instalar e abrir todos os pacotes necessários para o cálculo;
2. Importar os dados das estações TMA;
3. Criar a área no entorno das estações de TMA e recortar os setores censitarios inseridos nesta área;
4. Calcular os dados totais de cada variável para a RM/Cidade e os dados dentro da area no entorno das estações;
5. Realizar cálculo final dos indicadores de PNT com as variáveis criadas nos passos anteriores.

# Fontes e Referências
Link para vídeo Tutorial
Post PNT
MobiliDADOS
Ficha dos indicadores
R  https://www.rstudio.com/products/rstudio/download/#download  
R Studio: https://cran.rstudio.com/  

# Glossário

Buffer

Setor censitário

Shapefiles

Transporte de média e alta capacidade

ATENÇÃO: É necessário que os shapes com os dados censitários e os dados das estações TMA estejam na mesma projeção.
Utilize o código (st_crs(TMA_stations) ==  st_crs(Setores)) para conferir. Caso a resposta seja FALSE, reprojetar os shapes com o código st_transform(). O código ESPG da projecao varia para cada cidade/RM brasileira:
   - Belo Horizonte, Distrito Federal, Rio De Janeiro e Sao Paulo 31983
   - Recife 31985
   - Belem 31982
   - Fortaleza 31984
