#' Create a Customized ggplot2 Theme
#'
#' This function generates a customized theme for ggplot2 plots.
#' It modifies elements such as legend position, axis text, and line colors.
#'
#' @return A `ggplot2::theme` object that can be added to ggplot2 plots.
#' @export
#' @examples
#' \dontrun{
#'   ggplot(data, aes(x, y)) +
#'   geom_line() +
#'   plot_theme()
#' }

plot_theme <- function() {
  ggplot2::theme(
    legend.position = "bottom",
    axis.text.x = ggplot2::element_text(angle = 90, size = 7),
    axis.line.x = ggplot2::element_line(color = "gray50", linewidth = .5),
    axis.line.y = ggplot2::element_line(color = "gray50", linewidth = .5),
    axis.title.y = ggtext::element_markdown(),
    axis.title.x = ggplot2::element_blank()  # Add x axis title element
  )
}


#' Generate a Plot from Validation and Training Results
#'
#' This function takes the results from model validation and training,
#' and creates a line plot comparing the two.
#'
#' @param validation_results A data frame of validation results.
#' @param training_results A data frame of training results.
#' @return A ggplot object representing the validation and training results.
#' @export
#' @importFrom ggplot2 ggplot aes geom_line scale_color_manual labs theme_classic
#' @importFrom rlang `:=`
#' @examples
#' \dontrun{
#'   # Assuming validation_results and training_results are available
#'   get_learning_curve(validation_results, training_results)
#' }

get_learning_curve <- function(validation_results, training_results) {
  rbind(validation_results, training_results) |>
    dplyr::mutate(id = stringr::str_extract(.data$id, "\\d+")) |>
    dplyr::mutate(id = as.numeric(.data$id)) |>
    ggplot2::ggplot(ggplot2::aes(x = .data$id, y = .data$.estimate, group = .data$error, color = .data$error)) +
    ggplot2::geom_line(color = "gray95", linewidth = 1.4) +
    ggplot2::geom_line() +
    ggplot2::scale_color_manual(values = c(Training = "#f47321", Validation = "#005030")) +
    ggplot2::labs(x = "",
                  caption = "X axis is Training Set Size",
                  y = "*R*<sup> 2</sup>",
                  color = "") +
    ggplot2::theme_classic() +
    plot_theme() +
    ggplot2::scale_y_continuous(limits = c(0, 1)) +
    ggplot2::scale_x_continuous(breaks = seq(0, 400, 10))
}



#' Create a Plot from Model Results
#'
#' This function takes a model and data splits, computes validation and training errors,
#' and then generates a plot to compare these errors.
#'
#' @param x A machine learning model object.
#' @param y An object containing data splits.
#' @return A ggplot object visualizing the validation and training errors.
#' @export
#' @importFrom dplyr mutate
#' @examples
#' \dontrun{
#'   # Assuming lm_model and data_splits are available
#'   create_plot(lm_model, data_splits)
#' }
#'
create_plot <- function(x,y){

  validation_error  <-  get_validation_error(x, y)
  training_error  <-  get_training_error(x, y)
  get_learning_curve(validation_error, training_error)
}
