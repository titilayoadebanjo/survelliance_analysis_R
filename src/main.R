required_packages <- c(
  "readr",
  "dplyr",
  "lubridate",
  "yaml"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Missing R packages: ",
    paste(missing_packages, collapse = ", "),
    ". Install them with:\n",
    "install.packages(c(",
    paste0(
      "\"",
      missing_packages,
      "\"",
      collapse = ", "
    ),
    "))"
  )
}

script_arguments <- commandArgs(trailingOnly = FALSE)
file_argument <- script_arguments[
  startsWith(script_arguments, "--file=")
]

if (length(file_argument) > 0) {
  script_file <- sub("^--file=", "", file_argument[[1]])
  script_directory <- dirname(normalizePath(script_file, winslash = "/"))
  base_directory <- normalizePath(
    file.path(script_directory, ".."),
    winslash = "/"
  )
} else {
  base_directory <- normalizePath(getwd(), winslash = "/")
}

source(file.path(base_directory, "src", "extract.R"))
source(file.path(base_directory, "src", "validate.R"))
source(file.path(base_directory, "src", "transform.R"))
source(file.path(base_directory, "src", "analysis.R"))
source(file.path(base_directory, "src", "reporting.R"))

config_file <- file.path(base_directory, "config", "config.yaml")
config <- yaml::read_yaml(config_file)

data_file <- file.path(
  base_directory,
  config$dataset$source
)

cat("Pipeline started\n")

df <- load_data(data_file)
cat(nrow(df), "records loaded\n")

df <- create_reporting_delay(df)

quality_issues <- c(
  validate_missing_values(df),
  validate_duplicates(df),
  validate_age(df),
  validate_dates(df)
)

df <- create_flags(df)

disease <- disease_summary(df)
region <- regional_summary(df)
outbreaks <- outbreak_summary(df)

validation_file <- file.path(
  base_directory,
  config$output$validation_report
)

disease_file <- file.path(
  base_directory,
  config$output$disease_summary
)

region_file <- file.path(
  base_directory,
  config$output$regional_summary
)

outbreak_file <- file.path(
  base_directory,
  config$output$outbreak_summary
)

write_validation_report(
  quality_issues,
  validation_file
)

write_summary_report(
  disease,
  region,
  outbreaks,
  disease_file,
  region_file,
  outbreak_file
)

cat("Pipeline completed successfully\n")