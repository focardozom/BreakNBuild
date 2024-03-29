#' Calculate Training Error for Machine Learning Models
#'
#' Computes the training error for a given machine learning model using resampled datasets.
#' This function is designed to fit the model to each split of the data, predict outcomes,
#' and calculate a performance metric (e.g., R-squared) for each resample.
#'
#' @param model A machine learning model object compatible with the `fit_resamples` method.
#' @param splits An object containing data splits, typically generated by functions from the
#'        `rsample` package, used for resampling.
#' @param metric The performance metric of interest as a string.
#'
#' @return A data frame containing the performance metric (R-squared by default) for each resample
#'         and an identification of the error type as "Training".
#'
#' @examples
#' \dontrun{
#' library(tidymodels) # assuming tidymodels includes necessary packages
#' data(iris)
#' model <- linear_reg() |> set_engine("lm")
#' splits <- initial_split(iris, prop = 0.75)
#' training_error <- get_training_error(model, splits)
#' }
#'
#' @export
#' @importFrom purrr map map2
#' @importFrom dplyr mutate select
#' @importFrom tidyr unnest
#' @importFrom tune fit_resamples
#' @importFrom tune control_resamples
#' @importFrom broom augment
#' @importFrom yardstick rsq
#' @importFrom rsample analysis
#' @importFrom tidyselect everything
#'
#' @seealso \link[tune]{fit_resamples}, \link[dplyr]{mutate}

get_training_error <- function(model, splits, metric) {
  if (!is.character(metric)) {
    stop("Error: 'metric' must be a string.")
  }

  outcome <- tune::outcome_names(model)
  metric_expr <- parse(text = paste0("yardstick::", metric))
  rec <- extrac_prep(model)

  model |>
    tune::fit_resamples(splits,
      control = tune::control_resamples(extract = extract_fit)
    ) |>
    tidyr::unnest(.data$.extracts) |>
    dplyr::mutate(data = purrr::map(splits, rsample::analysis)) |>
    dplyr::mutate(data_preprocessed = purrr::map(.data$data, apply_rec, rec)) |>
    dplyr::mutate(predict = purrr::map2(.data$.extracts, .data$data, broom::augment)) |>
    dplyr::mutate(compute_metric = purrr::map(.data$predict, eval(metric_expr), "truth" = outcome, "estimate" = .data$.pred)) |>
    unnest(.data$compute_metric) |>
    select(.data$id, .data$.estimate) |>
    dplyr::mutate(error = "Training")
}

#' Extract Fit Parameters from a Resampled Model
#'
#' This function simplifies the process of extracting fit parameters from a model object
#' created using the `parsnip` package. It is particularly useful in scenarios where
#' model objects are embedded within resampled results.
#'
#' @param x A model object, typically resulting from a resampling process
#'          (e.g., using `fit_resamples` from the `rsample` package).
#'
#' @return Returns the extracted fit parameters from the provided model object.
#'
#' @examples
#' \dontrun{
#' data(iris)
#' model <- linear_reg() |> set_engine("lm")
#' resamples <- vfold_cv(iris)
#' fit_results <- model |> fit_resamples(resamples)
#' extracted_params <- extract_fit(fit_results)
#' }

#'
#' @export
#' @importFrom tune extract_fit_parsnip
#'
#' @seealso \link[tune]{extract_fit_parsnip}
extract_fit <- function(x) {
  x |>
    tune::extract_fit_parsnip()
}
