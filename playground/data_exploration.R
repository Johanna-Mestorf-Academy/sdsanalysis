library(magrittr)

test_sds <- sdsanalysis::get_single_artefact_data("test_data")

test_sds_decoded <- sdsanalysis::lookup_everything(test_sds)
