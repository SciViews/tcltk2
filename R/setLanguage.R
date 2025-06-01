# Management of locales and message translation using msgcat


#' Change or get the language used in R and Tcl/Tk, strings translation in Tcl
#'
#' The function changes dynamically the language used by both R (messages only)
#' and Tcl/Tk, retrieves its current value, and manage string translation in
#' Tcl.
#'
#' @param lang An identification for the targeted language, for instance, \"en\"
#' for English, \"en_US\" for american English, \"fr\" for French, \"de\" for
#' German, \"it\" for Italian, etc. Facultative argument for [tclmclocale()].
#' @param msg A single character string with the message to translate.
#' @param translation The corresponding version in `lang`. Substitutions markers
#' like \%s for strings, or \%d for numbers are allowed (same syntax as
#' [base::gettextf()]). These translations are added in the Tcl catalog in the
#' main domain, i.e., you don't need to give a domain name with [tclmc()] to
#' retrieve the translation.
#' @param fmt A single character vector of format string.
#' @param ... Values to be passed into \code{fmt} for the substitution.
#' @param domain The 'domain", i;e., Tcl namespace where the translation is
#' defined. Use `NULL` (the default) or `""` for the main domain where
#' translations using [tclmcset()]	are stored.
#'
#' @return
#' [setLanguage()] returns `TRUE` if language was successfully changed in
#' Tcl/Tk, `FALSE` otherwise. [getLanguage()] returns a string with current
#' language in use for R, or an empty string if it cannot determinate which is
#' the language currently used, and a `tcl.language` attribute with the
#' different catalogs that are used in priority order (ending with `""` for no
#' translation, i.e., Tcl translations do not return an error, but the initial
#' string if the item is not found in the catalog).
#' [tclmclocale()] allows to change and get language for Tcl only, without
#' changing anything for R.
#'
#' The two functions [tclmcset()] and [tclmc()] allow to record and retrieve the
#' translation of strings in the main R domain. Moreover, [tclmc()] also allows
#' to retrieve translations of Tcl strings in other Tcl namespaces (a.k.a.,
#' domains), see the examples.
#'
#' @note You need the msgcat Tcl package to use this (but it is provided with
#' all recent distributions of Tcl/Tk by default).
#'
#' @author Philippe Grosjean
#' @export
#' @keywords utilities
#'
#' @examples
#' # What is the language used by Tcl?
#' tclmclocale()
#'
#' # Define a simple translation in French and German
#' tclmcset("de", "Yes", "Ja")
#' tclmcset("fr", "Yes", "Oui")
#'
#' # Determine which language is currently in use in R
#' (oldlang <- getLanguage())
#' if (oldlang != "") {
#'   # Switch to English; test a command that issues a warning and a Tcl string
#'   setLanguage("en_US")
#'   1:3 + 1:2
#'   tclmc("Yes")
#'
#'   # Switch to German and test
#'   setLanguage("de")
#'   1:3 + 1:2
#'   tclmc("Yes")
#'
#'   # Switch to Belgian French and test
#'   setLanguage("fr_BE")
#'   1:3 + 1:2
#'   tclmc("Yes")
#'
#'   # A more complex trnaslation message with a substitution
#'   tclmcset("fr", "Directory contains %d files",
#'     "Le repertoire contient %d fichiers")
#'   tclmc("Directory contains %d files", 9)
#'   # or from a R/Tcl variable...
#'   nfiles <- tclVar(12)
#'   tclmc("Directory contains %d files", tclvalue(nfiles))
#'
#'   # Retrieve a translation defined in the "tk" domain
#'   tclmc("Replace existing file?", domain = "tk")
#'
#'   # Tcl dialog boxes are translated according to the current language
#'   \dontrun{
#'     tkgetOpenFile()
#'   }
#'
#'   # Restore previous language
#'   setLanguage(oldlang)
#' }
setLanguage <- function(lang) {
  # Change locale for both R and Tcl/Tk
  Sys.setLanguage(substring(lang, 1, 2)) #Sys.setenv(LANGUAGE = lang)
  Sys.setenv(LANG = lang)
  #try(Sys.setlocale("LC_MESSAGES", lang), silent = TRUE)  # Fails on Windows!
  res <- tclRequire("msgcat")
  if (inherits(res, "tclObj")) {
    .Tcl("namespace import msgcat::*")
    # If the tcl.language attribute is defined, use it
    tcllang <- attr(lang, "tcl.language")
    if (!is.null(tcllang) && tcllang[1] != "") {
      lang <- tcllang[1] # Use only first item
    } else {
      # Tcl does not accept locales like en_US.UF-8: must be en_us only
      lang <- tolower(sub("^([^.]+)\\..*$", "\\1", lang))
    }
    if (lang == "c") {
      tclmclocale("en") # Use English by default
    } else {
      tclmclocale(lang)
    }
    TRUE
  } else {
    FALSE
  }
}

#' @export
#' @rdname setLanguage
getLanguage <- function() {
  # Try to recover current language used for messages and GUI stuff in R
  lang <- Sys.getenv("LANGUAGE")
  if (lang == "")
    lang <- Sys.getlocale("LC_MESSAGES")
  # This is a bad hack that probably does not work all the time, but at least,
  # it works under Windows for getting "fr" for French language
  if (lang == "")
    lang <- tolower(substr(Sys.getlocale("LC_COLLATE"), 1, 2))

  # Try to get language information from Tcl
  tcllang <- try(as.character(tcl("mcpreferences")), silent = TRUE)
  attr(lang, "tcl.language") <- tcllang

  lang
}

#' @export
#' @rdname setLanguage
tclmclocale <- function(lang) {
  if (missing(lang)) {
    as.character(tcl("mclocale"))
  } else {
    # Make sure lang is made compatible to Tcl
    lang <- tolower(sub("^([^.]+)\\..*$", "\\1", lang))
    as.character(tcl("mclocale", lang))
  }
}

#' @export
#' @rdname setLanguage
tclmcset <- function(lang, msg, translation)
  invisible(tclvalue(tcl("mcset", lang, msg, translation)))

#' @export
#' @rdname setLanguage
tclmc <- function(fmt, ..., domain = NULL) {
  if (is.null(domain) || domain == "") {
    # Simpler form
    tclvalue(tcl("mc", fmt, ...))
  } else {
    # Need to evaluate in 'domain' Tcl namespace
    transl <- .Tcl(paste0("namespace eval ", domain, " {set ::Rtransl [mc {",
      fmt, "}]}"))
    sprintf(tclvalue(transl), ...)
  }
}
