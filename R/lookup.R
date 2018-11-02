#' lookup_everything
#'
#' @param x Dataframe. Table in SDS standard format.
#'
#' @return Decoded and optimized SDS data.frame.
#' 
#' @export
lookup_everything <- function(x) {
  
  res <- x
  
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

#' lookup_vars
#'
#' @param x Character Vector. Keys to look up values: Variable IDs.
#' 
#' @return Unified variable names.
#' 
#' @export
lookup_vars <- function(x) {

  res <- x 
  
  # check which variables can be looked up
  vars_in_hash <- x %in% hash::keys(var_hash)
  
  # if none can be looked up than the input is returned
  if (!any(vars_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[vars_in_hash] <- hash::values(var_hash, x[vars_in_hash])
  
  return(res)
}

#' lookup_var_complete_names
#'
#' @param vr Character Vector. Keys to look up values: Unified variable names.
#'
#' @return Complete variable names.
#' 
#' @export
lookup_var_complete_names <- function(vr) {

  vr_complete_name <- vr
    
  # check which variables can be looked up
  var_in_hash <- vr %in% hash::keys(var_hash_complete_name)
  
  # lookup complete name for variable in hash
  vr_complete_name[var_in_hash] <- hash::values(var_hash_complete_name, vr[var_in_hash])
  
  return(unlist(vr_complete_name))
}

#' lookup_var_types
#'
#' @param vr Character. Keys to look up values: Unified variable names.
#'
#' @return Variable types (names of types as character vector).
#' 
#' @export
lookup_var_types <- function(vr) {
  
  vr_type <- rep(NA, length(vr))
  
  # check which variables can be looked up
  var_in_hash <- vr %in% hash::keys(var_hash_type)
  
  # lookup type for variable in hash
  vr_type[var_in_hash] <- hash::values(var_hash_type, vr[var_in_hash])
  
  return(unlist(vr_type))
}

#' apply_var_types
#'
#' @param x Vector. Variable data. 
#' @param vr Character. Relevant variable: Unified variable name.
#'
#' @return Replacement vector.
#' 
#' @export
apply_var_types <- function(x, vr) {
  
  res <- x
  
  # lookup type for variable in hash
  vr_type <- lookup_var_types(vr)
  
  # get trans function
  vr_trans_function <- string_to_as(vr_type)
  
  # transform variable, if trans function is available
  if (!is.null(vr_trans_function)) {
    res <- vr_trans_function(res)
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

#' lookup_attrs
#'
#' @param x Vector. Keys to look up values: Numeric or character values in database.
#' @param vr Character. Relevant variable: Unified variable name.
#'
#' @return Transformed variable values.
#' 
#' @export
lookup_attrs <- function(x, vr) {
  
  res <- x 
  
  # check if there is a hash for this variable
  if (!(vr %in% hash::keys(attr_hash))) {
    return(res)
  }
  
  # get relevant hash for vr
  vr_hash <- hash::values(attr_hash, vr)[[1]]
  
  # check which variables can be looked up
  attr_in_hash <- x %in% hash::keys(vr_hash)
  
  # if none can be looked up than the input is returned
  if (!any(attr_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[attr_in_hash] <- hash::values(vr_hash, x[attr_in_hash])
  
  return(res)
}

#' lookup_attr_types
#'
#' @param x Vector. Keys to look up values: Numeric or character values in database.
#' @param vr Character. Relevant variable: Unified variable name.
#'
#' @return Type of variable: Not data type, but "normal"/"absent"/"unknown".
#' 
#' @export
lookup_attr_types <- function(x, vr) {
  
  res <- x 
  
  # check if there is a hash for this variable
  if (!(vr %in% hash::keys(attr_hash_type))) {
    return(res)
  }
  
  # get relevant hash for vr
  vr_hash <- hash::values(attr_hash_type, vr)[[1]]
  
  # check which variables can be looked up
  attr_in_hash <- x %in% hash::keys(vr_hash)
  
  # if none can be looked up than the input is returned
  if (!any(attr_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[attr_in_hash] <- hash::values(vr_hash, x[attr_in_hash])
  
  return(res)
}

#' apply_attr_types
#'
#' @param x Vector. Variable data. 
#' @param vr Character. Relevant variable: Unified variable name.
#'
#' @return Replacement vectors.
#' 
#' @export
apply_attr_types <- function(x, vr) {
  
  res <- x
  
  # lookup type for variable in hash
  attr_types <- lookup_attr_types(x, vr)
  
  # get replacement vector
  replacement_vector <- unlist(purrr::map2(attr_types, x, na_vars_switch))
  
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

#' lookup_IGerM_category
#'
#' @param x Character vector. Keys to look up values: IGerM character codes in data.
#' @param subcategory Boolean. Should the function return IGerM subcategories instead of categories?
#'
#' @export
lookup_IGerM_category <- function(x, subcategory = FALSE) {
  
  cat_hash <- IGerM_category_hash
  
  if (subcategory) {
    cat_hash <- IGerM_subcategory_hash
  }
  
  res <- x
  
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
  
