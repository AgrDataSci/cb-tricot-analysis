# ................................
# ................................
# Here is the exercise from the 
# tricot rankings into PlackettLuce rankings

# ................................
# ................................
# ................................
# 1. Load the packages gosset, ClimMobTools and PlackettLuce
library("PlackettLuce")
library("gosset")

data(beans)

# 3. Select the columns that are used for this process and 
#  and assign a new object 
str(beans)


plot(beans[,c("lon", "lat")])

vars = unlist(beans[,c("variety_a", "variety_b", "variety_c")])

table(vars)

table(beans$season)

# 4. Use the function rank_tricot() to create the rankings
# Attention to the order of the elements in the input and items vector
# they should be in the order of itemA, itemB, itemC and best, worst
?rank_tricot

names(beans)

R2 = rank_tricot(data = beans,
                 items = c("variety_a", "variety_b", "variety_c"),
                 input = c("best", "worst"),
                 additional.rank = beans[,c("var_a", "var_b", "var_c")])

class(R2)
 
mod = PlackettLuce(R2)

class(mod)

str(mod)

summary(mod, ref = "Local")

qvmod = qvcalc(mod)

plot(qvmod)

worth = itempar(mod)

sort(worth)


G = rank_tricot(data = beans,
                items = c("variety_a", "variety_b", "variety_c"),
                input = c("best", "worst"),
                additional.rank = beans[,c("var_a", "var_b", "var_c")],
                group = TRUE)

class(G)

length(G)
nrow(beans)

dat <- cbind(G, beans[,c("season", "maxTN")])

head(dat)

?pltree

names(dat)

plt = pltree(G ~ season + maxTN, data = dat)

summary(plt)

plot(plt)

library(patchwork)
library(ggparty)

gosset:::plot_tree(plt)

AIC(mod)
AIC(plt)



# ####
# varieties <-dimnames(R2)[[2]]
# 
# features <- data.frame(varieties = varieties,
#                        yield = 0)
# 
# modglm <- pladmm(R2, ~ varieties, data = features)
# 
# summary(modglm)
# 
# itempar(modglm)
