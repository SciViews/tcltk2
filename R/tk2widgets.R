# tk2widgets.R - Support for the ttk widgets
# Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
# Licensed under LGPL 3 or above
#
# Changes:
# - 2012-01-09: reworked tk2label to provide "full options"
#
# - 2012-01-07: listbox now behaves like a ttk widget, although it is not!
#
# - 2009-06-30: only use ttk (no tile or plain widgets)
#
# - 2007-01-01: first version (for tcltk2_1.0-0)
#
# To do:
# - Rework all this and add new widgets like sizegrip, tkplot, ...

### autoscroll
#tclRequire("autoscroll")
#tt <- tktoplevel()
#scrl <- tkscrollbar(tt, orient = "v", command = function(...) tkyview(txt, ...))
#txt <- tktext(tt, highlightthickness = 0, yscrollcommand = function(...) tkset(scrl, ...))
#tkpack(scrl, side = "right", fill = "y")
#tkpack(txt, side = "left", fill = "both", expand = 1)
#tcl("::autoscroll::autoscroll", scrl)


# Management of locales and message translation using msgcat


#' A series of versatile using either themable ttk widgets
#'
#' A series of widgets you can use in your Tk windows/dialog boxes.
#'
#' @param parent The parent window.
#' @param tip A tooltip to display for this widget (optional).
#' @param label A single character string used to label that widget (optional).
#' @param tag Ay object that you would like to associate with this widget
#' (optional).
#' @param cfglist A named list with configuration parameters and values to
#' apply.
#' @param wrap Do we wrap long lines in the widget?
#' @param values A character vector with values to use to populate the widget.
#' @param value A character vector with current value for the widget, or
#' currently selected values, if multiple selection is allowed. Takes precedence
#' on `selection`.
#' @param selection A numeric (indices) vector with current selection.
#' @param selectmode The selection mode for this widget. `extended` is the
#' usual choice for multiselection `tk2listbox()`.
#' @param height The height of the widget.
#' @param scroll Do we add scrollbars? Possible values are `"x"`, `"y"`,
#' `"both"` or `"none"`; can be abridged.
#' @param autoscroll Do we automatically hide scrollbars if not needed? Possible
#' values are the same as for the `scroll` argument.
#' @param enabled Is the widget enabled or disabled?
#' @param text The text to display in the widget.
#' @param justify How text is justified?
#' @param tabs The tabs to create in the notebook widget.
#' @param width The desired width. Use a negative value to use `aspect` instead.
#' @param aspect Sets the aspect ratio of the widget (100 = square, 200 = twice
#' as large, 50 = twice as tall). Only used if `width` is negative.
#' @param orientation Either `"horizontal"` or `"vertical"`.
#' @param activebackground Color to use for active background of menu items (if
#' not provided, a reasonable default value is used).
#' @param activeforeground Color to use for active foreground of menu items (if
#' not provided, a reasonable default value is used).
#' @param ... Further arguments passed to the widget.
#'
#' @return
#' The reference to the created widget.
#'
#' @note You need Tk 8.5 or above to use these widgets.
#'
#' @author Philippe Grosjean
#' @export
#' @rdname tk2widgets
#' @seealso [is.ttk()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' # A tk2notebook example
#' tt2 <- tktoplevel()
#' nb <- tk2notebook(tt2, tabs = c("Test", "Button"))
#' tkpack(nb, fill = "both", expand = 1)
#' tb1 <- tk2notetab(nb, "Test")
#' lab <- tk2label(tb1, text = "Nothing here.")
#' tkpack(lab)
#' tb2 <- tk2notetab(nb, "Button")
#' but <- tk2button(tb2, text = "Click me", command = function() tkdestroy(tt2))
#' tkgrid(but)
#' tk2notetab.select(nb, "Button")
#' tk2notetab.text(nb) # Text of the currently selected tab
#'
#' # A simple tk2panedwindow example
#' tt2 <- tktoplevel()
#' pw <- tk2panedwindow(tt2, orient = "vertical")
#' lpw.1 <- tk2text(pw)
#' lpw.2 <- tk2text(pw)
#' tkadd(pw, lpw.1)#, minsize = 100)
#' tkadd(pw, lpw.2)#, minsize = 70)
#' but <- tk2button(tt2, text = "OK", width = 10,
#'   command = function() tkdestroy(tt2))
#' tkpack(pw, fill = "both", expand = "yes")
#' tkpack(but)
#' # Resize the window and move the panel separator with the mouse
#'
#' # A tk2combobox example
#' tt2 <- tktoplevel()
#' cb <- tk2combobox(tt2)
#' tkgrid(cb)
#' # Fill the combobox list
#' fruits <- c("Apple", "Orange", "Banana")
#' tk2list.set(cb, fruits)
#' tk2list.insert(cb, "end", "Scoubidou", "Pear")
#' tk2list.delete(cb, 3)   # 0-based index!
#' tk2list.size(cb)
#' tk2list.get(cb)   # All items
#' # Link current selection to a variable
#' Fruit <- tclVar("Pear")
#' tkconfigure(cb, textvariable = Fruit)
#' # Create a button to get the content of the combobox
#' but <- tk2button(tt2, text = "OK", width = 10,
#'   command = function() {tkdestroy(tt2); cat(tclvalue(Fruit), "\n")})
#' tkgrid(but)
#'
#' # An example of a tk2spinbox widget
#' tt2 <- tktoplevel()
#' tspin <- tk2spinbox(tt2, from = 2, to = 20, increment = 2)
#' tkgrid(tspin)
#' # This widget is not added yet into tcltk2!
#' #tdial <- tk2dial(tt2, from = 0, to = 20, resolution = 0.5, width = 70,
#' #	tickinterval = 2)
#' #tkgrid(tdial)
#' tbut <- tk2button(tt2, text = "OK", width = 10,
#'   command = function() tkdestroy(tt2))
#' tkgrid(tbut)
#'
#' # A tk2mclistbox example
#' tt2 <- tktoplevel()
#' mlb <- tk2mclistbox(tt2, width = 55, resizablecolumns = TRUE)
#' # Define the columns
#' tk2column(mlb, "add", "name", label = "First name", width = 20)
#' tk2column(mlb, "add", "lastname", label = "Last name", width = 20)
#' tk2column(mlb, "add", "org", label = "Organisation", width = 15)
#' tkgrid(mlb)
#' # Fill the multicolumn list (we can use a vector, or a matrix of character strings)
#' item1 <- c("Bryan", "Oackley", "ChannelPoint")
#' items <- matrix(c("John", "Ousterhout", "Scriptics", "Steve", "Miller", "TclTk inc."),
#'   ncol = 3, byrow = TRUE)
#' tk2insert.multi(mlb, "end", item1)
#' tk2insert.multi(mlb, "end", items)
#' # TODO: bind events
#' # Ex: .listbox label bind date <ButtonPress-1> "sortByDate %W"
#' # See the example.tcl in .\libs\mclistbox1.02 for a more complex example
#' # Create a button to close the dialog box
#' but <- tk2button(tt2, text = "OK", width = 10,
#'   command = function() tkdestroy(tt2))
#' tkgrid(but)
#'
#' # A simple tk2table example (Tktable is required here!)
#' myRarray <- c("Animal", "\"sphinx moth\"", "oyster", "Type", "insect", "mollusk")
#' dim(myRarray) <- c(3, 2)
#' for (i in (0:2))
#'   for (j in (0:1))
#'     .Tcl(paste("set tclarray(", i, ",", j, ") ", myRarray[i+1, j+1], sep = ""))
#' tt2 <- tktoplevel()
#' table1 <- tk2table(tt2, variable = "tclarray", rows = "3", cols = "2",
#'   titlerows = "1", selectmode = "extended", colwidth = "25", background = "white")
#' tkpack(table1)

