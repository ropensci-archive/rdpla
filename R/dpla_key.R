#' Request an API key from the Digital Public Library of America (DPLA).
#'
#' @export
#' @param email (character) An email address.
#' @param ... Curl options passed on to \code{\link[httr]{POST}}, eg., \code{\link[httr]{verbose}}
#' @return On success, a message that your API key will be emailed to you.
#'
#' @examples \donttest{
#' dpla_key(email="stuff@@thing.com")
#' dpla_key(email="scott.chamberlain@@berkeley.edu")
#' }

dpla_key <- function(email, ...) {
  res <- POST(paste0('http://api.dp.la/v2/api_key/', email), ...)
  message(content(res)$message)
}
