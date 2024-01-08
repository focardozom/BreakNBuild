#' Extract Validation Data and Augmented Predictions
#'
#' Performs resampling on a model and extracts validation data and augmented predictions.
#'
#' @param model A machine learning model object, compatible with `tune::fit_resamples`.
#' @param splits Resampling splits object, usually created using the `rsample` package.
#'
#' @return A tibble containing augmented prediction data from the validation set.
#' @export
#'
#' @examples
#' \dontrun{
#'   # Assuming 'model' and 'splits' are predefined
#'   validation_data <- get_validation_augment(model, splits)
#' }

get_validation_augment <- function(model, splits) {
  model |>
    tune::fit_resamples(splits,
                        control = tune::control_resamples(extract = extract_fit)) |>
    dplyr::mutate(data = purrr::map(splits, rsample::assessment)) |>
    tidyr::unnest(.data$.extracts) |>
    dplyr::mutate(augmented = purrr::map2(.data$.extracts, .data$data, broom::augment))
}

#' Extract Fitted Model Object from Resampling
#'
#' Extracts the fitted model object from each resample.
#'
#' @param x A resample result object.
#'
#' @return A list of extracted fitted model objects.
#' @export
#'
#' @examples
#' \dontrun{
#'   # Assuming 'resample_result' is predefined
#'   fitted_models <- extract_fit(resample_result)
#' }
extract_fit <- function(x) {
  x |>
    tune::extract_fit_parsnip()
}





