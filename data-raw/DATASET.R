## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(lubridate)
library(leaflet)

# GROUNDWATER DATA =============================================================
sites_near_adobe <- c("389535N1228968W001", "389569N1228885W001", "389592N1228971W001",
                      "389726N1228847W001", "389797N1228831W001", "389796N1228819W002",
                      "389778N1228732W001", "389868N1228802W001", "389930N1228687W001",
                      "389940N1228706W001", "389937N1228718W001", "389937N1228751W001",
                      "389975N1228770W001", "390041N1228801W001", "390149N1228719W001",
                      "390175N1228682W001", "389611N1228872W001")


gst1 <- read_csv("data-raw/groundwater/GST_20190613134250.csv") %>%
  select(site_code, local_well_designation, lat=latitude, lng=longitude,
         total_depth_ft)
gwl1 <- read_csv("data-raw/groundwater/GWL_20190613134250.csv") %>%
  select(site_code, measurement_date, rp_elevation, gs_elevation,
         ws_reading, rp_reading)

gst2 <- read_csv("data-raw/groundwater/GST_20190613134316.csv") %>%
  select(site_code, local_well_designation, lat=latitude, lng=longitude,
         total_depth_ft)
gwl2 <- read_csv("data-raw/groundwater/GWL_20190613134316.csv") %>%
  select(site_code, measurement_date, rp_elevation, gs_elevation,
         ws_reading, rp_reading)

groundwater_levels <- bind_rows(
  gwl1, gwl2
) %>%
  mutate(wse = rp_elevation - ws_reading - rp_reading)

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
) %>% left_join(groundwater_metrics_by_site, by=c("site_code", "site_code")) %>%
  mutate(
    is_near_adobe = site_code %in% sites_near_adobe
  )

usethis::use_data(groundwater_stations, overwrite = TRUE)

# PRESSURE TRANSDUCER DATA =====================================================

bell_hill <- read_csv("data-raw/transducer/2020-04/Bell Hill_Append_2020-04-18_18-14-46-011-BaroMerge.csv",
                      skip = 83,
                      col_types = "ccccccc",
                      col_names = c("dateTime","seconds", "pressure_psi", "temp_c", "depth_ft",
                                    "baro_pressure_psi", "dummy")) %>%
  transmute(
    transducer = "bell_hill",
    dateTime = mdy_hms(dateTime),
    depth_ft = as.numeric(depth_ft),
    temp_c = as.numeric(temp_c))

argonaut <- read_csv("data-raw/Argonaut_Append_2019-03-24_10-34-19-544-BaroMerge.csv",
                     skip = 83,
                     col_types = "ccccccc",
                     col_names = c("dateTime","seconds", "pressure_psi", "temp_c", "depth_ft",
                                   "baro_pressure_psi", "dummy")) %>%
  transmute(
    transducer = "argonaut",
    dateTime = mdy_hms(dateTime),
    depth_ft = as.numeric(depth_ft),
    temp_c = as.numeric(temp_c))

soda_bay <- read_csv("data-raw/Soda Bay_Append_2019-03-24_11-36-13-985-BaroMerge.csv",
                     skip = 75,
                     col_types = "ccccccc",
                     col_names = c("dateTime","seconds", "pressure_psi", "temp_c", "depth_ft",
                                   "baro_pressure_psi", "dummy")) %>%
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

usethis::use_data(pressure_transducer, overwrite = TRUE)
