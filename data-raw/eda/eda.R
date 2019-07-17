library(adobeCreekData)
library(lubridate)
library(magrittr)
library(tidyverse)

# GROUNDWATER ==================================================================

# what data do we actually have?
groundwater_levels %>%
  ggplot(aes(measurement_date, wse, color=groundwater_levels)) + geom_line()

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

# the top wells with data
top_5 <- groundwater_stations %>%
  filter(year(end_date) == 2019) %>%
  arrange(desc(total_measures)) %>%
  head(5) %>% pull(site_code)

groundwater_levels %>%
  filter(site_code %in% top_5,
         year(measurement_date) >= 2000) %>%
  ggplot(aes(site_code, wse, fill=site_code)) + geom_boxplot()
