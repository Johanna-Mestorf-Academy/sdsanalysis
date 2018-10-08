library(magrittr)

variables <- data.table::fread("https://raw.githubusercontent.com/nevrome/sdsmeta/master/variable_list.csv") %>% tibble::as.tibble()
variable_values <- data.table::fread("https://raw.githubusercontent.com/nevrome/sdsmeta/master/variable_values_list.csv") %>% tibble::as.tibble()


fb1 <- data.table::fread("../sdsmeta/example_data/Kuesterberg_fb1_test.csv", encoding = "Latin-1") %>% tibble::as.tibble()

variables %>% dplyr::filter(form_sheet_number == 1) -> fb1_vars
variable_values %>% dplyr::filter(form_sheet_number == 1) -> fb1_var_vals

fb1_vars$number <- as.character(fb1_vars$number)

variable_selection <- tibble::tibble(number = names(fb1)) %>%
  dplyr::left_join(
    fb1_vars, by = "number"
  )

new_names <- ifelse(
  !is.na(variable_selection$name_unified_de),
  variable_selection$name_unified_de,
  variable_selection$number
)

names(fb1) <- new_names

