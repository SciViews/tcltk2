#' Display and manage tooltips in Tk widgets
#'
#' [tk2tip()] provides a simple mechanism to display tooltips on Tk widgets when
#' the mouse cursor hoovers on top of them.
#'
#' @param widget The widget to which a tooltip is attached.
#' @param message The message of the tooltip (\code{""} to remove the tooltip).
#' @param x A tk2widget object.
#' @param ... Further arguments to the method (unused, but reserved for
#' future use).
#' @param value The message of the tooltip, or \code{""} to remove the tip.
#'
#' @return
#' The current tip or `NULL` depending on the function.
#'
#' @note
#' This implementation is done in pure Tcl code.
#'
#' @export
#' @author Philippe Grosjean
#' @seealso [tk2button()], [label()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' # Using plain Tcl/Tk label and button (tk2XXX equivalent have built-in
#' # tooltip features)
#' tt <- tktoplevel()
#' lb <- tklabel(tt, text = "Move mouse over me, or over the button to see tooltip")
#' tkgrid(lb)
#' tk2tip(lb, "A tooltip for the label \ndisplayed on two lines")
#' but <- tkbutton(tt, text = "Exit", width = 10,
#'   command = function() tkdestroy(tt))
#' tkgrid(but)
#' tk2tip(but, "Exit from this dialog box")
#'
#' # To test tk2killtip(), move mouse on top of a widget
#' # so that the tip is visible, and force killing it manually using:
#' tk2killtip()
#' # Move again to the widget: the tip is displayed again.
#'
#' # With tk2widgets, the tip() method can also be used:
#' lb2 <- tk2label(tt, text = "Move also over me to see the tooltip")
#' tkgrid(lb2)
#' tip(lb2) # No tip yet
#' tip(lb2) <- "Now the tooltip is there!"
#' # Move the mouse over that last label
#'
#' tip(lb2) # Yes, this is my tooltip
#' tip(lb2) <- NULL # To eliminate the tooltip for this widget
#' }
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

#' @export
#' @rdname tk2tip
tk2killtip <- function() {
  if (!is.tk())
    stop("Package Tk is required but not loaded")
  invisible(tcl("tooltip::hide"))
}

#' @export
#' @rdname tk2tip
tip <- function(x, ...)
  UseMethod("tip")

#' @export
#' @rdname tk2tip
tip.tk2widget <- function(x, ...)
  x$env$tip

#' @export
#' @rdname tk2tip
`tip<-` <- function(x, value)
  UseMethod("tip<-")

#' @export
#' @rdname tk2tip
`tip<-.tk2widget` <- function(x, value) {
  tk2tip(x, value)
  x
}
