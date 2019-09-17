library(tidyverse)
library(lubridate)

csv_list <- list.files("data-raw/fish/", pattern = "results", full.names = TRUE)


results_05 <- read_csv("data-raw/fish/lakelive_results2005.csv",
                       col_types = "ccccccc")

results_10 <- read_csv("data-raw/fish/lakelive_results2010.csv")



raw_fish_data <- csv_list %>%
  map_df(function(csv) {
    d <- read_csv(csv, col_types = "ccccccc")
  })

x <- raw_fish_data %>%
  filter(!is.na(date)) %>%
  transmute(
    date = ymd(date),
    time,
    creek = tolower(creek),
    location = tolower(location),
    fish_raw = fish,
    fish = readr::parse_number(fish)
  ) %>%
  group_by(creek, location, date) %>%
  summarise(
    fish = max(fish, na.rm = TRUE)
  ) %>% ungroup() %>%
  filter(
    str_detect(creek, "adobe")
  ) %>%
  mutate(
    fish = ifelse(is.infinite(fish), as.numeric(NA), fish)
  )

x %>%
  group_by(date) %>%
  summarise(
    count = sum(fish, na.rm = TRUE)
  ) %>%
  mutate(fake_date = `year<-`(date, 2050),
         year = as.character(year(date))) %>%
  ggplot(aes(fake_date, count, group=year)) + geom_line(alpha=0.3)








