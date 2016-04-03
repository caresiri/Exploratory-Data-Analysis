library(lattice)
library(datasets)
#xplot: this is the main function for creating scatterplots
# xyplot(y ~ x | f * G, data)
#f and g are optional conditioning variables
# the * indicates the interaction between the two variables

xyplot(Ozone ~ Wind, data = airquality)

airquality <- transform(airquality,Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5,1))
xyplot(Ozone ~ Wind | Month, data = airquality)

#if we want to print later

p <- xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5,1))
print(p)

#bwplot: box and whiskers plots (boxplot)
#histogram
#stripplot: like a boxplot but with actual points
#dotplot: plot dots on"violin strings"
#splom: scatterplot matrix: like pairs in the base plotting system
#levelplot, contourplot: for plotting immage data


#Lattice Planel Functions
set.seed(10)
x <- rnorm(100)
f <- rep(0.1, each = 50)
f <- x + f - f * x + rnorm(100, sd = 0.5)
f<- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2,1)) # Plot with two panels


#Custom Panel Function ad median line

xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x,y,...) # first call the default pannel
  panel.abline(h = median(y), lty = 2) ## add a horizontal line at the median
})

#Custom Panel Function add Regression line
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x,y,...) # first call the default pannel
  panel.lmline(x, y, col =2 ) ## overlay a simple linear regression line
})
