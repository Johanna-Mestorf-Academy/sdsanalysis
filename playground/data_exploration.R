library(magrittr)

fb1 <- data.table::fread("example_data/Kuesterberg_sds_fb1.csv", encoding = "Latin-1") %>% tibble::as.tibble()

fb1$Quadratmeter %>% hist


