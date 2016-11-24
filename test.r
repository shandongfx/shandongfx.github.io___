# reflesh the whole website
# servr::jekyll()
# servr::jekyll(command = "jekyll build --watch")
# servr::jekyll(command = "jekyll build --force_polling --incrementa")

# https://github.com/yihui/en
# https://github.com/yihui/cn/blob/gh-pages/_config.yml
# https://www.r-bloggers.com/blogging-with-rmarkdown-knitr-and-jekyll/

#install.packages(c("knitr", "servr", "devtools"))     # To process .Rmd files
devtools::install_github("hadley/lubridate")         # brocks reqs dev version
devtools::install_github("brendan-r/brocks")         # My lazy wrapper funs

library(servr)
library(knitr)
library(brocks)

new_post("test2")
blog_gen()
blog_push()
#jekyll(input="_source/test2/",output="_source/test2/",serve=F)
jekyll()
