# Script to render all the .Rmd files in this directory at once
library("rmarkdown")
library("knitr")

# get names of .Rmd files
files <- list.files("docs", pattern = ".Rmd", full.names = TRUE)
# replace extension .Rmd by .html for the new file names
newnames <- gsub(".Rmd", ".html", files)

# run over files and render html 
for(i in seq_along(files)) {
  rmarkdown::render(files[i],
                    output_dir = "docs",
                    output_format = "html_document",
                    output_file = newnames[i])
}

