#' R Client for the Digital Public Library of America (DPLA).
#'
#' @description Interact with the Digital Public Library of America (DPLA)
#' REST API from R, including search.
#' @name rdpla-package
#' @aliases rdpla
#' @docType package
#' @author Scott Chamberlain
#' @importFrom httr GET POST content warn_for_status stop_for_status
#' @importFrom jsonlite fromJSON
#' @importFrom data.table rbindlist
#' @importFrom tibble as_data_frame data_frame
NULL

#' Metadata providers data.frame.
#' @name dpla_fields
#' @docType data
#' @keywords datasets
NULL

#' Language codes.
#' @name language_codes
#' @docType data
#' @keywords datasets
NULL

#' Country codes
#' @name country_codes
#' @docType data
#' @keywords datasets
NULL
