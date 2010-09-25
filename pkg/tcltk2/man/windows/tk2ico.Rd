\name{tk2ico}
\alias{tk2ico}
\alias{tk2ico.create}
\alias{tk2ico.destroy}
\alias{tk2ico.hicon}
\alias{tk2ico.info}
\alias{tk2ico.load}
\alias{tk2ico.pos<-}
\alias{tk2ico.set}
\alias{tk2ico.taskbar.add}
\alias{tk2ico.taskbar.delete}
\alias{tk2ico.taskbar.modify}
\alias{tk2ico.text}
\alias{tk2ico.text<-}

\title{ Manipulate icons under Windows }
\description{
  Create, load and work with Windows icons. Change icons fo Windows, use icons in
  the taskbar under Windows 9X/2000/XP, ... These function are only useful for
  Windows, but they silently return \code{NULL} on other platforms for writing
  compatible code (Windows icons instructions can be simply ignored).
}

\usage{
tk2ico.load(file = "shell32.dll", res = "application")
tk2ico.create(iconfile)
tk2ico.destroy(icon)
tk2ico.hicon(icon)
tk2ico.info(icon, convert = TRUE)
tk2ico.set(win, icon, pos = NULL, type = c("all", "small", "big"))
tk2ico.text(icon)
tk2ico.text(icon) <- value
tk2ico.pos(icon) <- value
tk2ico.taskbar.add(icon, pos = 0, text = tk2ico.text(icon),
    leftmenu = NULL, rightmenu = NULL)
tk2ico.taskbar.delete(icon)
tk2ico.taskbar.modify(icon, pos = NULL, text = NULL)
}

\arguments{
  \item{file}{ a file having icon resources (.exe, or .dll) }
  \item{res}{ the name of the resource from where the icon should be extracted }  
  \item{iconfile}{ a file with a .ico extension, containing one or more Windows
    icons }
  \item{icon}{ an icon object. }
  \item{convert}{ do we convert the result into a data.frame? }
  \item{win}{ a tk window, or an integer representing the handle (HWND) of a
    foreign window whose icon will be changed (take care, the function returns
	\code{TRUE} even if the handle is wrong! }
  \item{pos}{ a position (starting from 0) pointing to an icon in a multi-icon
    object. Note that \code{pos} is not used in \code{tk2ico.set()} if
	\code{type = "all"} (in this case, best icons matching both \"small\" and
	\"large\" sizes are searched in the \code{icon} resource. }
  \item{type}{ do we change only the small, the large, or both icons? }
  \item{value}{ a string with the new text for the icon in
    \code{tk2ico.text()} or a numerical value indicating the new default
	position in the icon resource for \code{tk2ico.pos()}. }
  \item{text}{ change a text for an icon. }
  \item{leftmenu}{ a \"tkwin\" object to display when the user left-clicks on
    the taskbar icon (usually, a Tk popup menu), or \code{NULL} for nothing. }
  \item{rightmenu}{ idem as \'lefmenu\' but for a right-click on the taskbar
    icon. }
}

\value{
  An icon object, which is a reference to an image resource in Tcl. Its classes
  are \code{c("tclObj", "tclIcon")}. Do not forget to destroy it using
  \code{tk2ico.destroy()} when you do not need it any more!
  
  If \code{tk2ico.load()}, \code{tk2ico.info()} fail, they return \code{NULL}
  instead on a Tcl object.
}

\author{ Philippe Grosjean }

\note{ This is Windows-specific. It uses the winico Tcl library. Under other
  platforms these functions just return \code{NULL} without error or warning. So,
  code that must run on different platforms could use these functions all the
  time, as soon as they correctly deal with possible \code{NULL} return. }

\seealso{ \code{\link{tk2dde}}, \code{\link{tk2reg}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

### Examples of tk2ico - icon manipulation under Windows
tt2 <- tktoplevel()
## Load a system icon (there are: "application", "asterisk", "error",
## "exclamation", "hand", "question", "information", "warning", and "winlogo".
Warn <- tk2ico.load(res = "warning")
tk2ico.info(Warn)
## Change the text
tk2ico.text(Warn)
tk2ico.text(Warn) <- "Warning icon"
tk2ico.text(Warn)
## Get hicon
tk2ico.hicon(Warn)
## Change the icon of my window tt2
tk2ico.set(tt2, Warn)
## Do not forget to destroy icon to free resource when not needed any more
tk2ico.destroy(Warn)
rm(Warn)
## Load an icon from the resource section of an exe, or dll
Rico <- tk2ico.load(file.path(Sys.getenv("R_HOME"), "bin", "R.exe"), res = "R")
tk2ico.info(Rico)
tk2ico.set(tt2, Rico)
tk2ico.destroy(Rico)
rm(Rico)

### Load one or several icons from an .ico file
libdir <- file.path(.path.package(package = "tcltk2")[1], "gui")
SVico <- tk2ico.create(file.path(libdir, "SciViews.ico"))
## The various resolution icons created from this file
tk2ico.info(SVico)
## Change the default position to 1 (the second icon)
tk2ico.pos(SVico) <- 1
## Change only the small icon (use Alt-Tab to see the large one)
tk2ico.set(tt2, SVico, type = "small")

## Set a taskbar icon, with both a left and right-click menu
lmenu <- tkmenu(.TkRoot, tearoff = FALSE)
tkadd(lmenu, "command", label = "Say hello",
    command = function() cat("Hello from taskbar!\n"))
rmenu <- tkmenu(.TkRoot, tearoff = FALSE)
tkadd(rmenu, "command", label = "Say hello again",
    command = function() cat("Hello again from taskbar!\n"))
tk2ico.taskbar.add(SVico, pos = 1, text = "my R taskbar icon",
    leftmenu = lmenu, rightmenu = rmenu)
## Try left and right-click on the taskbar icon...
## Change its text...
tk2ico.taskbar.modify(SVico,  pos = 1, text = "text changed!")
##... and delete it
tk2ico.taskbar.delete(SVico)

## Destroy the icons
tk2ico.destroy(SVico)
rm(SVico)

## When done, dispose of the window and clean the workspace
tkdestroy(tt2)
rm(list = c("libdir", "lmenu", "rmenu", "tt2"))
}
}

\keyword{ utilities }

\concept{ icons, windows and taskbar }
