library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(leaflet)
stations <- read.csv(file = "./sf-bay-area-bike-share/station_trimmed.csv",stringsAsFactors = T)

trips = read.csv(file = "./sf-bay-area-bike-share/trip_withTime.csv", stringsAsFactors = T)
trips$X <- NULL
trips$start_date = parse_date_time(trips$start_date, 'mdy HM')
trips$end_date = parse_date_time(trips$end_date, 'mdy HM')
trips$start_day = as.Date(trips$start_date)
trips$end_day = as.Date(trips$end_date)
trips$month = month(trips$start_date, label =T) # label=T --> month names as character factor 
trips$season = as.factor(ifelse(trips$month %in% c('Dec','Jan','Feb'),'Winter',
                                ifelse(trips$month %in% c('Mar','Apr','May'),'Spring',
                                       ifelse(trips$month %in% c('Jun','Jul','Aug'),'Summer','Fall'))))
trips$Weekend = as.factor(ifelse(wday(trips$start_day, label = T) %in% c('Sat','Sun'), "Weekend", "Weekday"))

#trips_hour = trips %>% group_by(h = hour(trips$start_date)) %>% 
#    summarise(N = n())

#trips_weekend = trips %>% 
#    group_by(date = start_day,Weekend) %>% 
#    summarise(N = n()) 

