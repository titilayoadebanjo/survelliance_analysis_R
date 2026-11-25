load_data <- function(filepath) {
  readr::read_csv(
    filepath,
    na = c("", "NULL"),
    show_col_types = FALSE
  )
}