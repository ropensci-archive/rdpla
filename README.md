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

### Authentication

You need an API key to use the DPLA API. Use `get_key()` to request a key, which will then be emailed to you. Pass in the key in the `key` parameter in functions in this package or you can store the key in your `.Rprofile` file under the name _dplakey_, which will then be read in automatically.

### Search - items

> Note: limiting fields returned for readme brevity.

Basic search


```r
items(q="fruit", page_size=5, fields=c("provider","creator"))
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
#> 
#> $facets
#> list()
```

Limit fields returned


```r
items(q="fruit", page_size = 10, fields=c("publisher","format"))
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
#> 
#> $facets
#> list()
```

Limit records returned


```r
items(q="fruit", page_size=2, fields=c("provider","title"))
#> $meta
#>   found start returned
#> 1 17954     0        2
#> 
#> $data
#>      title                      provider
#> 1  [Fruit] Mountain West Digital Library
#> 2 [Fruit.]   The New York Public Library
#> 
#> $facets
#> list()
```

Search by date


```r
items(q="science", date_before=1900, page_size=10, fields=c("id","date"))
#> $meta
#>   found start returned
#> 1 29773     0       10
#> 
#> $data
#>                                  id        date
#> 1  2289f4cbee338d3ee22472084399d0c1       1880-
#> 2  3bc189a6c3061bd9c2005e67150d4b5a        1880
#> 3  855407956475c37b086fa7603aa29038        1880
#> 4  afbea811bc274aac4a049828941c86e9        1880
#> 5  e7c3b499f627d21910b4ebb4282f0bdc        1880
#> 6  9f79e6f53dfd2f31a17d756a90f22e0b        1883
#> 7  7a8afa97e5805d66ab044e6a71d70b5f        1851
#> 8  8b2dba3d4947cc97de111425cd43d3e6       1883-
#> 9  1ce2228055729fefa3a12a5a882f631c [1894]-1902
#> 10 655a9657f0beb4d523e41edf9c935996 [1894]-1902
#> 
#> $facets
#> list()
```

Search on specific fields


```r
items(description="obituaries", page_size=2, fields="description")
#> $meta
#>   found start returned
#> 1 50367     0        2
#> 
#> $data
#> [1] "Obituaries of members"             
#> [2] "Pages from the complied obituaries"
#> 
#> $facets
#> list()
```


```r
items(subject="yodeling", page_size=2, fields="subject")
#> $meta
#>   found start returned
#> 1    23     0        2
#> 
#> $data
#> [1] "Yodel & yodeling;Humorous songs;Musicals--Excerpts--Vocal scores with piano"    
#> [2] "Portraits;Costumes and clothes;Yodeling;Holsinger Studio (Charlottesville, Va.)"
#> 
#> $facets
#> list()
```


```r
items(provider="HathiTrust", page_size=2, fields="provider")
#> $meta
#>     found start returned
#> 1 1914614     0        2
#> 
#> $data
#> [1] "HathiTrust" "HathiTrust"
#> 
#> $facets
#> list()
```

Spatial search, across all spatial fields 


```r
items(sp='Boston', page_size=2, fields=c("id","provider"))
#> $meta
#>   found start returned
#> 1 26223     0        2
#> 
#> $data
#>                                 id                provider
#> 1 c6791046ceb3a0425f78a083a5370a13 Smithsonian Institution
#> 2 5fa648a09ec8310841de88afc739e20f Smithsonian Institution
#> 
#> $facets
#> list()
```

Spatial search, by states


```r
items(sp_state='Massachusetts OR Hawaii', page_size=2, fields=c("id","provider"))
#> $meta
#>   found start returned
#> 1 76401     0        2
#> 
#> $data
#>                                 id
#> 1 3d3fba16636ab5211a10ff0b0bf44ae6
#> 2 97feb7d7f98eb76c6713a6435ab9a0cd
#>                                         provider
#> 1 United States Government Printing Office (GPO)
#> 2                                     HathiTrust
#> 
#> $facets
#> list()
```

Faceted search


