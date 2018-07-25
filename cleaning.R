stations <- read.csv(file = "./sf-bay-area-bike-share/station.csv")
stations$installation_date <- NULL
stations %>% write.csv(file = './sf-bay-area-bike-share/station_trimmed.csv', row.names=FALSE)
stations <- read.csv(file = './sf-bay-area-bike-share/station_trimmed.csv', stringsAsFactors = T)

trips = read.csv(file = "./sf-bay-area-bike-share/trip.csv")
trips$installation_date <- NULL
trips$zip_code <- NULL
trips$bike_id <-NULL

#removing rows from trips which have a station absent in stations. 
trips = semi_join(trips,stations, by =c('start_station_name'='name', 'end_station_name'='name'))
trips[, drop=T]
trips %>% write.csv('./sf-bay-area-bike-share/trip_trimmed.csv', row.names=FALSE)

full_join(trips,stations, by = c("start_station_name"="name")) %>% 
    write.csv('./sf-bay-area-bike-share/trip_withCity.csv')
trips = read.csv(file = "./sf-bay-area-bike-share/trip_withCity.csv")
trips$X <- NULL
trips$id.x <- NULL
trips$id.y <-NULL
trips$start_station_id <-NULL
trips$end_station_id <-NULL

trips %>% write.csv('./sf-bay-area-bike-share/trip_withTime.csv', row.names=FALSE)
