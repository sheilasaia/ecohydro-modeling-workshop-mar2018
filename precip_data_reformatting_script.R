# reformat daily precip text file

# set working directory
setwd('/Users/ssaia/Documents/GitHub/ecohydro-modeling-workshop-mar2018/data/swat_input_data/precip_data/')

# load libraries
library(tidyverse)
library(lubridate)

# define date sequence based on first row of text file (this is the start date of the daily precip data)
date_seq = seq(ymd('1979-01-01'), ymd('2014-07-31'), by='days')

# reformat daily precip data to monthly precip data
monthly_precip_data = read_table('p354-775.txt') %>%
  mutate(date_seq = date_seq, year = year(date_seq), month = month(date_seq), precip_mm = `19790101`, date = paste0(year, "_", month)) %>%
  filter(year >= 1997 & year <= 2010) %>%
  select(date, year, month, precip_mm) %>% # in mm
  group_by(date) %>%
  summarize(year = unique(year), month = unique(month), monthly_precip_mm = sum(precip_mm)) %>%
  mutate(gauge_id = "p354-775")

# write file
write_csv(monthly_precip_data, '/Users/ssaia/Documents/GitHub/ecohydro-modeling-workshop-mar2018/data/swat_input_data/precip_data/p354-775_reformatted.csv')


