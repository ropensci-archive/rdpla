dcomp <- function (l) Filter(Negate(is.null), l)

dpbase <- function() "http://api.dp.la/v2/items"

dpla_GET <- function(args, ...){
  tt <- GET(dpbase(), query = args, ...)
  warn_for_status(tt)
  stopifnot(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  jsonlite::fromJSON(res, simplifyVector = TRUE, simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}
