library("climatrends")
library("tidyverse")
library("PlackettLuce")
library("patchwork")
library("qvcalc")
library("ggparty")
library("gosset")
library("igraph")
source("https://raw.githubusercontent.com/agrobioinfoservices/ClimMob-analysis/master/R/functions.R")

# read the data of beans tricot trials
dt <- read.csv("data/common_bean.csv")

dim(dt)
class(dt)
str(dt)
names(dt)
head(dt)
tail(dt)

# convert the beans data into a PlackettLuce rankings
R <- rank_tricot(data = dt, items = c("variety_a","variety_b","variety_c"),input = c("best","worst"))

class(R)
dim(R)
head(R)

# convert the PlackettLuce rankings into a matrix
R2 <- unclass(R)


#----------------
# Start explanatory analysis ####

# view the network 
a <- adjacency(R)

a <- network(a)

plot(a)

# now look for the favourability
f <- summarise_favourite(R)

plot(f) + 
  theme_bw() +
  theme(panel.grid = element_blank())


# now loof for the dominance
d <- summarise_dominance(R)
plot(d)








