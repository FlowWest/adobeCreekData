library(adobeCreekData)
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
# and text strings. once "+" and "s" are removed the numbers can be plotted, but
# it may change the meaning of the data-- "1000" is different than "1000s"--
# replacing "1000s" with "10,000" (for example) introduces additional uncertainty
# so I have just removed the additional characters.
# use this data knowing fish numbers are fuzzy.


# parse the data (make columns the correct data type)--------------------


# fixing date column to date format-------------------------------

# @NICK its not a good idea to reassign a data frame back to itself
# even if it means that variable names get long
# for example here I would call the new df "lakelive_results_adobe_dates_parsed"
lakelive_results_adobe_dates_parsed <- lakelive_results_adobe %>%
  mutate(
    date2= ymd(date)
  ) %>%
  mutate(
    location2 = tolower(location)
  )


# fixing location column ------------------------------------------

# @NICK same as above regarding the naming.....
# @NICK notice that you can combine these two operations the date2 and location2
# into a single mutate, try that out

# make locations all lowercase


# normalize string names
lakelive_results_adobe2 <- lakelive_results_adobe_dates_parsed %>%
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

# get rid of extraneous characters and notes typed in fish column
# and extract lower range of fish numbers when range is given

lakelive_results_adobe3 <- lakelive_results_adobe2 %>%
  mutate(fish2 = case_when(
    str_detect(fish, "([a-z]{4})") & (str_length(fish) > 4)
    ~ NA_character_,
    str_detect(fish, "([/ \\+ \\- \\( \\) \\? s]{3})") & (str_length(fish) > 3)
    ~ str_sub(fish, 1, -4),
    str_detect(fish, "([/ \\+ \\- \\( \\) \\? s]{2})") & (str_length(fish) > 2)
    ~ str_sub(fish, 1, -3),
    str_detect(fish, "[/ \\+ \\- \\( \\) \\? s]$") & (str_length(fish) > 1)
    ~ str_sub(fish, 1, -2),
    str_detect(fish, "\\d\\-\\d")
    ~ sapply(strsplit(fish, "-"), '[', 1),
    str_detect(fish, "\\d")
    ~ fish
  ))

# @NICK try this regex outstr_match("700+", "([0-9]+$)|(([0-9]+)-([0-9]+))")
#readr::parse_number("700s")

# create another column for cases where range of fish numbers are given
# to hold upper range of fish
lakelive_results_adobe4 <- lakelive_results_adobe3 %>%
  mutate(fish3 = case_when(
    str_detect(fish, "([a-z]{4})") & (str_length(fish) > 4)
    ~ NA_character_,
    str_detect(fish, "\\d\\-\\d")
    ~ sapply(strsplit(fish, "-"), '[', 2)
  ))

#create numeric columns and calculate average in cases where range of fish was given
lakelive_results_adobe5 <- lakelive_results_adobe4 %>%
  mutate(fish2n = as.numeric(fish2)) %>%
  mutate(fish3n = as.numeric(fish3))

lakelive_results_adobe6 <- lakelive_results_adobe5 %>%
  mutate(fish4 =
          case_when(
             !is.na(fish3n) ~ (fish3n + fish2n) / 2,
             is.na(fish3n) ~ fish2n
          )
  )

# compile results into simplified table. time is ignored.

lakelive_results_adobe_final <- lakelive_results_adobe6 %>%
  transmute( creek, location = location3, date = date2, fish = fish4, observer, comments)

# plot----------------------------------------------------------------

ggplot(lakelive_results_adobe_final, aes(date, fish)) +
  geom_point()

# write data------------------------------------------------------------

# @NICK for now just use write_csv(lakelive_results_adobe_final,"data-raw/hitch-counts-2005-2019.csv")
# @NICK overall this look great! I really appreciate all of the regex work it's a great
# skill to have when wrangling data.

write_csv(lakelive_results_adobe_final, "data-raw/fish/adobe-hitch-counts-2005-2018.csv")
hitch_counts <- lakelive_results_adobe_final
usethis::use_data(hitch_counts, overwrite = TRUE)


# Hitch locations ----------------------------------------------------------------------
# these locations were mapped with google maps
# simply used intersection between the roads and the creek for lat longs

hitch_locations <- read_csv("data-raw/fish/hitch-locations.csv")


