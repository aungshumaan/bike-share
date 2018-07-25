#stations <- read.csv(file = "./sf-bay-area-bike-share/station.csv")
#trips = read.csv(file = "./sf-bay-area-bike-share/trip.csv")
function(input, output, session) {
    
    #output$mymap_full <- renderLeaflet({
    #    leaflet() %>%
    #    addTiles() %>%  # Add default OpenStreetMap map tiles
    #    #addMarkers(lng=stations$long, lat=stations$lat, popup=stations$name)
    #        #addProviderTiles, addCircleMarker
    #    #stations %>%filter(city %in% input$cityGroup)
    #    addCircles(lng=stations$long, lat=stations$lat, radius= stations$dock_count, 
    #           weight =20, opacity=0.3, 
    #           popup=paste(stations$name, ":",stations$dock_count, " docks"))
    #    #addPolylines(lng = c(-122.4009,-122.4008), lat = c(37.79854,37.78963))
    #})
    #Map of Stations 
    output$mymap <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%  # Add default OpenStreetMap map tiles
            addCircles(lng=(stations %>%filter(city %in% input$cityGroup))$long, 
                       lat=(stations %>%filter(city %in% input$cityGroup))$lat, 
                       radius= stations$dock_count, 
                       weight =20, opacity=0.3, 
                       popup=paste(stations$name, ":",stations$dock_count, " docks"))
    })
    
    # plot of number of docks in a station for a particular city 
    output$dock_countBycityPlot = renderPlot(
        stations %>% filter(city %in% input$cityGroup) %>% 
            ggplot(aes(x =reorder(name,dock_count), y =dock_count)) + 
            geom_bar(stat="identity", fill="red") +
            ylab("Number of docks") +
            xlab("Name of city")+
            coord_flip() +
            theme(legend.key=element_blank(), legend.position="bottom") +
            #scale_fill_brewer(palette = 'Set1') +
            theme_bw() 
        
    )
    output$min_maxdate <- renderText({ 
        paste("   You have chosen a date range that goes from",
              input$date[1], "to", input$date[2])
    })
    stafreq <- reactive({
        trips %>% 
            filter(city  == input$city) %>% 
            filter(start_day >= input$date2[1] & start_day <= input$date2[2]) %>%
            filter(hour(start_date) >= input$hour2[1] & hour(start_date) <= input$hour2[2]) %>%
            group_by(start_station_name, long, lat) %>%
            summarise(N =n())
    })
    
    # map of trip frequency
    output$mymap_freq <- renderLeaflet({
        Long  = ( stafreq()  )$long
        Lat   = ( stafreq()  )$lat
        R     = ( stafreq()  )$N
        stat  = ( stafreq()  )$start_station_name
        
        leaflet() %>%
            addTiles() %>%  # Add default OpenStreetMap map tile
            addCircles(lng=Long, lat = Lat, 
                       radius = R/100, opacity=0.5,
                       popup=paste(stat, ": ",R, " total trips")
                       )
            
                
                #,
                #popup=paste(input$name," ")
                #addPolylines(lng = c(-122.4009,-122.4008), lat = c(37.79854,37.78963)
        #)
    })
    
    output$mymap_endfreq <- renderLeaflet({
        
        df = trips %>% filter(start_station_name == input$name) %>% 
            #filter(start_day > input$date[1] & start_day < input$date[2]) %>%
            group_by(end_station_name) %>%
            summarise(N =n())
        df2  = left_join( df, stations, by =c('end_station_name'='name')) 
        
        
        leaflet() %>%
            addTiles() %>%  # Add default OpenStreetMap map tile
            addCircleMarkers(lng= (trips %>% filter(start_station_name ==input$name) %>%
                                       select(long,lat) %>% unique())$long,
                             lat = (trips %>% filter(start_station_name ==input$name) %>%
                                        select(long,lat) %>% unique())$lat,
                             color = 'red') %>%
            addCircleMarkers(lng=df2$long, lat =df2$lat, 
                       radius = df2$N/100, opacity=0.5,
                       popup=paste(df2$end_station_name, ": ",df2$N, " trips")
            ) 
     
    })
    output$endfreqPlot = renderPlot(
        trips %>% filter(start_station_name == input$name) %>%  
            #filter(start_day > input$date[1] & start_day < input$date[2]) %>%
            group_by(end_station_name) %>%
            summarise(N =n()) %>%
            ggplot(aes(x =reorder(end_station_name,N), y =N)) + 
            geom_bar(stat="identity", fill="red") +
            ylab("Number of trips") +
            xlab("Name of station") +
            coord_flip() +
            theme(legend.key=element_blank(), legend.position="bottom") +
            theme_bw() 
        
    )
    
    
    #output$trip_durationPlot = renderPlot(
    #    ggplot(data = trips %>% filter(duration < 3600) , aes(x=duration))+
    #        geom_freqpoly( binwidth = 60, aes(color=month))
    #)
    
    bla <- reactive({
    trips %>% 
        filter(duration < 3600) %>%
        filter(hour(start_date) >= input$hour[1] & hour(start_date) <= input$hour[2]) %>%
        filter(duration > input$dur[1]*60 & duration < input$dur[2]*60)
    })
    
    output$trip_seasonPlot = renderPlot(
        bla() %>%
        ggplot( aes(x=duration)) +
            geom_freqpoly( binwidth = 60, aes(color=season)) + 
            labs(y='Number of trips')
    )
    output$trip_subscriptionPlot = renderPlot(
        bla() %>%
            group_by(subscription_type, season) %>% summarise(N = n()) %>% 
            ggplot(aes(x=season,y=N))+
            geom_col(aes(fill=subscription_type),position = 'dodge') +
            labs(y='Number of trips') +
            theme(legend.position="bottom")+
            scale_fill_discrete(name="User type",
                                breaks=c("Subscriber", "Customer"),
                                labels=c("Subscription", "Pay-as-you-go"))
    )
    
    output$trip_weekendPlot = renderPlot(
        #trips_weekend %>% 
        trips %>% 
            filter(start_day >= input$date[1] & start_day <= input$date[2]) %>% 
            group_by(date = start_day,Weekend) %>% 
            summarise(N = n()) %>%
            ggplot(aes(x=date, y =N))+ geom_point(aes(color=Weekend)) +
            geom_smooth(method = 'gam',aes(color=Weekend)) +
            labs(y ='Number of trips') + 
            theme( legend.key=element_blank(), legend.position="bottom") +
            scale_color_discrete(name="", breaks=c('Weekday', 'Weekend'),
                                labels=c("Weekday", "Weekend"))
           
    )
    output$trip_hourPlot = renderPlot(
        #trips_hour %>% 
        trips %>% group_by(h = hour(trips$start_date)) %>% 
            filter(start_day >= input$date[1] & start_day <= input$date[2]) %>%
            summarise(N = n()) %>% 
            ggplot(aes(x=h, y =N)) + 
            geom_bar(stat="identity", fill="steelblue") + 
            labs(x='hour of the day',y='number of trips')
    )
    
    
    #output$trip_dayPlot = renderPlot(
    #    trips %>% group_by(start_day) %>% summarise(N = n()) %>% 
    #        ggplot(aes(x=start_day, y =N))+ geom_point()
    #    #geom_bar(stat='identity') 
    #)
    #output$trip_weekend2Plot = renderPlot(
    #    trips %>% filter(isWeekend==T) %>% group_by(start_day,isWeekend) %>% summarise(N = n()) %>% 
    #        ggplot(aes(x=start_day, y =N))+ geom_bar(stat='identity')
    #    
    #)
    
    
    
    #output$dock_countPlot = renderPlot(
    #stations %>% group_by(city) %>% 
    #    summarise(N = n()) %>% 
    #    ggplot(aes(x=reorder(city,-N), y = N))+ 
    #    geom_bar(stat="identity", fill="steelblue") + 
    #    labs(x='city',y='number of stations')
    #)
    #output$dock_PiePlot = renderPlot(
    #stations %>% group_by(city) %>% 
    #    summarise(N = n()) %>% 
    #ggplot(aes(x="", y = N, fill=city))+ 
    #    geom_bar(width =1, #width = 0.9 (default) leaves a hole at the center.
    #             stat="identity", position = "stack") + 
    #    coord_polar("y") #+ theme_economist()
    #    
    #)
    
    #output$mymap_bla <- renderLeaflet({
    #    leaflet() %>%
    #        addTiles() %>%  # Add default OpenStreetMap map tiles
    #        addPolylines(lng = c(-122.4009,-122.4008), lat = c(37.79854,37.78963))
    #})
    
        
}
