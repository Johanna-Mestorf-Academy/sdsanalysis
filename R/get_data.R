#' get_single_artefact_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_single_artefact_data <- function(dataset_name) {
  dataset_url <- get_metadata(dataset_name, "single")
  dataset <- utils::read.csv(dataset_url, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_multi_artefact_data
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_multi_artefact_data <- function(dataset_name) {
  dataset_url <- get_metadata(dataset_name, "multi")
  dataset <- utils::read.csv(dataset_url, stringsAsFactors = FALSE, check.names = FALSE)
  return(dataset)
}

#' get_description
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_description <- function(dataset_name) {
  dataset_url <- get_metadata(dataset_name, "description")
  description <- readLines(dataset_url)
  return(description)
}

#' get_site
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_site <- function(dataset_name) {
  site <- get_metadata(dataset_name, "site")
  return(site)
}

#' lookup_data_positions
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_metadata <- function(dataset_name, type) {
  data_position <- get_dataset_metadata() 
  metdata_for_dataset <- data_position[data_position$id == dataset_name, ]
  if (nrow(metdata_for_dataset) == 0) {stop("No dataset with this name available.")}
  type_column <- switch(
    type,
    "description" = "url_description_file",
    "single" = "url_single_artefacts_file",
    "multi" = "url_multi_artefacts_file",
    "site" = "site"
  )
  info <- metdata_for_dataset[,type_column]
  if (is.na(info)) {stop(paste("No", type, "data available for dataset", dataset_name))}
  return(info)
}

#' get_type_options
#'
#' @param dataset_name Character. Name of an available dataset.
#'
#' @export
get_type_options <- function(dataset_name) {
  data_position <- get_dataset_metadata()
  metadata_for_dataset <- data_position[data_position$id == dataset_name, ]
  if (nrow(metadata_for_dataset) == 0) {stop("No dataset with this name available.")}
  types <- c("single_artefacts", "multi_artefacts")[!is.na(
    metadata_for_dataset[c("url_single_artefacts_file", "url_multi_artefacts_file")]
  )]
  return(types)
}

#' get_available_datasets
#'
#' @export
get_available_datasets <- function() {
  data_position <- get_dataset_metadata() 
  unique(data_position$id)
}

#' get_dataset_metadata
#' 
#' @export
get_dataset_metadata <- function() {
  pos <- "https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsanalysis/master/data-raw/dataset_metadata_list.csv"
  data_position <- utils::read.csv(pos, stringsAsFactors = FALSE, na.strings = "")
  return(data_position)
}
