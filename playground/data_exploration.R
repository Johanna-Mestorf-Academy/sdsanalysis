library(magrittr)

test_sds <- sdsanalysis::get_data("test_data")

test_sds_decoded <- sdsanalysis::lookup_everything(test_sds)
