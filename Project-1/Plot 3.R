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
plot(time, Dates$Sub_metering_1, type= "l", xlab = "", ylab="Energy sub metering")
lines(time, Dates$Sub_metering_2, type = "l", col="red")
lines(time, Dates$Sub_metering_3, type = "l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))

#Save Plot
dev.copy(png, file = "Plot3.png")
dev.off()
