#' Augment Analysis Data from Resampling Results
#'
#' This function fits a model to resampled datasets, preprocesses the analysis data, and then augments it.
#'
#' @param model A machine learning model object, compatible with `tune::fit_resamples`.
#' @param splits Resampling splits object, usually created using the `rsample` package.
#'
#' @return A tibble containing augmented data from the analysis portion of the resampling splits.
#' @export
#'
#' @examples
#' \dontrun{
#'   # Assuming 'model' is a predefined model object and 'splits' is defined
#'   analysis_data <- get_validation_augment(model, splits)
#' }
get_validation_augment <- function(model, splits) {

    rec <- extrac_prep(model)

    model |>
      tune::fit_resamples(splits,
                          control = tune::control_resamples(
                            extract = workflows::extract_fit_parsnip)) |>
      tidyr::unnest(.data$.extracts) |>
      dplyr::mutate(data = purrr::map(splits, rsample::assessment)) |>
      dplyr::mutate(data_preprocessed = purrr::map(.data$data, apply_rec, rec))  |>
      dplyr::mutate(data_augmented = purrr::map2(.data$.extracts, .data$data_preprocessed, broom::augment)) |>
      select(.data$id, .data$data_augmented)    |>
      unnest(.data$data_augmented)

}
