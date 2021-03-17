# ................................
# ................................
# Visualization and summary
library("PlackettLuce")
library("ggplot2")
library("gosset")
library("igraph")
library("leaflet")
source("https://raw.githubusercontent.com/AgrDataSci/ClimMob-analysis/master/R/functions.R")

# ................................
# ................................
# Example 1: Beans data
# load the data of beans tricot trials
data("beans", package = "PlackettLuce")


# ................................
# ................................
# Some summaries
str(beans)

summary(beans$season)

items <- unlist(beans[,c("variety_a", "variety_b", "variety_c")])

items <- table(items)

hist(beans$maxTN)

boxplot(beans$maxTN)

plot(beans[,c("lon", "lat")])

summary(beans[,c("lon", "lat")])

# ................................
# ................................
# Plot map
# function from ClimMob workflow
plot_map(beans, c("lon", "lat"))


# tricot into a PlackettLuce rankings
R <- rank_tricot(data = beans,
                 items = c("variety_a","variety_b","variety_c"),
                 input = c("best","worst"))

class(R)
dim(R)
head(R)

# PlackettLuce rankings into a Sparse matrix
unclass(R)

# ................................
# ................................
# View the network 
a <- adjacency(R)

a

# function from ClimMob workflow
a <- network(a)

plot(a)

# ................................
# ................................
# Favourability score
?summarise_favourite
fav <- summarise_favourite(R)

fav

plot(fav) + 
  theme_bw() +
  theme(panel.grid = element_blank())


# ................................
# ................................
# Dominance
dom <- summarise_dominance(R)

head(dom)

plot(dom) + 
  theme_bw() +
  theme(panel.grid = element_blank())

# ................................
# ................................
# Contests
vic <- summarise_victories(R)

head(vic)

plot(vic) +
  theme_bw()


# ................................
# ................................
# Example 2: Sweetpotato data
dt <- read.csv("https://raw.githubusercontent.com/AgrDataSci/sweetpotato-cip-tricot/master/data/spotato_data.csv")

head(dt)

str(dt)


