fluidPage(
    titlePanel("SF Bay Area Bike Share"),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput(inputId = "cityGroup",
                               label = "Select a city",
                               choices = c("San Francisco" , 
                                              "San Jose" , 
                                              "Redwood City" ,
                                              "Mountain View" , 
                                              "Palo Alto" ),
                               selected = "San Francisco"),
            selectizeInput(inputId = "city",
                           label = "City",
                           choices = unique(stations$city),
                           selected = 'San Francisco'),
            
            selectizeInput(inputId = "name",
                           label = "Station",
                           choices = unique(stations$name),
                           selected = 'San Francisco Caltrain (Townsend at 4th)'), 
            sliderInput(inputId = 'date',
                        label = 'Date',
                        min =min(as.Date(trips$start_date)),
                        max =max(as.Date(trips$start_date)),
                        value = c(min(as.Date(trips$start_date)),
                                  max(as.Date(trips$start_date)))
                        )
            
            
            
            #dateRangeInput(inputId = "time",
            #            label = "Time",
            #            start = min(as.Date(trips$start_date)),
            #            end =max(as.Date(trips$start_date))
            #  )          
            #selectizeInput(inputId = "trip_freq",
            #               label = "trip frequency",
            #               choices = 1:50,
            #               selected = 1)            
        ),
        mainPanel(
            #station df
            leafletOutput("mymap"),
            plotOutput("dock_countBycityPlot"),
            #plotOutput("dock_countPlot"),
            #plotOutput("dock_PiePlot"),
            textOutput("min_maxdate"),
            leafletOutput("mymap_freq"),
            h3("Choose a station to see where most trips go!!"),
            leafletOutput("mymap_endfreq"),
            plotOutput("endfreqPlot")
           
        )
    )
)
