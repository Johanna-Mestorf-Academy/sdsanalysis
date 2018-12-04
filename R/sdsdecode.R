#' @name sdsdecoding
#' 
#' @title sdsanalysis decoding functions
#' 
#' @description 
#' SDS traditionally provides a set of predefined values for each variable. 
#' That's not just convenience: It theoretically also allows for a high degree of 
#' comparability between different datasets. This predefined values/categories are 
#' encoded with a simple and minimalistic alphanumerical scheme. That's a 
#' technological rudiment both from the time when the systems that served SDS as 
#' an inspiration were created and when most stone tool analysis was made without 
#' a computer in reach.
#' 
#' The encoding has the big disadvantage that it's not immediately human readable.
#' If you try to understand an SDS dataset you're forced to constantly look up new 
#' variables in the SDS publications. That makes it very difficult to get a fast 
#' overview of an SDS dataset.
#' 
#' sdsanalysis offers functions to quickly decode the cryptic codes in the SDS 
#' tables and replace them with human readable descriptions. This is implemented 
#' with hash tables to enable high-speed transformation even for datasets with 
#' thousands of artefacts.
#' 
#' \itemize{
#'   \item{\code{\link{lookup_everything}}: Wizard function. Enter a SDS data.frame and 
#'   receive a decoded version}
#'   \item{\code{\link{lookup_vars}}: Get short variable names from IDs}
#'   \item{\code{\link{lookup_var_complete_names}}: Get long variable names from short 
#'   variable names}
#'   \item{\code{\link{lookup_var_types}}: Get variable data types from short variable 
#'   names}
#'   \item{\code{\link{apply_var_types}}: Get variable vector with correct data type from 
#'   variable vector with arbitrary data type}
#'   \item{\code{\link{lookup_attrs}}: Get decoded version of encoded variable vector}
#'   \item{\code{\link{lookup_attr_types}}: Get variable vector with semantic type from 
#'   variable vector}
#'   \item{\code{\link{apply_attr_types}}: Get variable vector with the correct values set 
#'   to NA based on the semantic type vector from variable vector}
#'   \item{\code{\link{lookup_IGerM_category}}: Get IGerM category or subcategory vector 
#'   from IGerM vector}
#' }
#' 
#' @rdname sdsdecoding
#' 
#' @param sds_df Dataframe. Data.frame in SDS standard format.
#' @param var_ids Character Vector. Variable IDs.
#' @param var_short_names Character Vector. Variable short names.
#' @param var_short_name Character. Variable short name.
#' @param var_data Vector. Variable data. 
#' @param igerm_data Character vector. IGerM character codes in data.
#' @param subcategory Boolean. Should the function return IGerM subcategories 
#' instead of categories?
#' 
NULL

#' @rdname sdsdecoding
#' @export
lookup_everything <- function(sds_df) {
  
  res <- sds_df
  
  # decode variable names
  names(res) <- sdsanalysis::lookup_vars(names(res))
  
  # replace NA attributes based on attribute type
  res <- purrr::map2_df(
    res, 
    names(res), 
    .f = sdsanalysis::apply_attr_types
  )
  
  # decode attributes
  res <- purrr::map2_df(
    res, 
    names(res), 
    .f = sdsanalysis::lookup_attrs
  )
  
  # fix variable types
  res <- purrr::map2_df(
    res, 
    names(res), 
    .f = sdsanalysis::apply_var_types
  )
  
  return(res)
  
}

