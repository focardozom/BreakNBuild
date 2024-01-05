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
#' splits <- progressive_split(iris, validation_size = 0.2, start_size = 10)
#'
#' @export
#' @importFrom rsample vfold_cv
#'
#' @seealso \link[rsample]{vfold_cv} for details on the underlying cross-validation method.

progressive_split <- function(data, validation_size = 0.2, start_size = 2) {
  n <- nrow(data)

  if (n < 2) {
    stop("Data must have at least two rows", call. = FALSE)
  }

  # Calculate the size of the validation set
  validation_n <- max(0, floor(n * validation_size))
  training_max_n <- n - validation_n

  if (start_size < 1 || start_size > training_max_n) {
    stop("start_size must be at least 1 and less than or equal to the number of rows in the training set", call. = FALSE)
  }

  if (training_max_n < start_size) {
    stop("Not enough data for training after allocating validation set", call. = FALSE)
  }

  # Create an initial 'rset' object with enough splits
  num_initial_splits <- training_max_n - start_size + 1
  initial_splits <- rsample::vfold_cv(data, v = num_initial_splits)

  # Define a fixed range for the validation set
  validation_range <- (n - validation_n + 1):n

  # Modify the splits
  custom_splits <- lapply(start_size:training_max_n, function(i) {
    analysis <- 1:i
    split_idx <- i - start_size + 1
    out <- initial_splits$splits[[split_idx]]
    out$in_id <- analysis
    out$out_id <- validation_range
    out
  })

  # Update the 'rset' object
  initial_splits$splits <- custom_splits
  initial_splits
}

