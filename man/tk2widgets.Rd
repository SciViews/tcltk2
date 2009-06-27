\name{tk2widgets}
\alias{tk2widgets}
\alias{tk2button}
\alias{tk2canvas}
\alias{tk2checkbutton}
\alias{tk2combobox}
\alias{tk2entry}
\alias{tk2frame}
\alias{tk2label}
\alias{tk2labelframe}
\alias{tk2listbox}
\alias{tk2mclistbox}
\alias{tk2menu}
\alias{tk2menubutton}
\alias{tk2message}
\alias{tk2notebook}
\alias{tk2panedwindow}
\alias{tk2progress}
\alias{tk2radiobutton}
\alias{tk2scale}
\alias{tk2scrollbar}
\alias{tk2separator}
\alias{tk2spinbox}
\alias{tk2table}
\alias{tk2text}
\alias{tk2ctext}
\alias{tk2tree}

\title{ A series of versatile using either themable (tile) or plain Tk widgets }
\description{
  A series of widgets you can use in your Tk windows/dialog boxes.
}
\usage{
tk2button(parent, tip = "", use.tile = is.tile(), ...)
tk2canvas(parent, tip = "", use.tile = is.tile(), ...)
tk2checkbutton(parent, tip = "", use.tile = is.tile(), ...)
tk2combobox(parent, tip = "", use.tile = is.tile(), ...)
tk2entry(parent, tip = "", use.tile = is.tile(), ...)
tk2frame(parent, use.tile = is.tile(), ...)
tk2label(parent, tip = "", use.tile = is.tile(), ...)
tk2labelframe(parent, use.tile = is.tile(), ...)
tk2listbox(parent, selectmode = c("single", "browse", "multiple", "extended"),
    tip = "", use.tile = is.tile(), ...)
tk2mclistbox(parent, tip ="", use.tile = is.tile(), ...)
tk2menu(parent, use.tile = is.tile(), ...)
tk2menubutton(parent, tip = "", use.tile = is.tile(), ...)
tk2message(parent, text = "", justify = c("left", "center", "right"),
    width = -1, aspect = 150, tip = "", use.tile = is.tile(), ...)
tk2notebook(parent, tabs, use.tile = is.tile(), ...)
tk2panedwindow(parent, orientation = c("horizontal", "vertical"),
    use.tile = is.tile(), ...)
tk2progress(parent, orientation = c("horizontal", "vertical"),
    tip = "", use.tile = is.tile(), ...)
tk2radiobutton(parent, tip = "", use.tile = is.tile(), ...)
tk2scale(parent, orientation = c("horizontal", "vertical"),
    tip = "", use.tile = is.tile(), ...)
tk2scrollbar(parent, orientation = c("horizontal", "vertical"),
    use.tile = is.tile(), ...)
tk2separator(parent, orientation = c("horizontal", "vertical"),
    use.tile = is.tile(), ...)
tk2spinbox(parent, tip = "", use.tile = is.tile(), ...)
tk2table(parent, use.tile = is.tile(), ...)
tk2text(parent, tip = "", use.tile = is.tile(), ...)
tk2ctext(parent, tip = "", use.tile = is.tile(), ...)
tk2tree(parent, tip = "", use.tile = is.tile(), ...)
}

\arguments{
  \item{parent}{ The parent window }
  \item{tip}{ A tooltip to display for this widget }
  \item{use.tile}{ Do we use the tile version of this widget? Normally, you do
    not have to change this value, except in very specific cases. If you want
    to use tile version, make sure that tile is loaded (\code{tile.load()} if
    needed). Once tile is loaded, it cannot be unloaded, but you can force using
    the non-tile version by setting \code{options(tcltk2.tile = FALSE)}. }
  \item{selectmode}{ The selection mode for this widget }
  \item{text}{ The text to display in the widget }
  \item{justify}{ How text is justified? }
  \item{tabs}{ The tabs to create in the notebook widget }
  \item{width}{ The desired width. Use a negative value to use \code{aspect} instead }
  \item{aspect}{ Sets the aspect ratio of the widget (100 = square, 200 =
    twice large, 50 = twice taller). Only used if \code{width} is negative }
  \item{orientation}{ Either \code{"horizontal"} or \code{"vertical"} }
  \item{\dots}{ Further arguments passed to the widget }
}

\value{
  The reference to the created widget.
}

\author{ Philippe Grosjean }
\note{ You need tile 0.7.2 or above to use the tile version of these widgets.
  The required library is autoamtically installed with the tcltk2 package under
  Windows, but for other platforms, you must make sure Tile => 0.7.2 is available. }

