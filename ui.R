library(shinydashboard)


dashboardPage(
    
    dashboardHeader(title = "Bay Area Bike Share"),
    
    dashboardSidebar(
        sidebarUserPanel("Aungshuman Zaman"),
        sidebarMenu(
         
            menuItem("Stations", tabName = "Page1"),
            menuItem("Trip frequency", tabName = "Page2"),
            menuItem("Station connections", tabName = "Page3"),
            menuItem("Trip duration", tabName = "Page4"),
            menuItem("Variation of trip frequency", tabName = "Page5")
            )
        
        
        
        
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "Page1",
                fluidRow(
                    box(leafletOutput("mymap")),
                    box(plotOutput("dock_countBycityPlot")) ,
                    box(checkboxGroupInput(inputId = "cityGroup",
                                           label = "Select one or more city",
                                           choices = c("San Francisco" , 
                                                       "San Jose" , 
                                                       "Redwood City" ,
                                                       "Mountain View" , 
                                                       "Palo Alto" ),
                                           selected = "San Francisco"))
                
                )
                ),
            tabItem(tabName = "Page2",
                fluidRow(
                    #textOutput("min_maxdate"),
                    box(leafletOutput("mymap_freq")),
                    box(selectizeInput(inputId = "city",
                                       label = "City",
                                       choices = unique(stations$city),
                                       selected = 'San Francisco'
                                       )
                        ),
                    box(sliderInput(inputId = 'hour2',
                                label = 'Hour of the day',
                                min =0,
                                max =24,
                                value = c(0,24)
                        )
                    ),
                    box(sliderInput(inputId = 'date2',
                                label = 'Date range',
                                min =min(trips$start_day),
                                max =max(trips$start_day),
                                value = c(min(trips$start_day),max(trips$start_day))
                            )
                        )
                    )
                ),
            tabItem(tabName = "Page3",  
                fluidRow(
                    box(leafletOutput("mymap_endfreq")), 
                    box(plotOutput("endfreqPlot")),
                    box(selectizeInput(inputId = "name",
                                       label = "Station",
                                       choices = unique(stations$name),
                                       selected = 'San Francisco Caltrain (Townsend at 4th)'
                                       )
                        )
                    #box(sliderInput(inputId = 'date',
                    #                label = 'Date',
                    #                min =min(trips$start_day),
                    #                max =max(trips$start_day),
                    #                value = c(min(trips$start_day),
                    #                          max(trips$start_day))
                    #                )
                    #   )
                    
                    
                    
                    
                    
                )
            ),
            
            tabItem(tabName = "Page4",
                fluidRow(
                    box(plotOutput("trip_seasonPlot")),
                    box(plotOutput("trip_subscriptionPlot")),
                    box(sliderInput(inputId = 'hour',
                                label = 'Hour of the day',
                                min =0,
                                max =24,
                                value = c(0,24)
                    )),
                    box(sliderInput(inputId = 'dur',
                                    label = 'Duration of trip',
                                    min =1,
                                    max =60,
                                    value = c(1,20)
                    ))
                    
                )
            ),
            tabItem(tabName = "Page5",
                    fluidRow(
                        box(plotOutput("trip_weekendPlot")), 
                        box(plotOutput("trip_hourPlot")),
                        box(sliderInput(inputId = 'date',
                                        label = 'Date range',
                                        min =min(trips$start_day),
                                        max =max(trips$start_day),
                                        value = c(min(trips$start_day),max(trips$start_day))
                        ))
                    ))
           
           
           
        
       
        ###plotOutput("dock_countPlot"),
        ###plotOutput("dock_PiePlot"),
        #textOutput("min_maxdate"),
        
        #h3("Choose a station to see where most trips go."),
        
        
        
        ###plotOutput("trip_durationPlot"),
        ###plotOutput("trip_dayPlot"), 
        
        ###plotOutput("trip_weekend2Plot"), 
        
        
        
    )
    
    
))

