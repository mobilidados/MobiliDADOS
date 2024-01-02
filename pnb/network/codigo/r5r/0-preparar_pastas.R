ano <- 2022
caminho <- "./pnb/network/"

folders <- c(
  "dados", 
  "codigo", 
  paste0("dados/infra_cicloviaria"),
  paste0("dados/infra_cicloviaria/buffer"),
  paste0("dados/infra_cicloviaria/buffer/", ano),
  paste0("dados/infra_cicloviaria/buffer/", ano, "/rds"),
  paste0("dados/infra_cicloviaria/buffer/", ano, "/shp"),
  paste0("dados/infra_cicloviaria/buffer_entorno"),
  paste0("dados/infra_cicloviaria/buffer_entorno/", ano),
  paste0("dados/infra_cicloviaria/buffer_entorno/", ano, "/geojson"),
  paste0("dados/infra_cicloviaria/buffer_entorno/", ano, "/rds"),
  paste0("dados/infra_cicloviaria/buffer_entorno/", ano, "/shp"),
  paste0("dados/infra_cicloviaria/geofabrik_filtrado"),
  paste0("dados/infra_cicloviaria/geofabrik_filtrado/", ano),
  paste0("dados/infra_cicloviaria/geofabrik_filtrado/", ano, "/rds"),
  paste0("dados/infra_cicloviaria/geofabrik_filtrado/", ano, "/shp"),
  paste0("dados/infra_cicloviaria/geofabrik_pontos"),
  paste0("dados/infra_cicloviaria/geofabrik_pontos/", ano),
  "otp",
  paste0("otp/", ano),
  paste0("otp/", "programs"),
  paste0("otp/", ano, "/graphs"),
  "resultados",
  paste0("resultados/", ano),
  paste0("resultados/", ano, "/network"),
  paste0("resultados/", ano, "/network/consolidado")
)

for (folder in folders) {
  if (!file.exists(paste0(caminho, folder))) {
    dir.create(paste0(caminho, folder))
  }
}
