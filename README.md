# NEON-DC-DataLesson-Hackathon
A repository for the visualization module from spatio-temporal data lesson hackathon. This site is viewable at http://data-lessons.github.com/NEON-R-Make-Pretty-Maps-Plots.

## Workflow

New Rmarkdown (`.Rmd`) posts go into the `posts` folder. These files need yaml front matter, like so:

```yaml
---
title:  "spatio-temporal Visualization"
author: "Ben Best, Matt Kwit, Meg Williams"
date:   "`r format(Sys.time(), '%Y-%m-%d')`"
output: html_document
---
```

You can then knit to HTML in RStudio. Some of the images may show up with "?" but then appear OK, when you view in external browser. Once knitted, you can `git commit -m "some message"` and `git push` to update the Github repository.

Once you add/remove/rename a post, you'll want to run `make.R` which inserts posts by brewing from `index.brew.html` into `index.html`.

## Details

Because this visualization module uses interactive [htmlwidgets](http://htmlwidgets.org) such as [leaflet](http://rstudio.github.io/leaflet/) for maps, [dygraphs](http://rstudio.github.io/dygraphs/) for time-series and [DT](http://rstudio.github.io/DT/) for data tables, a more typical rendering interoperable with [knitr](http://yihui.name/knitr/) and [jekyll](http://jekyllrb.com/docs/github-pages/) in Github pages is not possible, per [Using htmlwidgets graphics with servr::jekyll() · Issue #8 · yihui/knitr-jekyll](https://github.com/yihui/knitr-jekyll/issues/8).

Instead, the knitted html_document draws from the [shared options](http://rmarkdown.rstudio.com/html_document_format.html#shared-options) `_output.yaml`:

```yaml
html_document:
  toc: true
  toc_depth: 4
  self_contained: false
  lib_dir: libs
  pandoc_args: [
      "--title-prefix", "Spatio-Temporal NEON Data Workshop",
    ]
  highlight: zenburn
  includes:
    in_header:   _output/header.html
    before_body: _output/before_body.html
    after_body:  _output/after_body.html
```

This then places HTML chunks in the header and around the body to provide the NEON navigational template elements.

Note that [jekyll](http://jekyllrb.com/) has been turned off for the site with the `.nojekyll` file.
