## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(lubridate)
library(leaflet)
# casgem groundwater data

gst1 <- read_csv("data-raw/GST_20190613134250.csv") %>%
  select(site_code, local_well_designation, lat=latitude, lng=longitude,
         total_depth_ft)
gwl1 <- read_csv("data-raw/GWL_20190613134250.csv") %>%
  select(site_code, measurement_date, rp_elevation, gs_elevation,
         ws_reading, rp_reading)

gst2 <- read_csv("data-raw/GST_20190613134316.csv") %>%
  select(site_code, local_well_designation, lat=latitude, lng=longitude,
         total_depth_ft)
gwl2 <- read_csv("data-raw/GWL_20190613134316.csv") %>%
  select(site_code, measurement_date, rp_elevation, gs_elevation,
         ws_reading, rp_reading)

groundwater_levels <- bind_rows(
  gwl1, gwl2
)

usethis::use_data(groundwater_levels, overwrite = TRUE)

groundwater_metrics_by_site <- groundwater_levels %>%
  group_by(site_code) %>%
  summarise(
    start_date = as_date(min(measurement_date)),
    end_date = as_date(max(measurement_date)),
    total_measures = n()
  )


groundwater_stations <- bind_rows(
  gst1, gst2
) %>% left_join(groundwater_metrics_by_site, by=c("site_code", "site_code"))

usethis::use_data(groundwater_stations, overwrite = TRUE)
