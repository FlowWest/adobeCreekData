# get water surface elevation for the lake

# station: 11450000
# param code: 00065

library(dataRetrieval)
library(tidyverse)

clear_lake_wse_raw <- readNWISdv("11450000", parameterCd = "00065",
                                 startDate = "1999-01-01")

clear_lake_wse <- clear_lake_wse_raw %>%
  transmute(
    agency_cd,
    site_no,
    date = Date,
    gage_height_ft = X_00065_00003
  ) %>% as_tibble()


clear_lake_wse %>%
  ggplot(aes(date, gage_height_ft)) + geom_line()

usethis::use_data(clear_lake_wse)
