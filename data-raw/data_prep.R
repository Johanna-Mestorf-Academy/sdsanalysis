# get meta data
variables <- data.table::fread("https://raw.githubusercontent.com/nevrome/sdsmeta/master/variable_list.csv")
variable_values <- data.table::fread("https://raw.githubusercontent.com/nevrome/sdsmeta/master/variable_values_list.csv")

variables

vars_num_name <- hash::hash(as.character(variables$number), variables$name_unified_de)

variable_values %<>%
  dplyr::left_join(
    variable_selection %>% dplyr::select(number, form_sheet_number, name_unified_de), 
    by = c("number", "form_sheet_number")
  )

lapply( 
  base::split(variable_values, variable_values$name_unified_de),
  function(x) {
    hash::hash(as.character(x$Ausprägungsnr), x$Ausprägungsname)
  }
)
  

devtools::use_data(vars_num_name, internal = TRUE)
