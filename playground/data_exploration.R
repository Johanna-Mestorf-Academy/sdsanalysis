library(magrittr)

fb1 <- data.table::fread("../sdsmeta/example_data/Kuesterberg_fb1_test.csv", encoding = "Latin-1") %>% tibble::as.tibble()

names(fb1) <- sdsanalysis::lookup_vars(names(fb1), 1)

fb1_decoded <- fb1 %>% purrr::map2_df(., names(.), .f = sdsanalysis::lookup_attrs)
