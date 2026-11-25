write_validation_report <- function(issues, output_file) {
  output_directory <- dirname(output_file)

  if (!dir.exists(output_directory)) {
    dir.create(output_directory, recursive = TRUE)
  }

  lines <- c(
    "SURVEILLANCE VALIDATION REPORT",
    paste0(rep("=", 40), collapse = ""),
    issues
  )

  writeLines(lines, output_file)
}


write_summary_report <- function(
    disease,
    region,
    outbreak,
    disease_file,
    region_file,
    outbreak_file
) {
  readr::write_csv(disease, disease_file)
  readr::write_csv(region, region_file)
  readr::write_csv(outbreak, outbreak_file)
}