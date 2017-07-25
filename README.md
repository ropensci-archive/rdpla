rdpla
=====



[![Build Status](https://travis-ci.org/ropensci/rdpla.svg?branch=master)](https://travis-ci.org/ropensci/rdpla)
[![codecov](https://codecov.io/gh/ropensci/rdpla/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/rdpla)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/rdpla?color=ff69b4)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rdpla)](https://cran.r-project.org/package=rdpla)
[![](https://badges.ropensci.org/71_status.svg)](https://github.com/ropensci/onboarding/issues/71)


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

* Introduction to `rdpla`
* `rdpla` use case: vizualize churches across DPLA holdings

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

You need an API key to use the DPLA API. Use `dpla_get_key()` to request a key, 
which will then be emailed to you. Pass in the key in the `key` parameter in 
functions in this package or you can store the key in your `.Renviron` as 
`DPLA_API_KEY` or in your `.Rprofile` file under the name `dpla_api_key`.

## Search - items

> Note: limiting fields returned for readme brevity.

Basic search


```r
dpla_items(q="fruit", page_size=5, fields=c("provider","creator"))
#> $meta
#> # A tibble: 1 × 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 28179     0        5
#> 
#> $data
#> # A tibble: 5 × 2
#>                        provider                         creator
#>                           <chr>                           <chr>
#> 1   The New York Public Library Anderson, Alexander (1775-1870)
#> 2   The New York Public Library Anderson, Alexander (1775-1870)
#> 3   The New York Public Library Anderson, Alexander (1775-1870)
#> 4 Mountain West Digital Library                      no content
#> 5 Mountain West Digital Library                      no content
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
#> 1 28179     0       10
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
#> 1 28179     0        2
#> 
#> $data
#> # A tibble: 2 × 2
#>      title                    provider
#>      <chr>                       <chr>
#> 1 [Fruit.] The New York Public Library
#> 2 [Fruit.] The New York Public Library
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
#> 1 51435     0       10
#> 
#> $data
#> # A tibble: 10 × 2
#>                                  id      date
#>                               <chr>     <chr>
#> 1  855407956475c37b086fa7603aa29038      1880
#> 2  8b2dba3d4947cc97de111425cd43d3e6     1883-
#> 3  7a8afa97e5805d66ab044e6a71d70b5f      1851
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
#> 1 50675     0        2
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
#> 1    53     0        2
#> 
#> $data
#> # A tibble: 2 × 1
#>                                                subject
#>                                                  <chr>
#> 1 Yodel & yodeling;Humorous songs;Musicals;Sheet music
#> 2 Yodel & yodeling;Humorous songs;Musicals;Sheet music
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
#> 1 2611716     0        2
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
#> 1 81448     0        2
#> 
#> $data
#> # A tibble: 2 × 2
#>                                 id                provider
#>                              <chr>                   <chr>
#> 1 c6791046ceb3a0425f78a083a5370a13 Smithsonian Institution
#> 2 90bef8ecb080f0abd457a94daea6c8f2 Smithsonian Institution
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
#> 1 211226     0        2
#> 
#> $data
#> # A tibble: 2 × 2
#>                                 id
#>                              <chr>
#> 1 3d3fba16636ab5211a10ff0b0bf44ae6
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
#> 1 15482760     0        0
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
#> 1 terms 4765201 11283320 2636181
#> 
#> $facets$sourceResource.spatial.state$data
#> # A tibble: 5 × 2
#>            term  count
#>           <chr>  <int>
#> 1         Texas 834772
#> 2       Georgia 449124
#> 3      New York 353060
#> 4    California 286216
#> 5 Massachusetts 205848
#> 
#> 
#> $facets$sourceResource.spatial.country
#> $facets$sourceResource.spatial.country$meta
#> # A tibble: 1 × 4
#>    type   total  missing  other
#>   <chr>   <int>    <int>  <int>
#> 1 terms 5644931 10154647 939834
#> 
#> $facets$sourceResource.spatial.country$data
#> # A tibble: 5 × 2
#>             term   count
#>            <chr>   <int>
#> 1  United States 4352777
#> 2 United Kingdom   99586
#> 3         France   97612
#> 4          China   78146
#> 5         Israel   76976
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
#> 1 10-81b4fd4a25fa48aa5a64b4ab7cb5bb58 2017-02-02T01:24:38.616543Z
#> 2 11-1bc6a8639fad19641c7b9e5df90608da 2017-02-02T01:24:36.686171Z
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
#> 1  7-dea73f0c6ab156f8451df771b8d807ba 2016-12-14T18:35:02.688434Z
#> 2 13-337242dcdbeb689009e0469ae87a94d0 2017-02-02T22:09:32.912791Z
#> 3  3-33d9d46983d4f05afab55fb81941e54a 2017-02-02T22:09:31.965405Z
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

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[dpla]: https://dp.la

