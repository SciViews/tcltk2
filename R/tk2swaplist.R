#' A list selector that allows to select and arrange items freely
#'
#' The swaplist is perfect to select and arrange items in a given order from a
#' fixed initial set of possible items.
#'
#' @param items A vector with all items.
#' @param selection A vector with preselected items (must be a subset of `items`).
#' @param title The title of the dialog box, by default, "Select items".
#' @param ... Further parameters passed to swaplist, see its tcl man page:
#' https://core.tcl-lang.org/tklib/doc/trunk/embedded/www/tklib/files/modules/swaplist/swaplist.html.
#'
#' @return A vector with the selected items in the chosen order.
#' @export
#' @seealso [tk2listbox()], [tk2tablelist()]
#'
#' @examples
#' \dontrun{
#' library(tcltk2)
#' # tk2swaplist() makes its use super-easy
#' tk2swaplist(1:9, selection = c(1, 3, 5))
#'
#' # Use of the swaplist on your own
#' tclRequire("swaplist")
#' tt <- tktoplevel()
#' opts <- tclVar()
#' sl <- tcl("swaplist::swaplist", tt, opts, 1:9, c(1, 3, 5))
#' cat("You choose:", tclvalue(opts), "\n")
#' rm(opts, sl, tt)
#' }
tk2swaplist <- function(items, selection, title = "Select items", ...) {
  win <- tktoplevel()
  res <- try(tclRequire("swaplist"), silent = TRUE)
  if (inherits(res, "try-error"))
    stop("swaplist Tcl package not available")
  sel <- tclVar()
  res <- tcl("swaplist::swaplist", win, sel, items, selection,
    title = title, ...)
  if (tclvalue(res) == 0) { # User cancelled
    res <- character(0)
  } else {
    res <- tclObj(sel)
  }
  if (is.ordered(items))
    return(ordered(as.character(res), levels = levels(items)))
  if (is.factor(items))
    return(factor(as.character(res), levels = levels(items)))
  switch(typeof(items),
    integer = as.integer(res),
    double = as.numeric(res),
    logical = as.logical(res),
    complex = as.complex(res),
    as.character(res)
  )
}
