# This script cleans up all the data within the water quality raw folder

library(tidyverse)
library(readxl)
library(lubridate)

# BVR DATA ---------------------------------------------------------------------

bvr_raw_data <- read_xlsx("data-raw/water-quality/BVR DATA_formatted.xlsx")

bvr_raw_data_A <- bvr_raw_data %>%
  transmute(
    origin_id = `Org ID`,
    origin_name = `Org Name`,
    station_id = `Station ID`,
    activity_start_date = as_date(`Activity Start Date`),
    characteristic_name = `Characteristic Name`,
    units = Units,
    raw_result_value = `Result Value as Text`,
    station_lat = `Station Latitude`,
    station_lon = `Station Longitude`,
    activity_depth = `Activity Depth`,
    activity_depth_unit = `Activity Depth Unit`,
    activity_medium = `Activity Medium`,
    activity_start_time = as.character(`Activity Start Time`),
    project_id = `Beach ID/Project ID`,
    state = tolower(State),
    county = tolower(County),
    huc = HUC,
    generated_huc = `Generated HUC`,
    station_horizontal_datum = `Station Horizontal Datum`,
    visit_num = `Visit Num`,
    activity_id = `Activity ID`,
    activity_start_zone = `Activity Start Zone`,
    activity_type = `Activity Type`,
    activity_category_rep_num = `Activity Category-Rep Num`,
    sample_collection_id = `Sample Collection ID`,
    field_gear_id = `Field Gear ID`,
    charactersitic_description = `Characteristic Description`,
    sample_fraction = `Sample Fraction`,
    value_type = `Value Type`,
    statistic_type = `Statistic Type`,
    result_value_status = `Result Value Status`,
    result_value_numeric = `Result Value as Number`,
    activity_comment = `Activity Comment`,
    result_comment = `Result Comment`,
    result_measure_qualifier = `Result Measure Qualifier`,
    weight_basis = `Weight Basis`,
    temperature_basis = `Temperature Basis`,
    duration_basis = `Duration Basis`,
    analytical_proc_id = `Analytical Proc ID`,
    result_depth_height = `Result Depth Height`,
    result_depth_height_unit = `Result Depth Height Unit`,
    result_depth_altitude_ref_point = `Result Depth Altitude Ref Point`,
    result_sampling_point = `Result Sampling Point`
  )

# its a good idea to extract out the station data, and only combine
# the result data to the station data when needed using some sort of join

bvr_stations <- bvr_raw_data_A %>%
  distinct(origin_id, origin_name,
           station_id, lat = station_lat, lon = station_lon,
           station_horizontal_datum,
           state, county)


bvr_stations %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers()

# remove these columns from the data
bvr_water_quality <- bvr_raw_data_A %>%
   select(-station_lat, -station_lon,
          -station_horizontal_datum,
          -state, -county) %>% # lets only select some of these for now
  select(
    origin_id,
    origin_name,
    station_id,
    activity_start_date,
    activity_start_time,
    characteristic_name,
    units,
    sample_fraction,
    value_type,
    statistic_type,
    result_value_numeric
  )

bvr_water_quality %>% distinct(characteristic_name)

bvr_water_quality %>%
  filter(characteristic_name == "Picloram") %>%
  ggplot(aes(activity_start_date, result_value_numeric)) + geom_point()

# so a lot of the data is just a few samples, let us remove these for now
# count number of observations per characteristic
top_wq_in_bvr <- bvr_water_quality %>%
  group_by(characteristic_name) %>%
  summarise(
    total = n()
  ) %>%
  arrange(desc(total)) %>%
  filter(total >= 100) %>%
  pull(characteristic_name)

bvr_wq <- bvr_water_quality %>%
  filter(characteristic_name %in% top_wq_in_bvr) %>%
  mutate(datetime = ymd_hms(paste(activity_start_date,
                               str_extract(activity_start_time,
                                           "[0-9]{2}:[0-9]{2}:[0-9]{2}"))))

usethis::use_data(bvr_wq, overwrite = TRUE)
# CDFA DATA --------------------------------------------------------------------

cdfa_raw_data <- read_xlsx("data-raw/water-quality/CDFA Data_formatted.xlsx")

cdfa_raw_data_A <- cdfa_raw_data %>%
  transmute(
    origin_id = `Org ID`,
    origin_name = `Org Name`,
    station_id = `Station ID`,
    activity_start_date = as_date(`Activity Start Date`),
    characteristic_name = `Characteristic Name`,
    units = Units,
    raw_result_value = `Result Value as Text`,
    station_lat = `Station Latitude`,
    station_lon = `Station Longitude`,
    activity_depth = `Activity Depth`,
    activity_depth_unit = `Activity Depth Unit`,
    activity_medium = `Activity Medium`,
    activity_start_time = as.character(`Activity Start Time`),
    project_id = `Beach ID/Project ID`,
    state = tolower(State),
    county = tolower(County),
    huc = HUC,
    generated_huc = `Generated HUC`,
    station_horizontal_datum = `Station Horizontal Datum`,
    visit_num = `Visit Num`,
    activity_id = `Activity ID`,
    activity_start_zone = `Activity Start Zone`,
    activity_type = `Activity Type`,
    activity_category_rep_num = `Activity Category-Rep Num`,
    sample_collection_id = `Sample Collection ID`,
    field_gear_id = `Field Gear ID`,
    charactersitic_description = `Characteristic Description`,
    sample_fraction = `Sample Fraction`,
    value_type = `Value Type`,
    statistic_type = `Statistic Type`,
    result_value_status = `Result Value Status`,
    result_value_numeric = `Result Value as Number`,
    activity_comment = `Activity Comment`,
    result_comment = `Result Comment`,
    result_measure_qualifier = `Result Measure Qualifier`,
    weight_basis = `Weight Basis`,
    temperature_basis = `Temperature Basis`,
    duration_basis = `Duration Basis`,
    analytical_proc_id = `Analytical Proc ID`,
    result_depth_height = `Result Depth Height`,
    result_depth_height_unit = `Result Depth Height Unit`,
    result_depth_altitude_ref_point = `Result Depth Altitude Ref Point`,
    result_sampling_point = `Result Sampling Point`
  )


















