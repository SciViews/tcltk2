\name{tk2commands}
\alias{tk2commands}
\alias{tk2column}
\alias{tk2insert.multi}
\alias{tk2list.delete}
\alias{tk2list.get}
\alias{tk2list.insert}
\alias{tk2list.set}
\alias{tk2list.size}
\alias{tk2notetraverse}
\alias{tk2notetab}
\alias{tk2notetab.select}
\alias{tk2notetab.text}
\alias{tk2state.set}
\alias{is.tk}
\alias{is.ttk}
\alias{tk2theme.elements}
\alias{tk2theme.list}
\alias{tk2theme}
\alias{tk2style}
\alias{tk2dataList}
\alias{tk2configList}

\title{ Tk commands associated with the tk2XXX widgets }
\description{
  These commands supplement those available in the tcltk package to ease
  manipulation of tk2XXX widgets.
}

\usage{
tk2column(widget, action = c("add", "configure", "delete", "names", "cget",
    "nearest"), ...)
tk2insert.multi(widget, where = "end", items)
tk2list.delete(widget, first, last = first)
tk2list.get(widget, first = 0, last = "end")
tk2list.insert(widget, index = "end", ...)
tk2list.set(widget, items)
tk2list.size(widget)
tk2notetraverse(nb)
tk2notetab(nb, tab)
tk2notetab.select(nb, tab)
tk2notetab.text(nb)
tk2state.set(widget, state = c("normal", "disabled", "readonly"))
is.tk()
is.ttk()
tk2theme.elements()
tk2theme.list()
tk2theme(theme = NULL)
tk2style(class, style, state = c("default", "active", "disabled", "focus",
    "!focus", "pressed", "selected", "background", "readonly", "alternate",
    "invalid", "hover", "all"), default = NULL)
tk2dataList(x)
tk2configList(x)
}

\arguments{
  \item{widget}{ the widget to which these actions apply. }
  \item{action}{ which kind of action? }
  \item{where}{ where are these item added in the list (by default, at the end). }
  \item{items}{ the items to add (either a vector for a single line, or a matrix
    for more items). }
  \item{\dots}{ further arguments to the action. }
  \item{first}{ the 0-based first index to consider in the list. }
  \item{last}{ the 0-based last index to consider in the list, or \code{"end"}
    for using the last element of the list. }
  \item{index}{ the 0-based index where to insert items in the list. }
  \item{nb}{ a tk2notebook or ttk2notebook widget (\"tclObj\" object). }
  \item{tab}{ the name (text) of a tab in a notebook. }
  \item{state}{ the new state of the widget, or the state to inquiry. }
  \item{theme}{ a theme to use (character string). }
  \item{class}{ the class of the tk2widget (either the Tk class, like
    \code{TButton}, or the name of the function that creates it, like
    \code{tk2button}) }
  \item{style}{ a character string with the name of the style to retrieve }
  \item{default}{ the default value to return in case this style is not found }
  \item{x}{ either a tk2widget object, or a character string with its class name. }
}

\details{
  \code{tk2column()} manipulate columns of a tk2mclistbox widget,
  \code{tk2insert.multi()} is used to insert multiple field entries in a
    tk2mclistbox widget,
  \code{is.tk()} determines if the tk package is loaded (on some platforms
    it is possible to load the tcltk package without tk, for instance, in
    batch mode). \code{is.ttk()} determines if 'ttk' widgets (styled widgets)
    used by the \code{tk2XXX()} functions are available (you need Tk >= 8.5).
}

\note{
  In comparison with traditional Tk widgets, ttk proposes an advances mechanism
  for styling the widgets with \"themes\". By default, it adapts to the current
  platform (for instance, under Windows XP with XP theme, all widgets take the
  appearance of XP themed widgets (even with custom themes applied!). Usual Tk
  widgets are ALWAYS displayed in old-looking fashion under Windows XP. If you
  want, you can switch dynamically to a different theme among those avaiable
  (list them using \code{tk2theme.list()}, and switch to another one with
  \code{tk2theme(newtheme)}. This is most useful to see how your GUI elements
  and dialog boxes look like on foreign systems. If you prefer, let's say, a
  Unix look of the R GUI elements under Windows, these functions are also
  useful. If you are more advanturous, you can even design your own themes (see
  the tile documentation on the Tcl wiki).
}

\author{ Philippe Grosjean }

\seealso{ \code{\link{tk2widgets}}, \code{\link{tk2tip}} }

\keyword{ utilities }

\concept{ Tcl/Tk widgets commands }
