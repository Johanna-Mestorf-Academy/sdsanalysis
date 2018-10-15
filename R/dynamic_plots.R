#' dynamic_plot
#'
#' @param inputdata test
#' @param var1 test
#' @param var2 test
#'
#' @return ggplot object.
#' 
#' @export
dynamic_plot <- function(inputdata, var1, var2) {
  
  ggplot2::ggplot(inputdata) +
    ggplot2::geom_point(
      ggplot2::aes_string(
        x = var1,
        y = var2
      )
    )
    
}

