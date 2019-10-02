library(readxl)

water_rights_raw <- read_xlsx("data-raw/water-rights/Water_Rights_Kelsey_Adobe_Creeks__2_.xlsx",
                              sheet = "Adobe Creek Water Rights",
                              skip = 1)

colnames(water_rights_raw)
