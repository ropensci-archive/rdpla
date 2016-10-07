rdpla
=====



[![Build Status](https://travis-ci.org/ropensci/rdpla.svg?branch=master)](https://travis-ci.org/ropensci/rdpla)
[![codecov](https://codecov.io/gh/ropensci/rdpla/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/rdpla)


`rdpla`: R client for Digital Public Library of America

[Digital Public Library of America][dpla] brings together metadata from libraries, archives,
and museums in the US, and makes it freely available via their web portal as well as 
an API. DPLA's portal and API don't provide the items themselves from contributing 
institutions, but they provide links to make it easy to find things. The kinds of 
things DPLA holds metadata for include images of works held in museums, photographs
from various photographic collections, texts, sounds, and moving images. 

DPLA has [a great API](https://github.com/dpla/platform) with good documentation - 
a rare thing in this world. Further documentation on their API can be found on their [search fields](https://dp.la/info/developers/codex/responses/field-reference/) and [examples of queries](https://dp.la/info/developers/codex/requests/).  Metadata schema information [here](https://dp.la/info/wp-content/uploads/2013/04/DPLA-MAP-V3.1-2.pdf).

DPLA data data can be used for a variety of use cases in various academic and 
non-academic fields. Here are some examples (vignettes to come soon showing examples): 

* Search for all photos of churches and make vizualization of 
their metadata through time
* Visualize data from individual collections - a maintainer of a collection
could gain insight from via DPLA data
* Search for all works within a spatial area, map results

DPLA API has two main services (quoting from [their API docs](https://dp.la/info/developers/codex/requests/)):

* items: A reference to the digital representation of a single piece of content indexed by 
the DPLA. The piece of content can be, for example, a book, a photograph, a video, etc. The 
content is digitized from its original, physical source and uploaded to an online repository. 
* collections: A collection is a little more abstract than an item. Where an item is a 
reference to the digital representation of a physical object, a collection is a 
representation of the grouping of a set of items.

Note that you can only run examples/vignette/tests if you have an API key. See 
`?dpla_get_key` to get an API key.

## Tutorials

There are two vignettes. After installation check them out. If installing from 
GitHub, do `devtools::install_github("ropensci/rdpla", build_vignettes = TRUE)`

* Introduction to rdpla
* rdpla use case: vizualize churches across DPLA holdings

## Installation

Stable version from CRAN


```r
install.packages("rdpla")
```

Dev version from GitHub:


```r
install.packages("devtools")
devtools::install_github("ropensci/rdpla")
```


```r
library('rdpla')
```

## Authentication

You need an API key to use the DPLA API. Use `dpla_get_key()` to request a key, which will then be emailed to you. Pass in the key in the `key` parameter in functions in this package or you can store the key in your `.Renviron` as `DPLA_API_KEY` or in your `.Rprofile` file under the name `dpla_api_key`.

## Search - items

> Note: limiting fields returned for readme brevity.

Basic search


```r
dpla_items(q="fruit", page_size=5, fields=c("provider","creator"))
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 27399     0        5
#> 
#> $data
#> # A tibble: 5 × 2
#>                        provider                         creator
#>                           <chr>                           <chr>
#> 1 Mountain West Digital Library                      no content
#> 2 Mountain West Digital Library                      no content
#> 3 Mountain West Digital Library                      no content
#> 4  Empire State Digital Network                  Preyer, Emilie
#> 5   The New York Public Library Anderson, Alexander (1775-1870)
#> 
#> $facets
#> list()
```

Limit fields returned


```r
dpla_items(q="fruit", page_size = 10, fields=c("publisher","format"))
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 27399     0       10
#> 
#> $data
#> # A tibble: 10 × 2
#>        format  publisher
#>         <chr>      <chr>
#> 1  no content no content
#> 2  no content no content
#> 3  no content no content
#> 4  no content no content
#> 5  no content no content
#> 6  no content no content
#> 7  no content no content
#> 8  no content no content
#> 9  no content no content
#> 10 no content no content
#> 
#> $facets
#> list()
```

Limit records returned


```r
dpla_items(q="fruit", page_size=2, fields=c("provider","title"))
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 27162     0        2
#> 
#> $data
#> # A tibble: 2 × 2
#>   title                      provider
#>   <chr>                         <chr>
#> 1 Fruit Mountain West Digital Library
#> 2 Fruit Mountain West Digital Library
#> 
#> $facets
#> list()
```

Search by date


```r
dpla_items(q="science", date_before=1900, page_size=10, fields=c("id","date"))
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 50843     0       10
#> 
#> $data
#> # A tibble: 10 × 2
#>                                  id      date
#>                               <chr>     <chr>
#> 1  7a8afa97e5805d66ab044e6a71d70b5f      1851
#> 2  8b2dba3d4947cc97de111425cd43d3e6     1883-
#> 3  855407956475c37b086fa7603aa29038      1880
#> 4  e7c3b499f627d21910b4ebb4282f0bdc      1880
#> 5  afbea811bc274aac4a049828941c86e9      1880
#> 6  4786d787da0ac9f126e5daf9a32f16b7      1886
#> 7  9f79e6f53dfd2f31a17d756a90f22e0b      1883
#> 8  bf656dc0ab243d29eba122387fbc0950 1881-1882
#> 9  3bc189a6c3061bd9c2005e67150d4b5a      1880
#> 10 2289f4cbee338d3ee22472084399d0c1     1880-
#> 
#> $facets
#> list()
```

Search on specific fields


```r
dpla_items(description="obituaries", page_size=2, fields="description")
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 50667     0        2
#> 
#> $data
#> # A tibble: 2 × 1
#>                          description
#>                                <chr>
#> 1              Obituaries of members
#> 2 Pages from the complied obituaries
#> 
#> $facets
#> list()
```


```r
dpla_items(subject="yodeling", page_size=2, fields="subject")
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1    51     0        2
#> 
#> $data
#> # A tibble: 2 × 1
#>                                                     subject
#>                                                       <chr>
#> 1 Yodeling--Austria;Musicians--Austria;Restaurants--Austria
#> 2  Yodeling--Austria;Musicians--Austria;Gamehouses--Austria
#> 
#> $facets
#> list()
```


```r
dpla_items(provider="HathiTrust", page_size=2, fields="provider")
#> $meta
#> # A tibble: 1 × 3
#>     found start returned
#>     <int> <int>    <int>
#> 1 2566670     0        2
#> 
#> $data
#> # A tibble: 2 × 1
#>     provider
#>        <chr>
#> 1 HathiTrust
#> 2 HathiTrust
#> 
#> $facets
#> list()
```

Spatial search, across all spatial fields


```r
dpla_items(sp='Boston', page_size=2, fields=c("id","provider"))
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 75970     0        2
#> 
#> $data
#> # A tibble: 2 × 2
#>                                 id                provider
#>                              <chr>                   <chr>
#> 1 c6791046ceb3a0425f78a083a5370a13 Smithsonian Institution
#> 2 1542004b196587885a5150650a5451ec Smithsonian Institution
#> 
#> $facets
#> list()
```

Spatial search, by states


```r
dpla_items(sp_state='Massachusetts OR Hawaii', page_size=2, fields=c("id","provider"))
#> $meta
#> # A tibble: 1 × 3
#>    found start returned
#>    <int> <int>    <int>
#> 1 182228     0        2
#> 
#> $data
#> # A tibble: 2 × 2
#>                                 id
#>                              <chr>
#> 1 b6f7914260c69876dd81037d353cdcc2
#> 2 97feb7d7f98eb76c6713a6435ab9a0cd
#> # ... with 1 more variables: provider <chr>
#> 
#> $facets
#> list()
```

Faceted search


```r
dpla_items(facets=c("sourceResource.spatial.state","sourceResource.spatial.country"),
      page_size=0, facet_size=5)
#> $meta
#> # A tibble: 1 × 3
#>      found start returned
#>      <int> <int>    <int>
#> 1 14037948     0        0
#> 
#> $data
#> # A tibble: 0 × 0
#> 
#> $facets
#> $facets$sourceResource.spatial.state
#> $facets$sourceResource.spatial.state$meta
#> # A tibble: 1 × 4
#>    type   total  missing   other
#>   <chr>   <int>    <int>   <int>
#> 1 terms 4014977 10478090 2211661
#> 
#> $facets$sourceResource.spatial.state$data
#> # A tibble: 5 × 2
#>            term  count
#>           <chr>  <int>
#> 1         Texas 758429
#> 2       Georgia 371966
#> 3    California 265226
#> 4          Utah 231129
#> 5 Massachusetts 176566
#> 
#> 
#> $facets$sourceResource.spatial.country
#> $facets$sourceResource.spatial.country$meta
#> # A tibble: 1 × 4
#>    type   total missing  other
#>   <chr>   <int>   <int>  <int>
#> 1 terms 4609034 9673035 793115
#> 
#> $facets$sourceResource.spatial.country$data
#> # A tibble: 5 × 2
#>             term   count
#>            <chr>   <int>
#> 1  United States 3523179
#> 2 United Kingdom   97742
#> 3         France   91655
#> 4         Canada   67781
#> 5        Germany   35562
```

## Search - collections

Search for collections with the words _university of texas_


```r
dpla_collections(q="university of texas", page_size=2)
#> $meta
#> # A tibble: 1 × 2
#>   found returned
#>   <int>    <int>
#> 1    18        2
#> 
#> $data
#> # A tibble: 2 × 14
#>                                `_rev`                  ingestDate
#>                                 <chr>                       <chr>
#> 1 10-01d4520a193dc80b47edff4d0c033690 2016-07-11T17:22:44.544050Z
#> 2 10-527c98617e8154a1c9432630753b9f1f 2016-07-11T17:22:43.760797Z
#> # ... with 12 more variables: `@context` <chr>, id <chr>, title <chr>,
#> #   `_id` <chr>, description <chr>, `@type` <chr>, ingestType <chr>,
#> #   `@id` <chr>, ingestionSequence <int>, score <dbl>,
#> #   validation_message <lgl>, valid_after_enrich <lgl>
```

You can also search in the `title` and `description` fields


```r
dpla_collections(description="east")
#> $meta
#> # A tibble: 1 × 2
#>   found returned
#>   <int>    <int>
#> 1     3       10
#> 
#> $data
#> # A tibble: 3 × 14
#>                                `_rev`                  ingestDate
#>                                 <chr>                       <chr>
#> 1  6-7283e1d42b01b1944637bec58a42b070 2016-09-22T05:27:22.447683Z
#> 2 11-db94de89ceb4e5ffe12cd9f041709795 2016-09-13T16:14:45.744176Z
#> 3  1-edfcbe6eb4befaeab389b4534046f3d6 2016-09-13T16:14:41.053522Z
#> # ... with 12 more variables: `@context` <chr>, id <chr>, title <chr>,
#> #   `_id` <chr>, description <chr>, `@type` <chr>, ingestType <chr>,
#> #   `@id` <chr>, ingestionSequence <int>, score <dbl>,
#> #   validation_message <lgl>, valid_after_enrich <lgl>
```

## Visualize

Visualize metadata from the DPLA - histogram of number of records per state (includes __states__ outside the US)


```r
out <- dpla_items(facets="sourceResource.spatial.state", page_size=0, facet_size=25)
library("ggplot2")
library("scales")
ggplot(out$facets$sourceResource.spatial.state$data, aes(reorder(term, count), count)) +
  geom_bar(stat="identity") +
  coord_flip() +
  theme_grey(base_size = 16) +
  scale_y_continuous(labels = comma) +
  labs(x="State", y="Records")
```

![](inst/img/unnamed-chunk-17-1.png)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rdpla/issues).
* License: MIT
* Get citation information for `rdpla` in R doing `citation(package = 'rdpla')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)

[dpla]: https://dp.la

