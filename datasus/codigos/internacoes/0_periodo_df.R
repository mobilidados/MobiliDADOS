# Create a data frame to store the periods
periodo_df <- data.frame(
  output_vector = character(),
  output_year = character(),
  output_month = character()
)

# Loop through the desired periods
for (i in 8:24) {
  for (j in 1:12) {
    output <- sprintf("fibr%02d%02d.dbf", i, j)
    year <- sprintf("20%02d", i)
    month <- sprintf("%02d", j)
    periodo_df <- rbind(periodo_df, data.frame(output_vector = output,
                                               output_year = year,
                                               output_month = month))
  }
}

remove(output, year, month,i,j)
