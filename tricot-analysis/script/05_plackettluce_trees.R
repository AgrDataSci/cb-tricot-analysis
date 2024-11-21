# ................................
# ................................
# Plackett-Luce trees
library("PlackettLuce")
library("qvcalc")
library("gosset")
library("patchwork")
library("ggparty")


# ................................
# ................................
# Example 1: Sweetpotato data
list.files("data", full.names = TRUE)


dt <- read.csv("data/sweet_potato.csv")

str(dt)


# keep only the Uganda data
keep <- dt$country == "Uganda"

table(keep)

dt <- dt[keep, ]

dim(dt)

tail(dt)

# Kendall correlation
#       varA varB varC
over <- c(1,  2,  3)
tast <- c(1,  3,  2)
smel <- c(1,  2,  3)

cor(over, smel, method = "kendall")

###

# tricot into a PlackettLuce rankings
R <- rank_tricot(data = dt,
                 items = c("item_A","item_B","item_C"),
                 input = c("best_overall","worst_overall"))

# rank for taste
names(dt)
RT <- rank_tricot(data = dt,
                  items = c("item_A","item_B","item_C"),
                  input = c("best_taste", "worst_taste"))

RT
names(dt)
# rank for color
RC <- rank_tricot(data = dt,
                  items = c("item_A","item_B","item_C") ,
                  input = c("best_color", "worst_color"))

# # for loop
# traits <- c("overall", "color", "taste")
# Rlist <- list()
# for (i in seq_along(traits)) {
#   R_i <- rank_tricot(dt,
#                      items = c("item_A","item_B","item_C"),
#                      input = paste0(c("best_", "worst_"), traits[i]))
#   Rlist[[i]] <- R_i
# }
# 
# Rlist

R
RT
RC

kendallTau(R, RT)

kendallTau(R, RC)

Rlist <- list(Taste = RT, 
              Color = RC)
traits <- c("Taste", "Color")
ag <- summarise_agreement(R, Rlist, traits)

plot(ag) +
  theme_bw()
##
modC <- PlackettLuce(RC)

ref <- "Ejumula"

summary(modC, ref = ref)

qv <- qvcalc(modC, ref = ref)

plot(qv)

# taste
ref <- "Ejumula"
modT <- PlackettLuce(RT)

summary(modT, ref = ref)

qvT <- qvcalc(modT, ref = ref)
plot(qvT)

# overall 
mod <- PlackettLuce(R)

summary(mod, ref = ref)

qv <- qvcalc(mod, ref = ref)

plot(qv)

sort(coef(mod, log = FALSE))

sum(coef(mod, log = FALSE))

capture.output(summary(mod),
               coef(mod), 
               file = "output/summary_mod_sweetpotato.txt")




# ................................
# ................................
# Add covariates
names(dt)

sel <- c("age", "gender")

covar <- dt[, sel]

str(covar)


covar$age <- as.integer(covar$age)
covar$gender <- as.factor(covar$gender)

summary(covar$gender)

# check for NAs
sum(is.na(covar))

keep <- apply(covar, 1, function(x){
  sum(is.na(x))
})

keep

keep <- keep == 0

sum(keep)

# filter 
covar <- covar[keep, ]
dt <- dt[keep, ]

str(covar)

# create a grouped rankings 
G <- rank_tricot(data = dt,
                 items = c("item_A","item_B","item_C"),
                 input = c("best_overall","worst_overall"),
                 group = TRUE)

G

# combine it with the covariates
pldt <- cbind(G, covar)

head(pldt)

str(pldt)

# fit the PL tree
names(pldt)

pl <- pltree(G ~ age + gender, data = pldt, alpha = 0.1, 
             minsize = 30,
             verbose = TRUE)


summary(pl, ref = ref)

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

names(dt)

names(dt) <- gsub("firstassessment_|package_|lastassessment_|registration_", 
                  "",
                  names(dt))



dt$plantingdate <- as.Date(dt$plantingdate, format = "%Y-%m-%d")

boxplot(dt$plantingdate)

dt$lon <- as.numeric(dt$farm_geo_longitude)
dt$lat <- as.numeric(dt$farm_geo_latitude)


temp <- temperature(dt[, c("lon", "lat")],
                    day.one = dt[, "plantingdate"],
                    span = 80)

temp


G <- rank_tricot(dt, 
                 items = c("item_A","item_B","item_C"), 
                 input = c("overallperf_pos","overallperf_neg"),
                 group = TRUE)

dat <- cbind(G, temp)

head(dat)

pl <- pltree(G ~ maxNT + maxDT, 
             data = dat)

summary(pl)

plot(pl)


gosset:::plot_tree(pl)

coef(pl)

coef(pl, log = FALSE)


predict(pl, newdata = dat[1:10, ])


?predict




