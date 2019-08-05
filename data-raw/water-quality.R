# This script cleans up all the data within the water quality raw folder

library(tidyverse)
library(readxl)
library(lubridate)

bounding_box <- c(-122.988845,38.857329,-122.542542,39.184385)

bvr_stations %>%
  filter(lat >= bounding_box[2], lat <= bounding_box[4],
         lon >= bounding_box[1], lon <= bounding_box[3])

# BVR DATA ---------------------------------------------------------------------

bvr_raw_data <- read_xlsx("data-raw/water-quality/BVR DATA_formatted.xlsx")

bvr_raw_data_A <- bvr_raw_data %>%
  transmute(
    origin_id = `Org ID`,
    origin_name = `Org Name`,
    station_id = `Station ID`,
    sample_date = as_date(`Activity Start Date`),
    analyte = `Characteristic Name`,
    units = Units,
    raw_result_value = `Result Value as Text`,
    station_lat = `Station Latitude`,
    station_lon = `Station Longitude`,
    activity_depth = `Activity Depth`,
    activity_depth_unit = `Activity Depth Unit`,
    activity_medium = `Activity Medium`,
    sample_time = as.character(`Activity Start Time`),
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

bvr_stations <- bvr_raw_data_A %>%
  distinct(origin_id, origin_name,
           station_id, lat = station_lat, lon = station_lon,
           station_horizontal_datum,
           state, county)

usethis::use_data(bvr_stations, overwrite = TRUE)


# remove these columns from the data
bvr_water_quality <- bvr_raw_data_A %>%
  select(
    origin_id,
    origin_name,
    station_id,
    sample_date,
    sample_time,
    analyte,
    units,
    sample_fraction,
    value_type,
    statistic_type,
    result_value_numeric
  )

bvr_wq <- bvr_water_quality %>%
  filter(characteristic_name %in% top_wq_in_bvr) %>%
  mutate(datetime = ymd_hms(paste(activity_start_date,
                                  str_extract(activity_start_time,
                                              "[0-9]{2}:[0-9]{2}:[0-9]{2}"))))

usethis::use_data(bvr_wq, overwrite = TRUE)

# its a good idea to extract out the station data, and only combine
# the result data to the station data when needed using some sort of join

# a lot of the stations are really near each other here I experiment clustering
# nearby stations and create more complete datasets from there

library(geosphere)

# create a distance matrix from the station lat longs
# at the end this is casted to a dist object in order to use
# it iwth the built in clustering methods in R
station_distances <- bvr_stations %>%
  select(lon, lat) %>%
  distm() %>%
  as.dist()

# create the cluster object from the distances
station_hc <- hclust(station_distances)

# implement the cluster based on the a 2km distance (here these are in meters)
station_cluster <- cutree(station_hc, h = 2000)

# append these cluters to the stations dataframe, note that the order of these
# has not changed from the select() in the above therefore we can just append
# I encode these clusters as letters to facilitate plotting
bvr_stations_clustered <-
  bvr_stations %>%
  mutate(
    group = LETTERS[station_cluster]
  )

# join these clusters to the data itself by just left joining
bvr_wq_with_clusters <-
  bvr_wq %>%
  left_join(select(bvr_stations_clustered, station_id, group))

bvr_stations_clustered %>%
  ggplot(aes(lat, lon, color=group)) + geom_point()

bvr_wq_with_clusters %>%
  filter(characteristic_name == "Turbidity") %>%
  group_by(group) %>%
  summarise(
    total_obs = n()
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



# CEDEN Data ----------------------------------------------------------------

ceden_lookups <-c(
  "Program" = "program",
  "ParentProject" = "parent_project",
  "StationCode" = "station_id",
  "SampleDate" = "date",
  "CollectionTime" = "time",
  "CollectionDepth" = "depth",
  "UnitCollectionDepth" = "depth_unit",
  "Analyte" = "analyte",
  "Unit" = "unit",
  "Result" = "result",
  "TargetLatitude" = "latitude",
  "TargetLongitude" = "longitude",
  "...13" = "d2",
  "...14" = "d3",
  "Project" = "project",
  "StationName" = "station_name",
  "LocationCode" = "location_code",
  "SampleTypeCode" = "d4",
  "CollectionReplicate" = "d5",
  "ResultsReplicate" = "d6",
  "LabBatch" = "d7",
  "LabSampleID" = "d8",
  "MatrixName" = "matrix_name",
  "MethodName" = "method_name",
  "Observation" = "observation",
  "MDL" = "d9",
  "RL" = "dd1",
  "ResultQualCode" = "result_qual_code",
  "QACode" = "qa_code",
  "BatchVerification" = "batch_verification",
  "ComplianceCode" = "compliance_code",
  "SampleComments" = "sample_comments",
  "CollectionComments" = "collection_comments",
  "ResultsComments" = "result_comments",
  "BatchComments" = "batch_comments",
  "EventCode" = "event_code",
  "ProtocolCode" = "protocol_code",
  "SampleAgency" = "sample_agency",
  "GroupSamples" = "group_samples",
  "CollectionMethodName" = "collection_method_name",
  "CollectionDeviceDescription" = "collection_device_description",
  "CalibrationDate" = "calibration_date",
  "PositionWaterColumn" = "position_water_column",
  "PrepPreservationName" = "prep_preservation_name",
  "PrepPreservationDate" = "prep_preservation_date",
  "DigestExtractMethod" = "digest_extract_method",
  "DigestExtractDate" = "digest_extract_date",
  "AnalysisDate" = "analysis_date",
  "DilutionFactor" = "dilution_factor",
  "ExpectedValue" = "expected_value",
  "LabAgency" = "lab_agency",
  "SubmittingAgency" = "submitting_agency",
  "SubmissionCode" = "submission_code",
  "OccupationMethod" = "occupation_method",
  "StartingBank" = "starting_bank",
  "DistanceFromBank" = "distance_from_bank",
  "UnitDistanceFromBank" = "unit_distance_from_bank",
  "StreamWidth" = "stream_width",
  "UnitStreamWidth" = "unit_stream_width",
  "StationWaterDepth" = "station_water_depth",
  "UnitStationWaterDepth" = "unit_station_water_depth",
  "HydroMod" = "hydro_mod",
  "HydroModLoc" = "hydro_mod_loc",
  "LocationDetailWQComments" = "location_deltail_wq_comments",
  "ChannelWidth" = "channel_width",
  "UpstreamLength" = "upstream_length",
  "DownstreamLength" = "downstream_length",
  "TotalReach" = "total_reach",
  "LocationDetailBAComments" = "location_detail_ba_comments",
  "county" = "county",
  "county_fips" = "county_fibs",
  "regional_board" = "regional_board",
  "rb_number" = "rb_number",
  "huc8" = "huc8",
  "huc8_number" = "huc8_number",
  "huc10" = "huc10",
  "huc10_number" = "huc10_number",
  "huc12" = "huc12",
  "huc12_number" = "huc12_number",
  "waterbody_type" = "waterbody_type",
  "SampleID" = "Sample_id"
)



ceden_raw <- read_xlsx("data-raw/water-quality/CEDEN.xlsx", skip = 2,
                       col_names = as.character(ceden_lookups))

# seperate observations data frame from locations data frame
ceden_wq <- ceden_raw %>%
  transmute(
    program,
    station_id,
    date_time = ymd_hms(paste(format(date, "%Y-%m-%d"), format(time, "%H:%M:%S"))),
    analyte,
    unit,
    result,
    matrix_name,
    result_qual_code
  )

ceden_wq_stations <- ceden_raw %>%
  select(
    station_id,
    station_name,
    lat = latitude,
    lon = longitude,
    county,
    county_fibs,
    regional_board,
    starts_with("huc"),
    waterbody_type
  ) %>% distinct(station_id, .keep_all = TRUE)


# Do stations overlap?
library(leaflet)

leaflet() %>%
  addTiles() %>%
  addMarkers(data=bvr_stations) %>%
  addCircleMarkers(data=ceden_wq_stations %>%
                     filter(lat >= bounding_box[2], lat <= bounding_box[4],
                            lon >= bounding_box[1], lon <= bounding_box[3])
  )


