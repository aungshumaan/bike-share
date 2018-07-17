library(shiny)
#library(dplyr)
#library(ggplot2)
stations <- read.csv(file = "./sf-bay-area-bike-share/station.csv")
function(input, output) {
    
    # plot of number of docks in a station for a particular city 
    output$dock_countPlot = renderPlot(
        stations %>% filter(city ==input$city) %>% 
            ggplot(aes(x =reorder(name,dock_count), y =dock_count)) + 
            geom_col(col ='red') + 
            ylab("number of docks") +
            coord_flip() +
            theme(legend.key=element_blank(), legend.position="bottom") +
            scale_fill_brewer(palette = 'Set1') +
            theme_bw() 
            
    )
        
}
