library(adobeCreekData)
library(lubridate)

# GROUNDWATER ==================================================================
# Groundwater levels by year
groundwater_levels %>%
  mutate(
    year = year(measurement_date)
  ) %>%
  group_by(year) %>%
  summarise(
    year_avg = mean(ws_reading, na.rm = TRUE),
    year_max = max(ws_reading, na.rm = TRUE),
    year_min = min(ws_reading, na.rm = TRUE)
  ) %>%
  gather(metric, value, -year) %>%
  ggplot(aes(year, value, color=metric)) + geom_line() + geom_point() +
  scale_x_continuous(breaks = seq(1950, 2019, by=5))

# Groundwater Levels by Month
groundwater_levels %>%
  mutate(
    month = factor(month.abb[month(measurement_date)], levels = month.abb)
  ) %>%
  group_by(month) %>%
  summarise(
    month_avg = mean(ws_reading, na.rm = TRUE),
    month_max = max(ws_reading, na.rm = TRUE),
    month_min = min(ws_reading, na.rm = TRUE)
  ) %>%
  gather(metric, value, -month) %>%
  ggplot(aes(month, value, color=metric)) + geom_line() + geom_point()


# TRANSDUCER DATA ==============================================================

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



