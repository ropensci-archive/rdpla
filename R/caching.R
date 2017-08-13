#' @title Caching
#'
#' @description Manage cached `rdpla` files with \pkg{hoardr}
#'
#' @export
#' @name dpla_cache
#'
#' @details The dafault cache directory is
#' `paste0(rappdirs::user_cache_dir(), "/R/rdpla")`, but you can set
#' your own path using `cache_path_set()`
#'
#' `cache_delete` only accepts 1 file name, while
#' `cache_delete_all` doesn't accept any names, but deletes all files.
#' For deleting many specific files, use `cache_delete` in a [lapply()]
#' type call
#'
#' @section Useful user functions:
#' \itemize{
#'  \item `dpla_cache$cache_path_get()` get cache path
#'  \item `dpla_cache$cache_path_set()` set cache path
#'  \item `dpla_cache$list()` returns a character vector of full
#'  path file names
#'  \item `dpla_cache$files()` returns file objects with metadata
#'  \item `dpla_cache$details()` returns files with details
#'  \item `dpla_cache$delete()` delete specific files
#'  \item `dpla_cache$delete_all()` delete all files, returns nothing
#' }
#'
#' @examples \dontrun{
#' dpla_cache
#'
#' # list files in cache
#' dpla_cache$list()
#'
#' # delete certain database files
#' # dpla_cache$delete("file path")
#' # dpla_cache$list()
#'
#' # delete all files in cache
#' # dpla_cache$delete_all()
#' # dpla_cache$list()
#'
#' # set a different cache path from the default
#' }
NULL
