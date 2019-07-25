#------------------------------------------------------------------------------
# Description:
# Scrape tables from:
# - https://lakelive.info/chicouncil/locations.htm
# - https://lakelive.info/chicouncil/2005results.htm (years 2005-2018)

#------------------------------------------------------------------------------
# Load packages
library(xml2)
library(rvest)
library(tidyverse)

# locations
loc_url <- read_html("https://lakelive.info/chicouncil/locations.htm")
loc_table <- loc_url %>%
  html_table("table", header = TRUE, fill = TRUE)
write_csv(loc_table[[1]], "data/lakelive_locations.csv")

# results
years <- c(2005:2018)
for (year in years){
  if (year < 2013){
    result_url <- read_html(paste("https://lakelive.info/chicouncil/",
                                  toString(year), "results.htm", sep = ""))
    print(year)
  }
  else{
    result_url <- read_html(paste("https://lakelive.info/chicouncil/",
                                  toString(year), "results.html", sep = ""))
    print(year)
  }
  result_table <- result_url %>%
    html_table("table", header = TRUE, fill = TRUE)
  write_csv(result_table[[1]], paste("data/lakelive_results", toString(year),
                                     ".csv", sep = ""))
}

