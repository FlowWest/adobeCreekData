library(tidyverse)
library(xml2)
library(rvest)
library(lubridate)
library(dplyr)
library(magrittr)

# locations -------------------------------------------------------------------
loc_url <- read_html("https://lakelive.info/chicouncil/locations.htm")
loc_table <- loc_url %>%
  html_table("table", header = TRUE, fill = TRUE) %>%
  .[[1]] %>%
  as_tibble() %>%
  replace(. == "\u00A0" | . == "", NA) %>%
  rename(
    number = "#",
    creek = "creek",
    bridge_1 = "bridge #1",
    bridge_2 = "bridge#2",
    bridge_3 = "bridge #3",
    bridge_4 = "bridge #4",
    bridge_5 = "bridge #5",
    unnamed_col = "\u00A0"
  )

write_csv(loc_table, "data-raw/fish/lakelive_locations.csv")

# results ---------------------------------------------------------------------
years <- c(2005:2018)
for (year in years){
  print(year)
  # construct the url
  if (year < 2013){
    result_url <- read_html(paste("https://lakelive.info/chicouncil/",
                                  toString(year), "results.htm", sep = ""))
  }
  else{
    result_url <- read_html(paste("https://lakelive.info/chicouncil/",
                                  toString(year), "results.html", sep = ""))
  }

  # extract table from website
  if (year < 2011){
    result_table <- result_url %>%
      html_table("table", header = TRUE, fill = TRUE) %>%
      .[[1]] %>%
      as_tibble() %>%
      replace(. == "\u00A0" | . == "", NA) %>%
      rename(fish = "number of fish") %>%
      mutate(date = mdy(date))
  }
  else if (year == 2017){
    result_table <- result_url %>%
      html_nodes("table") %>%
      .[[2]] %>%
      html_table(header = TRUE, fill = TRUE) %>%
      as_tibble(.name_repair = "unique") %>%
      replace(. == "\u00A0" | . == "", NA) %>%
      select(
        date,
        time,
        creek,
        location,
        fish = "number of fish",
        comments,
        observer
        ) %>%
      mutate(date = mdy(date))
  }
  else {
    result_table <- result_url %>%
      html_nodes("table") %>%
      .[[2]] %>%
      html_table(header = TRUE, fill = TRUE) %>%
      as_tibble() %>%
      replace(. == "\u00A0" | . == "", NA) %>%
      rename(fish = "number of fish") %>%
      mutate(date = mdy(date))
  }
  # write extracted table to csv
  write_csv(result_table, paste("data-raw/fish/lakelive_results", toString(year),
                                ".csv", sep = ""))
}

