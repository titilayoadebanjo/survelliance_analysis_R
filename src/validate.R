validate_missing_values <- function(df) {
  missing_counts <- colSums(is.na(df))

  missing_counts <- missing_counts[missing_counts > 0]

  paste0(
    names(missing_counts),
    ": ",
    missing_counts,
    " missing values"
  )
}


validate_duplicates <- function(df) {
  duplicate_count <- sum(duplicated(df))

  if (duplicate_count > 0) {
    c(paste0(duplicate_count, " duplicate records found"))
  } else {
    character(0)
  }
}


validate_age <- function(df) {
  invalid_ages <- sum(
    !is.na(df$Age) &
      (df$Age > 120 | df$Age < 0)
  )

  if (invalid_ages > 0) {
    c(paste0(invalid_ages, " invalid age records"))
  } else {
    character(0)
  }
}


validate_dates <- function(df) {
  date_issues <- sum(
    !is.na(df$SampleDate) &
      !is.na(df$ReportDate) &
      df$SampleDate > df$ReportDate
  )

  if (date_issues > 0) {
    c(paste0(date_issues, " date anomalies detected"))
  } else {
    character(0)
  }
}