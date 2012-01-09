\name{tk2tip}
\alias{tk2tip}
\alias{tk2killtip}
\alias{tip}
\alias{tip.tk2widget}
\alias{tip<-}
\alias{tip<-.tk2widget}

\title{ Display and manage tooltips in Tk widgets }
\description{
  \code{tk2tip} provides a simple mechanism to display tooltips on Tk widgets
  when the mouses hoover on top of them.
}

\usage{
tk2tip(widget, message)
tk2killtip()
tip(x, \dots)
\method{tip}{tk2widget}(x, \dots)
tip(x) <- value
\method{tip}{tk2widget}(x) <- value
}

\arguments{
  \item{widget}{ the widget to which a tooltip is attached. }
  \item{message}{ the message of the tooltip (\code{""} to remove the tooltip). }
  \item{x}{ a tk2widget object. }
  \item{\dots}{ further arguments to the method (unused, but reserved for
    future use). }
  \item{value}{ the message of the tooltip, or \code{""} to remove the tip. }
}

\author{ Philippe Grosjean }

\note{ This implementation is done in pure Tcl code }

\seealso{ \code{\link{tk2widgets}}, \code{\link{tk2methods}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

## Using plain Tcl/Tk label and button (tk2XXX equivalent have built-in
## tooltip features)
tt <- tktoplevel()
lb <- tklabel(tt, text = "Move mouse over me, or over the button to see tooltip")
tkgrid(lb)
tk2tip(lb, "A tooltip for the label \ndisplayed on two lines")
but <- tkbutton(tt, text = "Exit", width = 10,
    command = function() tkdestroy(tt2))
tkgrid(but)
tk2tip(but, "Exit from this dialog box")
    
## To test tk2killtip(), move mouse on top of a widget
## so that the tip is visible, and force killing it manually using:
tk2killtip()
## Move again to the widget: the tip is displayed again.

## With tk2widgets, the tip() method can also be used:
lb2 <- tk2label(tt, text = "Move also over me to see the tooltip")
tkgrid(lb2)
tip(lb2) # No tip yet
tip(lb2) <- "Now the tooltip is there!"
## Move the mouse over that last label

tip(lb2) # Yes, this is my tooltip
tip(lb2) <- NULL # To eliminate the toltip for this widget
}
}

\keyword{ utilities }

\concept{ Tcl/Tk widget tooltip }
