dcomp <- function(x) Filter(Negate(is.null), x)

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  }
  else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

dpbase <- function() "http://api.dp.la/v2/"

dpla_GET <- function(url, args, ...){
  tt <- httr::GET(url, query = args, ...)
  err_catch(tt)
}

`%||%` <- function(x, y) {
  if (is.null(x) || nchar(x) == 0) {
    y
  }
  else {
    x
  }
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

err_catch <- function(x) {
  if (!inherits(x, "response")) stop("object not of class 'response'",
                                     call. = FALSE)
  if (x$status_code > 201) {
    xx <- contt(x)
    res <- tryCatch(jsonlite::fromJSON(xx), error = function(e) e)
    if (inherits(res, "error")) {
      stop(xx, call. = FALSE)
    } else {
      stop(res$message, call. = FALSE)
    }
  } else {
    stopifnot(x$headers$`content-type` == "application/json; charset=utf-8")
    txt <- contt(x)
    res <- tryCatch(jsonlite::fromJSON(txt), error = function(e) e)
    if (inherits(res, "error")) {
      stop(txt, call. = FALSE)
    } else {
      jsonlite::fromJSON(txt, simplifyVector = TRUE, simplifyDataFrame = FALSE,
                         simplifyMatrix = FALSE)
    }
  }
}

contt <- function(x) {
  httr::content(x, as = "text", encoding = "UTF-8")
}
