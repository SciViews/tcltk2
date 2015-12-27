\name{setLanguage}
\alias{setLanguage}
\alias{getLanguage}
\alias{tclmclocale}
\alias{tclmcset}
\alias{tclmc}

\title{ Change or get the language used in R and Tcl/Tk, and manipulate strings trnaslation in Tcl }
\description{
  The function changes dynamically the language used by both R (messages only)
  and Tcl/Tk, retrieves its current value, and manage string translation in Tcl.
}
\usage{
setLanguage(lang)
getLanguage()
tclmclocale(lang)
tclmcset(lang, msg, translation)
tclmc(fmt, ..., domain = NULL)
}

\arguments{
  \item{lang}{ an identification for the targeted language, for instance,
    \"en\" for English, \"en_US\" for american English, \"fr\" for French,
	\"de\" for German, \"it\" for Italian, etc. Facultative argument for \code{tclmclocale()}. }
  \item{msg}{ a single character string with the message to translate. }
  \item{translation}{ the corresponding version in \code{lang}. Substitutions
    markers like \%s for strings, or \%d for numbers are allowed (same syntax
    as \code{gettextf()}). These translations are added in the Tcl catalog in
    the main domain, i.e., you don't need to give a domain name with
    \code{tclmc()} to retrieve the translation. }
  \item{fmt}{ a single character vector of format string. }
  \item{\dots}{ values to be passed into \code{fmt} for the substitution. }
  \item{domain}{ the 'domain", i;e., Tcl namespace where the translation is
    defined. Use \code{NULL} (the default) or \code{""} for the main domain
	where trnaslations using \code{tclmcset()} 	are stored. }
}

\value{
  \code{setLanguage()} returns \code{TRUE} if language was successfully changed
  in Tcl/Tk, \code{FALSE} otherwise. \code{getLanguage()} returns a string with
  current language in use for R, or an empty string if it cannot determinate
  which is the language currently used, and a \code{tcl.language} attribute
  with the different catalogs that are used in priority order (ending with
  \code{""} for no translation, i.e., Tcl trnaslations do not return an error,
  but the initial string if the item is not found in the catalog).
  \code{tclmclocale()} allows to change and get language for Tcl only, without
  changing anything for R.
  
  The two functions \code{tclmcset()} a,d \code{tclmc()} allow to record and
  retrieve the translation of strings in the main R domain. Moreover,
  \code{tclmc()} also allows to retrieve trnaslations of Tcl strings in other
  Tcl namespaces (a.k.a., domains), see the examples.
}

\author{ Philippe Grosjean }

\note{ You need the msgcat Tcl package to use this (but it is provided with all
  recent distributions of Tcl/Tk by default). }

\examples{
## What is the language used by Tcl?
tclmclocale()

## Define a simple translation in French and German
tclmcset("de", "Yes", "Ja")
tclmcset("fr", "Yes", "Oui")

## Determine which language is currently in use in R
(oldlang <- getLanguage())
if (oldlang != "") {
    ## Switch to English; test a command that issues a warning and a Tcl string
    setLanguage("en_US")
	1:3 + 1:2
	tclmc("Yes")
	
    ## Switch to German and test
    setLanguage("de")
	1:3 + 1:2
	tclmc("Yes")
	
    ## Switch to Belgian French and test
    setLanguage("fr_BE")
	1:3 + 1:2
	tclmc("Yes")
    
	## A more complex trnaslation message with a substitution
	tclmcset("fr", "Directory contains \%d files",
      "Le r\u00e9pertoire contient \%d fichiers")
	tclmc("Directory contains \%d files", 9)
	## or from a R/Tcl variable...
	nfiles <- tclVar(12)
    tclmc("Directory contains \%d files", tclvalue(nfiles))

    ## Retrieve a translation defined in the "tk" domain
	tclmc("Replace existing file?", domain = "tk")
	
	## Tcl dialog boxes are translated according to the current language
	\dontrun{
	tkgetOpenFile()
	}
	
    ## Restore previous language
    setLanguage(oldlang)
}
}

\keyword{ utilities }

\concept{ Tcl/Tk language translation }
