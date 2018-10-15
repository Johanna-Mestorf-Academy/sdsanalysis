library(magrittr)

x <- data.table::fread("../sdsmeta/example_data/Kuesterberg_fb1_test.csv", encoding = "Latin-1") %>% tibble::as.tibble()

fb1_decoded <- lookup_everything(x, 1)

fb <- fb1_decoded

library(ggplot2)

ggplot(fb) +
  geom_point(
    aes(dicke, groesse)
  )

inputdata <- fb
var1 <- "fundjahr"
var2 <- "gewicht"

dynamic_plot(fb, "fundjahr", "gewicht")
