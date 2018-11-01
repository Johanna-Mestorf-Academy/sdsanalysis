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

test3_decoded_multi <- get_multi_artefact_data("Bad-Oldesloe_Wolkenwehe") %>% sdsanalysis::lookup_everything()
get_description("Bad-Oldesloe_Wolkenwehe")

#### Oldenburg_Dannau ####

test4_decoded_multi <- get_multi_artefact_data("Oldenburg_Dannau") %>% sdsanalysis::lookup_everything()
get_description("Oldenburg_Dannau")

#### Wangels ####

test5_decoded_multi <- get_multi_artefact_data("Wangels") %>% sdsanalysis::lookup_everything()
get_description("Wangels")


