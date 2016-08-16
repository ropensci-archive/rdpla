dcomp <- function(x) Filter(Negate(is.null), x)

dpbase <- function() "http://api.dp.la/v2/"

dpla_GET <- function(url, args, ...){
  tt <- GET(url, query = args, ...)
  warn_for_status(tt)
  stopifnot(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text", encoding = "UTF-8")
  jsonlite::fromJSON(res, simplifyVector = TRUE, simplifyDataFrame = FALSE,
                     simplifyMatrix = FALSE)
}

ifn <- function(x) if (is.null(x)) NA else x

pop <- function(x, y) x[ !names(x) %in% y ]

coll <- function(x) if (is.null(x)) NULL else paste0(x, collapse = ",")

key_check <- function(x) {
  tmp <- if (is.null(x)) Sys.getenv("DPLA_API_KEY", "") else x
  if (tmp == "") {
    getOption("dpla_api_key", stop("need an API key for DPLA", call. = FALSE))
  } else {
    tmp
  }
}
