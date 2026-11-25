create_reporting_delay <- function(df) {
  df$SampleDate <- lubridate::dmy(
    df$SampleDate,
    quiet = TRUE,
    tz = "UTC"
  )

  df$ReportDate <- lubridate::dmy(
    df$ReportDate,
    quiet = TRUE,
    tz = "UTC"
  )

  df$ReportingDelay <- as.numeric(
    difftime(
      df$ReportDate,
      df$SampleDate,
      units = "days"
    )
  )

  df
}


create_flags <- function(df) {
  df$AgeIssue <- !is.na(df$Age) &
    (df$Age > 120 | df$Age < 0)

  df$DelayIssue <- !is.na(df$ReportingDelay) &
    df$ReportingDelay > 14

  df
}