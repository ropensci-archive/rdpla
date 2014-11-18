rdpla
=========



[![Build Status](https://api.travis-ci.org/ropensci/rdpla.png)](https://travis-ci.org/ropensci/rdpla)

`rdpla`: R client for Digital Public Library of America

Metadata from the Digital Public Library of America ([DPLA](http://dp.la/)). They have [a great API](https://github.com/dpla/platform) with good documentation - a rare thing in this world. Further documentation on their API can be found on their [search fields](http://dp.la/info/developers/codex/responses/field-reference/) and [examples of queries](http://dp.la/info/developers/codex/requests/).  Metadata schema information [here](http://dp.la/info/wp-content/uploads/2013/04/DPLA-MAP-V3.1-2.pdf). 

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

### Search

> Note: limiting fields returned for readme brevity.

Basic search


```r
dpla_items(q="fruit", page_size=5, fields=c("provider","creator"))
#> $meta
#>   found start returned
#> 1 17954     0        5
#> 
#> $data
#>                        provider
#> 1 Mountain West Digital Library
#> 2   The New York Public Library
#> 3   The New York Public Library
#> 4   The New York Public Library
#> 5       Smithsonian Institution
#>                                                         creator
#> 1 Huntington, Elfie, 1868-1949;Bagley, Joseph Daniel, 1874-1936
#> 2                               Anderson, Alexander (1775-1870)
#> 3                               Anderson, Alexander (1775-1870)
#> 4                               Anderson, Alexander (1775-1870)
#> 5                                                    no content
```

Limit fields returned


```r
dpla_items(q="fruit", page_size = 10, fields=c("publisher","format"))
#> $meta
#>   found start returned
#> 1 17954     0       10
#> 
#> $data
#>                    format  publisher
#> 1              no content no content
#> 2              no content no content
#> 3              no content no content
#> 4              no content no content
#> 5              no content no content
#> 6  Block-printed on paper no content
#> 7              no content no content
#> 8              no content no content
#> 9              no content no content
#> 10             no content no content
```

Limit records returned


```r
dpla_items(q="fruit", page_size=2, fields=c("provider","title"))
#> $meta
#>   found start returned
#> 1 17954     0        2
#> 
#> $data
#>      title                      provider
#> 1  [Fruit] Mountain West Digital Library
#> 2 [Fruit.]   The New York Public Library
```

Search by date


```r
dpla_items(q="science", date_before=1900, page_size=10, fields=c("id","date"))
#> $meta
#>   found start returned
#> 1 29773     0       10
#> 
#> $data
#>            id        date
#> 1  no content       1880-
#> 2  no content        1880
#> 3  no content        1880
#> 4  no content        1880
#> 5  no content        1880
#> 6  no content        1883
#> 7  no content        1851
#> 8  no content       1883-
#> 9  no content [1894]-1902
#> 10 no content [1894]-1902
```

Search on specific fields


```r
dpla_items(description="obituaries", page_size=2, fields="description")
#> $meta
#>   found start returned
#> 1 50367     0        2
#> 
#> $data
#> [1] "Obituaries of members"             
#> [2] "Pages from the complied obituaries"
```


```r
dpla_items(subject="yodeling", page_size=2, fields="subject")
#> $meta
#>   found start returned
#> 1    23     0        2
#> 
#> $data
#> [1] "Yodel & yodeling;Humorous songs;Musicals--Excerpts--Vocal scores with piano"    
#> [2] "Portraits;Costumes and clothes;Yodeling;Holsinger Studio (Charlottesville, Va.)"
```


```r
dpla_items(provider="HathiTrust", page_size=2, fields="provider")
#> $meta
#>     found start returned
#> 1 1914614     0        2
#> 
#> $data
#> [1] "HathiTrust" "HathiTrust"
```

Spatial search, across all spatial fields 


```r
dpla_items(sp='Boston', page_size=2, fields=c("id","provider"))
#> $meta
#>   found start returned
#> 1 26223     0        2
#> 
#> $data
#>           id                provider
#> 1 no content Smithsonian Institution
#> 2 no content Smithsonian Institution
```

Spatial search, by states


```r
dpla_items(sp_state='Massachusetts OR Hawaii', page_size=2, fields=c("id","provider"))
#> $meta
#>   found start returned
#> 1 76401     0        2
#> 
#> $data
#>           id                                       provider
#> 1 no content United States Government Printing Office (GPO)
#> 2 no content                                     HathiTrust
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
