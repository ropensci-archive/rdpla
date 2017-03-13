#' Search specific fields in the items endpoint from the DPLA.
#'
#' @export
#'
#' @param queries A list of query terms paired with the fields you want to
#' search them in. You can search on specific fields, see details below.
#' @param key Your DPLA API key. Either pass in here, or store in your
#' \code{.Rprofile} file and it will be read in on function execution.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @details You can search on a vector of the fields to return in the output.
#' The default is all fields. Options are:
#' \itemize{
#'  \item title - Object title
#'  \item description - Description
#'  \item subject - Subjects, semicolon separated
#'  \item language - Language
#'  \item format - Format, one of X, Y.
#'  \item collection - Collection name
#'  \item type - Type of object
#'  \item publisher - Publisher name
#'  \item creator - Creator
#'  \item provider - Data provider
#'  \item score - Matching score on your query
#'  \item creator - Creator
#' }
#' @return A list for now...
#'
#' @examples \donttest{
#' # Search by specific fields
#' dpla_by_fields(queries=c("fruit,title","basket,description"))
#'
#' # Items from before 1900
#' dpla_by_fields("1900,date.before")
#'
#' dpla_by_fields("Boston,spatial")
#' }

dpla_by_fields <- function(queries = NULL, key=getOption("dplakey"), ...)
{
  args <- list()
  for(i in seq_along(queries)){
    assign(paste("sourceResource",
                 strsplit(queries[[i]], ",")[[1]][[2]], sep="."),
           strsplit(queries[[i]], ",")[[1]][[1]])
    args[[list(grep("sourceResource", ls(), value=TRUE))[[1]][[i]]]] <-
      eval(parse(text=grep("sourceResource", ls(), value=TRUE)[[i]]))
  }
  dpla_GET(dcomp(c(args, api_key=key)), ...)
}
