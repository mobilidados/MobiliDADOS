# Definindo o ano para ser usado nos caminhos
ano <- 2022

# Lista de caminhos
caminhos <- list(
  "./pnt/output/",
  paste0("./pnt/output/", ano),
  paste0("./pnt/output/", ano, "/buffer"),
  paste0("./pnt/output/", ano, "/buffer", "/rds"),
  paste0("./pnt/output/", ano, "/buffer", "/rds/capitais/"),
  paste0("./pnt/output/", ano, "/buffer", "/rds/rms/"),
  paste0("./pnt/output/", ano, "/buffer", "/shp/capitais/"),
  paste0("./pnt/output/", ano, "/buffer", "/shp/rms/"),
  paste0("./pnt/output/", ano, "/entorno"),
  paste0("./pnt/output/", ano, "/entorno", "/rds"),
  paste0("./pnt/output/", ano, "/entorno", "/rds/capitais/"),
  paste0("./pnt/output/", ano, "/entorno", "/rds/rms/"),
  paste0("./pnt/output/", ano, "/entorno", "/shp/capitais/"),
  paste0("./pnt/output/", ano, "/entorno", "/shp/rms/"),
  paste0("./pnt/output/", ano, "/entorno", "/geojson/capitais/"),
  paste0("./pnt/output/", ano, "/entorno", "/geojson/rms/"),
  paste0("./pnt/output/", ano, "/points"),
  paste0("./pnt/output/", ano, "/points", "/rds"),
  paste0("./pnt/output/", ano, "/points", "/rds/capitais/"),
  paste0("./pnt/output/", ano, "/points", "/rds/rms/"),
  paste0("./pnt/output/", ano, "/points", "/shp/capitais/"),
  paste0("./pnt/output/", ano, "/points", "/shp/rms/"),
  "./pnt/resultados/",
  paste0("./pnt/resultados/", ano),
  paste0("./pnt/resultados/", ano, "/capitais"),
  paste0("./pnt/resultados/", ano, "/rms"),
  "./pnt/resultados/0_consolidado/",
  paste0("./pnt/resultados/0_consolidado/", ano)
)

# Itera sobre a lista de caminhos e cria as pastas se não existirem
for (path in caminhos) {
  if (!dir.exists(path)) {
    if (dir.create(path, recursive = TRUE)) {
      cat("Pasta criada: ", path, "\n", sep = "")
    } else {
      cat("Erro ao criar a pasta: ", path, "\n", sep = "")
    }
  } else {
    cat("Pasta já existe: ", path, "\n", sep = "")
  }
}
