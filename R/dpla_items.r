#' Search items from the Digital Public Library of America (DPLA).
#'
#' @importFrom httr GET POST content warn_for_status stop_for_status
#' @importFrom jsonlite fromJSON
#' @importFrom plyr rbind.fill
#' @export
#'
#' @param q Query terms.
#' @param limit Number of items to return, defaults to 10. Max of 100.
#' @param page Page number to return, defaults to NULL.
#' @param sort_by The default sort order is ascending. Most, but not all fields
#'    can be sorted on. Attempts to sort on an un-sortable field will return
#'    the standard error structure with a HTTP 400 status code.
#' @param fields A vector of the fields to return in the output. The default
#'    is all fields. See details for options.
#' @param date.before Date before
#' @param date.after Date after
#' @param verbose If TRUE, fun little messages print to console to inform you
#'    of things.
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
#' and limit [number results returned]), and the resulting data.frame of results.
#'
#' @examples \donttest{
#' # Basic search, "fruit" in any fields
#' dpla_items(q="fruit")
#'
#' # Limit records returned
#' dpla_items(q="fruit", limit=2)
#'
#' # Some verbosity
#' dpla_items(q="fruit", verbose=TRUE, limit=2)
#'
#' # Return certain fields
#' dpla_items(q="fruit", verbose=TRUE, fields=c("id","publisher","format"))
#' dpla_items(q="fruit", fields="subject")
#'
#' # Max is 100 per call, but the function handles larger numbers by looping
#' dpla_items(q="fruit", fields="id", limit=200)
#' dpla_items(q="fruit", fields=c("id","provider"), limit=200)
#' out <- dpla_items(q="science", fields=c("id","subject"), limit=400)
#' head(out$data)
#'
#' # Search by date
#' out <- dpla_items(q="science", date.before=1900, limit=200)
#' head(out$data)
#'
#' # Spatial search
#' dpla_items(q='Boston', fields='spatial')
#'
#' # things
#' dpla_items(q="*:*", limit=5, what="list")
#' }

dpla_items <- function(q=NULL, verbose=FALSE, fields=NULL, limit=10, page=NULL,
  sort_by=NULL, date.before=NULL, date.after=NULL, key=getOption("dplakey"),
  what="table", ...)
{
  fields2 <- fields

  if(!is.null(fields)){
    fieldsfunc <- function(x){
      if(x %in% c("title","description","subject","creator","type","publisher",
                  "format","rights","contributor","spatial")) {
        paste("sourceResource.", x, sep="") } else { x }
    }
    fields <- paste(sapply(fields, fieldsfunc, USE.NAMES=FALSE), collapse=",")
  } else {NULL}

  if(!limit > 100){
    args <- dcomp(list(api_key=key, q=q, page_size=limit, page=page, fields=fields,
                         sourceResource.date.before=date.before,
                         sourceResource.date.after=date.after))
    temp <- dpla_GET(paste0(dpbase(), "items"), args, ...)
    hi <- data.frame(temp[c('count','limit')], stringsAsFactors = FALSE)
    names(hi) <- c('found','returned')
    if(verbose)
      message(paste(hi$count, " objects found, started at ", hi$start, ", and returned ", hi$limit, sep=""))
    dat <- temp[[4]] # collect data
  } else
  {
    maxpage <- ceiling(limit/100)
    page_vector <- seq(1,maxpage,1)
    argslist <- lapply(page_vector, function(x) dcomp(list(api_key=key, q=q, page_size=100, page=x, fields=fields, sourceResource.date.before=date.before, sourceResource.date.after=date.after)))
    out <- lapply(argslist, function(x) dpla_GET(paste0(dpbase(), "items"), args = x, ...))
    hi <- data.frame(found=out[[1]]$count, stringsAsFactors = FALSE)
    hi$returned <- sum(sapply(out, function(x) length(x$docs)))
    if(verbose)
      message(paste(hi$count, " objects found, started at ", hi$start, ", and returned ", sum(hi[,c(5,6)]), sep=""))
    dat <- do.call(c, lapply(out, function(x) x[[4]])) # collect data
  }

  if(what == "list"){
    structure(list(meta=hi, data=dat))
  } else {
    output <- do.call(rbind.fill, lapply(dat, getdata, flds=fields))

    if(is.null(fields)){ list(meta=hi, data=output) } else
    {
      output2 <- output[,names(output) %in% fields2]
      # convert one column factor string to data.frame (happens when only one field is requested)
      if(class(output2) %in% "factor"){
        output3 <- data.frame(output2)
        names(output3) <- fields2
        list(meta=hi, data=output3)
      } else { list(meta=hi, data=output2) }
    }
  }
}

# function to process data for each element
getdata <- function(y, flds){
  process_res <- function(x){
    reduce1 <- function(x) if(length(x) > 1) paste(as.character(x), collapse=";") else x
    id <- x$id
    title <- reduce1(x$title)
    description <- x$description
    subject <- if(length(x$subject)>1){paste(as.character(unlist(x$subject)), collapse=";")} else {x$subject[[1]][["name"]]}
    language <- x$language[[1]][["name"]]
    format <- x$format
    collection <- if(any(names(x$collection) %in% "name")) {x$collection[["name"]]} else {"no collection name"}
    type <- x$type
    date <- x$date[[1]]
    publisher <- x$publisher
    provider <- x$provider[["name"]]
    creator <- reduce1(x$creator)
    rights <- x$rights

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
    provider <- data.frame(t(y$provider), stringsAsFactors = FALSE)
    names(provider) <- c("provider_url","provider_name")
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
