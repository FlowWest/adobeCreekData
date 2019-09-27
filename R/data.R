#' @title Groundwater Elevations
#' @description These are groundwater elevations for wells located in the
#' Big Valley Water Basin. The data was obtained from CASGEM.
#' \describe{
#'   \item{site_code}{a unique CASGEM code for the well}
#'   \item{measurement_date}{date when measure was taken}
#'   \item{rp_elevation}{reference point of elevation}
#'   \item{gs_elevation}{groun surface elevation}
#'   \item{ws_reading}{water surface reading}
#'   \item{rp_reading}{reference point reading}
#'   \item{wse}{water surface elevation, (defined as rp_elevation - ws_reading - rp_reading)}
#' }
#' @details
#' This data was obtained using the CASGEM data portal. A search for Big Valley
#' water basin yielded a list of over 80 wells, this dataset contains all data
#' measured from those 80 wells that were reported to CASGEM.
"groundwater_levels"

#' @title Groundwater Stations
#' @description These are the wells for which data is reported/
#' \describe{
#'   \item{site_code}{a unique CASGEM code for the well}
#'   \item{local_well_designation}{well designation for local use}
#'   \item{lat}{latitude for the well}
#'   \item{lng}{longitude for the well}
#'   \item{total_depth_ft}{total depth for the well (if not confidential)}
#'   \item{start_date}{first date measured (with CASGEM data)}
#'   \item{end_date}{most recent data with measured data}
#'   \item{total_measures}{number of measurements taken in date range}
#' }
"groundwater_stations"

#' @title Pressure Transducer Data
#' @description blah
#' \describe{
#'   \item{transducer}{name of the transducer}
#'   \item{dateTime}{date-time for the measurements}
#'   \item{depth_ft}{the depth (in feet) reported by the pressure transducer}
#'   \item{temp_c}{the temperature (in C) reported by the pressure transducer}
#' }
"pressure_transducer"

#' @title Kelsey Creek Flow
#' @description Flow at Kelsey Creek using site no: 11449500 from USGS. Data is
#' reported as the daily average.
#' \describe{
#'   \item{site_no}{site number from USGS}
#'   \item{site_name}{name for the site}
#'   \item{date}{date for observed flow}
#'   \item{flow_cfs}{flow value in cfs}
#' }
"kelsey_creek_flow"

#' @title Cache Creek near Lower Lake Flow
#' @description Flow at Cache Creek near Lower Lake using site no: 11451000 from USGS. Data is
#' reported as the daily average.
#' \describe{
#'   \item{site_no}{site number from USGS}
#'   \item{site_name}{name for the site}
#'   \item{date}{date for observed flow}
#'   \item{flow_cfs}{flow value in cfs}
#' }
"cache_creek_flow"

#' @title Flow Stations
#' @description Flow stations around Big Valley Rancheria
#' \describe{
#'   \item{agency_cd}{agency code}
#'   \item{site_no}{site number from USGS}
#'   \item{site_name}{name for the site}
#'   \item{lat}{latitide}
#'   \item{lon}{longitude}
#' }
"flow_stations"

#' @title BVR Water Quality Stations
#' @description Water Quality Stations for Big Valley Rancheria
#' \describe{
#'   \item{origin_id}{id for the orgnization collecting/supplying data}
#'   \item{station_id}{id for the station}
#'   \item{lat}{latitude}
#'   \item{lon}{longitude}
#'   \item{station_horizontal_datum}{horizontal datum for the station}
#'   \item{state}{state}
#'   \item{county}{county}
#' }
"bvr_stations"

#' @title BVR Water Quality Data
#' @description Water Quality Data measured by Big Valley Rancheria (BVR). This data
#' contains only analytes that were measured at least 10 times.
#' \describe{
#'   \item{origin_id}{id for the orgnization collecting/supplying data}
#'   \item{station_id}{id for the station (assume unique only within this orgin_id)}
#'   \item{datetime}{the date and time of observation}
#'   \item{analyte}{name of the analyte measured}
#'   \item{units}{units reported for the measurement}
#'   \item{sample_fraction}{blah}
#'   \item{value_type}{a qualifier for the type of value}
#'   \item{statistic_type}{summary statistic used in result, if none this is NA}
#'   \item{value_raw}{raw value reported from the measurement}
#'   \item{value_numeric}{the numerical value obtained from value raw}
#' }
"bvr_water_quality"

#' @title CDFA Water Quality Stations
#' @description Water Quality Stations for the California Department of Food and Ag (CDFA)
#' \describe{
#'   \item{origin_id}{id for the data supplier}
#'   \item{station_id}{id for the sttation (assume unique only within origin id)}
#'   \item{lat}{station latitude}
#'   \item{lon}{station longitude}
#' }
"cdfa_stations"

#' @title CDFA Water Quality Data
#' @description Water Quality data reported by the CDFA
#' \describe{
#'   \item{origin_id}{id for the data supplier}
#'   \item{station_id}{id for observation station}
#'   \item{datetime}{datetime of measurement}
#'   \item{unit}{unit of measure}
#'   \item{value_raw}{raw value obtained from the measurement}
#'   \item{value_numeric}{numeric version of the measurement}
#'   \item{method_name}{method used for the measurement}
#' }
"cdfa_water_quality"

#' @title CEDEN Water Quality Stations
#' @description fda
#' \describe{
#'   \item{origin_id}{id for the data supplier}
#'   \item{station_id}{id for the station}
#'   \item{lat}{latitude}
#'   \item{lon}{longitude}
#' }
"ceden_stations"

#' @title CEDEN Water Quality Data
#' @description water quality data reported by Aquatic Pesticide Monitoring Program,
#' Irrigated Lands Regulatory Program and Surface Water Ambient Monitoring Program
#' obtained through CEDEN.
#' \describe{
#'   \item{origin_id}{program or orgnization collecting data}
#'   \item{station_id}{id for station where data was measured}
#'   \item{datetime}{datetime of measurement}
#'   \item{analyte}{name of the analyte measured}
#'   \item{unit}{unit reported in the measurement}
#'   \item{value_numeric}{numeric value obtained from measurement}
#'   \item{matrix_name}{blah}
#'   \item{result_qual_code}{blah}
#' }
"ceden_water_quality"


#' @title Hitch Counts
#' @description longer
#' \describe{
#'   \item{origin_id}{program or orgnization collecting data}
#' }
#' @details
#' details abpout the data
"hitch_counts"












