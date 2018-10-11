#' lookup_everything
#'
#' @param x Dataframe. Table in SDS standard format.
#' @param fb Numeric. Relevant Formblatt.
#'
#' @return Decoded and optimized SDS data.frame.
#' 
#' @export
lookup_everything <- function(x, fb) {
  
  res <- x
  
  # decode variable names
  names(res) <- sdsanalysis::lookup_vars(names(res), fb)
  
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
#' @param x Character Vector. Keys to look up values.
#' @param fb Numeric. Relevant Formblatt.
#'
#' @return Variable names.
#' 
#' @export
lookup_vars <- function(x, fb) {

  # if no lookup possible than the input is returned
  res <- x 
  
  # check if there is a hash for this fb
  if (!fb %in% hash::keys(var_hash)) {
    return(res)
  }  
  
  # get relevant hash for fb
  fb_hash <- hash::values(var_hash, fb)[[1]]

  # check which variables can be looked up
  vars_in_hash <- x %in% hash::keys(fb_hash)
  
  # if none can be looked up than the input is returned
  if (!any(vars_in_hash)) {
    return(res)
  }
  
  # lookup for variables in hash
  res[vars_in_hash] <- hash::values(fb_hash, x[vars_in_hash])
  
  return(res)
}

#' lookup_attrs
#'
#' @param x Vector. Keys to look up values.
#' @param vr Character. Relevant variable.
#'
#' @return Variable names.
#' 
#' @export
lookup_attrs <- function(x, vr) {
  
  # if no lookup possible than the input is returned
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

#' lookup_var_types
#'
#' @param vr Character. Relevant variable.
#'
#' @return Variable types.
#' 
#' @export
lookup_var_types <- function(vr) {
  
  # check which variables can be looked up
  var_in_hash <- vr %in% hash::keys(var_hash_type)
  
  # if none can be looked up than the input is returned
  if (!var_in_hash) {
    return(NA)
  }
  
  # lookup type for variable in hash
  vr_type <- hash::values(var_hash_type, vr)
  
  return(vr_type)
}

#' apply_var_types
#'
#' @param x Vector. Variable data. 
#' @param vr Character. Relevant variable.
#'
#' @return Variable types.
#' 
#' @export
apply_var_types <- function(x, vr) {
  
  # if no lookup possible than the input is returned
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
    "integer" = as.integer,
    "double" = as.double,
    "factor" = as.factor,
    "character" = as.character,
    NA
  )
}
