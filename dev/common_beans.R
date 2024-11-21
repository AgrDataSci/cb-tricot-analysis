# library("remotes")
# install_github("hturner/PlackettLuce", upgrade = "never")
# install_github("agrdatasci/gosset", upgrade = "never")

# Packages
library("PlackettLuce")
library("gosset")
library("climatrends")
library("tidyverse")

data(beans, package = "PlackettLuce")

load("data/common_beans_clim.rda")

modis[1:4, 1:5, ]

# compute the number of days required to accumulate gdd from 
# planting date to maturity
gdd <- GDD(modis, 
           day.one = beans$planting_date, 
           degree.days = 900, 
           return.as = "ndays")


boxplot(gdd)

# add gdd to the beans data
# and take the average of gdd per season
beans %<>%  
  mutate(gdd = gdd$gdd) %>% 
  group_by(season) %>% 
  mutate(gdds = as.integer(mean(gdd)))
  
# compute the temperature indices from planting date to the number of days 
# required to accumulate the gdd in each season
temp <- temperature(modis, 
                    day.one = beans$planting_date, 
                    span = beans$gdds)

rain <- rainfall(chirps, 
                    day.one = beans$planting_date, 
                    span = beans$gdds)


# round values to 2 decimals, this will not change the main result, but will 
# help in visualizing the tree 
temp[1:ncol(temp)] <- lapply(temp[1:ncol(temp)], function(x) round(x, 2))


# create the PlackettLuce rank
G <- rank_tricot(data = beans,
                 items = c("variety_a", "variety_b", "variety_c"),
                 input = c("best", "worst"),
                 group = TRUE,
                 additional.rank = beans[c("var_a", "var_b", "var_c")])

# combine the indices with the main data
pldata <- cbind(G, temp, rain)

# fit a PL tree
plt <- pltree(G ~ maxNT + SU, data = pldata, minsize = 50)

plot(plt)

gosset:::plot_tree(plt)
