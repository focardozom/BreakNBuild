<!-- badges: start -->
[![R-CMD-check](https://github.com/focardozom/BreakNBuild/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/focardozom/BreakNBuild/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


# BreakNBuild: Optimize Machine Learning Models with Dynamic Data Splits <a href="https://focardozom.github.io/DocumentData/"><img src="man/figures/logo.png" align="right" height="138" alt="DocumentData website" /></a>

## Overview
`BreakNBuild` is designed to evaluate model performance through progressively sampled training data. It offers a structured way to analyze how a model’s accuracy, error, or other metrics evolve as the amount of data increases. This iterative sampling approach is particularly useful for identifying bias-variance trade-offs, diagnosing overfitting or underfitting, and understanding how much data is needed to achieve optimal model performance. With BreakNBuild, users can visualize learning curves, helping to fine-tune algorithms, assess generalization, and debug machine learning models efficiently.

## Features
- **Progressive Data Splitting**: partition your dataset into training and validation subsets.
- **Customizable Sample Sizes**: Control the size of your training data to understand model performance under different conditions.
- **Easy Integration**: Built on the `rsample` package, `BreakNBuild` seamlessly integrates with the `tidymodels` framework.

![man/figures/schema_progressive_split.svg]

## Installation
To install the latest version from GitHub, use:

```r
# install.packages("devtools")
devtools::install_github("https://github.com/focardozom/BreakNBuild")
```

## Usage

Here's a quick example to get you started:

```r
library(BreakNBuild)

splits <- progressive_splits(data, validation_size = 0.2, start_size = 10)

```

This will create a splits object that you can use to train your model using the `tidymodels` ecosystem for Machine Learning. 

For more details on how to use the `BreakNBuild` package, please refer to the [package vignette](https://focardozom.github.io/BreakNBuild/articles/BreakNBuild.html).