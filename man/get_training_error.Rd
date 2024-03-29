% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_training_error.R
\name{get_training_error}
\alias{get_training_error}
\title{Calculate Training Error for Machine Learning Models}
\usage{
get_training_error(model, splits, metric)
}
\arguments{
\item{model}{A machine learning model object compatible with the \code{fit_resamples} method.}

\item{splits}{An object containing data splits, typically generated by functions from the
\code{rsample} package, used for resampling.}

\item{metric}{The performance metric of interest as a string.}
}
\value{
A data frame containing the performance metric (R-squared by default) for each resample
and an identification of the error type as "Training".
}
\description{
Computes the training error for a given machine learning model using resampled datasets.
This function is designed to fit the model to each split of the data, predict outcomes,
and calculate a performance metric (e.g., R-squared) for each resample.
}
\examples{
\dontrun{
library(tidymodels) # assuming tidymodels includes necessary packages
data(iris)
model <- linear_reg() |> set_engine("lm")
splits <- initial_split(iris, prop = 0.75)
training_error <- get_training_error(model, splits)
}

}
\seealso{
\link[tune]{fit_resamples}, \link[dplyr]{mutate}
}
