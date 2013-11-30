\name{tk2dialogs}
\alias{tk2chooseFont}
\alias{tk2swaplist}

\title{ Additional Tk dialog boxes  }
\description{
  Tk dialog boxes to select a font or a list of ordered items.
}
\usage{
tk2chooseFont(\dots)
tk2swaplist(items, selection, title = "Select items", \dots)
}

\arguments{
  \item{items}{ a vector of numbers, logicals, characters, factor or ordered. }
  \item{selection}{ preselected items, in the right order. }
  \item{title}{ title of the dialog box. }
  \item{\dots}{ further arguments passed to the dialog box. }
}

\value{
  The selection made in the dialog box if \code{OK} is clicked, \code{""}
  otherwise for \code{tk2chooseFont()}, or an zero-length vector for
  \code{tk2swaplist()}.
}

\author{ Philippe Grosjean }
\note{ If you use tile 0.7.2 or above, these dialog boxes will automatically
  use it. Otherwise, the dialog boxes will use plain Tk widgets (not yet for
  \code{tk2swaplist()}). }

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

tk2swaplist(1:10, 1:5) # integer
tk2swaplist(as.numeric(1:10), 1:5) # double
tk2swaplist(paste("V", 1:10), paste("V", 1:5)) # character
tk2swaplist(as.factor(1:10), 1:5) # factor
tk2swaplist(as.ordered(1:10), 1:5) # ordered
}
}

\keyword{ utilities }

\concept{ More Tcl/Tk dialog boxes, font and color selection }
