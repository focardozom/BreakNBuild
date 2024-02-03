library(testthat)
library(tibble)

test_that("progressive_splits works", {
  df <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
  test <- progressive_splits(df, 0.1, 1)

  # Verify the output is a tibble
  expect_true(tibble::is_tibble(test), "The output should be a tibble.")

  # Check for expected columns
  expect_true(all(c("splits", "id") %in% names(test)), "The tibble does not have the expected columns.")

  # Verify the number of rows
  expect_equal(nrow(test), length(df$x) - 1)

  # Check the content of the id column
  expected_ids <- paste("Split", 1:9)
  expect_equal(test$id, expected_ids)

  # Check each split's content
  for (i in 1:9) {
    split_data <- test$splits[[i]][[2]]
    expect_equal(split_data, 1:i)

    split_test_value <- test$splits[[i]][[3]]
    expect_equal(split_test_value, 10)
  }

  original_values <- df$x

  for (i in 1:9) {
    split_data <- test$splits[[i]][[2]]

    # Verify split data is within original dataset values
    unexpected_values <- setdiff(split_data, original_values)
    expect_true(length(unexpected_values) == 0)
  }
})
