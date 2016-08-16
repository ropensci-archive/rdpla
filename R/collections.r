#' Search collections from the Digital Public Library of America (DPLA).
#'
#' @export
#'
#' @param q Query terms.
#' @param title Query in the title field
#' @param description Query in the description field
#' @param fields A vector of the fields to return in the output. The default
#' @param sort_by The default sort order is ascending. Most, but not all fields
#'    can be sorted on. Attempts to sort on an un-sortable field will return
#'    the standard error structure with a HTTP 400 status code.
#'    is all fields. See details for options.
#' @param page_size Number of items to return, defaults to 10. Max of 500.
#' @param page Page number to return, defaults to NULL.
#' @param key Your DPLA API key. Either pass in here, store as en env var
#' in either \code{.Renviron}/\code{.bash_profile}/etc., or in your
#' \code{.Rprofile} file and it will be read in on function execution.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @return A list with a slot for metadata (meta) and data (a tibble/data.frame).
#'
#' @examples \dontrun{
#' dpla_collections(q="university", config=verbose())
#' dpla_collections(q="university of texas", page_size=2)
#' dpla_collections(q="university of texas", fields='id', page_size=2)
#' dpla_collections(q="university of texas", sort_by='title', page_size=5)
#' dpla_collections(title="paso")
#' dpla_collections(description="east")
#' }

dpla_collections <- function(q=NULL, title=NULL, description=NULL, fields=NULL,
  sort_by=NULL, page_size=10, page=NULL, key=NULL, ...) {

  args <- dcomp(list(api_key=key_check(key), q=q, title=title,
                     description=description, page_size=page_size,
                     page=page, fields = paste0(fields, collapse = ",") %||% NULL, sort_by=sort_by))
  res <- dpla_GET(paste0(dpbase(), "collections"), args, ...)
  meta <- data_frame(found = res$count, returned = res$limit)
  dat <- as_data_frame(
    rbindlist(lapply(res$docs, parse_coll), use.names = TRUE, fill = TRUE)
  )
  list(meta = meta, data = dat)
}

parse_coll <- function(x){
  admin <- sapply(x$admin, ifn)
  x <- pop(x, "admin")
  df <- as_data_frame(lapply(x, ifn))
  names(df) <- as.character(names(x))
  cbind(df, t(admin))
}
