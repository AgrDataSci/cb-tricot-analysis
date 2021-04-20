# ................................
# ................................
# Introduction to R
# this script will show some base R commands

# ................................
# ................................
# ................................
# Vectors #####

# The elements of the vector must be of the same type, common types 
# are integer, numeric, character, factor and logical
# Elements of a vector are separated to each other with a comma 

# Numbers are native elements and are recognised by R without the 
# need of quotation mark " "
# an integer
c(1, 2, 3)


# To assign strings (characters) to a vector you need to wrap 
# each element with a quotation mark
# a vector with characters (strings)
c("red", "yellow", "green") 

c("red", "yellow", "green")


c(1, 2, 3)

# a logical
c(TRUE, FALSE, TRUE) 

# something
# R is a case sensitive language, 
# TRUE is different than true or True 
# true, TRUE, True



# Missing values (of any type) are represented by logical constant `NA`.

c("apple",  "banana", "orange", NA)

length(c("apple", "banana", "orange", NA))


length(c("apple", "banana", "orange"))

# The function `is.na()` helps in finding the `NA`s in a vector
is.na(c("apple", "banana", "orange", NA))

!is.na(c("apple", "banana", "orange", NA))

# ................................
# ................................
# ................................
# Lists #####

# Lists are the R objects which contain elements of different types like numbers, 
# characters, vectors or even another list inside it

list(
  c(1, 4, 6, 7, 10, 11),
  c("A", "G", "R", "J", NA),
  FALSE
)

# ................................
# ................................
# ................................
# Data frame #####

#  a list of equal-length vectors and can be created with the function `data.frame()`

iris

str(iris)

dim(iris)

ncol(iris)

nrow(iris)

# creating a data frame

data.frame(farmername = c("Kjs", "Jsk", "Opa", "Ghs", "Lkd"),
           age = c(23, 34, 50, 40, 36),
           participated = c(TRUE, FALSE, TRUE, TRUE, TRUE))

# ................................
# ................................
# ................................
# R objects #####

# objects are assigned with <- or =

dt <- data.frame(farmername = c("Kjs", "Jsk", "Opa", "Ghs", "Lkd"),
                 age = c(23, 34, 50, 40, 36),
                 participated = c(TRUE, FALSE, TRUE, TRUE, TRUE))


farmsize <- c(0.3, 0.5, 1.2, 0.6, 2)

dt <- cbind(dt, farmsize)


# ................................
# ................................
# ................................
# Indexing #####

x <- c(4, 5, 2, -1, 11, 15, 6, 3)

length(x)

x

x[1]

x[1:3]

x[c(3,5,8)]


# %in%
# checks if 3 is within x
3 %in% x

# checks whether x has the value 3 and where is it
x %in% 3

# match
match(5, x)

# which
which(x > 3)

# ................................
# ................................
# ................................
# Indexing a Data frame #####

# take all the elements from the first column
dt[1] 

# take all the elements from the fist row
dt[1,]

# take the elements from rows one and three, and columns three and four
dt[c(1,3), c(3, 4)]

# access column named farmername dt
# this returns a data frame with one column
dt["farmername"]

# dollar sign $ can be used to access elements inside a data frame or a list
dt$farmername


# access lines one and two
dt[1:2, c("farmername", "farmsize")] 


# ................................
# ................................
# ................................
# R packages #####

# install.packages("ggplot2")

# install.packages("remotes")
# remotes::install_github("agrdatasci/gosset", upgrade = "never")
