library(testthat)
library(tibble)

test_that("progressive_splits with 0%  validation works", {
  df <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
  test_zero_val <- progressive_splits(df, 0, 1)
  assessment_size <- 0

  # Verify the number of rows
  expect_equal(nrow(test_zero_val), length(df$x)*(1-assessment_size))

  # Check the content of the id column
  expected_ids <- paste("Split", 1:10)
  expect_equal(test_zero_val$id, expected_ids)

  # Check each split's content
  for (i in 1:10) {
    split_data <- test_zero_val$splits[[i]][[2]]
    expect_equal(split_data, 1:i)

    split_test_value <- test_zero_val$splits[[i]][[3]]
    expect_equal(split_test_value, integer(0))
  }

  original_values <- df$x

  for (i in 1:10) {
    split_data <- test_zero_val$splits[[i]][[2]]

    # Verify split data is within original dataset values
    unexpected_values <- setdiff(split_data, original_values)
    expect_true(length(unexpected_values) == 0)
  }
})

test_that("progressive_splits with 10% validation works", {
  df <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
  assessment_size <- 0.1
  test <- progressive_splits(df, 0.1, 1)

  # Verify the output is a tibble
  expect_true(tibble::is_tibble(test))

  # Check for expected columns
  expect_true(all(c("splits", "id") %in% names(test)))

  # Verify the number of rows
  expect_equal(nrow(test), length(df$x)*(1-assessment_size))

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

test_that("progressive_splits with 50% validation works", {
  df <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
  assessment_size <- 0.5
  start_number <- 1
  len_splits <- length(df$x)*(1-assessment_size)
  test_five_val <- progressive_splits(df, assessment_size, start_number)

  # Verify the number of rows
  expect_equal(nrow(test_five_val), len_splits)

  # Check the content of the id column
  expected_ids <- paste("Split", 1:5)
  expect_equal(test_five_val$id, expected_ids)

  # Check each split's content
  for (i in 1:5) {
    split_data <- test_five_val$splits[[i]][[2]]
    expect_equal(split_data, 1:i)

    split_test_value <- test_five_val$splits[[i]][[3]]
    expect_equal(split_test_value, c(6,7,8,9,10))
  }

  original_values <- df$x

  for (i in 1:5) {
    split_data <- test_five_val$splits[[i]][[2]]

    # Verify split data is within original dataset values
    unexpected_values <- setdiff(split_data, original_values)
    expect_true(length(unexpected_values) == 0)
  }
})

test_that("progressive_splits with 90% validation works", {
  df <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
  assessment_size <- 0.9
  len_splits <- length(df$x)*(1-assessment_size)
  start_number <- 1

  test_nine_val <- progressive_splits(df, assessment_size, start_number)

  # Verify the number of rows
  expect_equal(nrow(test_nine_val), len_splits)

  # Check the content of the id column
  expected_ids <- paste("Split", 1)
  expect_equal(test_nine_val$id, expected_ids)

  # Check each split's content
  for (i in 1:len_splits) {
    split_data <- test_nine_val$splits[[i]][[2]]
    expect_equal(split_data, 1:i)

    split_test_value <- test_nine_val$splits[[i]][[3]]
    expect_equal(split_test_value, c(2, 3, 4, 5, 6, 7, 8, 9, 10))
  }

  original_values <- df$x

  for (i in 1:len_splits) {
    split_data <- test_nine_val$splits[[i]][[2]]

    # Verify split data is within original dataset values
    unexpected_values <- setdiff(split_data, original_values)
    expect_true(length(unexpected_values) == 0)
  }

})

test_that("progressive_splits with 100% validation works", {
  df <- data.frame(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
  assessment_size <- 1
  start_number <- 1
  expect_error(progressive_splits(df, assessment_size, start_number))
})

test_that("data 'is' data", {
  df <- data.frame(x = c(1))
  assessment_size <- 1
  start_number <- 1
  expect_error(progressive_splits(df, assessment_size, start_number))
})
