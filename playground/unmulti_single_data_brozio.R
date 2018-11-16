library(magrittr)

#### read wrong data ####
sds <- read.csv(
  "/home/clemens/sds/sdsdata/Wangels/alt/Wangels_LA69_single.csv",
  stringsAsFactors = FALSE
  )

#### replace FB_19:FB_21 ####
sds <- sds %>%
  tidyr::gather(
    FB1_35, value, FB7_19:FB7_21
  ) %>%
  dplyr::filter(
    value != 0
  ) %>%
  dplyr:::select(
    -value
  ) %>%
  dplyr::mutate(
    FB1_35 = unname(sapply(
      FB1_35,
      function(x) {
        switch (
          x,
          FB7_19 = 0,
          FB7_20 = 1,
          FB7_21 = 9
        )
      }
    ))
  )
  
#### replace FB_22:FB_27 ####
sds <- sds %>%
  tidyr::gather(
    FB1_36, value, FB7_22:FB7_27
  ) %>%
  dplyr::filter(
    value != 0
  ) %>%
  dplyr:::select(
    -value
  ) %>%
  dplyr::mutate(
    FB1_36 = unname(sapply(
      FB1_36,
      function(x) {
        switch (
          x,
          FB7_22 = 0,
          FB7_23 = 1,
          FB7_24 = 2,
          FB7_25 = 3,
          FB7_26 = 4,
          FB7_27 = 9
        )
      }
    ))
  )

#### write correct data ####
write.csv(
  sds, file = "/home/clemens/sds/sdsdata/Wangels/Wangels_LA69_single.csv",
  row.names = FALSE
)
