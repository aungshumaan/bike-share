library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
stations <- read.csv(file = "./sf-bay-area-bike-share/station.csv")
function(input, output, session) {
    
    output$mymap <- renderLeaflet({
        leaflet() %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        #addMarkers(lng=stations$long, lat=stations$lat, popup=stations$name)
        addCircles(lng=stations$long, lat=stations$lat, radius= stations$dock_count, 
               weight =20, opacity=0.3, 
               popup=paste(stations$name, ":",stations$dock_count, " docks"))
        
    })
    
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
    # plot of number of docks in a station for a particular city 
    output$dock_countBycityPlot = renderPlot(
        stations %>% filter(city ==input$city) %>% 
            ggplot(aes(x =reorder(name,dock_count), y =dock_count)) + 
            geom_bar(stat="identity", fill="red") +
            ylab("number of docks") +
            coord_flip() +
            theme(legend.key=element_blank(), legend.position="bottom") +
            #scale_fill_brewer(palette = 'Set1') +
            theme_bw() 
            
    )
        
}
