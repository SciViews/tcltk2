\name{tk2dialogs}
\alias{tk2chooseFont}

\title{ Additional Tk dialog boxes  }
\description{
  Tk dialog boxes to select a font, a R color, etc.
}
\usage{
tk2chooseFont(...)
}

\arguments{
  \item{\dots}{ Further arguments passed to the dialog box }
}

\value{
  The selection made in the dialog box if \code{OK} is clicked, \code{""} otherwise.
}

\author{ Philippe Grosjean }
\note{ If you use tile 0.7.2 or above, these dialog boxes will automatically
  use it. Otherwise, the dialog boxes will use plain Tk widgets }

\seealso{ \code{\link{tk2widgets}}, \code{\link{tk2commands}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded
tk2chooseFont()
tk2chooseFont(font = "{courier} 9", title = "Choose a fixed font",
  fonttype = "fixed", style = 4, sizetype = "all")
tk2chooseFont(font = "Verdana 12 bold italic underline overstrike",
    fonttype = "prop", style = 2, sizetype = "point")
}
}

\keyword{ utilities }
