#' get_single_artefact_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_single_artefact_data <- function(dataset_name) {
  dataset_position_table <- lookup_data_positions(dataset_name)
  dataset_url <- dataset_position_table$url[data_position$type == "single_artefacts"]
  dataset <- utils::read.csv(dataset_url, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_multi_artefact_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_multi_artefact_data <- function(dataset_name) {
  dataset_position_table <- lookup_data_positions(dataset_name)
  dataset_url <- dataset_position_table$url[data_position$type == "multi_artefacts"]
  dataset <- utils::read.csv(dataset_url, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_description
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_description <- function(dataset_name) {
  dataset_position_table <- lookup_data_positions(dataset_name)
  dataset_description_url <- dataset_position_table$url[data_position$type == "description"]
  description <- readLines(dataset_description_url)
  return(description)
}

#' lookup_data_positions
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
lookup_data_positions <- function(dataset_name) {
  data_position <- get_data_position_list() 
  data_position[data_position$dataset == dataset_name, ]
}

#' get_available_datasets
#'
#' @export
get_available_datasets <- function() {
  data_position <- get_data_position_list() 
  unique(data_position$dataset)
}

#' get_data_position_list
#' 
#' @export
get_data_position_list <- function(
  pos = "https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsanalysis/master/data-raw/data_position_list.csv"
) {
  data_position <- utils::read.csv("data-raw/data_position_list.csv", stringsAsFactors = FALSE)
  return(data_position)
}
