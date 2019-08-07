# stations near the lake:
# 11449500

library(lubridate)
library(dataRetrieval)
library(tidyverse)

kelsey_creek_flow <- readNWISdv("11449500", parameterCd = "00060", startDate = "1970-01-01") %>%
  transmute(
    site_no,
    site_name = tolower("KELSEY C NR KELSEYVILLE CA"),
    date = Date,
    flow_cfs = X_00060_00003
  ) %>% as_tibble()


kelsey_creek_flow %>%
  ggplot(aes(date, flow_cfs)) + geom_line()


usethis::use_data(kelsey_creek_flow, overwrite = TRUE)


cache_creek_flow <- readNWISdv("11451000", parameterCd = "00060",
                               startDate = "2000-01-01") %>%
  transmute(
    site_no,
    site_name = tolower("CACHE C NR LOWER LAKE CA"),
    date = Date,
    flow_cfs = X_00060_00003
  ) %>% as_tibble()

usethis::use_data(cache_creek_flow, overwrite = TRUE)

clear_lake_elev <- readNWISdv("11450000", parameterCd = "00065",
                              startDate = "2000-01-01") %>%
  transmute(
    site_no,
    site_name = tolower("CLEAR LK A LAKEPORT CA"),
    date = Date,
    elevation_feet = X_00065_00003
  ) %>% as_tibble()



# Analysis ----------------------------------------

ggplot() +
  geom_line(data = filter(kelsey_creek_flow, year(date) == 2019),
            aes(date, flow_cfs, color="kelsey")) +
  geom_line(data = filter(cache_creek_flow, year(date) == 2019),
            aes(date, flow_cfs, color="cache"))

