library(tidyverse)
library(lubridate)

# read in the data------------------------------------------------------
lakelive_results_files <-
  list.files(path = "./data-raw/fish/",
    pattern="lakelive_results*",
    full.names = T)

lakelive_results_all <- lakelive_results_files %>%
  map_df(~read_csv(.))

# filter adobe creek data only
lakelive_results_adobe <- filter(lakelive_results_all, creek == "Adobe")

# comments on raw data:

# -"time" entries are missing from ~60% of entries
# -"time" entries are in format H or HH instead of HH:MM in some observations
# -location names are inconsistent: i.e. "Finley East" and "Finley East Road"
# probably refer to same location. Likewise for "Soda Bay", "Soda Bay Rd", "SBR"
# -location names are missing for some observations
# "fish" values include  symbols ("?", "+", "-"), ranges of numbers ("75-100"),
# and text strings


# parse the data (make columns the corrent data type)--------------------

# paste in :00 to times that only have hours

# is there a function in R that eliminates the need for nested if_else?

lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(
    time2 =
      if_else(str_length(time)== 4,
        paste0(substr(time, 1, 2), ":00", substr(time, 3, 4)),
          if_else((str_length(time)== 3),
            paste0(substr(time, 1, 1), ":00", substr(time, 2, 3)), time
          ), time
      )
  ) %>%

# convert date and time to datetime column

  mutate(
    datetime = ymd_hm(paste0(date, " ", time2))
  )

# make location names uniform
location_list = c()
x = c("one" = 1, "two" = 2)

x["one"]


lakelive_results_adobe %>%
  group_by(location) %>%
  summarise( count = n()) %>%
  view()

locations_lits
lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(
    location2 =


  )

# plot----------------------------------------------------------------

# write data------------------------------------------------------------
