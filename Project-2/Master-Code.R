#Are air pollution levels lower than they were before
#Website: https://www3.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm
setwd("./Desktop") 
if(!file.exists("./data")){dir.create("./data")} 
setwd("./data")
#download data set
data <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
download.file(data,destfile="./exdata-data-NEI_data.zip",method="curl") 
unzip("exdata-data-NEI_data.zip")
getwd() 
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#The overall goal of this assignment is to explore the National Emissions Inventory 
#database and see what it say about fine particulate matter pollution in the United states
#over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

#1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

Q1 <- with(NEI, tapply(Emissions, year, sum, na.rm =T))
barplot(Q1, main = " total PM2.5 emission", xlab="Years",ylab=" Total Amount of PM2.5 emitted (tons)" )
dev.copy(png, file = "Plot1.png")
dev.off()
#Yes, total emmisions have decreased

#2.Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999
#to 2008? Use the base plotting system to make a plot answering this question.
Q2 <- subset(NEI, fips == "24510")
Q2.1 <- with(Q2, tapply(Emissions, year, sum, na.rm =T))
barplot(Q2.1, main = " total PM2.5 emission for Baltimore City", xlab="Years",ylab=" Total Amount of PM2.5 emitted (tons)" )
dev.copy(png, file = "Plot2.png")
dev.off()
#It has decreased from 1999 to 2008, with an increase from 2002 to 2005

#3. Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad)
#Variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
#geom_point(aes(color = bmicat), size = 4, alpha = 1/2)
library(ggplot2)
library(plyr)
Q3 <- subset(NEI, fips == "24510")
Q3.1 <- ddply(Q3, .(year, type), function(x) sum(x$Emissions))
colnames(Q3.1)[3] <- "Emissions"
qplot(year, Emissions, data = Q3.1, color = type, geom = "line") +
  ggtitle(expression("Baltimore City" ~ PM[2.5] ~ 
                       "Emissions by Source Type and Year")) + xlab("Year") +
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))


#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
Mrg<- merge(NEI,SCC, by="SCC")
coal <- filter ( Mrg, grepl("Coal", EI.Sector))
g<- ggplot(coal, aes(year, Emissions))+
  labs(title="Fine Particulate Emissions\n Coal Combustion Related Sources\n Total United States \n")+
  xlab( "Years") + ylab("Amount of PM2.5 emitted, in tons")
plot4<- g + geom_bar(stat="identity", fill ="brown")
print(plot4)


#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

baltimore<- filter(Mrg, fips == "24510" )
VON<- filter(baltimore, type == "ON-ROAD"  )
VNON <- filter(baltimore, type == "NON-ROAD"  )
V<- rbind(vehicles_on, vehicles_non)
g<- ggplot(V,  aes(year, Emissions)) + labs(title = " Fine Particulate Emissions\n Motor Vehicle Sources \n Baltimore City\n")+
  xlab( "Years") + ylab("Amount of PM2.5 emitted, in tons")
g
plot5<- g + geom_bar(stat="identity", fill="purple")
print(plot5)

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, 
#California (fips == “06037”). Which city has seen greater changes over time in motor vehicle emissions?


Car<- filter(Mrg, fips == "24510" | fips == "06037")
ON<- filter(Car, type == "ON-ROAD")
NON <- filter(Car, type == "NON-ROAD")
Car2<- rbind(ON,NON)
Car2$fips<- gsub("24510", "Baltimore" ,Car2$fips)
Car2$fips<- gsub("06037", "Los Angeles", Car2$fips)
g<- ggplot(Car2,  aes(year, Emissions))+labs(title = "Comparison Vehicles Emissions")+
  ylab("Amount of emissions")
plot6<- g + geom_bar(stat="identity", fill ="brown") + facet_grid(.~fips)
print(plot6)

