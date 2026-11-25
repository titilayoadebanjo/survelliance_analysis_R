disease_summary <- function(df) {
  df |>
    dplyr::count(Disease, name = "Cases") |>
    dplyr::arrange(dplyr::desc(Cases))
}


regional_summary <- function(df) {
  df |>
    dplyr::count(Region, name = "Cases") |>
    dplyr::arrange(dplyr::desc(Cases))
}


outbreak_summary <- function(df) {
  df |>
    dplyr::filter(!is.na(OutbreakRef)) |>
    dplyr::count(OutbreakRef, name = "Cases") |>
    dplyr::arrange(dplyr::desc(Cases))
}