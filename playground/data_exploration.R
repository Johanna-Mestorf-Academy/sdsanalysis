library(magrittr)

fb1 <- sdsanalysis::get_data("test_data")

fb1_decoded <- sdsanalysis::lookup_everything(fb1, 1)
