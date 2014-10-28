dcomp <- function (l) Filter(Negate(is.null), l)

dpbase <- function() "http://api.dp.la/v2/"

dpla_GET <- function(url, args, ...){
  tt <- GET(url, query = args, ...)
  warn_for_status(tt)
  stopifnot(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  jsonlite::fromJSON(res, simplifyVector = TRUE, simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

ifn <- function(x) if(is.null(x)) NA else x

pop <- function(x, y) x[ !names(x) %in% y ]
