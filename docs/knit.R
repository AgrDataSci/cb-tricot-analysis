# Script to render all the .Rmd files in this directory at once
library("rmarkdown")
library("knitr")
library("pagedown")

# # get names of .Rmd files
# files <- list.files("docs", pattern = ".Rmd", full.names = TRUE)
# # replace extension .Rmd by .html for the new file names
# newnames <- gsub(".Rmd", ".html", files)
# 
# # run over files and render html 
# for(i in seq_along(files)) {
#   rmarkdown::render(files[i],
#                     output_dir = "docs",
#                     output_format = "html_document",
#                     output_file = newnames[i])
# }

files <- list.files("docs", pattern = ".html", full.names = TRUE)

files <- files[1:6]

outputpath <- "tricot-analysis/slides/"

dir.create(outputpath, recursive = TRUE, showWarnings = FALSE)

newnames <- gsub(".html", ".pdf", files)
newnames <- gsub("docs/", outputpath, newnames)

# run over files and render html
for(i in seq_along(files)) {
  chrome_print(files[i],
               output = newnames[i])
}