#' @rdname sdsdecoding
#' @export
lookup_vars <- function(var_ids) {

  res <- var_ids 
  
  # check which variables can be looked up
  vars_in_hash <- var_ids %in% hash::keys(var_hash)
  
  # if none can be looked up than the input is returned
  if (!any(vars_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[vars_in_hash] <- hash::values(var_hash, var_ids[vars_in_hash])
  
  return(res)
}

#' @rdname sdsdecoding
#' @export
lookup_var_complete_names <- function(var_short_names) {

  var_complete_name <- var_short_names
    
  # check which variables can be looked up
  var_in_hash <- var_short_names %in% hash::keys(var_hash_complete_name)
  
  # lookup complete name for variable in hash
  var_complete_name[var_in_hash] <- hash::values(var_hash_complete_name, var_short_names[var_in_hash])
  
  return(unlist(var_complete_name))
}

#' @rdname sdsdecoding
#' @export
lookup_var_types <- function(var_short_names) {
  
  var_type <- rep(NA, length(var_short_names))
  
  # check which variables can be looked up
  var_in_hash <- var_short_names %in% hash::keys(var_hash_type)
  
  # lookup type for variable in hash
  var_type[var_in_hash] <- hash::values(var_hash_type, var_short_names[var_in_hash])
  
  return(unlist(var_type))
}

#' @rdname sdsdecoding
#' @export
apply_var_types <- function(var_data, var_short_name) {
  
  res <- var_data
  
  # lookup type for variable in hash
  var_type <- lookup_var_types(var_short_name)
  
  # get trans function
  var_trans_function <- string_to_as(var_type)
  
  # transform variable, if trans function is available
  if (!is.null(var_trans_function)) {
    res <- var_trans_function(res)
  }
  
  return(res)
}

# map type string to as.x function
string_to_as <- function(x) {
  switch(
    x,
    "integer" = as.numeric,
    "double" = as.numeric,
    "factor" = as.factor,
    "character" = as.character,
    NA
  )
}

#' @rdname sdsdecoding
#' @export
lookup_attrs <- function(var_data, var_short_name) {
  
  res <- var_data 
  
  # check if there is a hash for this variable
  if (!(var_short_name %in% hash::keys(attr_hash))) {
    return(res)
  }
  
  # get relevant hash for var_short_name
  var_hash <- hash::values(attr_hash, var_short_name)[[1]]
  
  # check which variables can be looked up
  attr_in_hash <- var_data %in% hash::keys(var_hash)
  
  # if none can be looked up than the input is returned
  if (!any(attr_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[attr_in_hash] <- hash::values(var_hash, var_data[attr_in_hash])
  
  return(res)
}

#' @rdname sdsdecoding
#' @export
lookup_attr_types <- function(var_data, var_short_name) {
  
  res <- var_data 
  
  # check if there is a hash for this variable
  if (!(var_short_name %in% hash::keys(attr_hash_type))) {
    return(res)
  }
  
  # get relevant hash for var_short_name
  var_hash <- hash::values(attr_hash_type, var_short_name)[[1]]
  
  # check which variables can be looked up
  attr_in_hash <- var_data %in% hash::keys(var_hash)
  
  # if none can be looked up than the input is returned
  if (!any(attr_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[attr_in_hash] <- hash::values(var_hash, var_data[attr_in_hash])
  
  return(res)
}

#' @rdname sdsdecoding
#' @export
apply_attr_types <- function(var_data, var_short_name) {
  
  res <- var_data
  
  # lookup type for variable in hash
  attr_types <- lookup_attr_types(var_data, var_short_name)
  
  # get replacement vector
  replacement_vector <- unlist(purrr::map2(attr_types, var_data, na_vars_switch))
  
  # transform variable
  res <- replacement_vector
  
  return(res)
}

# map attr type string to as.x function
na_vars_switch <- function(attr_type, value) {
  switch(
    as.character(attr_type),
    "normal" = value,
    "unknown" = NA,
    "absent" = NA,
    "cat_in_num" = NA,
    value
  )
}

#' @rdname sdsdecoding
#' @export
lookup_IGerM_category <- function(igerm_data, subcategory = FALSE) {
  
  cat_hash <- IGerM_category_hash
  
  if (subcategory) {
    cat_hash <- IGerM_subcategory_hash
  }
  
  res <- igerm_data
  
  # check which variables can be looked up
  attr_in_hash <- res %in% hash::keys(cat_hash)
  
  # if none can be looked up than the input is returned
  if (!any(attr_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[attr_in_hash] <- hash::values(cat_hash, res[attr_in_hash])
  
  return(res)
}
