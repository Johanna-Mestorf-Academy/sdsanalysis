#' get_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_data <- function(dataset_name) {
  dataset_position_table <- lookup_data_positions(dataset_name)
  dataset_fb_urls <- dataset_position_table$url[data_position$fb != "description"]
  # to primitive: has to be adjusted to cover data composed of multiple fbs
  dataset <- utils::read.csv(dataset_fb_urls, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_description
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_description <- function(dataset_name) {
  dataset_position_table <- lookup_data_positions(dataset_name)
  dataset_description_url <- dataset_position_table$url[data_position$fb == "description"]
  description <- readLines(dataset_description_url)
  return(description)
}

#' lookup_data_positions
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
lookup_data_positions <- function(dataset_name) {
  data_position[data_position$dataset == dataset_name, ]
}

#' get_available_datasets
#'
#' @export
get_available_datasets <- function() {
  unique(data_position$dataset)
}
