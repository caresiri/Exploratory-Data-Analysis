# Basic components of ggplot 
# a data fram
# aesthetic mappings
# geoms
# facets: for conditional plots
# stats:
#scales
#coordinate system
# Annotaton
#Labels: xlab(), ylab(), labs,qqtitle()
#Each of the "geom" functions has options to modify
#For this that only make sense globaly, use theme
#Two standard apperance themes are inluded
#-theme_gray()
#a nice display is geom_point(color = "steelblue", size = 4, alpha = 1/2)
#there is a difference between asigning a color to a  constant or a variable
#geom_point(aes(color = bmicat), size = 4, alpha = 1/2)
install.packages("ggplot2")
library(ggplot2)
testdat <- data.frame( x = 1:100, y = rnorm(100))
testdat[50,2]<- 100 ## Outlier
plot(testdat$x, testdat$y, type = "l", ylim = c(-3,3))
g <- ggplot(testdat, aes(x =x, y =y))
g + geom_line()
#how to change the outlier without eliminating the variable
g + geom_line() + coord_cartesian(ylim = c(-3,3))
