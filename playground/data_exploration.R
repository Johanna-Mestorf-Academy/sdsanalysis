library(magrittr)

fb1 <- data.table::fread("../sdsmeta/example_data/Kuesterberg_fb1_test.csv", encoding = "Latin-1") %>% tibble::as.tibble()

fb1_decoded <- lookup_everything(fb1, 1)

