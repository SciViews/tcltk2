\name{tk2edit}
\alias{tk2edit}

\title{ Edit a matrix or data frame in spreadsheet-like editor }
\description{
  A tkTable widget is used to display and edit a matrix or data frame. One
  can edit entries, add or delete rows and columns, ....
}
\usage{
  tk2edit(x, title = "Matrix Editor", header = NULL,
	  maxHeight = 600, maxWidth = 800, fontsize = 9, ...) 
}

\arguments{
  \item{x}{ A matrix or data frame to edit }
  \item{title}{ The title of the editor window }
  \item{header}{ Do we display a header? }
  \item{maxHeight}{ The maximum height of the editor window }
  \item{maxWidth}{ The maximum width of the editor window }
  \item{fontsize}{ The size of the font to use in the editor window }
  \item{\dots}{ Further arguments to pass to the function }
}

\value{
  The function is used for its side-effet, that is, to modify a matrix or data
  frame in a spreadsheet-like editor.
}

\author{ Jeffrey J. Hallman }
\note{ You need the tkTable widget to use this function }

\seealso{ \code{\link{tclSetValue}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded
data(iris)
tk2edit(iris)	
  }
}

\keyword{ utilities }
