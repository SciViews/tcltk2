\name{tk2fonts}
\alias{tk2fonts}
\alias{tk2font.get}
\alias{tk2font.set}
\alias{tk2font.setstyle}

\title{ Edit a matrix or data frame in spreadsheet-like editor }
\description{
  A tkTable widget is used to display and edit a matrix or data frame. One
  can edit entries, add or delete rows and columns, ....
}
\usage{
tk2font.get(font, what = c("family", "size", "bold", "italic"))
tk2font.set(font, settings)
tk2font.setstyle(text = TRUE, system = FALSE, default.styles = FALSE)
}

\arguments{
  \item{font}{ The name of one or several cached Tk font }
  \item{what}{ A list of font characteristics to get: 'family', 'size', 'bold',
    'italic', 'underline' and/or 'overstrike'. By default, everything except
	'underline' and 'overstrike' }
  \item{settings}{ Settings of fonts. There are two forms possibles: (1) a vector
    of character strings of same length as font with Tk fonts description like
	'-family Times -size 12 -weight bold', for instance, or (2) a list of
	font characteristics (list with components 'family', 'size', 'bold', 'italic',
	'underline' and 'overstrike') }
  \item{text}{ Do we synchronise text Tk fonts (text, titles, and fixed-font text)
    with current settings, as in '.Fonts' in TempEnv? }
  \item{system}{ Do we synchronise system Tk fonts (widgets, window caption,
    menus, tooltips, ...) with current system configuration? This is highly
    platform dependent. Currently, system settings are gathered only under Windows,
    thanks to the winSystemFonts() function }
  \item{default.styles}{ Do we add .fontsStyleXXX in TempEnv, where XXX is one
    of the four default styles: 'Classic', 'Alternate', 'Presentation' or 'Fancy' }
}

\value{
  \code{tk2font.get()} retrieves a list with font characteristics (same format
  as the \code{settings} argument) for the first Tk font found in its \code{font}
  argument, or \code{""} if the font is not found. \code{tk2font.set()} changes
  current font settings or, possibly, create the Tk font.
  \code{tk2font.setstyle()} changes the current Tk fonts settings according to
  actual system and/or text configuration fonts.
}

\author{ Philippe Grosjean <phgrosjean@sciviews.org> }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded
# Refresh both text and system Tk fonts
tk2font.setstyle(system = TRUE)
# Get characteristics of the default font
tk2font.get("TkDefaultFont")
  }
}

\keyword{ utilities }
