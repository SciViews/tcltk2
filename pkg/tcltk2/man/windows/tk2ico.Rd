\name{tk2ico}
\alias{tk2ico}
\alias{tk2ico.create}
\alias{tk2ico.destroy}
\alias{tk2ico.hicon}
\alias{tk2ico.info}
\alias{tk2ico.list}
\alias{tk2ico.sizes}
\alias{tk2ico.load}
\alias{tk2ico.pos<-}
\alias{tk2ico.setFromFile}
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
tk2ico.create(iconfile, res = 0, size = 16)
tk2ico.destroy(icon)
tk2ico.list(file = "shell32.dll")
tk2ico.sizes(file = "shell32.dll", res = "application")
tk2ico.load(file = "shell32.dll", res = "application", size = 16)
tk2ico.set(win, icon, pos = NULL, type = c("all", "small", "big"))
tk2ico.setFromFile(win, iconfile)

## Deprecated functions since drop of winico.dll support
tk2ico.hicon(icon)
tk2ico.info(icon, convert = TRUE)
tk2ico.text(icon)
tk2ico.text(icon) <- value
tk2ico.pos(icon) <- value
tk2ico.taskbar.add(icon, pos = 0, text = tk2ico.text(icon),
    leftmenu = NULL, rightmenu = NULL)
tk2ico.taskbar.delete(icon)
tk2ico.taskbar.modify(icon, pos = NULL, text = NULL)
}

\arguments{
  \item{iconfile}{ a file with a .ico, or .exe extension, containing one or
    more Windows icons }
  \item{file}{ a file having icon resources (.exe, or .dll) }
  \item{res}{ the name of the resource from where the icon should be extracted }
  \item{size}{ the size of the icon to use. For windows icons, 16 should be
    fine usually }
  \item{win}{ a Tk window, or an integer representing the handle (HWND) of a
    foreign window whose icon will be changed (take care, the function returns
	\code{TRUE} even if the handle is wrong! }  
  \item{icon}{ an icon object. }

  \item{convert}{ do we convert the result into a data.frame? }
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
  
  If \code{tk2ico.load()} fails, it returns \code{NULL} instead of a Tcl object.
}

\author{ Philippe Grosjean }

\note{ This is Windows-specific. It was implemented using the winico Tcl library
  in tcltk2 <= 1.2-0. Now it switches to the ico Tcl package, which is supported
  on all platforms. Hence, in future versions of this package, it will be also
  available for Linux/Unix and Max OS X. Under other platforms these functions
  currently just return \code{NULL} without error or warning. So, code that must
  run on different platforms could use these functions all the
  time, as soon as they correctly deal with possible \code{NULL} return.
  The functions \code{tk2ico.hicon()}, \code{tk2ico.info()}, \code{tk2ico.text()},
  \code{tk2ico.pos()}, \code{tk2ico.taskbar.add()}, \code{tk2ico.taskbar.delete()}
  and \code{tk2ico.taskbar.modify()} are deprecated (and by the way, they issue
  an error, because the corresponding Tcl code is not available in the 'ico' Tcl
  package) and will be removed in futures versions of the tcltk2 package. }

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
## Change the icon of my window tt2
tk2ico.set(tt2, Warn)
## Do not forget to destroy icon to free resource when not needed any more
tk2ico.destroy(Warn)
rm(Warn)

### Otherwise, the list of icons in a file are:
tk2ico.list()
## and for a given icon, the various sizes are:
tk2ico.sizes(res = 4)

### One can set icon of a window from an .ico or .exe file directly
tk2ico.setFromFile(tt, default = file.path(R.home("bin"), "Rgui.exe"))
 
tk2ico.setFromFile(tt2, system.file("gui", "SciViews.ico", package = "tcltk2"))

### When done, dispose of the window and clean the workspace
tkdestroy(tt2)
rm(tt2)
}
}

\keyword{ utilities }

\concept{ icons, windows }
