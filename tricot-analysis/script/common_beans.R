# library("remotes")
# install_github("hturner/PlackettLuce", upgrade = "never")
# install_github("agrdatasci/gosset", upgrade = "never")

# Packages
library("PlackettLuce")
library("gosset")


load("data/common_bean.rda")


# compute the number of days required to accumulate gdd from 
# planting date to maturity
gdd <- GDD(modis, 
           day.one = cbean$planting_date, 
           degree.days = 900, 
           return.as = "ndays")

# add gdd to the cbean data
# and take the average of gdd per season
cbean %<>%  
  mutate(gdd = gdd$gdd) %>% 
  group_by(season) %>% 
  mutate(gdds = as.integer(mean(gdd)))
  
# compute the temperature indices from planting date to the number of days 
# required to accumulate the gdd in each season
temp <- temperature(modis, 
                    day.one = cbean$planting_date, 
                    span = cbean$gdds)

rain <- rainfall(chirps, 
                    day.one = cbean$planting_date, 
                    span = cbean$gdds)


# round values to 3 decimals, this will not change the main result, but will 
# help in visualizing the tree 
temp[1:ncol(temp)] <- lapply(temp[1:ncol(temp)], function(x) round(x, 2))

# combine the indices with the main data
cbean <- cbind(cbean, temp, rain)

# fit a PL tree
plt <- pltree(G ~ maxNT + SU, data = cbean, minsize = 50)

plot(plt)

gosset:::plot_tree(plt)
