# ................................
# ................................
# Plackett-Luce trees
library("PlackettLuce")
library("qvcalc")
library("gosset")
library("patchwork")
library("ggparty")
library("climatrends")
library("nasapower")
library("ClimMobTools")

# ................................
# ................................
# Example 1: Sweetpotato data
dt <- read.csv("data/sweet_potato.csv")

# keep only the Ghana data
dt <- dt[dt$country == "Ghana", ]

head(dt)

# tricot into a PlackettLuce rankings
R <- rank_tricot(data = dt,
                 items = c("item_A","item_B","item_C"),
                 input = c("best_overall","worst_overall"))


mod <- PlackettLuce(R)

summary(mod)

ref = "SARI-Nyumingre (Obare)"

summary(mod, ref = ref)

plot(qvcalc(mod, ref = ref))

coef(mod, ref = ref)

coef(mod, log = FALSE)

sum(coef(mod, log = FALSE))

# ................................
# ................................
# Add covariates
names(dt)

sel <- c("age", "gender")

covar <- dt[sel]

covar$age <- as.integer(covar$age)
covar$gender <- as.factor(covar$gender)

# check for NAs
sum(is.na(covar))

keep <- apply(covar, 1, function(x){
  sum(is.na(x))
})

keep <- keep == 0

sum(keep)

# filter the data
covar <- covar[keep, ]
dt <- dt[keep, ]

str(covar)

# create a grouped rankings 
G <- rank_tricot(data = dt,
                 items = c("item_A","item_B","item_C"),
                 input = c("best_overall","worst_overall"),
                 group = TRUE)

# combine it with the covariates
pldt <- cbind(G, covar)

head(pldt)

str(pldt)

# fit the PL tree
pl <- pltree(G ~ age + gender, data = pldt, alpha = 0.1)

summary(pl)

plot(pl)

gosset:::plot_tree(pl)

predict(pl)
coef(pl)

# ................................
# ................................
# Example 2: Breadwheat data
# the API key
key <- "d39a3c66-5822-4930-a9d4-50e7da041e77"

dt <- getDataCM(key = key,
                project = "breadwheat",
                pivot.wider = TRUE)


names(dt) <- gsub("firstassessment_|package_|lastassessment_|registration_", "",
                  names(dt))


dt$plantingdate <- as.Date(dt$plantingdate, format = "%Y-%m-%d")
dt$lon <- as.numeric(dt$farm_geo_longitude)
dt$lat <- as.numeric(dt$farm_geo_latitude)

temp <- temperature(dt[, c("lon","lat")], 
                    day.one = dt[, "plantingdate"],
                    span = 80)

temp


G <- rank_tricot(dt, 
                 items = c("item_A","item_B","item_C"), 
                 input = c("overallperf_pos","overallperf_neg"),
                 group = TRUE)

dat <- cbind(G, temp)

pl <- pltree(G ~ maxNT + maxDT, 
             data = dat)

summary(pl)

plot(pl)


