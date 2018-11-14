#' get_single_artefact_data
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_single_artefact_data <- function(dataset_names) {
  dataset_urls <- get_metadata(dataset_names, "single_artefacts")
  dataset_list <- lapply(dataset_urls, function(x) {
    utils::read.csv(x, stringsAsFactors = FALSE, check.names = FALSE)
  })
  if (is.list(dataset_list) & length(dataset_list) == 1) {dataset_list <- dataset_list[[1]]}
  return(dataset_list)
}

#' get_multi_artefact_data
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_multi_artefact_data <- function(dataset_names) {
  dataset_urls <- get_metadata(dataset_names, "multi_artefacts")
  dataset_list <- lapply(dataset_urls, function(x) {
    utils::read.csv(x, stringsAsFactors = FALSE, check.names = FALSE)
  })
  if (is.list(dataset_list) & length(dataset_list) == 1) {dataset_list <- dataset_list[[1]]}
  return(dataset_list)
}

#' get_description
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_description <- function(dataset_names) {
  dataset_urls <- get_metadata(dataset_names, "description")
  dataset_list <- lapply(dataset_urls, function(x) {readLines(x)})
  if (is.list(dataset_list) & length(dataset_list) == 1) {dataset_list <- dataset_list[[1]]}
  return(dataset_list)
}

#' get_site
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_site <- function(dataset_names) {
  site <- get_metadata(dataset_names, "site")
  return(site)
}

#' get_coords
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_coords <- function(dataset_names) {
  coords <- get_metadata(dataset_names, "coords")
  return(coords)
}

#' get_dating
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_dating <- function(dataset_names) {
  dating <- get_metadata(dataset_names, "dating")
  return(dating)
}

#' get_type_options
#'
#' @param dataset_names Character vector. Names of available datasets.
#'
#' @export
get_type_options <- function(dataset_names) {
  types_list <- lapply(dataset_names, get_type_options_one)
  if (length(types_list) == 1) {types_list <- unlist(types_list)}
  return(types_list)
}

# get_type_options_one
get_type_options_one <- function(dataset_name) {
  data_position <- get_dataset_metadata()
  metadata_for_dataset <- data_position[data_position$id == dataset_name, ]
  if (nrow(metadata_for_dataset) == 0) {stop(paste("No dataset with this name available:", dataset_name))}
  types <- c("single_artefacts", "multi_artefacts")[!is.na(
    metadata_for_dataset[c("url_single_artefacts_file", "url_multi_artefacts_file")]
  )]
  return(types)
}

# get_metadata
get_metadata <- function(dataset_names, types) {
  data_list <- purrr::map2(dataset_names, types, get_metadata_one)
  if (length(data_list) == 1 | all(sapply(data_list, is.character))) {data_list <- unlist(data_list)}
  if (all(sapply(data_list, is.data.frame))) {data_list <- do.call(rbind, data_list)}
  return(data_list)
}

# get_metadata_one
get_metadata_one <- function(dataset_name, type) {
  data_position <- get_dataset_metadata() 
  metdata_for_dataset <- data_position[data_position$id == dataset_name, ]
  if (nrow(metdata_for_dataset) == 0) {stop(paste("No dataset with this name available:", dataset_name))}
  type_column <- switch(
    type,
    "description" = "url_description_file",
    "single_artefacts" = "url_single_artefacts_file",
    "multi_artefacts" = "url_multi_artefacts_file",
    "site" = "site",
    "coords" = c("lat", "lon"),
    "dating" = "dating"
  )
  info <- metdata_for_dataset[,type_column]
  if (any(is.na(info))) {stop(paste("No", type, "data available for dataset", dataset_name))}
  return(info)
}

#' get_available_datasets
#'
#' @export
get_available_datasets <- function() {
  data_position <- get_dataset_metadata() 
  unique(data_position$id)
}

# get_dataset_metadata
get_dataset_metadata <- function() {
  pos <- "https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsanalysis/master/data-raw/dataset_metadata_list.csv"
  data_position <- utils::read.csv(pos, stringsAsFactors = FALSE, na.strings = "")
  return(data_position)
}
