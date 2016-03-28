library(dplyr)
getwd()
setwd("./Desktop/data")
data <- read.csv("./household_power_consumption.txt", header=T, sep=';', na.strings="?", nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
str(data)
head(data)
#Filter Dates
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
Dates <- filter(data, Date >= "2007-02-01" & Date <= "2007-02-02")
head(Dates)

#Plot 1 Global Active Power Histogram 
hist(Dates$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red")

#Save Plot
dev.copy(png, file = "Plot1.png")
dev.off()
