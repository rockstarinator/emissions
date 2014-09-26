require(shiny); require(rCharts)
df <- read.table("emissionsData.txt", header = T)

# Set up a plotting function that takes a data frame as an argument
plotter <- function(dfplot) {
        h1 <- hPlot(emissions ~ gdp, data = dfplot, type = "bubble", 
                    group = "country", size = "totalEmissions")
        h1$legend(enabled = F)
        h1$title(text = "What Country Emitted the Most CO2 in a Given Year?")
        h1$subtitle(text = "Bubble Size: National Emissions (Billions of Kilograms)")
        h1$credits(text = "Data from Gapminder.org")
        h1$xAxis(title = list(text = "GDP per Capita (2005 US Dollars)"), tickPositions = seq(0, 50000, 10000), min = 0, max = 50000)
        h1$yAxis(title = list(text = "Emissions per Capita (Kilograms)"), tickPositions = seq(0, 25000, 5000), min = 0, max = 25000)
        h1$plotOptions(bubble = list(maxSize = "300", 
                                     minSize = "5",
                                     tooltip = list(headerFormat = "<b>{series.name}</b><br/>",
                                                    pointFormat = "{point.y} kilograms per capita <br/> {point.z} billion kilograms nationally")))
        h1$addParams(dom = 'yearPlot')
        return(h1) # Return yearPlot to the shiny UI
}

# Creating a ginormous fake bubble off the screen regulates the size of the bubbles
fake <- data.frame("Fake Country", 100000, 100, 23000)
names(fake) <- c("country", "gdp", "emissions", "totalEmissions")

shinyServer(function(input, output) {
        output$yearPlot <- renderChart({
                if (input$special == 2) {
                        # Plot a data set with hypothetical values
                        dfplot <- df[, c(1, grep(input$year, names(df)))]
                        dfplot[, 4] <- signif(dfplot[, 4]/dfplot[, 3]*dfplot[45, 3], 2)
                        dfplot[, 3] <- 1000*dfplot[45, 3]
                        names(dfplot) <- c("country", "gdp", "emissions", "totalEmissions")
                        dfplot <- rbind(dfplot, fake) # Helps normalize bubble size
                        plotter(dfplot)
                } else if (input$special == 3) {
                        # Plot a data set with hypothetical values
                        dfplot <- df[, c(1, grep(input$year, names(df)))]
                        dfplot[, 4] <- signif(dfplot[, 4]/dfplot[, 3]*dfplot[15, 3], 2)
                        dfplot[, 3] <- 1000*dfplot[15, 3]
                        names(dfplot) <- c("country", "gdp", "emissions", "totalEmissions")
                        dfplot <- rbind(dfplot, fake) # Helps normalize bubble size
                        plotter(dfplot)
                } else {
                        # Plot a data set with real values
                        dfplot <- df[, c(1, grep(input$year, names(df)))]
                        dfplot[, 3] <- 1000*dfplot[, 3]
                        names(dfplot) <- c("country", "gdp", "emissions", "totalEmissions")
                        dfplot <- rbind(dfplot, fake) # Helps normalize bubble size
                        plotter(dfplot)
                }
        })
})