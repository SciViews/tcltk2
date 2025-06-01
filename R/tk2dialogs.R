#' Additional Tk dialog boxes
#'
#' Tk dialog boxes to select a font, unicode characters or a list of ordered
#' items.
#'
#' @param ... Further arguments passed to the dialog box.
#' @param parent The Tk toplevel dialog box that will be the parent of the
#' configuration dialog box.
#' @param widget A widget that can accept a unicode character. For
#' `tk2unicode_bind()` it must be a `tk2text` or a `tk2entry` widget.
#'
#' @return
#' The selection made in the dialog box if `OK` is clicked, `""` otherwise for
#' [tk2chooseFont()].
#'
#' The [tk2unicode_select()] dialog pastes the selected unicode character in the
#' designed widget, but returns nothing. The [tk2unicode_config()] changes the
#' configuration for the unicode composer, but returns nothing. If you decide to
#' do so, it saves the config on a file. This is done app-by-app, and the
#' default app name is `"R"`. You can change it by setting a different
#' value in the option `"tk2app"`, i.e., `options(tk2app = "myApp")`.
#' The `tk2unicode_bind()` is also invoked for its side-effect to install
#' required bindings to enable the unicode composer engine for the given widget
#' and it returns nothing.
#'
#' @export
#' @rdname tk2dialogfonts
#' @author Philippe Grosjean
#' @seealso [tk2text()], [tk2listbox()], [tk2list.insert()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' library(tcltk2)
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' # Font selection
#' tk2chooseFont()
#' tk2chooseFont(font = "{courier} 9", title = "Choose a fixed font",
#'   fonttype = "fixed", style = 4, sizetype = "all")
#' tk2chooseFont(font = "Verdana 12 bold italic underline overstrike",
#'   fonttype = "prop", style = 2, sizetype = "point")
#'
#' # Easy unicode character entry
#' tt <- tktoplevel()
#' txt <- tk2text(tt, width = 60, height = 20)
#' tkpack(txt)
#' e <- tk2entry(tt, width = 50)
#' tkpack(e)
#' # Get an unicode character for the text widget
#' tk2unicode_select(txt)
#' # and for the entry widget
#' tk2unicode_select(e)
#'
#' # Bind the composer to both the text and the entry widgets
#' # and display the configuration box
#' # Once done, try the compose key + m + u, or compose + " + a
#' # or any othert sequence in both widgets
#' # or hit the compose key twice
#' tk2unicode_bind(txt)
#' tk2unicode_bind(e)
#' tk2unicode_config(tt)
#' }
tk2chooseFont <- function(...) {
  if (!is.tk())
    stop("Package Tk is required but not loaded")
  tclRequire("choosefont")
  # Make sure message translations are correctly loaded
  try(tcl("mcload", system.file("tklibs", "choosefile", "msgs",
    package = "tcltk2")), silent = TRUE)
  tcl("choosefont::choosefont", ...)
}

# Unicode character input
.tk2unicode_file <- function(app = getOption("tk2app", "R"))
  file.path("~", paste0(".khimrc.", as.character(app)[1]))

.tk2unicode_load <- function() {
  # Try to get current configuration
  cfg <- try(tcl("::khim::getConfig"), silent = TRUE)
  if (inherits(cfg, "try-error")) {
    # Try loading the khim package
    res <- tclRequire("khim")
    if (!inherits(res, "tclObj"))
      return()
    # If a config file exists, load it now
    cfgfile <- .tk2unicode_file()
    if (file.exists(cfgfile))
      tcl("source", cfgfile)
    # finally get the updated config
    cfg <- tcl("::khim::getConfig")
  }
  # Make sure message translations are correctly loaded
  try(tcl("mcload", system.file("tklibs", "khim", "msgs",
    package = "tcltk2")), silent = TRUE)
  tclvalue(cfg)
}

#' @export
#' @rdname tk2dialogfonts
tk2unicode_config <- function(parent) {
  if (!inherits(parent, "tkwin"))
    stop("'parent' must be a 'tkwin' object")

  # Make sure khim is loaded and get its current config
  cfg <- .tk2unicode_load()

  # Display the configuration dialog box
  .Tcl(paste0("::khim::getOptions ", parent$ID, ".khim"))

  # Get the new config and compare it with the old one
  cfg2 <- tclvalue(tcl("::khim::getConfig"))
  if (cfg2 != cfg) {
    # Ask to save the new config
    msg <- tclmc("Do you want to save this configuration on disk?",
      domain = "khim")
    res <- tkmessageBox(
      message = msg, icon = "question", type = "yesno")
    if (tclvalue(res) == "yes") {
      cfgfile <- .tk2unicode_file()
      cat(cfg2, file = cfgfile)
    }
  }
}

#' @export
#' @rdname tk2dialogfonts
tk2unicode_select <- function(widget) {
  .tk2unicode_load()
  tcl("::khim::FocusAndInsertSymbol", widget$ID)
}

#' @export
#' @rdname tk2dialogfonts
tk2unicode_bind <- function(widget) {
  if (!inherits(widget, c("tk2text", "tk2entry")))
    stop("You can bind the unicode composer to tk2text() or tk2entry() widgets only")
  # Make sure evertything is loaded and configured correctly
  .tk2unicode_load()
  # Create the binding
  if (inherits(widget, "tk2text")) {
    tkbindtags(widget, paste0(widget$ID , " KHIM Text ",
      widget$env$parent$ID, " all"))
  } else {# This must be a tk2entry widget
    tkbindtags(widget, paste0(widget$ID , " KHIM Entry ",
      widget$env$parent$ID, " all"))
  }
}
