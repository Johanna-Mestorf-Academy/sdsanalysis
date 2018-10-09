#' lookup_vars
#'
#' @param x Character Vector. Keys to look up values.
#' @param fb Numeric. Relevant Formblatt.
#'
#' @return Variable names.
#' 
#' @export
lookup_vars <- function(x, fb) {
  
  # geht relevant hash for fb
  fb_hash <- hash::values(var_hash, fb)[[1]]
  # lookup for variables in hash
  res <- x 
  vars_in_hash <- x %in% hash::keys(fb_hash)
  res[vars_in_hash] <- hash::values(fb_hash, x[vars_in_hash])
  
  return(res)
}
