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




# parse the data (make columns the corrent data type)
results_2005 %>%
  mutate(
    datetime1 = ymd_h(paste0(date, " ", time)),
    datetime2 = ymd_hm(paste0(date, " ", time))
  ) %>% View()
# plot

# write data
