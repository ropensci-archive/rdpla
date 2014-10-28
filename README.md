rdpla
=========



`rdpla`: R client for Digital Public Library of America

Metadata from the Digital Public Library of America ([DPLA](http://dp.la/)). They have [a great API](https://github.com/dpla/platform) with good documentation - a rare thing in this world. Further documentation on their API can be found on their [search fields](http://dp.la/info/developers/codex/responses/field-reference/) and [examples of queries](http://dp.la/info/developers/codex/requests/).

## Quick start

### Installation

Install `rdpla` from GitHub:


```r
install.packages("devtools")
devtools::install_github("ropensci/rdpla")
```


```r
library('rdpla')
```

### Search metadata

Search metadata from the Digital Public Library of America (DPLA).


```r
dpla_basic(q="fruit", verbose=TRUE, fields=c("publisher","format"))
```

### Visualize

Visualize metadata from the DPLA - histogram of number of subjects per record


```r
# Get results from searching on the terme ecology
out <- dpla_basic(q="ecology", fields=c("publisher","subject"), limit=90)
dpla_plot(input=out, plottype = "subjectsum")
```

![](inst/img/dpla_subjects_barplot.png)

Visualize metadata from the DPLA - timeline plot of the top 10 encountered subjects


```r
# Serching for the term science from before the year 1900
out <- dpla_basic(q="science", date.before=1900, limit=200)
dpla_plot(input=out, plottype="subjectsbydate")
```

![](inst/img/dpla_subjects_through_time.png)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rdpla/issues).
* License: MIT
* Get citation information for `rdpla` in R doing `citation(package = 'rdpla')`

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
