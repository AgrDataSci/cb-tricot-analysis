# Here is the exercise from the 
# Introduction to R

# ................................
# ................................
# ................................


# 1. Install the packages tidyverse, climatrends and remotes
# using the function install.packages()
# block the line using # after you have installed the packages



# 2. Install the packages PlackettLuce, ClimMobTools and gosset
# using the function install_github() from the package remotes
# PlackettLuce is hosted at hturner/
# ClimMobTools and gosset are hosted at agrdatasci/
# block the line using # after you have installed the packages


# 3. Load the five packages using the function library()


# 4. Create a vector of integers with length 7
x <- c(11, 31, 53, 7, 19, 11, 32)

x > 20

x[ x < 20 ]

x[ x > 20 ]


which(x < 20)

# 5. Create a vector of logical with length 7
l <- c(TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE)

which(l == TRUE)

# 6. Create a vector character with length 7
f <- c("M", "W", "W", "M", "M", "W", "W")

f == "M"

f[f == "M"]

which(f == "M")

# 7. Create a data frame with these three vectors
# using the function data.frame()
dat <- data.frame(experience = x,
                  gender = f,
                  bank = l)

dat

# 8. Select the rows from 1 to 3 and all the columns 
# in the previous data.frame
dim(dat)

dat[1:3, ]



# 9. Select the rows 3 and 7 and only the column with 
# character and logical from the previous data.frame
# select the columns using the names 
dat[c(3,7), 2:3]

keep <- dat$experience > 15
keep2 <- dat$bank == FALSE

dat[keep & keep2, ]

boxplot(dat$experience)

boxplot(dat$experience ~ dat$gender)

# boxplot(dat$experience ~ dat$bank)


# simulate some data 

set.seed(234)
age = as.integer(rnorm(n = 100, mean = 40, sd = 5))

gender = rep(c("M", "W"), each = 50)

set.seed(123)
land = sample(c(TRUE, FALSE), 100, replace = TRUE)

set.seed(456)
yield = rnorm(100, 20, 5)
hist(yield)

dat = data.frame(age, gender, land, yield)

boxplot(dat$yield ~ dat$gender, 
        ylab = "Yield (kg/ha)",
        xlab = "Gender")

?glm
mod = glm(yield ~ gender, data = dat)

summary(mod)

mod_aov = anova(mod)

mod_aov

plot(mod)






































