#' Request an API key from the Digital Public Library of America (DPLA).
#'
#' @export
#' @param email (character) An email address.
#' @param ... Curl options passed on to [httr::POST()], eg.,
#' [httr::verbose()]
#'
#' @return On success, a message that your API key will be emailed
#' to you.
#'
#' @details You are required to have an API key to use \pkg{rdpla}. To get one,
#' use `dpla_get_key` for getting a key programatically.
#' After getting the key, you can pass the key as a parameter to \pkg{rdpla}
#' functions, but we recommend storing the key on your machine, since not
#' exposing your key in your files that may end up on the web is good
#' practice. Store your key either as an environment variable in your
#' `.Renviron` file or similar like `DPLA_API_KEY=<yourkey>`,
#' or as an R option in your \code{.Rprofile} file like
#' `options(dpla_api_key = "<yourkey>")`. Either will be read in
#' when you call \pkg{rdpla} functions. Make sure to restart your R session
#' after storing your key as either env var or R option.
#'
#' @examples \dontrun{
#' # dpla_get_key(email="stuff@@thing.com")
#' }
dpla_get_key <- function(email, ...) {
  res <- httr::POST(paste0('http://api.dp.la/v2/api_key/', email), ...)
  httr::stop_for_status(res)
  message(jsonlite::fromJSON(contt(res))$message)
}
