# stations near the lake:
# 11449500

library(lubridate)
library(dataRetrieval)
library(tidyverse)

flow_stations <-
  dataRetrieval::readNWISsite(c("11449500", "11451000", "11450000",
                                "11448500", "11449010")) %>%
  transmute(agency_cd, site_no, site_name = tolower(station_nm),
         lat = dec_lat_va, lon = dec_long_va)

usethis::use_data(flow_stations, overwrite = TRUE)

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


# adobe creek (old station)

adobe_creek_flow <- readNWISdv("11448500", parameterCd = "00060",
                               startDate = "1954-10-01",
                               endDate = "1978-10-02") %>%
  transmute(
    site_no,
    site_name = tolower("ADOBE C NR KELSEYVILLE CA"),
    date = Date,
    flow_cfs = X_00060_00003
  ) %>% as_tibble()

usethis::use_data(adobe_creek_flow, overwrite = TRUE)


# highland creek below dam

highland_creek_flow <- readNWISdv("11449010", parameterCd = "00060",
                                  startDate = "1965-12-01",
                                  endDate = "1977-09-29") %>%
  transmute(
    site_no,
    site_name = tolower("HIGHLAND C BL HIGHLAND CREEK DAM CA"),
    date = Date,
    flow_cfs = X_00060_00003
  ) %>% as_tibble()

usethis::use_data(highland_creek_flow, overwrite = TRUE)


a


