# ................................
# ................................
# tricot rankings into PlackettLuce rankings


# If not yet installed, please unlock these lines and 
# install PlackettLuce and gosset
# library("remotes")
# install_github("hturner/PlackettLuce", upgrade = "never")
# install_github("agrdatasci/gosset", upgrade = "never")

# ................................
# ................................
# ................................
# Packages ####
library("PlackettLuce")
library("gosset")

# Load the bean data from PlackettLuce
# here we can read some information about the data set
data("beans", package = "PlackettLuce")

?beans



# a data frame with 842 entries and 14 variables
str(beans)

dim(beans)

# first 6 rows 
head(beans)

# last 6 rows
tail(beans)

# get the first five lines to understand the process
sel <- c("variety_a", "variety_b", "variety_c", "best", "worst", "var_a", "var_b", "var_c")

sel %in% colnames(beans)

all(sel %in% colnames(beans))

# subset the data frame
beans2 <- beans[1:3, sel]

beans2

# write it as a csv file and show
# how this works 
write.csv(beans2, file = "data/beans_subset.csv", row.names = FALSE)



# gosset wrapped this process into a function called 
# rank_tricot()
R <- rank_tricot(data = beans2,
                 items = c("variety_a", "variety_b", "variety_c"),
                 input = c("best", "worst"))

R

R[1:length(R),, as.rankings = FALSE]


# add the local
R <- rank_tricot(data = beans2,
                 items = c("variety_a", "variety_b", "variety_c"),
                 input = c("best", "worst"),
                 additional.rank = beans2[c("var_a", "var_b", "var_c")])

R

R[1:length(R),, as.rankings=FALSE]


