library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(leaflet)
stations <- read.csv(file = "./sf-bay-area-bike-share/station.csv")
#trips = read.csv(file = "./sf-bay-area-bike-share/trip.csv")
trips = read.csv(file = "./sf-bay-area-bike-share/trip_withCity.csv")