#' Progressive Split of Dataset for Model Evaluation
#'
#' Dynamically partitions a dataset into training and validation subsets,
#' allowing for evaluation of machine learning model performance across
#' varying sample sizes.
#'
#' @param data A data frame containing the dataset to be split.
#' @param validation_size A numeric value between 0 and 1 indicating the proportion
#'        of the dataset to be used as the validation set. Default is 0.2.
#' @param start_size An integer indicating the initial size of the training set.
#'        Must be at least 1 and less than the number of rows in the dataset minus
#'        the size of the validation set. Default is 2.
#'
#' @return An object of class 'rset' containing the training and validation splits
#'         for each iteration of increasing training set size.
#'
#' @examples
#' # Example usage:
#' data(iris)
#' splits <- progressive_splits(iris, validation_size = 0.2, start_size = 10)
#'
#' @export
#' @importFrom rsample vfold_cv
#'
#' @seealso \link[rsample]{vfold_cv} for details on the underlying cross-validation method.

progressive_splits <- function(data, validation_size = 0.2, start_size = 2) {
  n <- nrow(data)
  if (n < 2) stop("Data must have at least two rows", call. = FALSE)

  validation_n <- max(0, floor(n * validation_size))
  training_max_n <- n - validation_n

  if (start_size < 1 || start_size > training_max_n) {
    stop("start_size must be within the valid range for training data", call. = FALSE)
  }

  assessment <- (n - validation_n + 1):n
  indices <- lapply(start_size:training_max_n, function(i) {
    list(analysis = 1:i, assessment = assessment)
  })

  created_progressive_splits <- lapply(indices, rsample::make_splits, data = data)

  split_names <- paste0("Split ", seq_along(created_progressive_splits))

  progressive_splits <- rsample::manual_rset(created_progressive_splits, split_names)

  return(progressive_splits)
}


