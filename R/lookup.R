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
  # res <- 
  
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
#' @param x Character Vector. Keys to look up values.
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

