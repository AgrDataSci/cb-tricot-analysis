# Analyse data with Plackett-Luce model
# from https://doi.org/10.5281/zenodo.4012057
# ..........................................
# ..........................................
## Packages ####
library("gosset")
library("tidyverse")
library("ClimMobTools")
library("PlackettLuce")
library("gtools")
library("ggparty")
library("patchwork")
library("ggplot2")
library("multcompView")


# write session info
# sessioninfo::session_info()
# capture.output(sessioninfo::session_info(),
#                file = "script/session_info/02_analyse_data.txt")

# ..........................................
# ..........................................
# Read data ####
dt <- read.csv("data/sweet_potato.csv")

head(dt)

# keep only Ghana data
dt <- dt[dt$country == "Ghana", ]

# select the reference variety
ref <- "Obare"

# ..........................................
# ..........................................
# Summary tables ####
# make a table with number of participants per type of testing
n <- nrow(dt)

tb <- table(dt$country, dt$trial)

dimnames(tb)[[2]] <- c("Centralised", "Home")

# export the table
output <- "output/summary_tables"
dir.create(output, showWarnings = FALSE, recursive = TRUE)

write.csv(tb, paste0(output, "/summary_trials_per_country.csv"))

# ..........................................
# ..........................................
# create a table with frequencies where each item was evaluated
itemdata <- dt[, paste0("item_", LETTERS[1:3])]

it <- data.frame(table(unlist(itemdata)))

it$x <- with(it, round((Freq / n) * 100, 1))

it$x <- with(it, paste0(x, "%"))

names(it) <- c("Genotype", "Freq", "Relative freq")

# add gender info
gender <- dt[, "gender"]
idt <- unlist(itemdata)

nMan <- sum(gender == "Man", na.rm = TRUE)
nWom <- sum(gender == "Woman", na.rm = TRUE)
  
gender <- cbind(tapply(rep(gender, 3), idt, function(x) sum(x == "Man", na.rm = TRUE)), 
                tapply(rep(gender, 3), idt, function(x) sum(x == "Woman", na.rm = TRUE))) 
  
it <- cbind(it, gender)
  
names(it)[4:5] <- paste0(c("Man (n=","Woman (n="), c(nMan, nWom), ")")
  
# add type of trial
trial <- dt[,"trial"]

nC <- sum(trial == "community", na.rm = TRUE)
nH <- sum(trial == "home", na.rm = TRUE)

trial <- cbind(tapply(rep(trial, 3), idt, function(x) sum(x == "community", na.rm = TRUE)), 
               tapply(rep(trial, 3), idt, function(x) sum(x == "home", na.rm = TRUE))) 

it <- cbind(it, trial)

names(it)[6:7] <- paste0(c("Centralised (n=","Home (n="), c(nC, nH), ")")

write.csv(it, paste0(output, "/summary_tested_varieties_gender_trial.csv"), 
          row.names = FALSE)

# -------------------------------------------
# Create summaries ####


# --------------------------------------------
# Fit PL tree model ####

# two trials (home and community)
# two genotype samples (advanced materials, released varieties)
# responses for OA and description for why ranking best and worst choice

# ..........................................
# ..........................................
# PLT with the OA using variables, 
# community, district, age, gender, trial and geno_test as covariates
g <- dt[dt$country == "Ghana", ]

# abbreviate the name of districts
#g$district <- abbreviate(g$district, 8)

R <- rank_tricot(g, 
                 items = paste0("item_", LETTERS[1:3]),
                 input = c("best_overall","worst_overall"))

G <- group(R, index = seq_along(g$id))

vars <- c("trial", "gender", "district","geno_test","age")

pld <- cbind(G, g[, vars])

# coerce variables to factor
fct <- c("gender", "district", "trial","geno_test")
pld[fct] <- lapply(pld[fct], function(x){
  as.factor(x)
})

head(pld)

pld$age <- as.integer(pld$age)
pld <- pld[!is.na(pld$age), ]

names(pld)[-1] <- ClimMobTools:::.title_case(names(pld)[-1])

head(pld)

# fit the model
plt <- pltree(G ~ District + Age, data = pld, alpha = 0.1, minsize = 50)
  
plot(plt)

gosset:::plot_tree(plt, add.letters = TRUE, threshold = 0.1)

