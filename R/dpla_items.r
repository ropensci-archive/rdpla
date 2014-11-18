#' Search items from the Digital Public Library of America (DPLA).
#'
#' @importFrom httr GET POST content warn_for_status stop_for_status
#' @importFrom jsonlite fromJSON
#' @importFrom plyr rbind.fill
#' @export
#'
#' @param q Query terms.
#' @param description Object description.
#' @param title Object title.
#' @param subject Subject.
#' @param creator Creator
#' @param type Type of object
#' @param publisher PUblisher
#' @param format Format
#' @param rights Rights
#' @param contributor Contributor
#' @param provider Provider
#' @param sp Query all spatial fields.
#' @param sp_coordinates Query only coordinates. Of the form <latitude,longitude>
#' @param sp_city Query by city name.
#' @param sp_county Query by county name.
#' @param sp_distance Distance from point defined in the \code{sp_coordinates} field
#' @param sp_country Query by location country
#' @param sp_code Query by ISO 3166-2 country code. Codes are included in this package, see
#' \code{country_codes}. Find out more at \url{https://www.iso.org/obp/ui/#search}.
#' @param sp_name Location name.
#' @param sp_region Name of a region, e.g., "Upstate New York" (literal)
#' @param sp_state ISO 3166-2 code for a U.S. state or territory
#' @param language One of a name of a language, or an ISO-639 code. Codes are included in this
#' package, see \code{language_codes}.  Find out more at
#' \url{http://www-01.sil.org/iso639-3/default.asp}.
#' @param sort_by The default sort order is ascending. Most, but not all fields
#'    can be sorted on. Attempts to sort on an un-sortable field will return
#'    the standard error structure with a HTTP 400 status code.
#' @param fields A vector of the fields to return in the output. The default
#'    is all fields. See details for options.
#' @param date A date
#' @param date_before Date before
#' @param date_after Date after
#' @param page_size Number of items to return, defaults to 100. Max of 500.
#' @param page Page number to return, defaults to NULL.
#' @param facets Fields to facet on.
#' @param facet_size Default to 100, maximum 2000.
#' @param key Your DPLA API key. Either pass in here, or store in your \code{.Rprofile} file
#'    and it will be read in on function execution.
#' @param what One of list or table (dat.frame). (Default: table)
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @details Options for the fields argument are:
#' \itemize{
#'  \item id The item id
#'  \item title The title of the object
#'  \item decription The description of the object
#'  \item subject The subjects of the object
#'  \item creator The creator of the object
#'  \item type The type of the object
#'  \item publisher The publisher of the object
#'  \item format The format of the object
#'  \item rights The rights for the object
#'  \item contributor The contributor of the object
#'  \item spatial The spatial of the object
#'  \item isPartOf The isPartOf thing, not sure what this is
#'  \item provider The provider of the object
#' }
#' @return A list of length two: meta with the metadata for the call (found, offset [aka start],
#' and page_size [number results returned]), and the resulting data.frame of results.
#'
#' @examples \donttest{
#' # Basic search, "fruit" in any fields
#' dpla_items(q="fruit")
#'
#' # Limit records returned
#' dpla_items(q="fruit", page_size=2)
#'
#' # Return certain fields
#' dpla_items(q="fruit", fields=c("id","publisher","format"))
#' dpla_items(q="fruit", fields="subject")
#'
#' # Max is 500 per call, but you can use combo of page_size and page params
#' dpla_items(q="fruit", fields="id", page_size=500)$meta$returned
#' lapply(1:2, function(x) dpla_items(q="fruit", fields="id", page_size=500, page=x)$meta$returned)
#' out <- lapply(1:2, function(x) dpla_items(q="fruit", fields="id", page_size=500, page=x))
#' lapply(out, function(y) head(y$data))
#'
#' # Search by date
#' out <- dpla_items(q="science", date_before=1900, page_size=200)
#' head(out$data)
#'
#' # Search by various fields
#' dpla_items(description="obituaries", page_size=2, fields="description")
#' dpla_items(title="obituaries", page_size=2, fields="title")
#' dpla_items(subject="yodeling", page_size=2, fields="subject")
#' dpla_items(creator="Holst-Van der Schalk", page_size=2, fields="creator")
#' dpla_items(type="text", page_size=2, fields="type")
#' dpla_items(publisher="Leningrad", page_size=2, fields="publisher")
#' dpla_items(rights="unrestricted", page_size=2, fields="rights")
#' dpla_items(provider="HathiTrust", page_size=2, fields="provider")
#'
#' ## don't seem to work
#' # dpla_items(contributor="Smithsonian", page_size=2, fields="contributor")
#' # dpla_items(format="Electronic resource", page_size=2, fields="format")
#'
#' # Spatial search
#' ## sp searches all spatial fields, or search on specific fields, see those params with sp_*
#' dpla_items(sp='Boston', page_size=2)
#' dpla_items(sp_state='Hawaii', page_size=2)
#' dpla_items(sp_state='Massachusetts OR Hawaii', page_size=2)
#' dpla_items(sp_coordinates='40,-100', page_size=2)
#' dpla_items(sp_country='Canada', page_size=2)
#' dpla_items(sp_county='Sacramento', page_size=2)
#'
#' # language search
#' dpla_items(language='Russian')$meta
#' dpla_items(language='rus')$meta
#' dpla_items(language='English')$meta
#'
#' # Faceting
#' dpla_items(facets="sourceResource.format", page_size=0)
#' dpla_items(facets="sourceResource.format", page_size=0, facet_size=5)
#' dpla_items(facets=c("sourceResource.spatial.state","sourceResource.spatial.country"),page_size=0)
#' dpla_items(facets="sourceResource.type", page_size=0)
#' dpla_items(facets="sourceResource.spatial.coordinates:42.3:-71", page_size=0)
#' dpla_items(facets="sourceResource.temporal.begin", page_size=0)
#' dpla_items(facets="provider.name", page_size=0)
#' dpla_items(facets="isPartOf", page_size=0)
#' dpla_items(facets="hasView", page_size=0)
#' }

