library(magrittr)

#### package test data ####

test_sds <- sdsanalysis::get_single_artefact_data("test_data")

test_sds_decoded <- sdsanalysis::lookup_everything(test_sds)

#### Kuesterberg ####

test2 <- utils::read.csv("../sdsdata/Kuesterberg/Kuesterberg.csv", stringsAsFactors = F) %>% tibble::as.tibble()

test2_decoded <- sdsanalysis::lookup_everything(test2)

#### Bad-Oldesloe_Wolkenwehe #### 

test_3 <- utils::read.csv(
  "../sdsdata/Bad-Oldesloe_Wolkenwehe/Bad-Oldesloe_Wolkenwehe.csv",
  stringsAsFactors = F
) %>% tibble::as.tibble()

test3_decoded <- sdsanalysis::lookup_everything(test_3)

#### Oldenburg_Dannau ####

test_4 <- utils::read.csv(
  "../sdsdata/Oldenburg_Dannau/Oldenburg_Dannau_multi.csv",
  stringsAsFactors = F
) %>% tibble::as.tibble()

test4_decoded <- sdsanalysis::lookup_everything(test_3)
