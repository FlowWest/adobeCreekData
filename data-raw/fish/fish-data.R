library(tidyverse)
library(rvest)
library(lubridate)

chi_council_obs_locations_URL <- "https://lakelive.info/chicouncil/locations.htm"
chi_council_2005_results_URL <- "https://lakelive.info/chicouncil/2005results.htm"

chi_council_obs_locations <- read_html(chi_council_obs_locations_URL) %>%
  html_node("table") %>%
  html_table() %>%
  .[, -8] %>%
  as_tibble() %>%
  select(
    no=`#`,
    creek,
    bridge_1 = `bridge #1`,
    bridge_2 = `bridge#2`,
    bridge_3 = `bridge #3`,
    bridge_4 = `bridge #4`,
    bridge_5 = `bridge #5`
  )

chi_council_2005_results <- read_html(chi_council_2005_results_URL) %>%
  html_node("table") %>%
  html_table(trim = TRUE) %>%
  select(
    creek, location, date, time, no_fish_raw = `number of fish`
  ) %>% as_tibble() %>%
  mutate(
    date = mdy(date),
    no_fish = readr::parse_number(no_fish_raw)
  )
