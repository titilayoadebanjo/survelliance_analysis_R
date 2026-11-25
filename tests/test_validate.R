import pandas as pd

from validate import validate_duplicates


def test_validation_returns_list():

    df = pd.DataFrame(
        {
            "id": [1, 1]
        }
    )

    result = validate_duplicates(df)

    assert isinstance(result, list)
script_arguments <- commandArgs(trailingOnly = FALSE)
file_argument <- script_arguments[
  startsWith(script_arguments, "--file=")
]

if (length(file_argument) > 0) {
  test_directory <- dirname(normalizePath(
    sub("^--file=", "", file_argument[[1]]),
    winslash = "/"
  ))
  project_root <- normalizePath(
    file.path(test_directory, ".."),
    winslash = "/"
  )
} else {
  project_root <- normalizePath(getwd(), winslash = "/")
}

source(file.path(project_root, "src", "validate.R"))

assert_equal <- function(actual, expected) {
  if (!identical(actual, expected)) {
    stop(
      "Assertion failed.\nActual: ",
      paste(actual, collapse = ", "),
      "\nExpected: ",
      paste(expected, collapse = ", ")
    )
  }
}

# Missing values
missing_df <- data.frame(
  Age = c(20, NA),
  Disease = c("Measles", NA),
  stringsAsFactors = FALSE
)
assert_equal(
  validate_missing_values(missing_df),
  c("Age: 1 missing values", "Disease: 1 missing values")
)

# Duplicate records
duplicate_df <- data.frame(
  CaseID = c(1, 1, 2),
  stringsAsFactors = FALSE
)
assert_equal(
  validate_duplicates(duplicate_df),
  "1 duplicate records found"
)
assert_equal(
  validate_duplicates(duplicate_df[!duplicated(duplicate_df), , drop = FALSE]),
  character(0)
)

# Invalid ages
age_df <- data.frame(Age = c(-1, 0, 120, 121, NA))
assert_equal(
  validate_age(age_df),
  "2 invalid age records"
)

# Date anomalies
date_df <- data.frame(
  SampleDate = as.Date(c("2026-11-15", "2026-11-03", NA)),
  ReportDate = as.Date(c("2026-11-04", "2026-11-05", "2026-11-06"))
)
assert_equal(
  validate_dates(date_df),
  "1 date anomalies detected"
)

assert_equal(
  validate_dates(date_df[2, , drop = FALSE]),
  character(0)
)