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

# The "Data" sheet of the three Excel workbooks 
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

write.table(df, "emissionsData.txt", row.names = F)