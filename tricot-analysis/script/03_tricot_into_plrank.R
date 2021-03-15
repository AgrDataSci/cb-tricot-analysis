# library("remotes")
# install_github("hturner/PlackettLuce", upgrade = "never")
# install_github("agrdatasci/gosset", upgrade = "never")

# Packages
library("PlackettLuce")
library("gosset")

# Load the bean data from PlackettLuce
# here we can read some information about the data set
?beans

data("beans", package = "PlackettLuce")

# a data frame with 842 entries and 14 variables
str(beans)

dim(beans)

# first 6 rows 
head(beans)

# last 6 rows
tail(beans)

# get the first five lines to understand the process

beans2 <- beans[1:3, c("variety_a", "variety_b", "variety_c", "best", "worst", "var_a", "var_b", "var_c")]

R <- rank_tricot(data = beans2,
                 items = c("variety_a", "variety_b", "variety_c"),
                 input = c("best", "worst"))

R[1:length(R),, as.rankings = FALSE]


R <- rank_tricot(data = beans,
                 items = c("variety_a", "variety_b", "variety_c"),
                 input = c("best", "worst"),
                 additional.rank = beans[c("var_a", "var_b", "var_c")],
                 full.output = TRUE)

print(R[c(1:3, 843:845)], width = 100)

beans3 <- beans[1:3, c("variety_a", "var_a")]
beans3

tvl <- cbind(ifelse(beans3$var_a == "Better", beans$variety_a, "Local"),
             ifelse(beans3$var_a == "Worse", beans$variety_a, "Local"))

R <- as.rankings(tvl, input = "orderings")

R[1:length(R),, as.rankings=FALSE]
