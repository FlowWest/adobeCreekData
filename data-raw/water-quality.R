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


















