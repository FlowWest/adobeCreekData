library(tidyverse)
library(lubridate)

# Results -----------------------------------------------------------------

# read in the data
lakeslive_results_all <-
  list.files(path = "./data-raw/fish/",
    pattern="lakelive_results*",
    full.names = T) %>%
  map_df(~read_csv(.))

#filter adobe creek data only
lakelive_results_adobe <- filter(lakeslive_results_all, creek == "Adobe")

#comments on raw data:

#-"time" entries are missing from certain year entirely
#-"time" entries are in format H or HH instead of HH:MM
#-location names are inconsistent: i.e. "Finley East" and "Finley East Road"
#probably refer to same location. Likewise for "Soda Bay", "Soda Bay Rd", "SBR"
#-location names are missing
#"fish" values include "?" and "+" symbols




# parse the data (make columns the corrent data type)
results_2005 %>%
  mutate(
    datetime1 = ymd_h(paste0(date, " ", time)),
    datetime2 = ymd_hm(paste0(date, " ", time))
  ) %>% View()
# plot

# write data
