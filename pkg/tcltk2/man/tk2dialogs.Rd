\name{tk2dialogs}
\alias{tk2chooseFont}
\alias{tk2swaplist}
\alias{tk2unicode_select}
\alias{tk2unicode_config}
\alias{tk2unicode_bind}

\title{ Additional Tk dialog boxes  }
\description{
  Tk dialog boxes to select a font, unicode characters or a list of ordered items.
}
\usage{
tk2chooseFont(\dots)

tk2swaplist(items, selection, title = "Select items", \dots)

tk2unicode_select(widget)
tk2unicode_config(parent)
tk2unicode_bind(widget)
}

\arguments{
  \item{items}{ a vector of numbers, logicals, characters, factor or ordered. }
  \item{selection}{ preselected items, in the right order. }
  \item{title}{ title of the dialog box. }
  \item{\dots}{ further arguments passed to the dialog box. }
  \item{widget}{ a widget that can accept a unicode character. For
    \code{tk2unicode_bind()} it must be a \code{tk2text} or a \code{tk2entry}
    widget. }
  \item{parent}{ the Tk toplevel dialog box that will be the parent of the
    configuration dialog box. }
}

\value{
  The selection made in the dialog box if \code{OK} is clicked, \code{""}
  otherwise for \code{tk2chooseFont()}, or an zero-length vector for
  \code{tk2swaplist()}.
  
  The \code{tk2unicode_select()} dialog pastes the selected unicode character
  in the designed widget, but returns nothing. The \code{tk2unicode_config}
  changes the configuration for the unicode composer, but returns nothing. If
  you decide to do so, it saves the config on a file. This is done app-by-app,
  and the default app name is \"R\". You can change it by setting a different
  value in the option \"tk2app\", i.e., \code{options(tk2app = "myApp")}.
  The \code{tk2unicode_bind()} is also invoked for its side-effect to install
  required bindings to enable the unicode composer engine for the given widget
  and it returns nothing.
}

\author{ Philippe Grosjean }

\seealso{ \code{\link{tk2widgets}}, \code{\link{tk2commands}} }

\examples{
\dontrun{
library(tcltk2)
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

## Font selection
tk2chooseFont()
tk2chooseFont(font = "{courier} 9", title = "Choose a fixed font",
    fonttype = "fixed", style = 4, sizetype = "all")
tk2chooseFont(font = "Verdana 12 bold italic underline overstrike",
    fonttype = "prop", style = 2, sizetype = "point")

## List selection and ordering
tk2swaplist(1:10, 1:5) # integer
tk2swaplist(as.numeric(1:10), 1:5) # double
tk2swaplist(paste("V", 1:10), paste("V", 1:5)) # character
tk2swaplist(as.factor(1:10), 1:5) # factor
tk2swaplist(as.ordered(1:10), 1:5) # ordered

## Easy unicode character entry
tt <- tktoplevel()
txt <- tk2text(tt, width = 60, height = 20)
tkpack(txt)
e <- tk2entry(tt, width = 50)
tkpack(e)
## Get an unicode character for the text widget
tk2unicode_select(txt)
## and for the entry widget
tk2unicode_select(e)

## Bind the composer to both the text and the entry widgets
## and display the configuration box
## Once done, try the compose key + m + u, or compose + " + a
## or any othert sequence in both widgets
## or hit the compose key twice
tk2unicode_bind(txt)
tk2unicode_bind(e)
tk2unicode_config(tt)
}
}

\keyword{ utilities }

\concept{ More Tcl/Tk dialog boxes, font and color selection }
