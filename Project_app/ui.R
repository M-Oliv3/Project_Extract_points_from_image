library(shiny)
library(shinyFiles)

# Define UI for application that extract points from an image
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Extract points from image (Graph)"),
        
        
        sidebarLayout(
                sidebarPanel(
                        tabsetPanel(type = "tabs",
                                    tabPanel("Tab 1", 
                                             fileInput("file1", "Choose jpg File", accept = ".jpg"),
                                             h4("Example: https://i.imgur.com/hYLWvdt.jpg"),
                                             textInput("AxisX", "Axis X:"),
                                             textInput("AxisY", "Axis Y:"),
                                             selectInput("state", "Calibration:",
                                                         list(`Calibration` = list("Origin", "X - Axis", "Y - Axis","Points"))),
                                             textOutput("result"),
                                             textOutput("result2")
                                             
                                             
                                             
                                    ),
                                    tabPanel("Tab 2",
                                             tableOutput("data"),
                                             actionButton("clean", "Clean")))
                        
                        
                        
                        
                        
                ),
                
                
                mainPanel(
                        plotOutput("distPlot", click = "plot_click"),
                        verbatimTextOutput("info"),
                        h3("Points (Calibrated)"),
                        verbatimTextOutput("Pts")
                )
        )
))
