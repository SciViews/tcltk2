\name{setLanguage}
\alias{setLanguage}
\alias{getLanguage}

\title{ Change or get the language used in R and Tcl/Tk }
\description{
  The function changes dynamically the language used by both R (messages only)
  and Tcl/Tk, or it retrieves its current value.
}
\usage{
setLanguage(lang)
getLanguage()
}

\arguments{
  \item{lang}{ An identification for the targeted language, for instance,
    \"en\" for English, \"fr\" for French, \"de\" for German, \"it\" for
	Italian, etc. }
}

\value{
  \code{setLanguage()} retyurns \code{TRUE} if language was successfully changed
  in Tcl/Tk, \code{FALSE} otherwise. \code{getLanguage()} returns a string with
  current language in use for R, or an empty string if it cannot determinate
  which is the language currently used.
}

\author{ Philippe Grosjean }
\note{ You need the msgcat Tcl package to use this (but it is provided with all
  recent distributions of Tcl/Tk by default) }

\seealso{ \code{\link{is.tile}}, \code{\link{tile.load}} }

\examples{
# Determine which language is currently in use in R
oldlang <- getLanguage()
if (oldlang != "") {
	# Switch to English and test a command that issues a warning
	if (setLanguage("en_US")) 1:3 + 1:2
	# Switch to French and test a command that issues a warning
	if (setLanguage("fr_FR")) 1:3 + 1:2
	# Switch to German and test a command that issues a warning
	if (setLanguage("de_DE")) 1:3 + 1:2
	# Switch to Italian and test a command that issues a warning
	if (setLanguage("it_IT")) 1:3 + 1:2
	# Etc..
	
	# Restore previous language
	setLanguage(oldlang) 
}
}

\keyword{ utilities }
