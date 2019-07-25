library(tidyverse)
library(xml2)
library(rvest)
library(lubridate)

chi_council_2005_results <- read_html(chi_council_2005_results_URL) %>%
  html_node("table") %>%
  html_table(trim = TRUE) %>%
  select(
    creek, location, date, time, no_fish_raw = `number of fish`
  ) %>% as_tibble() %>%
  mutate(
    date = mdy(date),
    no_fish = readr::parse_number(no_fish_raw)
  )

# locations -------------------------------------------------------------------
loc_url <- read_html("https://lakelive.info/chicouncil/locations.htm")
loc_table <- loc_url %>%
  html_table("table", header = TRUE, fill = TRUE) %>%
  .[[1]] %>%
  as_tibble() %>%
  select(
    no = "#",
    creek = "creek",
    bridge_1 = "bridge #1",
    bridge_2 = "bridge#2",
    bridge_3 = "bridge #3",
    bridge_4 = "bridge #4",
    bridge_5 = "bridge #5"
    # need to add that last column too!
  )
# loc_table

write_csv(loc_table, "data-raw/fish/lakelive_locations.csv")

# results ---------------------------------------------------------------------
years <- c(2005:2018)
for (year in years){
  if (year < 2013){
    result_url <- read_html(paste("https://lakelive.info/chicouncil/",
                                  toString(year), "results.htm", sep = ""))
  }
  else{
    result_url <- read_html(paste("https://lakelive.info/chicouncil/",
                                  toString(year), "results.html", sep = ""))
  }
  result_table <- result_url %>%
    html_table("table", header = TRUE, fill = TRUE) %>%
    .[[1]] %>%
    select(
      creek, location, date, fish = "number of fish", observer, comments
    ) %>%
    as_tibble() %>%
    mutate(
      date = mdy(date) #,
      # no_fish = readr::parse_number(no_fish_raw)
    )
  write_csv(result_table, paste("data-raw/fish/lakelive_results", toString(year),
  ".csv", sep = ""))
}

