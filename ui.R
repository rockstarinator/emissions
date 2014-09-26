require(shiny); require(rCharts)

shinyUI(pageWithSidebar(
        headerPanel(""),
        sidebarPanel(
                p(tags$strong("This CO2 emissions enables you to point, click and explore with interactive graphing.")),
                p(tags$span(style="color:green", "Click or point at a bubble to see what country is represented.")),
                sliderInput(inputId = "year",
                            label = tags$span(style="color:red", "Push the slider to explore a different year:"),
                            min = 1951,
                            max = 2011,
                            value = 2011,
                            step = 1,
                            format = "####"),
                tags$br(),
                radioButtons("special", 
                             label = tags$span(style="color:blue", "Click below to explore a hypothetical world where people emit more or less CO2:"),
                             choices = list("View real world data." = 1, 
                                            "What if all people emitted as much CO2 as Americans?" = 2,
                                            "What if all people emitted as little CO2 as the French?" = 3)
                             )
        ), 
        mainPanel(showOutput("yearPlot", "highcharts"))
))