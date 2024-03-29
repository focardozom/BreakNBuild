% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/progressive_splits.R
\name{progressive_splits}
\alias{progressive_splits}
\title{Progressive Split of Dataset for Model Evaluation}
\usage{
progressive_splits(data, assessment_size = 0, start_size = 2)
}
\arguments{
\item{data}{A data frame containing the dataset to be split.}

\item{assessment_size}{A numeric value between 0 and 1 indicating the proportion
of the dataset to be used as the validation set. Default is 0.2.}

\item{start_size}{An integer indicating the initial size of the training set.
Must be at least 1 and less than the number of rows in the dataset minus
the size of the validation set. Default is 2.}
}
\value{
An object of class 'rset' containing the training and validation splits
for each iteration of increasing training set size.
}
\description{
Dynamically partitions a dataset into training and validation subsets,
allowing for evaluation of machine learning model performance across
varying sample sizes.
}
\examples{
# Example usage:
data(iris)
splits <- progressive_splits(iris, assessment_size = 0.2, start_size = 10)

}
\seealso{
\link[rsample]{vfold_cv} for details on the underlying cross-validation method.
}