dpla_items <- function(q=NULL, description=NULL, title=NULL, subject=NULL, creator=NULL,
  type=NULL, publisher=NULL, format=NULL, rights=NULL, contributor=NULL, provider=NULL, sp=NULL,
  sp_coordinates=NULL, sp_city=NULL, sp_county=NULL,
  sp_distance=NULL, sp_country=NULL, sp_code=NULL, sp_name=NULL, sp_region=NULL, sp_state=NULL,
  fields=NULL, sort_by=NULL, date=NULL, date_before=NULL, date_after=NULL, language=NULL,
  page_size=100, page=NULL, facets=NULL, facet_size=100, key=getOption("dplakey"), what="table", ...)
{
  fields2 <- fields
  fields <- filter_fields(fields)
  args <- dcomp(list(api_key=key, q=q, page_size=page_size, page=page, fields=fields,
                     provider=provider,
                     sourceResource.description=description,
                     sourceResource.title=title,
                     sourceResource.subject=subject,
                     sourceResource.creator=creator,
                     sourceResource.type=type,
                     sourceResource.publisher=publisher,
                     sourceResource.format=format,
                     sourceResource.rights=rights,
                     sourceResource.contributor=contributor,
                     sourceResource.spatial=sp,
                     sourceResource.spatial.coordinates=sp_coordinates,
                     sourceResource.spatial.city=sp_city,
                     sourceResource.spatial.county=sp_county,
                     sourceResource.spatial.distance=sp_distance,
                     sourceResource.spatial.country=sp_country,
                     `sourceResource.spatial.iso3166-2`=sp_code,
                     sourceResource.spatial.name=sp_name,
                     sourceResource.spatial.region=sp_region,
                     sourceResource.spatial.state=sp_state,
                     sourceResource.language=language,
                     sourceResource.date=date,
                     sourceResource.date.before=date_before,
                     sourceResource.date.after=date_after,
                     facets=coll(facets), facet_size=facet_size))
  temp <- dpla_GET(url=paste0(dpbase(), "items"), args, ...)
  hi <- setNames(data.frame(temp[c('count','start','limit')], stringsAsFactors = FALSE), c('found','start','returned'))
  dat <- temp$docs
  fac <- temp$facets

  if(what == "list"){
    structure(list(meta=hi, data=dat, facets=fac))
  } else {
    facdat <- proc_fac(fac)
    output <- do.call(rbind.fill, lapply(dat, getdata, flds=fields))
    if(is.null(fields)){ list(meta=hi, data=output, facets=facdat) } else {
      output2 <- output[,names(output) %in% fields2]
      # convert one column factor string to data.frame (happens when only one field is requested)
      if(class(output2) %in% "factor"){
        output3 <- data.frame(output2)
        names(output3) <- fields2
        list(meta=hi, data=output3, facets=facdat)
      } else { list(meta=hi, data=output2, facets=facdat) }
    }
  }
}

