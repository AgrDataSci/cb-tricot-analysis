# ................................
# ................................
# ClimMob data in R

# If not yet installed, please unlock these lines and 
# install ClimMobTools
# library("remotes")
# install_github("agrdatasci/ClimMobTools", upgrade = "never")


# ................................
# ................................
# ................................
# Packages ####
library("ClimMobTools") 

# the API key 
key <- "d39a3c66-5822-4930-a9d4-50e7da041e77"

projects <- getProjectsCM(key)

projects


# as a tidy data frame 
bread <- getDataCM(key, project = "breadwheat")

bread

# as a wider data frame 
bread <- getDataCM(key, project = "breadwheat", pivot.wider = TRUE)

bread

# as a list
bread <- getDataCM(key, project = "breadwheat", as.data.frame = FALSE)

bread

