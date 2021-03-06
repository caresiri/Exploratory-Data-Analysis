#Are air pollution levels lower than they were before
#Website: https://www3.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm
setwd("./Desktop") 
if(!file.exists("./data")){dir.create("./data")} 
#download two data sets
pm1999 <- "http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/daily_88101_1999.zip" 
pm2012 <- "http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/daily_88101_2012.zip"
download.file(pm1999,destfile="./data/daily_88101_1999.zip",method="curl") 
download.file(pm2012,destfile="./data/daily_88101_2012.zip",method="curl") 
setwd("./data") 
unzip("daily_88101_1999.zip")
unzip("daily_88101_2012.zip") 
getwd() 
pm0 <- read.csv("daily_88101_1999.csv", comment.char = "#",na.strings = "")
pm1 <- read.csv("daily_88101_2012.csv", comment.char = "#",na.strings = "")
dim(pm0)
head(pm0)
#grab PM2.5
x0 <- pm0$Arithmetic.Mean
x1 <- pm1$Arithmetic.Mean
#lets see what it is
class(x0) #[1] "numeric"
str(x0)
str(x1)
summary(x0)
summary(x1)
dim(pm1)

# Lets look at the boxplot
boxplot(x0, x1) #its hard to look at and there is a lot of squwee
#one way to fix the squwee is to take the log
boxplot(log10(x0), log10(x1))
# the spread of the data increased but the mean decreased

#it is a bit weird that there are negative value as there can not be a negative mass, we need to fix that
summary(x1)
negative <- x1 < 0
str(negative)
sum(negative, na.rm = TRUE) # there are 1145 that are negative
mean(negative, na.rm = TRUE) # it is about 3.8% of the values (maybe there are negative values at certain times of the year)
dates <- pm1$Date.Local
asdates <- as.Date(dates, "%Y-%m-%d")
str(asdates)
hist(asdates, "month")
hist(asdates[negative],"month")#maybe the negative values are a measurment error when values are low

#something that would be interesting is rather than seeing the data for the entire contry, lets bring it down for particular location

site0 <- unique(subset(pm0, State.Name == "Texas",c(County.Name,Site.Num)))
site1 <- unique(subset(pm1, State.Name == "Texas",c(County.Name,Site.Num)))

site0 <- paste(site0[,1], site0[,2], sep = ".")
site1 <- paste(site1[,1], site1[,2], sep = ".")
head(site1)

#now we need to find out what State.Site combination is available in both sets. Lets use the intersect function for that
both <- intersect(site0, site1)
both
# we are going to create a new variable
pm0$county.site <- with(pm0, paste(County.Name, Site.Num, sep="."))
pm1$county.site <- with(pm1, paste(County.Name, Site.Num, sep="."))

pm1$county.site
#now we want to subset the data only for texas
cnt0 <- subset(pm0, State.Name == "Texas" & county.site %in% both)
cnt1 <- subset(pm1, State.Name == "Texas"& county.site %in% both)

head(cnt0)
cnt1
#lets find out the number of rows for each one of th emonitors
sapply(split(cnt0, cnt0$county.site), nrow)
sapply(split(cnt1, cnt1$county.site), nrow)

#we will pick Harris.1035 because it has a good number of data to measure
pm1sub <- subset(pm1, State.Name == "Texas" & County.Name =="Harris" & Site.Num == 1035)
pm0sub <- subset(pm0, State.Name == "Texas" & County.Name =="Harris" & Site.Num == 1035)
dim(pm0sub)

#we will now make plots to visualize if it has hone down
dates1 <- pm1sub$Date.Local
dates0 <- pm0sub$Date.Local
x1sub <- pm1sub$Arithmetic.Mean
x0sub <- pm0sub$Arithmetic.Mean
dates1 <- as.Date(dates1, "%Y-%m-%d")
dates0 <- as.Date(dates0, "%Y-%m-%d")
plot(dates1, x1sub)
plot(dates0, x0sub)
summary(x1sub)
summary(x0sub)

#It is hard to look at the data separately, so lets build a panel plot
par(mfrow = c(1,2), mar = c(4,4,2,1))
plot(dates0,x0sub,pch=20)
abline(h=median(x0sub, na.rm=T))
plot(dates1,x1sub,pch=20)
abline(h=median(x1sub,na.rm=T))

#now lets try to put them in the same plot
rng <- range(x0sub, x1sub, na.rm=T)
par(mfrow = c(1,2))
plot(dates0, x0sub, pch=20, ylim=rng)
abline(h=median(x0sub, na.rm=T))
plot(dates1, x1sub, pch=20, ylim=rng)
abline(h=median(x1sub, na.rm=T))

#Explore Changes at the state level
head(pm0)

#the Tapply function would take the average of a vector
mn0 <- with(pm0, tapply(Arithmetic.Mean, State.Name, mean, na.rm =T))
str(mn0)
summary(mn0)
mn1 <- with(pm1, tapply(Arithmetic.Mean, State.Name, mean, na.rm =T))
summary(mn1)
#Create a data frame of the state and the mean
d0 <- data.frame(state = names(mn0), mean =mn0)
d1 <- data.frame(state = names(mn1), mean =mn1)
head(d0)
head(d1)
#now I just want to merge these together
mrg <- merge(d0, d1, by ="state")
head(mrg)
par(mfrow=c(1,1))
with(mrg, plot(rep(1999, 52), mrg[,2], xlim=c(1998,2013)))
with(mrg, points(rep(2012, 52), mrg[,3]))
segments(rep(1999, 52), mrg[,2], rep(2012,52), mrg[,3])
