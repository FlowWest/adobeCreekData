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
# -"fish" values include  symbols ("?", "+", "-"), ranges of numbers ("75-100"),
# and text strings


# parse the data (make columns the correct data type)--------------------


# fixing date column to date format-------------------------------

lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(
    date2= ymd(date)
  )


# fixing location column ------------------------------------------

# make locations all lowercase
lakelive_results_adobe <- lakelive_results_adobe %>%
  mutate(
    location2 = tolower(location)
  )

# normalize string names
lakelive_results_adobe2 <- lakelive_results_adobe %>%
  mutate(location3 = case_when(
    str_detect(location2, "argonaut") ~ "argonaut_rd",
    str_detect(location2, "bell") ~ "bell_hill_rd",
    str_detect(location2, "big valley") ~ "big_valley_rd",
    str_detect(location2, "clear|mouth") ~ "clear_lake",
    str_detect(location2, "finley") ~ "e_finley_rd",
    str_detect(location2, "harris") ~ "harris_ave",
    str_detect(location2, "highland|dam") ~ "highland_springs_dam",
    str_detect(location2, "man") ~ "manning_br",
    str_detect(location2, "merrit") ~ "merrit_rd",
    str_detect(location2, "sbr") ~ "soda_bay_rd",
    str_detect(location2, "scully") ~ "scully_meadow",
    str_detect(location2, "soda") ~ "soda_bay_rd",
    str_detect(location2, "stone") ~ "stone_rd",
    str_detect(location2, "thomas") ~ "thomas_rd",
    str_detect(location2, "29") ~ "hwy_29",
    str_detect(location2, "14") ~ "14c-2"
  ))

# fixing "fish" column IN PROGRESS--------------------------------------

lakelive_results_adobe3 <- lakelive_results_adobe2 %>%
  mutate(fish2 = case_when(
    str_detect(fish, "([\\+ \\- \\( \\) \\?]{3})") & (str_length(fish) > 3)
    ~ str_sub(fish, 1, -4),
    str_detect(fish, "([\\+ \\- \\( \\) \\?]{2})") & (str_length(fish) > 2)
    ~ str_sub(fish, 1, -3),
    str_detect(fish, "[\\+ \\- \\( \\) \\?]$") & (str_length(fish) > 1)
    ~ str_sub(fish, 1, -2),
    str_detect(fish, "\\d\\-\\d")
    ~ str_sub(fish, 1, str_locate(fish, "-")[[1]][1]-1)
  ))

str_sub("100-200", 1, str_locate("100-200", "-")[[1]][1]-1)

#regular expression syntax seems to mess with function arguments

lakelive_results_adobe3 <- lakelive_results_adobe2 %>%
  mutate(fish2 = case_when(
    str_detect(fish, "^\?") ~ NA,
    str_detect(fish, "[+-]$") ~ "test"
  ))
substr(fish, 1, str_length(fish)-1)
lakelive_results_adobe2 %>%
  mutate(
    fish2 = substr(fish, 1, str_length(fish)-1))

str_detect(lakelive_results_adobe2$fish, "[+-]$")


# plot----------------------------------------------------------------

# write data------------------------------------------------------------
