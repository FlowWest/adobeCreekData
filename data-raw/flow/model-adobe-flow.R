library(mgcv)
library(tidyverse)

adobe_creek_flow
kelsey_creek_flow
highland_creek_flow

# first thing we need to do is create the adobe creek after the junction
# with the highland creek. This means summmingt up highland creek and adobe
# creek flow

adobe_downstream_flow <- adobe_creek_flow %>%
  rename(adobe_cfs = flow_cfs) %>%
  left_join(highland_creek_flow %>% rename(highland_cfs = flow_cfs),
            by = c("date" = "date")) %>%
  filter(!is.na(highland_cfs)) %>%
  mutate(adobe_downstream_cfs = adobe_cfs + highland_cfs)


bvr_flow <-
  adobe_downstream_flow %>%
  left_join(kelsey_creek_flow %>% rename(kel_flow = flow_cfs),
            by = c("date" = "date")) %>%
  filter(!is.na(kel_flow)) %>%
  select(date, adobe_cfs, highland_cfs, adobe_downstream_cfs,
         kel_cfs = kel_flow) %>%
  left_join(clear_lake_wse %>% select(date, lake_elev_ft = gage_height_ft)) %>%
  left_join(lake_county_meteor)



gam_model <- gam(adobe_downstream_cfs ~ s(kel_cfs, bs = "cs"), data=train)

summary(gam_model)

gam_model_test_results <-
  tibble(
    idx = seq_along(test$date),
    date = test$date,
    actual = test$adobe_downstream_cfs,
    predicted = predict(gam_model, newdata = test),
    resids = actual - predicted
  )

gam_model_test_results %>%
  filter(month(date) %in% 2:4) %>%
  ggplot(aes(date, actual, color = "Actual")) + geom_line() +
  geom_line(aes(date, predicted, color = "Prediction"))

gam_model_test_results %>%
  ggplot(aes(predicted, actual)) + geom_point() +
  geom_abline(intercept = 0, slope = 1, linetype = 2)

gam_model_test_results %>%
  ggplot(aes(date, resids)) + geom_point()

gam_model_test_results %>%
  arrange(actual) %>%
  ggplot(aes(actual, resids)) + geom_point()

gam_model_test_results %>%
  ggplot(aes(resids)) + geom_density()

# this is where the actual data for adobe creek stops
kelsey_creek_flow_input <-
  kelsey_creek_flow %>%
  filter(date >= "1977-10-01")

adobe_creek_downstream_predicted <-
  tibble(
    date = kelsey_creek_flow_input$date,
    adobe_creek_preds = predict(gam_model,
                                newdata = select(kelsey_creek_flow_input, kel_cfs=flow_cfs))
  ) %>%
  mutate(adobe_downstream_cfs = floor(ifelse(adobe_creek_preds < 0, 0, adobe_creek_preds)))


actual_and_predicted_together <-
  adobe_downstream_flow %>%
  bind_rows(adobe_creek_downstream_predicted)


actual_and_predicted_together %>%
  filter(year(date) %in% 1977:1980) %>%
  ggplot(aes(date, adobe_downstream_cfs)) + geom_line()


kelsey_creek_flow %>%
  filter(year(date) %in% 1977:1980) %>%
  ggplot(aes(date, flow_cfs)) + geom_line()


