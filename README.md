rdpla
=====



[![Build Status](https://travis-ci.org/ropensci/rdpla.svg?branch=master)](https://travis-ci.org/ropensci/rdpla)
[![codecov](https://codecov.io/gh/ropensci/rdpla/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/rdpla)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rdpla?color=ff69b4)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rdpla)](https://cran.r-project.org/package=rdpla)
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
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 40007     0        5
#> 
#> $data
#> # A tibble: 5 x 2
#>                        provider                         creator
#>                           <chr>                           <chr>
#> 1 Mountain West Digital Library                      no content
#> 2 Mountain West Digital Library                      no content
#> 3 Mountain West Digital Library                      no content
#> 4 Mountain West Digital Library                      no content
#> 5   The New York Public Library Anderson, Alexander (1775-1870)
#> 
#> $facets
#> list()
```

Limit fields returned


```r
dpla_items(q="fruit", page_size = 10, fields=c("publisher","format"))
#> $meta
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 40007     0       10
#> 
#> $data
#> # A tibble: 10 x 2
#>                                    format
#>                                     <chr>
#>  1                             no content
#>  2                             no content
#>  3                             no content
#>  4                             no content
#>  5                             no content
#>  6                             no content
#>  7                Gum bichromate on vinyl
#>  8                      1 b 10 x 12.5 cm.
#>  9 Woodblock print;Ink and color on paper
#> 10                             no content
#> # ... with 1 more variables: publisher <chr>
#> 
#> $facets
#> list()
```

Limit records returned


```r
dpla_items(q="fruit", page_size=2, fields=c("provider","title"))
#> $meta
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 40007     0        2
#> 
#> $data
#> # A tibble: 2 x 2
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
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 57622     0       10
#> 
#> $data
#> # A tibble: 10 x 2
#>                                  id      date
#>                               <chr>     <chr>
#>  1 9cfe90e850b13bc1854f3e40223529c8 1881-1882
#>  2 9d008b592ad35eaa1e4dbff8aa976318      1884
#>  3 268fb8978bbab523ec1ad48ee72e7464      1892
#>  4 7f25fff59b55bd99df3a864e514c3d1d      1893
#>  5 0457c88ca237cec73ce2876f91d56572      1893
#>  6 19bdb84f833b28cb36207d02c38cfc69      1883
#>  7 e93faad718b9d63c2c8dd8725edadb93      1891
#>  8 9f79e6f53dfd2f31a17d756a90f22e0b      1883
#>  9 e3f11047a57f18f8a21baf5d6ff3c4dd      1886
#> 10 e8f0ed10dbdcd0ffd6f504e1892515da      1885
#> 
#> $facets
#> list()
```

Search on specific fields


```r
dpla_items(description="obituaries", page_size=2, fields="description")
#> $meta
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 50777     0        2
#> 
#> $data
#> # A tibble: 2 x 1
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
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1    54     0        2
#> 
#> $data
#> # A tibble: 2 x 1
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
#> # A tibble: 1 x 3
#>     found start returned
#>     <int> <int>    <int>
#> 1 2647621     0        2
#> 
#> $data
#> # A tibble: 2 x 1
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
#> # A tibble: 1 x 3
#>   found start returned
#>   <int> <int>    <int>
#> 1 97974     0        2
#> 
#> $data
#> # A tibble: 2 x 2
#>                                 id                provider
#>                              <chr>                   <chr>
#> 1 337556aaa3096bd77e462d898b70c9d7 Smithsonian Institution
#> 2 41aa36a38d69f5247529505a55528b5d Smithsonian Institution
#> 
#> $facets
#> list()
```

Spatial search, by states


```r
dpla_items(sp_state='Massachusetts OR Hawaii', page_size=2, fields=c("id","provider"))
#> $meta
#> # A tibble: 1 x 3
#>    found start returned
#>    <int> <int>    <int>
#> 1 235411     0        2
#> 
#> $data
#> # A tibble: 2 x 2
#>                                 id
#>                              <chr>
#> 1 3d3fba16636ab5211a10ff0b0bf44ae6
#> 2 0c0b0cc05188d33b63fc6adc14774250
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
#> # A tibble: 1 x 3
#>      found start returned
#>      <int> <int>    <int>
#> 1 17104849     0        0
#> 
#> $data
#> # A tibble: 0 x 0
#> 
#> $facets
#> $facets$sourceResource.spatial.state
#> $facets$sourceResource.spatial.state$meta
#> # A tibble: 1 x 4
#>    type   total  missing   other
#>   <chr>   <int>    <int>   <int>
#> 1 terms 6249159 11599925 3632477
#> 
#> $facets$sourceResource.spatial.state$data
#> # A tibble: 5 x 2
#>            term  count
#>           <chr>  <int>
#> 1         Texas 882954
#> 2    California 636851
#> 3       Georgia 472738
#> 4      New York 397295
#> 5 Massachusetts 226844
#> 
#> 
#> $facets$sourceResource.spatial.country
#> $facets$sourceResource.spatial.country$meta
#> # A tibble: 1 x 4
#>    type   total  missing   other
#>   <chr>   <int>    <int>   <int>
#> 1 terms 7786409 10212531 1818325
#> 
#> $facets$sourceResource.spatial.country$data
#> # A tibble: 5 x 2
#>             term   count
#>            <chr>   <int>
#> 1  United States 5327273
#> 2         Russia  172146
#> 3 United Kingdom  169379
#> 4         Mexico  167957
#> 5         France  131329
```

## Search - collections

Search for collections with the words _university of texas_


```r
dpla_collections(q="university of texas", page_size=2)
#> $meta
#> # A tibble: 1 x 2
#>   found returned
#>   <int>    <int>
#> 1    20        2
#> 
#> $data
#> # A tibble: 2 x 14
#>                                `_rev`                  ingestDate
#>                                 <chr>                       <chr>
#> 1 14-bccf34a900456b064086f20da68b0f89 2017-08-08T02:55:37.637978Z
#> 2 13-e91ba552cf695a88c3f285266a272ca8 2017-08-08T02:55:47.403457Z
#> # ... with 12 more variables: `@context` <chr>, id <chr>, title <chr>,
#> #   `_id` <chr>, description <chr>, `@type` <chr>, ingestType <chr>,
#> #   `@id` <chr>, ingestionSequence <int>, score <dbl>,
#> #   validation_message <lgl>, valid_after_enrich <lgl>
```

You can also search in the `title` and `description` fields


```r
dpla_collections(description="east")
#> $meta
#> # A tibble: 1 x 2
#>   found returned
#>   <int>    <int>
#> 1     3       10
#> 
#> $data
#> # A tibble: 3 x 14
#>                               `_rev`                  ingestDate
#>                                <chr>                       <chr>
#> 1 8-6b723068e71b40c6d9b64b0c14f80e20 2017-05-23T02:22:47.507183Z
#> 2 3-388428340432e8ff676cd8d10f9d02b0 2017-07-31T17:06:05.782685Z
#> 3 3-0318d8a1af2907653ac3a11fb9a5bd5b 2017-07-31T17:05:59.746631Z
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

