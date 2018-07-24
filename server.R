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
            ylab("number of docks") +
            coord_flip() +
            theme(legend.key=element_blank(), legend.position="bottom") +
            #scale_fill_brewer(palette = 'Set1') +
            theme_bw() 
        
    )
    stafreq <- reactive({
        trips %>% filter(city  %in% input$cityGroup) %>% 
            filter(as.Date(start_date) %in% input$date[1]:input$date[2]) %>%
            group_by(start_station_name, long, lat) %>%
            summarise(N =n())
    })
    output$min_maxdate <- renderText({ 
        paste("You have chosen a date range that goes from",
              input$date[1], "to", input$date[2])
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
            filter(as.Date(start_date) %in% input$date[1]:input$date[2]) %>%
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
            filter(as.Date(start_date) %in% input$date[1]:input$date[2]) %>%
            group_by(end_station_name) %>%
            summarise(N =n()) %>%
            ggplot(aes(x =reorder(end_station_name,N), y =N)) + 
            geom_bar(stat="identity", fill="red") +
            ylab("number of trips") +
            coord_flip() +
            theme(legend.key=element_blank(), legend.position="bottom") +
            #scale_fill_brewer(palette = 'Set1') +
            theme_bw() 
        
    )
    output$dock_countPlot = renderPlot(
    stations %>% group_by(city) %>% 
        summarise(N = n()) %>% 
        ggplot(aes(x=reorder(city,-N), y = N))+ 
        geom_bar(stat="identity", fill="steelblue") + 
        labs(x='city',y='number of stations')
    )
    output$dock_PiePlot = renderPlot(
    stations %>% group_by(city) %>% 
        summarise(N = n()) %>% 
    ggplot(aes(x="", y = N, fill=city))+ 
        geom_bar(width =1, #width = 0.9 (default) leaves a hole at the center.
                 stat="identity", position = "stack") + 
        coord_polar("y") #+ theme_economist()
        
    )
    
    #output$mymap_bla <- renderLeaflet({
    #    leaflet() %>%
    #        addTiles() %>%  # Add default OpenStreetMap map tiles
    #        addPolylines(lng = c(-122.4009,-122.4008), lat = c(37.79854,37.78963))
    #})
    
        
}