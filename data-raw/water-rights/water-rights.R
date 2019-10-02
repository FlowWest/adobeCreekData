library(readxl)

water_rights_raw <- read_xlsx("data-raw/water-rights/Water_Rights_Kelsey_Adobe_Creeks__2_.xlsx",
                              sheet = "Adobe Creek Water Rights",
                              skip = 1)

water_rights_data_colnames <- water_rights_raw %>%
  select(-starts_with("...")) %>%
  colnames()

water_rights_columns_corrected <-  c(
  "application_id", "permit_id", "water_rights_type", "current_status",
  "holder_name", "date_of_status", "face_amount", "date_of_first_known_use", "total_known_diversion",
  paste(
  rep(1967:2014, each = 3),
  water_rights_data_colnames[10:length(water_rights_data_colnames)],
  sep = "_") %>%
  str_replace(
    string = .,
    pattern = "...[0-9]+$", ""
  ))

water_rights_data <- water_rights_raw %>%
  select(-starts_with("..."))

colnames(water_rights_data) <- water_rights_columns_corrected

adobe_water_rights <- water_rights_data %>%
  filter(!is.na(application_id)) %>%
  gather(type, value, `1967_Maximum Annual Draw (Gallons)`:`2014_Purpose of Use`) %>%
  separate(type, sep = "_", into=c("year", "metric")) %>%
  mutate(year = as.numeric(year),
         value = as.numeric(value))

adobe_water_rights %>%
  filter(metric == "Total Annual Draw (Gallons)") %>%
  ggplot(aes(year, value, fill=holder_name)) + geom_col(position = "stack") +
  scale_x_continuous(breaks = seq(1965, 2015, by = 5)) +
  scale_fill_brewer(palette = "Set2")