#' # A tablelist example
#' tt <- tktoplevel()
#' tlist <- tk2tablelist(tt, columntitles = c("First column", "Second column"),
#'   stretch = "all", expand = 1)
#' tkpack(tlist, fill = "both")
#' tkinsert(tlist, "end", c("first row", "another value"))
#' tkinsert(tlist, "end", c("another row", "bla bla"))
#' tbut <- tk2button(tt, text = "Done", command = function () tkdestroy(tt))
#' tkpack(tbut)
#' }
tk2button <- function(parent, tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::button", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2button", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2canvas <- function(parent, tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
### TODO: use autoscroll here!
  # Default background to fieldbackground
  if (any(names(list(...)) == "background")) {
    w <- tkwidget(parent, "canvas", ...)
  } else {
    background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
    if (background == "")
      background <- "white"
    w <- tkwidget(parent, "canvas", background = background, ...)
  }
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2canvas", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2checkbutton <- function(parent, tip = "", ...) {
### TODO: associate with a variable and set both states values
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::checkbutton", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2checkbutton", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2combobox <- function(parent, tip = "", ...) {
### TODO: associate the list and results with a variable and intialize the widget
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::combobox", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2combobox", "tk2widget", class(w))
  w
}

### TODO: a centry widget

#' @export
#' @rdname tk2widgets
tk2entry <- function(parent, tip = "", ...) {
### TODO: add cut/copy/paste/select all/clear context menu
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::entry", cursor = "xterm", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2entry", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2frame <- function(parent, ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::frame", ...)
  class(w) <- c("tk2frame", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2label <- function(parent, tip, label, tag, cfglist, wrap = FALSE, ...) {
  # Also image, text, textvariable, label & tag for data
  # width = -10, compound = "left", justify = "left", wrap = FALSE for config
  # Special treatment from wrap (wraplength)
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  # If a config list is provided, rework arguments
  if (!missing(cfglist)) {
    args <- .mergeList(cfglist, list(...))
    args$parent <- parent
    if (!missing(tip))
      args$tip <- tip
    if (!missing(label))
      args$label <- label
    if (!missing(tag))
      args$tag <- tag
    return(do.call(tk2label, args))
  }
  # Create the widget and the corresponding R object
  w <- tkwidget(parent, "ttk::label", ...)
  class(w) <- c("tk2label", "tk2widget", class(w))
  if (!missing(tip))
    tip(w) <- tip
  if (!missing(label))
    label(w) <- label
  if (!missing(tag))
    tag(w) <- tag
  # Special treatment for 'wrap' argument that does not exists in ttk::label
  if (!missing(wrap)) {
    # We need width
    width <- abs(as.integer(tclvalue(tkcget(w, "-width"))))
    if (isTRUE(wrap)) wraplength <- .wraplength(w, width) else wraplength <- 0
    tkconfigure(w, wraplength = wraplength)
    # If width is not reapplied after wraplength, the text is not always
    # wrapped in the widget (is this a bug?)
    if (wraplength > 0 && length(width))
      tkconfigure(w, width = width)
  }
  w
}

#' @export
#' @rdname tk2widgets
tk2labelframe <- function(parent, ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::labelframe", ...)
  class(w) <- c("tk2labelframe", "tk2widget", class(w))
  w
}

## TODO: I need to rework this on the same scheme as tk2label

#' @export
#' @rdname tk2widgets
tk2listbox <- function(parent, values, value, selection,
selectmode = c("extended", "single", "browse", "multiple"), height = 5,
tip = "", scroll = "both", autoscroll = "x", enabled = TRUE, ...) {
  # Check conditions and arguments
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  selectmode <- match.arg(selectmode)
  scrolls <- c("x", "y", "both", "none")
  scroll <- match.arg(scroll, scrolls)
  autoscroll <- match.arg(autoscroll, scrolls)
  if (missing(values) || length(values) == 0) {
    values <- NULL
  } else {
    values <- as.character(values)
  }
  # We provide either value or selection... translate value into selection
  if (missing(selection))
    selection <- NULL
  if (!missing(value)) {
    if (is.null(values) || length(values) < 1) {
      selection <- NULL
    } else {
      selection <- (1:length(values))[values %in% as.character(value)]
    }
  }
  if (length(selection) == 0 || is.null(values) || length(values) < 1) {
    selection <- NULL
  } else {
    selection <- sort(as.integer(round(selection)))
    if (selection[1] < 1)
      stop("Numerical selections must be indices > 0")
    if (selection[1] > length(values))
      selection <- NULL
    if (selectmode == "single" && length(selection) > 1) {
      warning("Only lowest selection used in single selection mode")
      selection <- selection[1]
    }
  }

  # Location of the widget depends if we add scrollbars or not
  background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
  if (background == "")
    background <- "white"
  if (scroll == "none") {
    w <- tkwidget(parent, "listbox", font = "TkDefaultFont",
      borderwidth = 1, relief = "sunken", activestyle = "dotbox",
      selectmode = selectmode, height = height, exportselection = 0,
      background = background, ...)
  } else {# We need to create a tk2frame as parent of the listbox
    wf <- tk2frame(parent)
    w <- tkwidget(wf, "listbox", font = "TkDefaultFont",
      borderwidth = 1, relief = "sunken", activestyle = "dotbox",
      selectmode = selectmode, height = height, exportselection = 0,
      background = background, ...)
  }
  # Make it react to tk2theme changes, and integrate the listbox as much
  # as possible with current ttk theme
  #restyleListbox <- function (W) {
  #  # Restyle the listbox according to current ttk style
  #  # Note: font is set to TkDefaultFont => already managed there!
  #  tkconfigure(W,
  #    foreground = tk2style("tk2entry", "foreground",
  #      default = "#000000"),
  #    borderwidth = tk2style("", "borderwidth", default = 0),
  #    disabledforeground = tk2style("tk2entry", "foreground",
  #      "disabled", default = "#a3a3a3"),
  #    highlightbackground = tk2style("tk2entry", "selectbackground",
  #      default = "#c3c3c3"),
  #    highlightcolor = tk2style("tk2entry", "selectbackground",
  #      default = "#c3c3c3"),
  #    selectbackground = tk2style("tk2entry", "selectbackground",
  #      default = "#c3c3c3"),
  #    selectforeground = tk2style("tk2entry", "selectforeground",
  #      default = "#ffffff")
  #  )
  #}
  # Restyle it now
  #restyleListbox(w)
  restyleListbox <- function(W) {
    background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
    if (background == "")
      background <- "white"
    tkconfigure(W, background = background)
  }

  # If there are values and/or selections, populate the list now
  for (item in values)
    tkinsert(w, "end", item)
  if (!is.null(selection)) {
    for (sel in selection)
      tkselection.set(w, sel - 1) # Because Tcl uses 0-based indexing!
    tksee(w, selection[1]) # Ensure that the first selected item is visible
  }

  # Possibly add a tooltip
  if (tip != "") tk2tip(w, tip)

  ## Do we add scrollbars?
  if (scroll == "none") {
    ## Apply bindings to original listbox
    tkbind(w, "<<ThemeChanged>>", restyleListbox)
    tkbind(w, "<1>", function(W) tkfocus(W)) # Needed for mouseweel action
    # Do we disable it?
    if (!isTRUE(enabled))
      tkconfigure(w, state = "disabled")
    # Done... just return the widget
    class(w) <- c("tk2listbox", "tk2widget", class(w))
    return(w)
  } else {
    # Add (autohide) scrollbar(s)
    tcl("scrolledWidget", w, wf, scroll, autoscroll)
    # Apply bindings to frame container
    tkbind(wf, "<<ThemeChanged>>", restyleListbox)
    tkbind(wf, "<1>", function(W) tkfocus(W)) # Needed for mouseweel action
    class(wf) <- c("tk2listbox", "tk2widget", class(w))
    # Do we disable it?
    if (!isTRUE(enabled))
      tkconfigure(wf, state = "disabled")
    return(wf)
  }
}

#' @export
#' @rdname tk2widgets
tk2mclistbox <- function(parent, tip ="", ...) {
### TODO: a tile equivalent of this widget
### TODO: or adjust the header: font, color and frame
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  res <- tclRequire("mclistbox")
  if (!inherits(res, "tclObj"))
    stop("Impossible to load the Tcl mclistbox package; check your Tcl/Tk installation")

  background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
  if (background == "")
    background <- "white"
  w <- tkwidget(parent, "mclistbox::mclistbox", font = "TkDefaultFont",
    background = background, ...)
  tkconfigure(w, relief = "flat")
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2mclistbox", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2menu <- function(parent, activebackground, activeforeground, ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "menu", ...)
  if (missing(activebackground))
    activebackground <- tk2style("tk2button", "selectbackground")
  if (activebackground == "")
    activebackground = "darkblue" # Default value
  if (missing(activeforeground))
    activeforeground <- tk2style("tk2button", "selectforeground")
  if (activeforeground == "") activeforeground = "white" # Default value
    tkconfigure(w, activebackground = activebackground,
      activeforeground = activeforeground)
  class(w) <- c("tk2menu", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2menubutton <- function(parent, tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::menubutton", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2menubutton", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2message <- function(parent, text = "", justify = c("left", "center", "right"),
width = -1, aspect = 150, tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  justify <- as.character(justify[1])
  w <- tkwidget(parent, "message", text = text, justify = justify,
    width = width, aspect = aspect, font = "TkDefaultFont", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2message", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2notebook <- function(parent, tabs, ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::notebook", ...)
  # Add pages
  tabs <- as.character(tabs)
  for (tab in tabs) {
    tframe <- tk2frame(w)
    tkadd(w, tframe, text = tab, sticky = "nsew")
  }
  tk2notetraverse(w)  # Enable keyboard traversal for this notebook
  class(w) <- c("tk2notebook", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2panedwindow <- function(parent, orientation = c("horizontal", "vertical"), ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  orientation <- as.character(orientation[1])
  w <- tkwidget(parent, "ttk::panedwindow", orient = orientation, ...)
  class(w) <- c("tk2panedwindow", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2progress <- function(parent, orientation = c("horizontal", "vertical"),
tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  orientation <- as.character(orientation[1])
  w <- tkwidget(parent, "ttk::progressbar", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2progress", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2radiobutton <- function(parent, tip = "", ...) {
### TODO: associate with a variable and set both states values
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  w <- tkwidget(parent, "ttk::radiobutton", ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2radiobutton", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2scale <- function(parent, orientation = c("horizontal", "vertical"),
tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  orientation <- as.character(orientation[1])
  w <- tkwidget(parent, "ttk::scale", orient = orientation, ...)
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2scale", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2scrollbar <- function(parent, orientation = c("horizontal", "vertical"), ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  orientation <- as.character(orientation[1])
  w <- tkwidget(parent, "ttk::scrollbar", orient = orientation, ...)
  class(w) <- c("tk2scrollbar", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2separator <- function(parent, orientation = c("horizontal", "vertical"), ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  orientation <- as.character(orientation[1])
  w <- tkwidget(parent, "ttk::separator", orient = orientation, ...)
  class(w) <- c("tk2separator", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2spinbox <- function(parent, tip = "", ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  # Default background to fieldbackground
  if (any(names(list(...)) == "background")) {
    w <- tkwidget(parent, "spinbox", font = "TkDefaultFont",
      relief = "solid", borderwidth = 1, ...)
  } else {
    background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
    if (background == "")
      background <- "white"
    w <- tkwidget(parent, "spinbox", font = "TkDefaultFont",
      relief = "solid", borderwidth = 1, background = background, ...)
  }

  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2spinbox", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2text <- function(parent, tip = "", ...) {
### TODO: autohide scrollbars
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")

  # Default background to fieldbackground
  if (any(names(list(...)) == "background")) {
    w <- tkwidget(parent, "text", font = "TkTextFont", ...)
  } else {
    background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
    if (background == "")
      background <- "white"
    w <- tkwidget(parent, "text", font = "TkTextFont", background = background, ...)
  }

  tkconfigure(w, relief = "flat")
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2text", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2ctext <- function(parent, tip = "", ...) {
### TODO: autohide scrollbars
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  tclRequire("ctext")

  # Default background to fieldbackground
  if (any(names(list(...)) == "background")) {
    w <- tkwidget(parent, "ctext", font = "TkFixedFont", ...)
  } else {
    background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
    if (background == "")
      background <- "white"
    w <- tkwidget(parent, "ctext", font = "TkFixedFont", background = background, ...)
  }

  tkconfigure(w, relief = "flat")
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2ctext", "tk2widget", class(w))
  w
}

### TODO: rework this, using ttk::treeview

#' @export
#' @rdname tk2widgets
tk2tree <- function(parent, tip = "", ...) {
### TODO: better icons!
  # Reasonable default icons for files and folders
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  images <- as.character(tcl("image", "names"))
  if (!"Tree:dir" %in% images)
    .Tcl("image create photo Tree:dir -data {R0lGODdhEAAQAPIAAAAAAHh4eLi4uPj4APj4+P///wAAAAAAACwAAAAAEAAQAAADPVi63P4wLkKCtTTnUsXwQqBtAfh910UU4ugGAEucpgnLNY3Gop7folwNOBOeiEYQ0acDpp6pGAFArVqthQQAO///}")
  if (!"Tree:file" %in% images)
    .Tcl("image create photo Tree:file -data {R0lGODdhEAAQAPIAAAAAAHh4eLi4uPj4+P///wAAAAAAAAAAACwAAAAAEAAQAAADPkixzPODyADrWE8qC8WN0+BZAmBq1GMOqwigXFXCrGk/cxjjr27fLtout6n9eMIYMTXsFZsogXRKJf6uP0kCADv/}")

### TODO: correct support of font
  w <- tkwidget(parent, "Tree:create")  #, font = "TkDefaultFont", ...)
  tkconfigure(w, relief = "flat")
  if (tip != "")
    tk2tip(w, tip)
  class(w) <- c("tk2tree", "tk2widget", class(w))
  w
}

#' @export
#' @rdname tk2widgets
tk2table <- function(parent, ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  if (inherits(tclRequire("Tktable", warn = FALSE), "tclObj")) {
    w <- tkwidget(parent, "table", font = "TkDefaultFont", ...)
    class(w) <- c("tk2table", "tk2widget", class(w))
    return(w)
  } else {
    stop("Tcl package 'Tktable' must be installed first")
  }
}

#' @export
#' @rdname tk2widgets
tk2tablelist <- function(parent, ...) {
  if (!is.ttk())
    stop("Tcl/Tk >= 8.5 is required")
  if (inherits(tclRequire("tablelist_tile", warn = FALSE), "tclObj")) {
    # Default background to fieldbackground
    if (any(names(list(...)) == "background")) {
      w <- tkwidget(parent, "tablelist::tablelist", font = "TkDefaultFont", ...)
    } else {
      background <- tclvalue(.Tcl("ttk::style lookup TEntry -fieldbackground"))
      if (background == "")
        background <- "white"
      w <- tkwidget(parent, "tablelist::tablelist",
        font = "TkDefaultFont", background = background, ...)
    }

    class(w) <- c("tk2tablelist", "tk2widget", class(w))
    return(w)
  } else {
    stop("Tcl package 'tablelist' must be installed first")
  }
}
