library(magrittr)

x <- data.table::fread("../sdsmeta/example_data/Kuesterberg_fb1_test.csv", encoding = "Latin-1") %>% tibble::as.tibble()

fb1_decoded <- lookup_everything(x, 1)

