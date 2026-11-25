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

source(file.path(project_root, "src", "analysis.R"))

assert_equal <- function(actual, expected) {
  if (!identical(as.data.frame(actual), expected)) {
    stop(
      "Assertion failed.\nActual:\n",
      paste(capture.output(print(actual)), collapse = "\n"),
      "\nExpected:\n",
      paste(capture.output(print(expected)), collapse = "\n")
    )
  }
}

df <- data.frame(
  Disease = c("Measles", "Measles", "Flu"),
  Region = c("North", "North", "South"),
  OutbreakRef = c("OB001", "OB001", NA),
  stringsAsFactors = FALSE
)

assert_equal(
  disease_summary(df),
  data.frame(
    Disease = c("Measles", "Flu"),
    Cases = c(2L, 1L),
    stringsAsFactors = FALSE
  )
)

assert_equal(
  regional_summary(df),
  data.frame(
    Region = c("North", "South"),
    Cases = c(2L, 1L),
    stringsAsFactors = FALSE
  )
)

assert_equal(
  outbreak_summary(df),
  data.frame(
    OutbreakRef = "OB001",
    Cases = 2L,
    stringsAsFactors = FALSE
  )
)
