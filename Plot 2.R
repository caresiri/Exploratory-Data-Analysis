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

#create datetime variable
time <- strptime(paste(Dates$Date, Dates$Time, sep = " "), format="%Y-%m-%d %H:%M:%S")
plot(time, Dates$Global_active_power, type= "l", xlab = "", ylab="Global Activity Power")
