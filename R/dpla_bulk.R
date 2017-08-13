#' Get bulk DPLA data
#'
#' @export
#' @param year (character) a year between 2015 and the current year
#' @param month (character) between 1 (January) and 12 (December)
#' @param key (character) a dataset name key, see Details.
#' @param ... Curl options passed on to [crul::HttpClient()]
#'
#' @return `dpla_bulk_list` returns the partial paths for JSON dataset dumps;
#' append the base URL `https://dpla-provider-export.s3.amazonaws.com` to the
#' beginning to get the full URL.
#' `dpla_bulk` returns a path to the compressed JSON file.
#'
#' @details All data in the DPLA repository are available for download
#' as gzipped JSON files. These include the standard DPLA fields, as well
#' as the complete record received from the partner.
#'
#' See <https://digitalpubliclibraryofamerica.atlassian.net/wiki/spaces/TECH/pages/5931056/Database+export+files>
#' for description of the structure of the files
#'
#' `dpla_bulk` doesn't attempt to read in the bulk JSON files as they can be
#' quite large - so we leave that to the user.
#'
#' @section Allowed Keys:
#' \itemize{
#'  \item all
#'  \item artstor
#'  \item bhl
#'  \item cdl
#'  \item david_rumsey
#'  \item digital_commonwealth
#'  \item digitalnc
#'  \item esdn
#'  \item georgia
#'  \item getty
#'  \item gpo
#'  \item harvard
#'  \item hathitrust
#'  \item il
#'  \item indiana
#'  \item internet_archive
#'  \item kdl
#'  \item lc
#'  \item maine
#'  \item maryland
#'  \item mdl
#'  \item michigan
#'  \item missouri_hub
#'  \item mwdl
#'  \item nara
#'  \item nypl
#'  \item pa
#'  \item pennsylvania
#'  \item scdl
#'  \item smithsonian
#'  \item tennessee
#'  \item the_portal_to_texas_history
#'  \item tn
#'  \item uiuc
#'  \item usc
#'  \item virginia
#'  \item washington
#'  \item wisconsin
#' }
#' @examples \dontrun{
#' dpla_bulk(year = 2016, month = 4, key = "nypl")
#' res <- dpla_bulk(year = 2017, month = 1, key = "artstor")
#' }
dpla_bulk <- function(year, month, key, ...) {
  month <- as.numeric(month)
  year <- as.numeric(year)
  stopifnot(month > 0 && month < 13)
  stopifnot(2015 <= year && year <= as.numeric(format(Sys.Date(), "%Y")))

  keys <- dpla_bulk_list()
  path <- sprintf("%s/%02d/%s.json.gz", year, month, key)
  jsonfile <- file.path(dpla_cache$cache_path_get(), path)
  dir.create(dirname(jsonfile), showWarnings = FALSE, recursive = TRUE)
  if (jsonfile %in% dpla_cache$list()) {
    message("file in cache already, at: ", jsonfile)
  } else {
    cli <- HttpClient$new(url = bulk_base_url, opts = list(...))
    tfile <- tempfile()
    on.exit(rm(tfile))
    res <- cli$get(path, disk = tfile)
    res$raise_for_status()
    suppressWarnings(file.copy(tfile, jsonfile))
    message("download complete - file at: ", jsonfile)
  }
  return(jsonfile)
}

#' @export
#' @rdname dpla_bulk
dpla_bulk_list <- function(...) {
  cli <- HttpClient$new(url = bulk_base_url, opts = list(...))
  res <- cli$get()
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  unlist(lapply(2015:as.numeric(format(Sys.Date(), "%Y")), function(z) {
    strextract(txt, paste0(z, "/[0-9]{2}/[(A-Za-z)(-)(_)]+\\.json\\.gz"))
  }))
}

bulk_base_url <- "https://dpla-provider-export.s3.amazonaws.com"

strextract <- function(str, pattern) {
  regmatches(str, gregexpr(pattern, str))[[1]]
}
