library(magrittr)

#### get meta data ####
data_position <- data.table::fread("data-raw/data_position_list.csv") %>% tibble::as.tibble()
variables <- data.table::fread("data-raw/variable_list.csv") %>% tibble::as.tibble()
variable_values <- data.table::fread("data-raw/variable_values_list.csv") %>% tibble::as.tibble()

#### store external data
devtools::use_data(
  data_position,
  variables,
  variable_values,
  overwrite = TRUE
)

#### create hash tables ####

# create variable hash table: variable number -> variable unified name
var_hash <- base::split(
  variables, 
  variables$form_sheet_number
) %>%
  lapply( 
    function(x) {
      hash::hash(x$variable_number, x$name_unified_de)
    }
  ) %>%
  hash::hash()

# create variable hash table: variable unified name -> variable complete name
var_hash_complete_name <- hash::hash(variables$name_unified_de, variables$name_de)

# create variable hash table: variable unified name -> variable r data type
var_hash_type <- hash::hash(variables$name_unified_de, variables$r_data_type)

# create attribute name hash table: attribute number -> attribute complete name
variable_values %<>%
  dplyr::left_join(
    variables %>% dplyr::select(variable_number, form_sheet_number, name_unified_de), 
    by = c("variable_number", "form_sheet_number")
  )
attr_hash <- base::split(
  variable_values, 
  variable_values$name_unified_de
) %>%
  lapply( 
    function(x) {
      hash::hash(as.character(x$attribute_number), x$attribute_name)
    }
  ) %>%
  hash::hash()

# create attribute type hash table: attribute number -> attribute type
attr_hash_type <- base::split(
  variable_values, 
  variable_values$name_unified_de
) %>%
  lapply( 
    function(x) {
      hash::hash(as.character(x$attribute_number), x$attribute_type)
    }
  ) %>%
  hash::hash()

#### store internal data (hash tables) ####
devtools::use_data(
  data_position,
  var_hash,
  var_hash_complete_name,
  var_hash_type,
  attr_hash,
  attr_hash_type,
  internal = TRUE, overwrite = TRUE, pkg = "."
)
