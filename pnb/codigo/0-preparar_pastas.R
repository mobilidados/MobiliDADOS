# Definindo o ano para ser usado nos caminhos
ano <- 2024

# Lista de caminhos
caminhos <- list(
  "./pnb/dados/infra_cicloviaria/pnb",
  "./pnb/dados/infra_cicloviaria/pnb/buffer/",
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer/", ano),
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer/", ano, "/rds"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer/", ano, "/shp"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer_entorno/", ano),
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer_entorno/", ano, "/geojson"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer_entorno/", ano, "/rds"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/buffer_entorno/", ano, "/shp"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/geofabrik_filtrado/", ano),
  paste0("./pnb/dados/infra_cicloviaria/pnb/geofabrik_filtrado/", ano, "/rds"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/geofabrik_filtrado/", ano, "/shp"),
  paste0("./pnb/dados/infra_cicloviaria/pnb/geofabrik_pontos/", ano),
  "./pnb/dados/infra_cicloviaria/pnpb",
  "./pnb/dados/infra_cicloviaria/pnpb/buffer/",
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer/", ano),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer/", ano, "/rds"),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer/", ano, "/shp"),
  "./pnb/dados/infra_cicloviaria/pnpb/buffer_entorno/",
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer_entorno/", ano),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer_entorno/", ano, "/geojson"),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer_entorno/", ano, "/rds"),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/buffer_entorno/", ano, "/shp"),
  "./pnb/dados/infra_cicloviaria/pnpb/geofabrik_filtrado/",
  paste0("./pnb/dados/infra_cicloviaria/pnpb/geofabrik_filtrado/", ano),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/geofabrik_filtrado/", ano, "/rds"),
  paste0("./pnb/dados/infra_cicloviaria/pnpb/geofabrik_filtrado/", ano, "/shp"),
  "./pnb/dados/infra_cicloviaria/pnpb/geofabrik_pontos/",
  paste0("./pnb/dados/infra_cicloviaria/pnpb/geofabrik_pontos/", ano),
  "otp/",
  paste0("otp/", ano),
  paste0("otp/", ano, "/graphs"),
  "./pnb/resultados/",
  "./pnb/resultados/pnb/",
  paste0("./pnb/resultados/pnb/", ano),
  paste0("./pnb/resultados/pnb/", ano, "/network"),
  paste0("./pnb/resultados/pnb/", ano, "/network/consolidado"),
  "./pnb/resultados/pnpb/",
  paste0("./pnb/resultados/pnpb/", ano),
  paste0("./pnb/resultados/pnpb/", ano, "/network"),
  paste0("./pnb/resultados/pnpb/", ano, "/network/consolidado"),
  "./pnb/infra_ciclo/",
  paste0("./pnb/infra_ciclo/",ano)
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
