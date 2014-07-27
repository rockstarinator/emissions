require(shiny); require(rCharts)

shinyUI(pageWithSidebar(
        headerPanel("CO2 Emissions App"),
        sidebarPanel(
                p('The CO2 emissions app allows you to explore CO2 emissions between 1951 and 2011. 
                  It is intended as an educational tool that gives accurate scientific information.'),
                p('Push the slider to explore a different year.
                  Click or point at a bubble to see what country is represented.
                  Check a box down below to explore a hypothetical world, where people emit more or less CO2.'),
                p('FYI, 1 tonne means 1000kg and GDP is measured in 2005 US dollars.'),
                p('---'),
                p('To see the R code, go to',
                  a("github.com/rockstarinator/emissions.", 
                    href = "https://github.com/rockstarinator/emissions")),
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
                checkboxInput(inputId = "special", 
                              label = "What if all people emitted as much CO2 as Americans?"),
                checkboxInput(inputId = "special2",
                              label = "What if all people emitted as little CO2 as the French?")
        )
))