proc_fac <- function(fac){
  lapply(fac, function(x){
    hitmp <- x[c('_type','total','missing','other')]
    hitmp[sapply(hitmp, is.null)] <- NA
    hitmp <- data.frame(hitmp, stringsAsFactors = FALSE)
    fac_hi <- setNames(hitmp, c('type','total','missing','other'))
    getterm <- names(x)[names(x) %in% c('terms','ranges','entries')]
    dat <- do.call(rbind.fill, lapply(x[[getterm]], data.frame, stringsAsFactors = FALSE))
    list(meta=fac_hi, data=dat)
  })
}

# function to process data for each element
getdata <- function(y, flds){
  process_res <- function(x){
    reduce1 <- function(x){
      x <- unlist(x)
      if(length(x) > 1) paste(as.character(x), collapse=";") else x
    }
    id <- reduce1(x$identifier)
    title <- reduce1(x$title)
    description <- reduce1(x$description)
    subject <- if(length(x$subject)>1){paste(as.character(unlist(x$subject)), collapse=";")} else {x$subject[[1]][["name"]]}
    language <- x$language[[1]][["name"]]
    format <- reduce1(x$format)
    collection <- if(any(names(x$collection) %in% "name")) {x$collection[["name"]]} else {"no collection name"}
    type <- reduce1(x$type)
    date <- x$date[[1]]
    publisher <- reduce1(x$publisher)
    provider <- x$provider[["name"]]
    creator <- reduce1(x$creator)
    rights <- reduce1(x$rights)

    replacenull <- function(y) if(is.null(y) || length(y) == 0) "no content" else y
    ents <- list(id,title,description,subject,language,format,collection,type,provider,publisher,creator,rights,date)
    names(ents) <- c("id","title","description","subject","language","format","collection","type","provider","publisher","creator","rights","date")
    ents <- lapply(ents, replacenull)
    data.frame(ents, stringsAsFactors = FALSE)
  }
  process_other <- function(x){
    # FIXME
    ## Still need to give back fields: @context, originalRecord
    get <- c('dataProvider','@type','object','ingestionSequence','ingestDate','_rev','aggregatedCHO','_id','ingestType','@id')
    have <- x[ names(x) %in% get ]
    df <- data.frame(have, stringsAsFactors = FALSE)
    names(df) <- names(have)
    df
  }

  if(is.null(flds)){
    id <- y$id
    provider <- setNames(data.frame(t(y$provider), stringsAsFactors = FALSE), c("provider_url","provider_name"))
    score <- y$score
    url <- y$isShownAt
    sourceResource <- y$sourceResource
    sourceResource_df <- process_res(sourceResource)
    sourceResource_df <- sourceResource_df[,!names(sourceResource_df) %in% c("id","provider")]
    other <- process_other(y)
    cbind(data.frame(id, sourceResource_df, provider, score, url, stringsAsFactors = FALSE), other)
  } else
  {
    names(y) <- gsub("sourceResource.", "", names(y))
    if(length(y)==1) {
      onetemp <- list(y[[1]])
      onename <- names(y)
      names(onetemp) <- eval(onename)
      process_res(onetemp)
    } else
    { process_res(y) }
  }
}

filter_fields <- function(fields){
  if(!is.null(fields)){
    fieldsfunc <- function(x){
      if(x %in% c("title","description","subject","creator","type","publisher",
                  "format","rights","contributor","date",
                  "spatial","spatial.coordinates","spatial.city",
                  "spatial.county","spatial.distance","spatial.country","spatial.iso3166-2",
                  "spatial.name","spatial.region","spatial.state","language")) {
        paste("sourceResource.", x, sep="") } else { x }
    }
    paste(sapply(fields, fieldsfunc, USE.NAMES=FALSE), collapse=",")
  } else { NULL }
}
