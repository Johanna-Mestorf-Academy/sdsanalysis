library(magrittr)

#### get meta data ####
data_position <- data.table::fread("data-raw/data_position_list.csv") %>% tibble::as.tibble()
variables <- data.table::fread("data-raw/variable_list.csv") %>% tibble::as.tibble()
variable_values <- data.table::fread("data-raw/variable_values_list.csv") %>% tibble::as.tibble()

#### store external data
usethis::use_data(
  data_position,
  variables,
  variable_values,
  overwrite = TRUE
)

#### create hash tables ####

# create variable hash table: variable id -> variable unified name
var_hash <- hash::hash(variables$variable_id, variables$name_unified_de)

# create variable hash table: variable unified name -> variable complete name
var_hash_complete_name <- hash::hash(variables$name_unified_de, variables$name_de)

# create variable hash table: variable unified name -> variable r data type
var_hash_type <- hash::hash(variables$name_unified_de, variables$r_data_type)

# create attribute name hash table: attribute number -> attribute complete name
variable_values %<>%
  dplyr::left_join(
    variables %>% dplyr::select(variable_id, name_unified_de), 
    by = "variable_id"
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

# create IGerM category hash table: IGerM name -> category name
IGerM_category_hash <- variable_values %>%
  dplyr::filter(variable_id == "IGerM") %$%
  hash::hash(attribute_name, attribute_category_name)

# create IGerM subcategory hash table: IGerM name -> subcategory name
IGerM_subcategory_hash <- variable_values %>%
  dplyr::filter(variable_id == "IGerM") %$%
  hash::hash(attribute_name, attribute_subcategory_name)

#### store internal data (hash tables) ####
usethis::use_data(
  data_position,
  var_hash,
  var_hash_complete_name,
  var_hash_type,
  attr_hash,
  attr_hash_type,
  IGerM_category_hash,
  IGerM_subcategory_hash,
  internal = TRUE, overwrite = TRUE
)
