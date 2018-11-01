library(magrittr)

#### package test data ####

test_sds <- sdsanalysis::get_single_artefact_data("test_data")

test_sds_decoded <- sdsanalysis::lookup_everything(test_sds)

#### Kuesterberg ####

test1_decoded_single <- get_single_artefact_data("Kuesterberg") %>% sdsanalysis::lookup_everything()
test1_decoded_multi <- get_multi_artefact_data("Kuesterberg") %>% sdsanalysis::lookup_everything()
get_description("Kuesterberg")

#### Hundesburg_Olbetal ####

test2_decoded_single <- get_single_artefact_data("Hundisburg_Olbetal") %>% sdsanalysis::lookup_everything()
test2_decoded_multi <- get_multi_artefact_data("Hundisburg_Olbetal") %>% sdsanalysis::lookup_everything()
get_description("Hundisburg_Olbetal")

#### Bad-Oldesloe_Wolkenwehe #### 

test_3 <- utils::read.csv(
  "../sdsdata/Bad-Oldesloe_Wolkenwehe/Bad-Oldesloe_Wolkenwehe_multi.csv",
  stringsAsFactors = F
) %>% tibble::as.tibble()

test3_decoded <- sdsanalysis::lookup_everything(test_3)

get_single_artefact_data("Bad-Oldesloe_Wolkenwehe")
get_multi_artefact_data("Bad-Oldesloe_Wolkenwehe")
get_description("Bad-Oldesloe_Wolkenwehe")

#### Oldenburg_Dannau ####

test_4 <- utils::read.csv(
  "../sdsdata/Oldenburg_Dannau/Oldenburg_Dannau_multi.csv",
  stringsAsFactors = F
) %>% tibble::as.tibble()

test4_decoded <- sdsanalysis::lookup_everything(test_4)

#### Wangels ####

test_5 <- utils::read.csv(
  "../sdsdata/Wangels/Wangels_multi.csv",
  stringsAsFactors = F
) %>% tibble::as.tibble()

test5_decoded <- sdsanalysis::lookup_everything(test_5)


