require(shiny); require(rCharts)

shinyUI(pageWithSidebar(
        headerPanel("CO2 Emissions App"),
        sidebarPanel(
                p('The CO2 emissions app allows you to explore CO2 emissions between 1951 and 2011.'),
                p('Push the slider to explore a different year.
                  Click or point at a bubble to see what country is represented.
                  Choose an option down below to explore a hypothetical world where people emit more or less CO2.'),
                p('GDP is measured in 2005 US dollars.'),
                p('---'),
                p('To see the R code, go',
                  a("here", href = "https://rockstarinator.github.io/emissions/ui.R"),
                  ' and ',
                  a("here", href = "https://rockstarinator.github.io/emissions/server.R")),
                p('All data comes from', 
                  a("Gapminder.org.", href = "http://www.gapminder.org"))
        ),
        mainPanel(
                sliderInput(inputId = "year",
                            label = "Select a year",
                            min = 1951,
                            max = 2011,
                            value = 2000,
                            step = 1,
                            format = "####"),
                showOutput("yearPlot", "highcharts"),
                radioButtons("special", 
                             label = "Choose an option:",
                             choices = list("View real world data." = 1, 
                                            "What if all people emitted as much CO2 as Americans?" = 2,
                                            "What if all people emitted as little CO2 as the French?" = 3))
        )
))