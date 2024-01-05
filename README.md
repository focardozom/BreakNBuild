<!-- badges: start -->
[![R-CMD-check](https://github.com/focardozom/BreakNBuild/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/focardozom/BreakNBuild/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


# BreakNBuild: Optimize Machine Learning Models with Dynamic Data Splits <a href="https://focardozom.github.io/DocumentData/"><img src="man/figures/logo.png" align="right" height="138" alt="DocumentData website" /></a>

## Overview
`BreakNBuild` is an R package designed to evaluate model performance with progressively sampled data. This approach is particularly useful for debugging in machine learning, as it allows you to observe the bias-variance trade-off in relation to the sample size used for training the model.

## Features
- **Progressive Data Splitting**: Dynamically partition your dataset into training and validation subsets.
- **Customizable Sample Sizes**: Control the size of your training data to understand model performance under different conditions.
- **Easy Integration**: Built on the `rsample` package, `BreakNBuild` seamlessly integrates with the `tidymodels` framework.

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

splits <- progressive_split(data, validation_size = 0.2, start_size = 10)

```

