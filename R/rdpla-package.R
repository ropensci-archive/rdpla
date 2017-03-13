#' R Client for the Digital Public Library of America (DPLA).
#'
#' @description Interact with the Digital Public Library of America (DPLA)
#' REST API from R, including search.
#'
#' For an introduction to \pkg{rdpla}, see the vignette
#' **Introduction to rdpla**
#'
#' @section Authentication:
#' See [dpla_get_key()] for authentication help.
#'
#' @name rdpla-package
#' @aliases rdpla
#' @docType package
#' @author Scott Chamberlain
NULL

#' Metadata providers data.frame
#'
#' A data.frame (46 rows, 2 columns) containing all the DPLA fields.
#' The columns are as follows:
#'
#' \itemize{
#'   \item field. Name of the field.
#'   \item field_description. Description of the field.
#' }
#'
#' @name dpla_fields
#' @docType data
#' @keywords datasets
NULL

#' Language codes.
#'
#' A data.frame (7879 rows, 2 columns) containing all language codes.
#' The columns are as follows:
#'
#' \itemize{
#'   \item id. id (or code) of the language
#'   \item name. longer name of the language
#' }
#'
#' @name language_codes
#' @docType data
#' @keywords datasets
NULL

#' Country codes
#'
#' A data.frame (249 rows, 2 columns) containing all language codes.
#' The columns are as follows:
#'
#' \itemize{
#'   \item code. country code
#'   \item name. country name
#' }
#'
#' @name country_codes
#' @docType data
#' @keywords datasets
NULL