```r
items(facets=c("sourceResource.spatial.state","sourceResource.spatial.country"),
      page_size=0, facet_size=5)
#> $meta
#>     found start returned
#> 1 8007019     0        0
#> 
#> $data
#> NULL
#> 
#> $facets
#> $facets$sourceResource.spatial.state
#> $facets$sourceResource.spatial.state$meta
#>    type   total missing   other
#> 1 terms 2243251 5965452 1026108
#> 
#> $facets$sourceResource.spatial.state$data
#>             term  count
#> 1          Texas 454858
#> 2        Georgia 228847
#> 3         Kansas 187644
#> 4           Utah 180276
#> 5 North Carolina 165518
#> 
#> 
#> $facets$sourceResource.spatial.country
#> $facets$sourceResource.spatial.country$meta
#>    type   total missing  other
#> 1 terms 2331589 5760256 344997
#> 
#> $facets$sourceResource.spatial.country$data
#>                                                   term   count
#> 1                                        United States 1770950
#> 2 United Kingdom of Great Britain and Northern Ireland  105416
#> 3                                   Republic of France   56512
#> 4                          Federal Republic of Germany   30665
#> 5                                  Repubblica Italiana   23049
```

### Search - collections

Search for collections with the words _university of texas_


```r
collections(q="university of texas", page_size=2)
#> $meta
#>   found returned
#> 1    15        2
#> 
#> $data
#>                                 _rev                  ingestDate
#> 1 1-b30e2458726b17265171946cae413252 2014-09-17T18:35:56.122352Z
#> 2 1-85e81c05b7233e6d346e8f797d8aeb2f 2014-09-17T18:35:56.122352Z
#>                                 id                             @context
#> 1 63933324c0f7076604fef034362ce0cb http://dp.la/api/collections/context
#> 2 d45deb62949c0b85354f5f4a31f268f1 http://dp.la/api/collections/context
#>                            title                 _id description
#> 1            University of Texas   texas--partner:UT            
#> 2 University of Texas at El Paso texas--partner:UTEP            
#>                 @type ingestType
#> 1 dcmitype:Collection collection
#> 2 dcmitype:Collection collection
#>                                                             @id
#> 1 http://dp.la/api/collections/63933324c0f7076604fef034362ce0cb
#> 2 http://dp.la/api/collections/d45deb62949c0b85354f5f4a31f268f1
#>   ingestionSequence     score validation_message valid_after_enrich
#> 1                12 11.002326                 NA               TRUE
#> 2                12  8.862748                 NA               TRUE
```

You can also search in the `title` and `description` fields


```r
collections(description="east")
#> $meta
#>   found returned
#> 1     2       10
#> 
#> $data
#>                                 _rev                  ingestDate
#> 1 1-982711b6d454651dda6a11dd46081697 2014-09-23T01:49:50.345024Z
#> 2 1-e4f629a86f1b267f0411d9dd4e295835 2014-09-04T00:57:02.902600Z
#>                                 id                             @context
#> 1 40e1a1b275d18f21489c311b502c9bcc http://dp.la/api/collections/context
#> 2 6ac62738cc2c583eb5257b311a5ada80 http://dp.la/api/collections/context
#>                                           title               _id
#> 1 Israeli Palestinian Archaeology Working Group usc--p15799coll74
#> 2               Mower County Historical Society    minnesota--mow
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ipawg, also, The West Bank and East Jerusalem Searchable Map
#> 2 The Mower County Historical Society has been collecting photos, artifacts and information related to Mower County history since 1947. Our collection is housed in 21 buildings located at the east end of Mower County Fairgrounds in Austin, Minnesota. Our resources include an extensive research library, allowing researchers of local history and genealogy many sources of information. Our contribution to Minnesota Reflections includes the 1896 Standard Atlas of Mower County and the 1949 Aerial Views of the county showing geographic features, farming traits, churches, schools and transportation routes in Mower County.
#>                 @type ingestType
#> 1 dcmitype:Collection collection
#> 2 dcmitype:Collection collection
#>                                                             @id
#> 1 http://dp.la/api/collections/40e1a1b275d18f21489c311b502c9bcc
#> 2 http://dp.la/api/collections/6ac62738cc2c583eb5257b311a5ada80
#>   ingestionSequence    score validation_message valid_after_enrich
#> 1                13 4.560579                 NA               TRUE
#> 2                13 1.596275                 NA               TRUE
```

### Visualize

Visualize metadata from the DPLA - histogram of number of records per state (includes __states__ outside the US)


```r
out <- items(facets="sourceResource.spatial.state", page_size=0, facet_size=25)
library("ggplot2")
library("scales")
ggplot(out$facets$sourceResource.spatial.state$data, aes(reorder(term, count), count)) +
  geom_bar(stat="identity") +
  coord_flip() + 
  theme_grey(base_size = 16) +
  scale_y_continuous(labels = comma) + 
  labs(x="State", y="Records")
```

![](inst/img/unnamed-chunk-16-1.png) 

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rdpla/issues).
* License: MIT
* Get citation information for `rdpla` in R doing `citation(package = 'rdpla')`

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
