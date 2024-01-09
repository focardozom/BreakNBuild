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
#'   validation_data <- get_analysis_augment(model, splits)
#' }
#'

get_analysis_augment <- function(model, splits) {

  rec <- extrac_prep(model)

  model |>
    tune::fit_resamples(splits,
                        control = tune::control_resamples(
                          extract = workflows::extract_fit_parsnip)) |>
    tidyr::unnest(.data$.extracts) |>
    dplyr::mutate(data = purrr::map(splits, rsample::analysis)) |>
    dplyr::mutate(data_preprocessed = purrr::map(.data$data, apply_rec, rec))  |>
    dplyr::mutate(data_augmented = purrr::map2(.data$.extracts, .data$data_preprocessed, broom::augment)) |>
    select(.data$id, .data$data_augmented)    |>
    unnest(.data$data_augmented)

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

#' Extract and Prepare Preprocessor from Model
#'
#' Extracts the preprocessor from a model and applies it to the provided data.
#'
#' @param model A model object, typically a workflow or recipe.
#' @param x A dataset to be preprocessed.
#'
#' @return A preprocessed dataset, where the preprocessing steps defined in the model are applied to `x`.
#' @export
#'
#' @examples
#' \dontrun{
#'   # Assuming 'model' is a predefined model object and 'data' is available
#'   preprocessed_data <- extrac_prep(model, data)
#' }

extrac_prep  <- function(model, x){
  model  |> tune::extract_preprocessor()
}

#' Apply Preprocessing Recipe
#'
#' Preprocesses a dataset using a specified recipe.
#'
#' @param x A dataset to be preprocessed.
#' @param rec A `recipe` object specifying the preprocessing steps.
#'
#' @return A preprocessed dataset based on the provided recipe.
#' @export
#'
#' @examples
#' \dontrun{
#'   # Assuming 'rec' is a predefined recipe object and 'data' is available
#'   preprocessed_data <- apply_rec(data, rec)
#' }
apply_rec <- function(x, rec) {

    rec |>
      recipes::prep(x)  |> recipes::bake(new_data=NULL)

}





