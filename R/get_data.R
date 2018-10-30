#' get_single_artefact_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_single_artefact_data <- function(dataset_name) {
  data_position <- lookup_data_positions(dataset_name)
  dataset_url <- data_position$url[data_position$type == "single_artefacts"]
  if (length(dataset_url) == 0) {stop("No single artefact dataset ", dataset_name, " available.")}
  dataset <- utils::read.csv(dataset_url, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_multi_artefact_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_multi_artefact_data <- function(dataset_name) {
  data_position <- lookup_data_positions(dataset_name)
  dataset_url <- data_position$url[data_position$type == "multi_artefacts"]
  if (length(dataset_url) == 0) {stop("No multi artefact dataset ", dataset_name, " available.")}
  dataset <- utils::read.csv(dataset_url, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_description
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_description <- function(dataset_name) {
  data_position <- lookup_data_positions(dataset_name)
  dataset_url <- data_position$url[data_position$type == "description"]
  if (length(dataset_url) == 0) {stop("No description for dataset ", dataset_name, " available.")}
  description <- readLines(dataset_url)
  return(description)
}

#' lookup_data_positions
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
lookup_data_positions <- function(dataset_name) {
  data_position <- get_data_positions() 
  data_position_for_dataset <- data_position[data_position$dataset == dataset_name, ]
  if (nrow(data_position_for_dataset) == 0) {stop("No dataset with this name available.")}
  return(data_position_for_dataset)
}

#' get_available_datasets
#'
#' @export
get_available_datasets <- function() {
  data_position <- get_data_positions() 
  unique(data_position$dataset)
}

#' get_data_positions
#' 
#' @export
get_data_positions <- function() {
  pos <- "https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsanalysis/master/data-raw/data_position_list.csv"
  data_position <- utils::read.csv(pos, stringsAsFactors = FALSE)
  return(data_position)
}
