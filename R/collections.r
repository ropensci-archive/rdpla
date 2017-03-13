#' Search collections from the Digital Public Library of America (DPLA).
#'
#' @export
#'
#' @param q (character) Query terms.
#' @param title (character) Query in the title field
#' @param description (character) Query in the description field
#' @param fields (character) A vector of the fields to return in the output.
#' The default is all fields. See [dpla_fields] for options.
#' @param sort_by (character) The default sort order is ascending. Most, but
#' not all fields can be sorted on. Attempts to sort on an un-sortable field
#' will return the standard error structure with a HTTP 400 status code.
#' @param page_size (integer) Number of items to return. Default: 10. Max: 500.
#' @param page (integer) Page number to return. Default: `NULL` (which
#' means this parameter is not passed to DPLA, so they default to **1**)
#' @param key (character) Your DPLA API key. See [dpla_get_key()]
#' @param ... Curl options passed on to [crul::HttpClient()]
#'
#' @return A list with two slots:
#' \itemize{
#'  \item meta - a tibble/data.frame of metadata for the response, with one
#'  row and two columns:
#'   \itemize{
#'    \item found - number of records found matching criteria
#'    \item returned - number of records returned
#'   }
#'  \item data - a tibble/data.frame of the data; empty data.frame
#'  if no data matches your request; structure varies depending on
#'  search criteria
#' }
#'
#' @examples \dontrun{
#' dpla_collections(q="university of texas", page_size=2)
#' dpla_collections(q="university of texas", fields='id', page_size=2)
#' dpla_collections(q="university of texas", sort_by='title', page_size=5)
#' dpla_collections(title="paso")
#' dpla_collections(description="east")
#'
#' # use curl options
#' dpla_collections(q="university", verbose = TRUE)
#' }

dpla_collections <- function(q=NULL, title=NULL, description=NULL, fields=NULL,
  sort_by=NULL, page_size=10, page=NULL, key=NULL, ...) {

  res <- dpla_collections_(q, title, description, fields, sort_by,
                           page_size, page, key, ...)
  meta <- tibble::data_frame(found = res$count, returned = res$limit)
  dat <- tibble::as_data_frame(
    data.table::rbindlist(lapply(res$docs, parse_coll), use.names = TRUE,
                          fill = TRUE)
  )
  list(meta = meta, data = dat)
}

dpla_collections_ <- function(q=NULL, title=NULL, description=NULL, fields=NULL,
  sort_by=NULL, page_size=10, page=NULL, key=NULL, ...) {

  args <- dcomp(list(
    api_key = key_check(key), q = q, title = title,
    description = description, page_size = page_size,
    page = page, fields = paste0(fields, collapse = ",") %||% NULL,
    sort_by = sort_by
  ))
  dpla_GET(path = "collections", args, ...)
}

parse_coll <- function(x){
  admin <- lapply(x$admin, ifn)
  x <- pop(x, "admin")
  df <- tibble::as_data_frame(lapply(x, ifn))
  names(df) <- as.character(names(x))
  if (length(admin) == 0) {
    df
  } else {
    cbind(df, tibble::as_data_frame(admin))
  }
}
