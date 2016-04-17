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
head(SCC)

#The overall goal of this assignment is to explore the National Emissions Inventory 
#database and see what it say about fine particulate matter pollution in the United states
#over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

#1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

Q1 <- with(NEI, tapply(Emissions, year, mean, na.rm =T))
plot(c('1999','2002','2005','2008'), Q1)

#Yes, total emmisions have decreased



