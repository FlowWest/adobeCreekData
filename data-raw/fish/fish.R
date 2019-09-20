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


# parse the data (make columns the correct data type)--------------------


# fixing time column -------------------------------
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

# fixing location column IN PROGRESS ------------------------------------------

# make locations all lowercase
lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(
    location2 = tolower(location)
  )

# initialize location3 column
lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(location3 = NA)

# create function to help normalize strings

# this function searches for search_criteria string in location2 column. if TRUE
# it enters output_string in location3, if FALSE it leaves location3 as NA.
location_fix <-
  function(data_frame, search_criteria, output_string) {
    if(is.na(location3)) {
      mutate(
        location3 = if(
          grepl(search_criteria, location2)) {output_string}
      )
    }
}

# normalize locations beginning with argonaut


lakelive_results_adobe <- lakelive_results_adobe %>%
  location_fix("^argonaut", "argonaut_rd")

lakelive_results_adobe <- lakelive_results_adobe %>%
  if(is.na(location3)) {
    mutate(
      location3 = if(
        grepl(search_criteria, location2)) {output_string}
   )
  }

lakelive_results_adobe %>%
  is.na(location2)

#normalize locations beginning with finley
  mutate(
    location3 = if_else(grepl("^finley", location2), "finley_east_rd", location2)
  )

lakelive_results_adobe %>%
  location3 != location2

location_list = c()
x = c("one" = 1, "two" = 2)

x["one"]


lakelive_results_adobe %>%
  group_by(location) %>%
  summarise( count = n()) %>%
  view()

lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(
    location2 =


  )

# plot----------------------------------------------------------------

# write data------------------------------------------------------------
