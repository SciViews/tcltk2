\name{tk2tip}
\alias{tk2tip}
\alias{tk2killtip}

\title{ Display and manage tooltips in Tk widgets }
\description{
  \code{tk2tip} provides a simple mechanism to display tooltips on Tk widgets when
  the mouse hoover on top of them.
}

\usage{
tk2tip(widget, message)
tk2killtip()
}

\arguments{
  \item{widget}{ the widget to which a tooltip is attached. }
  \item{message}{ the message of the tooltip ("" to remove the tooltip). }
}

\author{ Philippe Grosjean }

\note{ This implementation is done in pure Tcl code }

\seealso{ \code{\link{tk2widgets}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

## Using plain Tcl/Tk label and button (tk2XXX equivalent have built-in
## tooltip features)
tt2 <- tktoplevel()
lb <- tklabel(tt2, text = "Move mouse over me, or over the button to see tooltip")
tkgrid(lb)
tk2tip(lb, "A tooltip for the label \ndisplayed on two lines")
but <- tkbutton(tt2, text = "Exit", width = 10,
    command = function() tkdestroy(tt2))
tkgrid(but)
tk2tip(but, "Exit from this dialog box")
    
## To test tk2killtip(), move mouse on top of a widget
## so that the tip is visible, and force killing it manually using:
tk2killtip()
## Move again to the widget: the tip is displayed again. 
}
}

\keyword{ utilities }

\concept{ Tcl/Tk widget tooltip }
