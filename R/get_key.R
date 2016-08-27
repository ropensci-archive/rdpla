#' Request an API key from the Digital Public Library of America (DPLA).
#'
#' @export
#' @param email (character) An email address.
#' @param ... Curl options passed on to \code{\link[httr]{POST}}, eg.,
#' \code{\link[httr]{verbose}}
#'
#' @return On success, a message that your API key will be emailed
#' to you.
#'
#' @details After getting your key, pass in the key in the `key` parameter
#' in functions in this package OR you can store the key in your
#' `.Renviron` as `DPLA_API_KEY` or in your `.Rprofile` file under
#' the name `dpla_api_key`
#'
#' @examples \donttest{
#' get_key(email="stuff@@thing.com")
#' get_key(email="scott.chamberlain@@berkeley.edu")
#' }

get_key <- function(email, ...) {
  res <- POST(paste0('http://api.dp.la/v2/api_key/', email), ...)
  message(content(res)$message)
}
