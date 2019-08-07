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

