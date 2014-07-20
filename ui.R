require(shiny); require(rCharts)

shinyUI(pageWithSidebar(
        headerPanel("CO2 Emissions"),
        sidebarPanel(
                p('Place the cursor near the bubble. You will see the following information...'),
                h5('Country Name'),
                h5('(x,y), Size: z'),
                p('- x is the per capita GDP in a country adjusted for inflation. Units are 2005 US dollars.'),
                p('- y is the per capita CO2 emitted in a country. Units are tonnes (1 tonne = 1000kg).'),
                p('- z (the size of the bubble) is the total CO2 emitted in a country. Units are milliones of tonnes.'),
                p('---'),
                p('This data is made available at Gapminder.org'),
                p('To see the R code, go to github.com/rockstarinator/emissions')
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