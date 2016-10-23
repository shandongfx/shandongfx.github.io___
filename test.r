# reflesh the whole website
servr::jekyll()
servr::jekyll(command = "jekyll build --watch")
servr::jekyll(command = "jekyll build --force_polling --incrementa")

# https://github.com/yihui/en
# https://github.com/yihui/cn/blob/gh-pages/_config.yml
# https://www.r-bloggers.com/blogging-with-rmarkdown-knitr-and-jekyll/

#install.packages(c("knitr", "servr", "devtools"))     # To process .Rmd files
devtools::install_github("hadley/lubridate")         # brocks reqs dev version
devtools::install_github("brendan-r/brocks")         # My lazy wrapper funs

library(brocks)

new_post_modified <- function (title = "new post", serve = TRUE, dir = "_source", 
          subdir = TRUE, skeleton_file = ".skeleton_post") 
{
  if (!dir.exists(dir)) {
    stop("The directory '", dir, "' doesn't exist. Are you running R in\n         the right directory?")
  }
  fname <- filenamise(title, sep_char = "-")
  fname <- file.path(paste0(Sys.Date(), "-", fname))
  
  if (subdir) {
    fpath <- file.path(dir, fname)
    dir.create(fpath)
  }
  else {
    fpath <- dir
  }
  rmd_name <- file.path(fpath, paste0(fname, 
                                      ".Rmd"))
  r_name <- file.path(fpath, paste0(fname, ".R"))
  if (!file.exists(skeleton_file)) {
    message("File .skeleton_post does not exist. Using package default")
    skeleton_file <- system.file("skeleton_post.Rmd", package = "brocks")
  }
  post <- readLines(skeleton_file)
  post[grepl("title: ", post)] <- paste0("title:  ", title)
  writeLines(post, rmd_name)
  writeLines(c("# This R file accomanies the .Rmd blog post", 
               paste("#", rmd_name), ""), r_name)
  sys_open(r_name)
  sys_open(rmd_name)
  if (serve) 
    blog_serve()
}


new_post_modified("Using a network-diagram to facilitate eliminating predictor variables")
new_post()
blog_gen()
blog_push()
