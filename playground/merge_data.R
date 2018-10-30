library(magrittr)

#### Küsterberg ####

fb1 <- read.csv("../sdsdata/Kuesterberg/data-raw/Kuesterberg_fb1.csv", stringsAsFactors = FALSE)
fb2 <- read.csv("../sdsdata/Kuesterberg/data-raw/Kuesterberg_fb2.csv", stringsAsFactors = FALSE)
fb4 <- read.csv("../sdsdata/Kuesterberg/data-raw/Kuesterberg_fb4.csv", stringsAsFactors = FALSE)

fb1 %<>% dplyr::select(-"FBG_6")
fb4 %<>% dplyr::select(-"FBG_6")

hu <- fb1 %>%
  dplyr::full_join(
    fb2,
    by = c("FBG_1", "FBG_3", "FBG_4", "FBG_5")
  ) %>%
  dplyr::full_join(
    fb4,
    by = c("FBG_1", "FBG_2", "FBG_3", "FBG_4", "FBG_5")
  )

write.csv(hu, "../sdsdata/Kuesterberg/Kuesterberg_single.csv", na = "", row.names = FALSE)

#### Hundesburg_Olbetal ####

fb1 <- read.csv("../sdsdata/Hundisburg_Olbetal/data-raw/Hundisburg_Olbetal_fb1.csv", stringsAsFactors = FALSE)
fb2 <- read.csv("../sdsdata/Hundisburg_Olbetal/data-raw/Hundisburg_Olbetal_fb2.csv", stringsAsFactors = FALSE)
fb4 <- read.csv("../sdsdata/Hundisburg_Olbetal/data-raw/Hundisburg_Olbetal_fb4.csv", stringsAsFactors = FALSE)

fb1 %<>% dplyr::select(-"FBG_6")
fb4 %<>% dplyr::select(-"FBG_6")

hu <- fb1 %>%
  dplyr::full_join(
    fb2,
    by = c("FBG_1", "FBG_3", "FBG_4", "FBG_5")
  ) %>%
  dplyr::full_join(
    fb4,
    by = c("FBG_1", "FBG_2", "FBG_3", "FBG_4", "FBG_5")
  )

write.csv(hu, "../sdsdata/Hundisburg_Olbetal/Hundisburg_Olbetal_single.csv", na = "", row.names = FALSE)
