library(magrittr)

fb1 <- data.table::fread("../sdsmeta/example_data/Kuesterberg_fb1_test.csv", encoding = "Latin-1") %>% tibble::as.tibble()

names(fb1) <- sdsanalysis::lookup_vars(names(fb1), 1)

variable_values %<>%
  dplyr::left_join(
    variable_selection %>% dplyr::select(number, form_sheet_number, name_unified_de), 
    by = c("number", "form_sheet_number")
  )

variable_values %>% dplyr::filter(form_sheet_number == 1) -> fb1_var_vals

fb1_decoded <- fb1
for (i in 1:ncol(fb1)) {
  variable <- names(fb1)[i]
  variable_data <- tibble::tibble(
    X = as.character(unlist(fb1[,variable]))
  )
  variants <- fb1_var_vals[fb1_var_vals$name_unified_de == variable,]
  fuzzy_variable <- dplyr::left_join(
    variable_data,
    variants,
    by = c("X" = "Ausprägungsnr")
  )$Ausprägungsname
  variable_data[is.na(fuzzy_variable),] <- paste0("0", variable_data[is.na(fuzzy_variable),]$X)
  fuzzy_variable <- dplyr::left_join(
    variable_data,
    variants,
    by = c("X" = "Ausprägungsnr")
  )$Ausprägungsname
  fb1_decoded[i] <- fuzzy_variable
  fb1_decoded[is.na(fb1_decoded[,i]),i] <- variable_data[is.na(fb1_decoded[,i]),1]
}

fb1_decoded
