## Elevation Differences

### 10 years

For the ten year difference I look at the 2018 elevation minus the 2008 elevation.
Not all wells are represented in this difference, of the 23 only 21 have values for
both 2008 and 2018.

```{r}
ten_year_difference <- elevation_data %>%
  filter(month(date) %in% 8:11, year(date) %in% c(2018, 2008)) %>%
  mutate(year = year(date)) %>%
  select(-date) %>%
  spread(year, wse) %>%
  mutate(difference = `2018` - `2008`) %>%
  filter(!is.na(difference))

ten_year_difference %>%
  ggplot(aes(difference)) + geom_histogram(binwidth = 4, color="#949494") +
  labs(title = "Elevation Change 2008 to 2018",
       x = "Elevation Difference (feet)")
```

```{r}
ten_year_difference_with_lat_long <-
  ten_year_difference %>%
  left_join(stations_with_recent_data, by=c("site_code"="site_code"))

difference_2008_2018_pal <- colorNumeric("Spectral",
                                         ten_year_difference_with_lat_long$difference)

ten_year_difference_with_lat_long %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(fillColor = ~difference_2008_2018_pal(difference),
                   color="#666666", weight = 2, fillOpacity = 1,
                   popup = ~paste0("Elevation Change: ", round(difference, 1))) %>%
  addLegend(values = ~difference, pal=difference_2008_2018_pal)
```


As is shown in the histogram most of values are close to zero, with two pontential
outliers on both sides. To determine if these are in fact outliers we will need to
explore differences across multiple decades. In the section below I do exactly this,
iterate through all decades in the data compute differences at these wells.

```{r}
decade_differences <- purrr::map_df(1980:2018, function(y) {
  year1 <- y - 10
  year2 <- y

  elevation_data %>%
    filter(month(date) %in% 8:11, year(date) %in% c(year1, year2)) %>%
    mutate(year = ifelse(year(date) == year1, "start_year", "end_year")) %>%
    select(-date) %>%
    group_by_at(vars(-wse)) %>%  # group by everything other than the value column.
    mutate(row_id=1:n()) %>% ungroup() %>%
    spread(year, wse) %>%
    mutate(difference = end_year - start_year,
           diff_id = paste0(year1, "_", year2),
           end_year = year2) %>%
    filter(!is.na(difference))
}) %>% left_join(stations_with_recent_data, by=c("site_code"="site_code"))

```

```{r}
decade_differences %>%
  ggplot(aes(difference)) + geom_histogram() +
  labs(x = "Decade Differences (feet)",
       title = "Decade Elevation Changes (1980-2018)")
```

The above is showing all decade differences for all wells that have recent data.
The shape is very similar to what we saw in the 2008 to 2018 change, the outliers
however are just tail ends to this larger distribution.

```{r}
decade_differences_avg <-
  decade_differences %>%
  group_by(site_code) %>%
  summarise(
    avg_diff = mean(difference, na.rm = TRUE),
    lat = first(lat),
    lng = first(lng)
  )

decade_differences_pal <- colorNumeric("Spectral",
                                       domain = decade_differences_avg$avg_diff)

decade_differences_avg %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(fillColor = ~decade_differences_pal(avg_diff),
                   fillOpacity = 1,
                   color = "#666666", weight = 2,
                   popup = ~paste0("Avg Difference: ", round(avg_diff))) %>%
  addLegend(pal = decade_differences_pal, values = ~avg_diff)
```

We can explore if there is any trend in the data by plotting the these differences
on a scatter plot.

```{r}
decade_differences %>%
  ggplot(aes(end_year, difference)) + geom_point(alpha=0.5) +
  geom_smooth()
```

### 5 years

For the 5 year difference I look at the elevation change between 2012 and 2017.
The distrubution is once again clustered around 0. We can get a better picture of
what a 5 year change looks like by iterating through all possible 5 year changes.


```{r}
five_year_difference <- elevation_data %>%
  filter(month(date) %in% 8:11, year(date) %in% c(2017, 2012)) %>%
  mutate(year = year(date)) %>%
  select(-date) %>%
  spread(year, wse) %>%
  mutate(difference = `2017` - `2012`) %>%
  filter(!is.na(difference))

five_year_difference %>%
  ggplot(aes(difference)) + geom_histogram(binwidth = 4, color="#949494") +
  labs(title = "Elevation Change 2013 to 2018",
       x = "Elevation Difference (feet)")
```


```{r}
five_year_differences <- purrr::map_df(1980:2018, function(y) {
  year1 <- y - 5
  year2 <- y

  elevation_data %>%
    filter(month(date) %in% 8:11, year(date) %in% c(year1, year2)) %>%
    mutate(year = ifelse(year(date) == year1, "start_year", "end_year")) %>%
    select(-date) %>%
    group_by_at(vars(-wse)) %>%  # group by everything other than the value column.
    mutate(row_id=1:n()) %>% ungroup() %>%
    spread(year, wse) %>%
    mutate(difference = end_year - start_year,
           diff_id = paste0(year1, "_", year2),
           end_year = year2) %>%
    filter(!is.na(difference))
})

```

```{r}
five_year_differences %>%
  ggplot(aes(difference)) + geom_histogram() +
  labs(x = "5-year Differences (feet)",
       title = "5-year Elevation Changes (1980-2018)")
```

The above is showing all decade differences for all wells that have recent data.
The shape is very similar to what we saw in the 10 year difference, fairly
symmetrical around 0. At first glance its pretty obvious that we would not have
sufficient evidence to disprove a null hypothesis stating no change in elevation
has happened.

We can explore if there is any trend in the data by plotting the these differences
on a scatter plot.

```{r}
five_year_differences %>%
  ggplot(aes(end_year, difference)) + geom_point(alpha=0.5) +
  geom_smooth() +
  scale_x_continuous(breaks = seq(1980, 2018, by = 5))
```


### 1-year change
