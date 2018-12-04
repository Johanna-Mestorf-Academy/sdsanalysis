#' @name sdsdownload
#' 
#' @title sdsanalysis data download functions
#' 
#' @description 
#' sdsanalysis offers functions to access openly available SDS datasets. It contains a
#' \href{https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/dataset_metadata_list.csv}{reference table}
#' with information about data mostly collected by students and researchers at the 
#' Institute of Pre- and Protohistoric Archaeology at Kiel University. That data can be 
#' downloaded directly into R with sdsanalysis.
#' 
#' \itemize{
#'   \item{\code{\link{get_available_datasets}}: Get a list of datasets that can 
#'   be directly downloaded with sdsanalysis}
#'   \item{\code{\link{get_type_options}}: Get the types of data that are available 
#'   for one/multiple datasets (single - \emph{Einzelaufnahme}, multi - \emph{Sammelaufnahme})}
#'   \item{\code{\link{get_single_artefact_data}} / 
#'   \code{\link{get_multi_artefact_data}}: Download one/multiple datasets as a 
#'   dataframe/a list of dataframes}
#'   \item{\code{\link{get_description}}: Download description text of one/
#'   multiple datasets}
#'   \item{\code{\link{get_site}}: Get site names of one/multiple datasets}
#'   \item{\code{\link{get_coords}}: Get site coordinates of one/multiple datasets}
#'   \item{\code{\link{get_dating}}: Get period information of one/multiple datasets}
#'   \item{\code{\link{get_creator}}: Get author of one/multiple datasets}
#' }
#' 
#' @rdname sdsdownload
#' 
#' @param dataset_names Character vector. Names of available datasets.
#' 
NULL

#' @rdname sdsdownload
#' @export
get_single_artefact_data <- function(dataset_names) {
  dataset_urls <- get_metadata(dataset_names, "single_artefacts")
  dataset_list <- lapply(dataset_urls, function(x) {
    utils::read.csv(x, stringsAsFactors = FALSE, check.names = FALSE)
  })
  if (is.list(dataset_list) & length(dataset_list) == 1) {dataset_list <- dataset_list[[1]]}
  return(dataset_list)
}

#' @rdname sdsdownload
#' @export
get_multi_artefact_data <- function(dataset_names) {
  dataset_urls <- get_metadata(dataset_names, "multi_artefacts")
  dataset_list <- lapply(dataset_urls, function(x) {
    utils::read.csv(x, stringsAsFactors = FALSE, check.names = FALSE)
  })
  if (is.list(dataset_list) & length(dataset_list) == 1) {dataset_list <- dataset_list[[1]]}
  return(dataset_list)
}

#' @rdname sdsdownload
#' @export
get_description <- function(dataset_names) {
  dataset_urls <- get_metadata(dataset_names, "description")
  dataset_list <- lapply(dataset_urls, function(x) {readLines(x)})
  if (is.list(dataset_list) & length(dataset_list) == 1) {dataset_list <- dataset_list[[1]]}
  return(dataset_list)
}

#' @rdname sdsdownload
#' @export
get_site <- function(dataset_names) {
  site <- get_metadata(dataset_names, "site")
  return(site)
}

#' @rdname sdsdownload
#' @export
get_coords <- function(dataset_names) {
  coords <- get_metadata(dataset_names, "coords")
  return(coords)
}

#' @rdname sdsdownload
#' @export
get_dating <- function(dataset_names) {
  dating <- get_metadata(dataset_names, "dating")
  return(dating)
}

#' @rdname sdsdownload
#' @export
get_creator <- function(dataset_names) {
  creator <- get_metadata(dataset_names, "creator")
  return(creator)
}

#' @rdname sdsdownload
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
    "dating" = "dating",
    "creator" = "creator"
  )
  info <- metdata_for_dataset[,type_column]
  if (any(is.na(info))) {stop(paste("No", type, "data available for dataset", dataset_name))}
  return(info)
}

#' @rdname sdsdownload
#' @export
get_available_datasets <- function() {
  data_position <- get_dataset_metadata() 
  unique(data_position$id)
}

# get_dataset_metadata
get_dataset_metadata <- function(
  pos = "https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsanalysis/master/data-raw/dataset_metadata_list.csv"
) {
  dataset_metadata_directory <- file.path(tempdir(), "sdsanalysis_dataset_metadata")
  dataset_metadata_file <- file.path(dataset_metadata_directory, "dataset_metadata.RData")
  if (file.exists(dataset_metadata_file)) {
    load(dataset_metadata_file)
  } else {
    dir.create(dataset_metadata_directory)
    dataset_metadata <- utils::read.csv(pos, stringsAsFactors = FALSE, na.strings = "")
    save(dataset_metadata, file = dataset_metadata_file)
  }
  return(dataset_metadata)
}

#' @rdname sdsdownload
#' @export
get_all_sds_data_urls <- function() {
  all_datasets <- get_available_datasets()
  type_options <- get_type_options(all_datasets)
  res <- c()
  for (p1 in 1:length(all_datasets)) {
    type_options[[p1]] <- append(type_options[[p1]], "description")
    for (p2 in 1:length(type_options[[p1]])) {
      res <- append(res, get_metadata(all_datasets[p1], type_options[[p1]][p2]))
    }
  }
  return(res)
}

#' @rdname sdsdownload
#' @export
get_variables_list <- function() {
  return(variables)
}

#' @rdname sdsdownload
#' @export
get_variable_values_list <- function() {
  return(variable_values)
}
