### TODO: implement ::ico::getIconByName, ::ico::getFileIcon & ::ico::writeIcon
### TODO: gif files are acceptable too for tk2ico.set(), example:
### Image <- tclVar()
### tcl("image", "create", "photo", Image, file = "myfile.gif")
### tcl("wm", "iconphoto", tt, Image) instead of tk2ico.set

#' Manipulate icons under Windows
#'
#' Create, load and work with Windows icons. Change icons for Windows. These
#' functions are only useful for Windows, but they silently return `NULL` on
#' other platforms for writing compatible code (Windows icons instructions can
#' be simply ignored).
#'
#' @param iconfile A file with a .ico, or .exe extension, containing one or more
#' Windows icons
#' @param file A file having icon resources (.exe, or .dll).
#' @param res The name of the resource from where the icon should be extracted.
#' @param size Te size of the icon to use. For windows icons, 16 should be fine
#' usually.
#' @param win A Tk window, or an integer representing the handle (HWND) of a
#' foreign window whose icon will be changed (take care, the function returns
#' `TRUE` even if the handle is wrong!
#' @param icon A icon object.
#'
#' @return
#' An icon object, which is a reference to an image resource in Tcl. Its classes
#' are `c("tclObj", "tclIcon")`. Do not forget to destroy it using
#' [tk2ico.destroy()] when you do not need it any more!
#' If [tk2ico.load()] fails, it returns `NULL` instead of a Tcl object.
#'
#' @note
#' This is Windows-specific. It is implemented using the ico Tcl package.
#'
#' @export
#' @rdname tk2ico
#' @author Philippe Grosjean
#' @seealso [tk2dde.exec()], [tk2reg.get()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' ### Examples of tk2ico - icon manipulation under Windows
#' tt2 <- tktoplevel()
#' # Load a system icon (there are: "application", "asterisk", "error",
#' # "exclamation", "hand", "question", "information", "warning", and "winlogo".
#' Warn <- tk2ico.load(res = "warning")
#' # Change the icon of my window tt2
#' tk2ico.set(tt2, Warn)
#' # Do not forget to destroy icon to free resource when not needed any more
#' tk2ico.destroy(Warn)
#' rm(Warn)
#'
#' ### Otherwise, the list of icons in a file are:
#' tk2ico.list()
#' # and for a given icon, the various sizes are:
#' tk2ico.sizes(res = 4)
#'
#' ### One can set icon of a window from an .ico or .exe file directly
#' tk2ico.setFromFile(tt, default = file.path(R.home("bin"), "Rgui.exe"))
#'
#' tk2ico.setFromFile(tt2, system.file("gui", "SciViews.ico", package = "tcltk2"))
#'
#' ### When done, dispose of the window and clean the workspace
#' tkdestroy(tt2)
#' rm(tt2)
#' }
tk2ico.create <- function(iconfile, res = 0, size = 16) {
  if (length(iconfile) != 1)
    stop("'iconfile' must be of length one!")
  if (!file.exists(iconfile <- as.character(iconfile)))
    stop(gettextf("File '%s' not found!", iconfile))

  # Just use tk2ico.load() with different default args)
  tk2ico.load(file = iconfile, res = res, size = size)
}

#' @export
#' @rdname tk2ico
tk2ico.destroy <- function(icon) {
  if (!is.tk())
    return(NULL)
  if (.Platform$OS.type != "windows")
    return(NULL)

  if (!inherits(icon, "tclIcon"))
    stop("'icon' is not a \"tclIcon\" object!")

  res <- tclvalue(.Tcl(paste("catch {image delete ", icon, "}", sep = "")))
  (res == "0")  # Return "0" if OK, "1" otherwise
}

#' @export
#' @rdname tk2ico
tk2ico.list <- function(file = "shell32.dll") {
  # Make sure that the 'ico' package is loaded
  .tk2ico.require()

  if (length(file) != 1)
    stop("'file' must be of length one!")

  # If the file is not found directly, try using Sys.which()
  if (!file.exists(file)) {
    File <- Sys.which(file)
    if (!file.exists(File))
      stop("file '", file, "' not found")
  } else File <- file

  cmd <- paste("::ico::icons {", File, "}", sep = "")
  res <- try(iconlist <- .Tcl(cmd), silent = TRUE)
  if (inherits(res, "try-error")) # Tcl error message is unreadable!
    stop("Unable to list the icon resources in 'file'!")
  as.character(iconlist)
}

