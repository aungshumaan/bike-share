library(shiny)

stations <- read.csv(file = "./sf-bay-area-bike-share/station.csv")
fluidPage(
    titlePanel("SF Bay Area Bike Share"),
    sidebarLayout(
        sidebarPanel(
            selectizeInput(inputId = "name",
                           label = "Station",
                           choices = unique(stations$name),
                           selected = ''),
            selectizeInput(inputId = "city",
                           label = "City",
                           choices = unique(stations$city),
                           selected = '')
        ),
        mainPanel(
            plotOutput("dock_countPlot")
        )
    )
)
