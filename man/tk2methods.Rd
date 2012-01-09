\name{tk2methods}
\alias{tk2methods}
\alias{is.tk2widget}
\alias{print.tk2widget}
\alias{tk2cfglist}
\alias{print.tk2cfglist}
\alias{state}
\alias{state.tk2widget}
\alias{label}
\alias{label.tk2widget}
\alias{label<-}
\alias{label<-.tk2widget}
\alias{tag}
\alias{tag.tk2widget}
\alias{tag<-}
\alias{tag<-.tk2widget}
\alias{disabled}
\alias{disabled.tk2widget}
\alias{disabled<-}
\alias{disabled<-.tk2widget}
\alias{values}
\alias{values.tk2widget}
\alias{values.tk2listbox}
\alias{values<-}
\alias{values<-.tk2widget}
\alias{values<-.tk2listbox}
\alias{value}
\alias{value.tk2widget}
\alias{value.tk2listbox}
\alias{value<-}
\alias{value<-.tk2widget}
\alias{value<-.tk2listbox}
\alias{selection}
\alias{selection.tk2widget}
\alias{selection.tk2listbox}
\alias{selection<-}
\alias{selection<-.tk2widget}
\alias{selection<-.tk2listbox}
\alias{visibleItem}
\alias{visibleItem.tk2widget}
\alias{visibleItem.tk2listbox}
\alias{size}
\alias{size.tk2widget}
\alias{size.tk2listbox}
\alias{config}
\alias{config.tk2widget}
\alias{config.tk2label}
\alias{config<-}
\alias{config<-.tk2widget}
\alias{config<-.tk2label}

\title{ A series of methods applicable to tk2widget or tk2cfglist objects }
\description{
  Tk2widgets can be used as tcltk widgets, but they propose also an
  object-oriented interaction through these different methods.
}
\usage{
is.tk2widget(x)
\method{print}{tk2widget}(x, \dots)

tk2cfglist(\dots)
\method{print}{tk2cfglist}(x, \dots)

state(x, \dots)
\method{state}{tk2widget}(x, \dots)

label(x, \dots)
\method{label}{tk2widget}(x, \dots)
label(x) <- value
\method{label}{tk2widget}(x) <- value

tag(x, \dots)
\method{tag}{tk2widget}(x, \dots)
tag(x) <- value
\method{tag}{tk2widget}(x) <- value

disabled(x, \dots)
\method{disabled}{tk2widget}(x, \dots)
disabled(x) <- value
\method{disabled}{tk2widget}(x) <- value

values(x, \dots)
\method{values}{tk2widget}(x, \dots)
\method{values}{tk2listbox}(x, \dots)
values(x) <- value
\method{values}{tk2widget}(x) <- value
\method{values}{tk2listbox}(x) <- value

value(x, \dots)
\method{value}{tk2widget}(x, \dots)
\method{value}{tk2listbox}(x, \dots)
value(x) <- value
\method{value}{tk2widget}(x) <- value
\method{value}{tk2listbox}(x) <- value

selection(x, \dots)
\method{selection}{tk2widget}(x, \dots)
\method{selection}{tk2listbox}(x, \dots)
selection(x) <- value
\method{selection}{tk2widget}(x) <- value
\method{selection}{tk2listbox}(x) <- value

visibleItem(x, index, \dots)
\method{visibleItem}{tk2widget}(x, index, \dots)
\method{visibleItem}{tk2listbox}(x, index, \dots)

size(x, \dots)
\method{size}{tk2widget}(x, \dots)
\method{size}{tk2listbox}(x, \dots)

config(x, \dots)
\method{config}{tk2widget}(x, cfglist, \dots)
\method{config}{tk2label}(x, cfglist, \dots)
config(x) <- value
\method{config}{tk2widget}(x) <- value
\method{config}{tk2label}(x) <- value
}

\arguments{
  \item{x}{ a tk2widget object. }
  \item{\dots}{ a series of named arguments corresponding to parameters and
    values to use for the configuration for \code{tk2cfglist()}, or reserved
    arguments for future use for the other function (not used yet). }
  \item{value}{ a value to assign to the object's method. }
  \item{index}{ the index of the item in the list to make visible. }
  \item{cfglist}{ a named list with configuration parameters and values to
    apply (usually, a \code{tk2cfglist} object). }
}

\value{
  Depnds on the function (TODO: complete this...).
}

\author{ Philippe Grosjean }

\seealso{ \code{\link{tk2widgets}}, \code{\link{tk2tip}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

## TODO: examples illustrating the use of these methods...
}
}

\keyword{ utilities }

\concept{ Tcl/Tk widgets notebook, combobox, paned window, progress bar, text area, tree }
