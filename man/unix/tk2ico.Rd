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
  These function are only useful for Windows, but they can be used without error
  on other platform for making platform-independent code that has an additional
  behaviour under Windows. On the other platforms, these function just return
  NULL silently.
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
  \item{file}{ a file having icon resources (.exe, or .dll). }
  \item{res}{ the name of the resource from where the icon should be extracted. }  
  \item{iconfile}{ a file with a .ico extension, containing one or more Windows
    icons. }
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
	position in the icon resource for \code{tk2ico.pos()} }
  \item{text}{ change a text for an icon. }
  \item{leftmenu}{ a \"tkwin\" object to display when the user left-clicks on
    the taskbar icon (usually, a Tk popup menu), or \code{NULL} for nothing. }
  \item{rightmenu}{ idem as \'lefmenu\' but for a right-click on the taskbar
    icon. }
}

\value{
  These function do nothing and return \code{NULL} on other platforms than
  Windows.
}

\author{ Philippe Grosjean }

\keyword{ utilities }

\concept{ icons, windows and taskbar }
