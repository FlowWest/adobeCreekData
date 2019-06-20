## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(lubridate)
library(leaflet)

# GROUNDWATER DATA =============================================================

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

# PRESSURE TRANSDUCER DATA =====================================================

bell_hill <- read_csv("data-raw/Bell Hill_Append_2019-03-24_10-53-07-322-BaroMerge.csv",
                      skip = 75,
                      col_types = "ccccccc",
                      col_names = c("dateTime", "pressure_psi", "temp_c", "depth_ft",
                                    "baro_pressure_psi", "unknown", "dummy")) %>%
  transmute(
    transducer = "bell_hill",
    dateTime = mdy_hms(dateTime),
    depth_ft = as.numeric(depth_ft),
    temp_c = as.numeric(temp_c))

argonaut <- read_csv("data-raw/Argonaut_Append_2019-03-24_10-34-19-544-BaroMerge.csv",
                     skip = 75,
                     col_types = "ccccccc",
                     col_names = c("dateTime", "pressure_psi", "temp_c", "depth_ft",
                                   "baro_pressure_psi", "unknown", "dummy")) %>%
  transmute(
    transducer = "argonaut",
    dateTime = mdy_hms(dateTime),
    depth_ft = as.numeric(depth_ft),
    temp_c = as.numeric(temp_c))

soda_bay <- read_csv("data-raw/Soda Bay_Append_2019-03-24_11-36-13-985-BaroMerge.csv",
                     skip = 75,
                     col_types = "ccccccc",
                     col_names = c("dateTime", "pressure_psi", "temp_c", "depth_ft",
                                   "baro_pressure_psi", "unknown", "dummy")) %>%
  transmute(
    transducer = "soda_bay",
    dateTime = mdy_hms(dateTime),
    depth_ft = as.numeric(depth_ft),
    temp_c = as.numeric(temp_c))

pressure_transducer <- bind_rows(
  bell_hill,
  argonaut,
  soda_bay
)
