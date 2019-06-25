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
    year_avg = mean(wse, na.rm = TRUE),
    year_max = max(wse, na.rm = TRUE),
    year_min = min(wse, na.rm = TRUE)
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


groundwater_levels %>%
  filter(site_code %in% good_sites) %>%
  ggplot(aes(measurement_date, ws_reading, color=site_code)) + geom_line()



range_for_transducer <- range(pressure_transducer$dateTime)

groundwater_levels %>%
  filter(measurement_date >= range_for_transducer[1]) %>%
  ggplot(aes(y=ws_reading)) + geom_boxplot()