#' @export
#' @rdname tk2ico
tk2ico.sizes <- function(file = "shell32.dll", res = "application") {
  # Make sure that the 'ico' package is loaded
  .tk2ico.require()

  if (length(file) != 1)
    stop("'file' must be of length one!")
  if (length(res) != 1)
    stop("'res' must be of length one!")
  # For compatibility reasons, res can be "application", "asterisk", "error",
  # "exclamation", "hand", "question", "information", "warning" or "winlogo"
  # but need to be changed into corresponding ID
  res <- as.character(res)[1]
  res <- switch(res,
    application = "154",
    asterisk = "173",
    error = "28",
    exclamation = "154",
    hand = "29",
    question = "263",
    information = "1001",
    warning = "200",
    winlogo = "47",
    res)

  # If the file is not found directly, try using Sys.which()
  if (!file.exists(file)) {
    File <- Sys.which(file)
    if (!file.exists(File))
      stop("file '", file, "' not found")
  } else File <- file

  cmd <- paste("::ico::iconMembers {", File, "} ", res,  sep = "")
  res <- try(iconsizes <- .Tcl(cmd), silent = TRUE)
  if (inherits(res, "try-error")) # Tcl error message is unreadable!
    stop("Unable to list sizes for the icon resource 'res' in 'file'!")
  iconsizes <- as.character(iconsizes)
  iconsizes <- unique(sub("^[^ ]+ ([0-9]+) .+$", "\\1", iconsizes))
  as.integer(iconsizes)
}

#' @export
#' @rdname tk2ico
tk2ico.load <- function(file = "shell32.dll", res = "application", size = 16) {
  # Make sure that the 'ico' package is loaded
  .tk2ico.require()

  if (length(file) != 1)
    stop("'file' must be of length one!")
  if (length(res) != 1)
    stop("'res' must be of length one!")
  # For compatibility reasons, res can be "application", "asterisk", "error",
  # "exclamation", "hand", "question", "information", "warning" or "winlogo"
  # but need to be changed into corresponding ID
  res <- as.character(res)[1]
  res <- switch(res,
    application = "154",
    asterisk = "173",
    error = "28",
    exclamation = "154",
    hand = "29",
    question = "263",
    information = "1001",
    warning = "200",
    winlogo = "47",
    res)

  # If the file is not found directly, try using Sys.which()
  if (!file.exists(file)) {
    File <- Sys.which(file)
    if (!file.exists(File))
      stop("file '", file, "' not found")
  } else File <- file

  # The old winico code!
  #cmd <- paste("winico load ", res, " {", file, "}", sep = "")
  cmd <- paste("::ico::getIcon {", File, "} ", res, " -res ", size, sep = "")
  res <- try(icon <- .Tcl(cmd), silent = TRUE)
  if (inherits(res, "try-error")) # Tcl error message is unreadable!
    stop("Unable to load the icon resource, 'file' or 'res' is wrong!")

  if (inherits(icon, "tclObj"))
    class(icon) <- c(class(icon), "tclIcon")
  icon
}

#' @export
#' @rdname tk2ico
tk2ico.setFromFile <- function(win, iconfile) {
  # iconfile can be either an .ico file, or an .exe
  # This is the simplest way to set a tk window icon
  tkwm.iconbitmap(win, iconfile)
}

#' @export
#' @rdname tk2ico
tk2ico.set <- function(win, icon) {
  # Integer for win is not supported any more
  if (inherits(win, "integer"))
    stop("Integers for argument win are not supported any more in tcltk > 1.2-0")

  # Make sure that the 'ico' package is loaded
  .tk2ico.require()

  if (!inherits(win, "tkwin") || length(win) < 1)
    stop("'win' is not a \"tkwin\" object")
  if (!inherits(icon, "tclIcon"))
    stop("'icon' is not a \"tclIcon\" object!")

  # Change the icon of a Tk window
  tcl("wm", "iconphoto", win, icon)
}

.tk2ico.require <- function() {
  if (.Platform$OS.type != "windows")
    stop("This is a Windows-specific function!")
  # Make sure tcl/tk dde is operational
  if (!capabilities("tcltk"))
    stop("This version of R cannot use Tcl/Tk!")
  if (!is.tk())
    stop("Tk is required")
  res <- tclRequire("ico", warn = TRUE)
  if (inherits(res, "tclObj"))
    res <- tclvalue(res)
  if (res[1] == FALSE)
    stop("Unable to find the 'ico' Tcl/tk package!")
  res  # The package version number
}
