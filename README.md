# NEON-DC-DataLesson-Hackathon
A repo for the spatio-temporal data lesson hackathon.

## Workflow

New Rmarkdown (`.Rmd`) posts go into the \_posts folder and must have a date prefix (ie `YYYY-MM-DD`), eg
`_posts/2015-10-15-spatio-temporal-data-workshop.Rmd`. They also need yaml front matter, like so:

```yaml
---
title:  "spatio-temporal Visualization"
author: "Ben Best, Matt Kwit, Meg Williams"
date:   "`r format(Sys.time(), '%Y-%m-%d')`"
output: html_document
---
```

You can then knit to HTML in RStudio. Some of the images may show up with "?" but then appear OK, when you view in external browser. Once knitted, you can `git commit -m "some message"` and `git push` to update the Github repository.

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

Note that a yaml header is not output in the rendered HTML which means jekyll does not render the output when hosted on Github. A make file could be added to this folder which for all posts adds a yaml header to induce Jekyll rendering and update any posts with newer inputs. Until this yaml header gets added after rendering, jekyll handling of tags and categories in yaml of posts won't work.

Jekyll works such that the final site is rendered to `_site`. You can install the [jekyll](http://jekyllrb.com/) ruby gem and generate a browsable \_site from the command line:


```bash
jekyll serve --baseurl ''
```

Then open the URL in a web browser:

```bash
open http://127.0.0.1:4000
```

Fancier realtime development options (ie rendering on the fly with every save) are available with [`servr::jekyll()`](http://yihui.name/knitr-jekyll/2014/09/jekyll-with-knitr.html) and [`servr::make()`](https://github.com/yihui/knitr-jekyll/issues/8).
