dir_posts = 'posts'
redo = F

for (rmd in list.files(dir_posts, pattern='\\.Rmd$')){ # rmd = list.files(dir_posts, pattern='\\.Rmd$')[1]

  # render Rmd to html
  pfx = tools::file_path_sans_ext(rmd)
  html = sprintf('%s/%s.html', dir_posts, pfx)
  if (!file.exists(html) | redo){
    path_html = rmarkdown::render(file.path(dir_posts, rmd))
  }

}

# inject links to posts in body
brew::brew('index.brew.html','index.html')