\seealso{ \code{\link{tile.load}}, \code{\link{is.tile}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

### A tk2notebook example
tt2 <- tktoplevel()
nb <- tk2notebook(tt2, tabs = c("Test", "Button"))
tkpack(nb, fill = "both", expand = 1)
tb1 <- tk2notetab(nb, "Test")
lab <- tk2label(tb1, text = "Nothing here.")
tkpack(lab)
tb2 <- tk2notetab(nb, "Button")
but <- tk2button(tb2, text = "Click me", command = function() tkdestroy(tt2))
tkgrid(but)
tk2notetab.select(nb, "Button")
tk2notetab.text(nb) # Text of the currently selected tab

## A simple tk2panedwindow example
tt2 <- tktoplevel()
pw <- tk2panedwindow(tt2, orient = "vertical")
lpw.1 <- tk2text(pw)
lpw.2 <- tk2text(pw)
tkadd(pw, lpw.1)#, minsize = 100)
tkadd(pw, lpw.2)#, minsize = 70)
but <- tk2button(tt2, text = "OK", width = 10,
    command = function() tkdestroy(tt2))
tkpack(pw, fill = "both", expand = "yes")
tkpack(but)
# Resize the window and move the panel separator with the mouse

## A tk2combobox example
tt2 <- tktoplevel()
cb <- tk2combobox(tt2)
tkgrid(cb)
# Fill the combobox list
fruits <- c("Apple", "Orange", "Banana")
tk2list.set(cb, fruits)
tk2list.insert(cb, "end", "Scoubidou", "Pear")
tk2list.delete(cb, 3)   # 0-based index!
tk2list.size(cb)
tk2list.get(cb)   # All items
# Link current selection to a variable
Fruit <- tclVar("Pear")
tkconfigure(cb, textvariable = Fruit)
# Create a button to get the content of the combobox
but <- tk2button(tt2, text = "OK", width = 10,
    command = function() {tkdestroy(tt2); cat(tclvalue(Fruit), "\n")})
tkgrid(but)

### An example of a tk2spinbox widget
tt2 <- tktoplevel()
tspin <- tk2spinbox(tt2, from = 2, to = 20, increment = 2)
tkgrid(tspin)
## This widget is not added yet into tcltk2!
#tdial <- tk2dial(tt2, from = 0, to = 20, resolution = 0.5, width = 70,
#	tickinterval = 2)
#tkgrid(tdial)
tbut <- tk2button(tt2, text = "OK", width = 10,
    command = function() tkdestroy(tt2))
tkgrid(tbut)

## A tk2mclistbox example
tt2 <- tktoplevel()
mlb <- tk2mclistbox(tt2, width = 55, resizablecolumns = TRUE)
# Define the columns
tk2column(mlb, "add", "name", label = "First name", width = 20)
tk2column(mlb, "add", "lastname", label = "Last name", width = 20)
tk2column(mlb, "add", "org", label = "Organisation", width = 15)
tkgrid(mlb)
# Fill the multicolumn list (we can use a vector, or a matrix of character strings)
item1 <- c("Bryan", "Oackley", "ChannelPoint")
items <- matrix(c("John", "Ousterhout", "Scriptics",
    "Steve", "Miller", "TclTk inc."), ncol = 3, byrow = TRUE)
tk2insert.multi(mlb, "end", item1)
tk2insert.multi(mlb, "end", items)
#### TO DO: bind events
# Ex: .listbox label bind date <ButtonPress-1> "sortByDate %W"
# See the example.tcl in .\libs\mclistbox1.02 for a more complex example
# Create a button to close the dialog box
but <- tk2button(tt2, text = "OK", width = 10,
    command = function() tkdestroy(tt2))
tkgrid(but)

### A simple tk2table example (Tktable is required here!)
myRarray <- c("Animal", "\"sphinx moth\"", "oyster",
    "Type", "insect", "mollusk")
dim(myRarray) <- c(3, 2)
for (i in (0:2))
    for (j in (0:1))
        .Tcl(paste("set tclarray(", i, ",", j, ") ", myRarray[i+1, j+1], sep = ""))
tt2 <- tktoplevel()
table1 <- tk2table(tt2, variable = "tclarray", rows = "3",
    cols = "2", titlerows = "1", selectmode = "extended", colwidth = "25",
    background = "white")
tkpack(table1)
}
}

\keyword{ utilities }
