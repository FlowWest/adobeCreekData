lake_county_meteor <- read_csv("data-raw/meteor/noaa-lake-county-precipitation-1970-1977.csv",
                               col_types = "ccDccddddddd") %>%
  select(date = DATE, precipitation = PRCP)

lake_county_meteor %>%
  ggplot(aes(date, precipitation)) + geom_line()

usethis::use_data(lake_county_meteor, overwrite = TRUE)
