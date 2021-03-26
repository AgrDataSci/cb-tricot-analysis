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
# from the package PlackettLuce 
data("beans", package = "PlackettLuce")

# ................................
# ................................
# Some summaries
str(beans)

summary(beans$season)

items <- unlist(beans[,c("variety_a", "variety_b", "variety_c")])

table(items)

table(items, rep(beans$season, 3))

plot(density(beans$maxTN))

boxplot(beans$maxTN)

summary(beans[,c("lon", "lat")])

plot(beans[,c("lon", "lat")])

# ................................
# ................................
# Plot map
# function from ClimMob workflow
# check map providers here https://leaflet-extras.github.io/leaflet-providers/preview/
plot_map(beans, c("lon", "lat"))

plot_map(beans, c("lon", "lat"), map_provider = "OpenStreetMap.Mapnik")


# ................................
# ................................
# Visualize the rankings
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
dt <- read.csv("data/sweet_potato.csv")

head(dt)

str(dt)

colnames(dt)

# ..........................................
# ..........................................
# compare rankings from the three traits using OA as baseline
# take Kendall tau and the agreement of being best and worst among the traits

# first, subset the main dataset to retain only the Uganda data
dt <- dt[dt$country == "Uganda", ]

names(dt)

# now isolate the strings for the traits assessed in Uganda
traits <- c("overall","taste","color")

sel <- paste0(c("best_","worst_"), rep(traits, each = 2))


# now create the rankings for each trait
# run over the traits
R <- list()
for(i in seq_along(traits)){
  R[[i]] <- rank_tricot(dt, 
                        items = c("item_A", "item_B", "item_C"),
                        input = paste0(c("best_","worst_"), traits[[i]]))
}

# compare rankings
a <- summarise_agreement(R[[1]],
                         compare.to = R[-1],
                         labels = c("Taste","Colour"))

plot(a) + 
  theme_bw()



