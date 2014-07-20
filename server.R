require(shiny); require(rCharts)

# Data was manually downloaded from Gapminder.org.
# indicator CDIAC carbon_dioxide_emissions_per_capita.xlsx was downloaded from
# http://spreadsheets.google.com/pub?key=phAwcNAVuyj1gkNuUEXOGag&output=xls
# indicator CDIAC carbon_dioxide_total_emissions.xlsx was downloaded from
# http://spreadsheets.google.com/pub?key=phAwcNAVuyj1NHPC9MyZ9SQ&output=xls
# indicator gapminder gdp_per_capita_ppp.xlsx was downloaded from
# http://spreadsheets.google.com/pub?key=phAwcNAVuyj1jiMAkmq1iMg&output=xls
# There may be a way to download data from Google Spreadsheets programatically, 
# but it is a difficult hack and I could not get it to work.
# For more details, see http://blog.revolutionanalytics.com/2009/09/how-to-use-a-google-spreadsheet-as-data-in-r.html

# Next, the "Data" sheet of the three Excel workbooks 
# was manually converted into .csv and renamed using Microsoft Excel.
# Again, there may be a way to do this programatically,
# but for some reason my system took 103 seconds to read each data frame
# using the xlsx package, which is far too slow.
# I apologize for the reliance on outside-of-R technologies.

# Get data about CO2 emissions per country
natEm <- read.csv("./data/nationalEmissions.csv")
names(natEm)[1] <- "country"
names(natEm) <- gsub("X", "total", names(natEm))
natEm[, -1] <- signif(natEm[, -1], 2) / 1000

# Get data about CO2 emissions per person per country
perEm <- read.csv("./data/personalEmissions.csv")
names(perEm)[1] <- "country"
names(perEm) <- gsub("X", "em", names(perEm))
perEm[, -1] <- round(perEm[, -1], 1)

# Get data about GDP in different countries
gdp <- read.csv("./data/gdp.csv")
names(gdp)[1] <- "country"
names(gdp) <- gsub("X", "gdp", names(gdp))
gdp[, -1] <- round(gdp[, -1], -2)

# Merge the data sets 
df <- merge(gdp, perEm)
df <- merge(df, natEm)

# Get only those countries with complete data from 1950-2011
df <- df[, c(1, grep("195", names(df)), grep("196", names(df)), 
             grep("197", names(df)), grep("198", names(df)), 
             grep("199", names(df)), grep("200", names(df)), 
             grep("201", names(df)))]
df <- df[apply(df, 1, function(x) sum(is.na(x))) == 0, ]
df$country <- as.character(df$country)

# Set up a plotting function that takes a data frame as an argument
plotter <- function(dfplot) {
        h1 <- hPlot(emissions ~ gdp,  data = dfplot, type = "bubble", 
                    group = "country", name = "country", size = "totalEmissions")
        h1$legend(enabled = F)
        h1$title(text = "What Country Emits the Most CO2?")
        h1$subtitle(text = "Bubble Size Is Proportional to CO2 Emitted in the Selected Year")
        h1$credits(text = "Data from Gapminder.org")
        h1$xAxis(title = list(text = "GDP per Capita"), tickPositions = seq(0, 50000, 10000), min = 0, max = 50000)
        h1$yAxis(title = list(text = "Tonnes of CO2 Emitted Per Capita"), tickPositions = seq(0, 50, 10), min = 0, max = 50)
        h1$plotOptions(bubble = list(maxSize = "300", minSize = "5"))
        h1$addParams(dom = 'yearPlot')
        return(h1) # Return yearPlot to the shiny UI
}

# This will come in handy later
fake <- data.frame("Fake Country", 100000, 100, 23000)
names(fake) <- c("country", "gdp", "emissions", "totalEmissions")

shinyServer(function(input, output) {
        output$yearPlot <- renderChart({
                if (input$special == T) {
                        # Plot a data set with hypothetical values
                        dfplot <- df[, c(1, grep(input$year, names(df)))]
                        dfplot[, 4] <- signif(dfplot[, 4]/dfplot[, 3]*dfplot[45, 3], 2)
                        dfplot[, 3] <- dfplot[45, 3]
                        names(dfplot) <- c("country", "gdp", "emissions", "totalEmissions")
                        dfplot <- rbind(dfplot, fake) # Helps normalize bubble size
                        plotter(dfplot)
                } else if (input$special2 == T) {
                        # Plot a data set with hypothetical values
                        dfplot <- df[, c(1, grep(input$year, names(df)))]
                        dfplot[, 4] <- signif(dfplot[, 4]/dfplot[, 3]*dfplot[15, 3], 2)
                        dfplot[, 3] <- dfplot[15, 3]
                        names(dfplot) <- c("country", "gdp", "emissions", "totalEmissions")
                        dfplot <- rbind(dfplot, fake) # Helps normalize bubble size
                        plotter(dfplot)
                } else {
                        # Plot a data set with real values
                        dfplot <- df[, c(1, grep(input$year, names(df)))]
                        names(dfplot) <- c("country", "gdp", "emissions", "totalEmissions")
                        dfplot <- rbind(dfplot, fake) # Helps normalize bubble size
                        plotter(dfplot)
                }
        })
})