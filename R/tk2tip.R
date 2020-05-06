### tk2tip.R - Tooltips for Tk widgets
### Copyright (c), Philippe Grosjean (phgrosjean@sciviews.org)
### Licensed under LGPL 3 or above
###
### Changes:
### - 2007-01-01: first version (for tcltk2_1.0-0)
###
### To do:
### - add and check catch instructions here

tk2tip <- function(widget, message) {
  if (!is.tk())
    stop("Package Tk is required but not loaded")
  if (is.null(message))
    message <- ""
  res <- tclRequire("tooltip")
  if (inherits(res, "tclObj")) {
    res <- tcl("tooltip::tooltip", widget, message)
    # Store tip text in the object (use NULL instead of "" for no tip)
    if (message == "")
      message <- NULL
    widget$env$tip <- message
  } else {
    stop("cannot find tcl package 'tooltip'")
  }
  invisible(res)
}

tk2killtip <- function() {
  if (!is.tk())
    stop("Package Tk is required but not loaded")
  invisible(tcl("tooltip::hide"))
}

# Get tip method
tip <- function(x, ...)
  UseMethod("tip")

tip.tk2widget <- function(x, ...)
  x$env$tip

# Change tip method
`tip<-` <- function(x, value)
  UseMethod("tip<-")

`tip<-.tk2widget` <- function(x, value) {
  tk2tip(x, value)
  x
}
