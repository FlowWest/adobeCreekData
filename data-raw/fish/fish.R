library(tidyverse)
library(lubridate)

# Results -----------------------------------------------------------------

# read in the data
results_2005 <- read_csv("data-raw/fish/lakelive_results2005.csv")
results_2005 %>% glimpse()

# parse the data (make columns the corrent data type)
results_2005 %>%
  mutate(
    datetime1 = ymd_h(paste0(date, " ", time)),
    datetime2 = ymd_hm(paste0(date, " ", time))
  ) %>% View()
# plot

# write data
