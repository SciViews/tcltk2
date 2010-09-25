\name{tk2dde}
\alias{tk2dde}
\alias{tk2dde.exec}
\alias{tk2dde.poke}
\alias{tk2dde.request}
\alias{tk2dde.services}

\title{ Use DDE (Dynamic Data Exchange) under Windows }
\description{
  DDE is the first Microsoft's attempt to make an inter-application mechanism.
  It is now superseeded by (D)Com, but it is still available. Being simpler than
  Com, DDE is interesting for simple tasks. Applications like Word, Excel,
  Windows Explorer, Internet Explorer, etc... provide services one can access
  through DDE (see examples).
}
\usage{
tk2dde(topic = NULL)
tk2dde.services(service = "", topic = "")
tk2dde.exec(service, topic, command, async = FALSE)
tk2dde.poke(service, topic, item, data)
tk2dde.request(service, topic, item, binary = FALSE)
}

\arguments{
  \item{topic}{ the 'topic' to reach or expose. A DDE server is accessed as
    'service'|'topic'. In the case of \code{tk2DDE()}, a non null topic activates
    the DDE server, and a null topic deactivate it. }
  \item{service}{ the name of the service to reach. In \code{tk2DDEservices}, if
    both service and topic are empty, the list of all available DDE service is
    returned, otherwise, only available topics for a given service are listed. }
  \item{command}{ a string with the command to run in the external application
    (syntax depends on the server). }
  \item{async}{ is a command run asynchroneously (returns immediately, before
    the command is processed), or not? }
  \item{item}{ the concerned item (usually a variable name, a range in a
    worksheet, etc...). }
  \item{data}{ the new value for the item. }
  \item{binary}{ should the return bez treated as binary data or not? }
}

\author{ Philippe Grosjean }

\note{ This is only available under Windows. Trying to use these functions under
  other platforms raises an error. Under Windows, R is automatically configured
  as a DDE server with name TclEval|SciViewsR when this package is loaded }

\seealso{ \code{\link{tk2reg}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

## Examples of DDE - Windows only

### Examples using wish ###
## Start a Wish84 console side-by-side with R.
## (to get wish, you need to install ActiveTcl from
## http://www.activestate.com/Products/ActiveTcl/)
## Once it is done, start 'Wish84' from the start menu)
## Register the Wish console as a DDE server, that is, type in it
## (\% is the Tcl prompt, don't type it!):
## \% package require dde
## \% dde servername wish

### In R:
tk2dde("R") # Return 0 if succeed
tk2dde.services()
## Evaluate some string in wish
tk2dde.exec("TclEval", "wish", "{puts {Hello World!}}")
## Give a value to a variable in wish
tk2dde.poke("TclEval", "wish", "myvar", "{This is a string!}")
## Note that you must surround strings with curly braces in Tcl!
tk2dde.poke("TclEval", "wish", "mynumvar", c(34.56, 78.9))

## In wish, check that vars exist and have correct value
## \% puts $myvar
## \% puts $mynumvar

## Get the value of one variable from wish into R
tk2dde.request("TclEval", "wish", "myvar")
tk2dde.request("TclEval", "wish", "mynumvar")
## Note that you don't know here if it is a string, a number, or so...
## You have to know and convert yourself!

## Now, the other way: execute a R function from wish
## You first need to register a R function for callback
## (For the moment, only functions without arguments are supported!)
doDDE <- function() cat("DDE execute!\n")	# A simple function
tclFun(doDDE)
## And in wish
## \% dde execute TclEval R doDDE

## Once you have defined a variable using tclVar, you can get or change it
## from the dde server. However, tclVar gives cryptic names like ::RTcl1.
## So we prefer to use tclVarName
myvar2 <- tclVarName("myvar2", "this is a test...")
tclvalue(myvar2) # This is the way we access to this variable in R

## In wish you get the value and change it:
## \% dde request TclEval R myvar2
## Again, dde poke does not work and must be replaced by an execute command
## This doesn't work (???)
## \% dde poke TclEval R myvar2 {yes! and it works...}
## ... but this is fine
## \% dde execute TclEval R {set myvar2 {yes! and it works...}}

## And in R...
tclvalue(myvar2)


### DDE at the command line with execdde.exe ###
## You can also change the value of a variable, or run a command in R from
## the command line using execdde.exe:
## - Download execdde.exe from http://www.sciviews.org/SciViews-R/execdde.zip
## - Unzip it and copy 'execdde.exe' somewhere in your path,
## - Start a DOS window
## - Enter the following commands ('>' is the prompt, don't type it):
## > execdde -s TclEval -t R -c doDDE > NUL
## > if errorlevel 1 echo An error occurs... branch accordingly in your batch!
## > execdde -s TclEval -t R -c "set myvar2 {ok from execdde!}" > NUL

## And in R:
tclvalue(myvar2)
## Note: thanks to separate event loops, it works also when R calculates...


### Other examples of DDE use:

### Manipulating Microsoft Excel ###
## Start Excel with a blank workbook, then...

## Change values in Excel from R:
tk2dde.poke("Excel", "Sheet1", "R1C1:R2C1", c("5.7", "6.34"))   # Some data
tk2dde.poke("Excel", "Sheet1", "R3C1", "= A1 + A2")        		# A formula

## Read values in Excel (note that results of formulas are returned)
Res <- tk2dde.request("Excel", "Sheet1", "R1C1:R3C1")
Res
as.numeric(Res)

## Execute a command in Excel
tk2dde.exec("Excel", "Sheet1", "{\[\Select(\"R1C1:R3C1\")]\[New(2,2)\]}")
## New(2,2) create a bar graph in a separate sheet
## Note: close this graph now, in order to run the rest properly!

## R as server and Excel as client
## Prepare R as server
tk2dde("R") # Now, my server name is TclEval|R !
## Create a variable that will be shared with Excel
XlVar <- tclVarName("XlVar", "this is a test!")
## Enter a formula somewhere in Excel to link to this variable
tk2dde.poke("Excel", "Sheet1", "R5C1", "=TclEval|R!'::XlVar'")

## Now, change the content in XlVar
tclvalue(XlVar) <- "Another text..."
## Rem: in my Excel, the content of the cell is not changed automatically...
## I must reenter the formula for the changes to be considered!?


### Manipulating Microsoft Word ###
## Start Word and then...
tk2dde.exec("Winword", "System", "{\[EndOfDocument\]}")
tk2dde.exec("Winword", "System", "{\[Insert \"Text from R.\"\]}", async = TRUE)

## Can also use:
##  AppMaximize 1
##  StatOfDocument
##  EditFind .Find="hello" .PatternMatch=1
##  FileExit 2
##  FileClose 2 # 2 = close without saving, 1 = save first, 0 = prompt

## If you want to start the program if not running, you must take care that
## you leave enough time to the program to initialize before you can use DDE
## commands with it! Here is an example (make sure that Word is not running):
is.WordStarted <- function()
    (length(tk2dde.services("Winword", "System")) > 0)
if (!is.WordStarted()) {
    ## Get the path to WinWord.exe
    Word <- try(tk2reg.get(paste("HKEY_LOCAL_MACHINE", "SOFTWARE", "Classes",
        "WordDocument", "protocol", "StdFileEditing", "server", sep = "\\"), ""))
    if (is.na(Word)) {
	cat("Microsoft Word is not found!\n")
    } else {  # Start Microsoft Word and wait for its complete loading
        ## Start Word
        system(Word, wait = FALSE)
        ## Wait a maximum of 15 sec...
        for (i in 1:15) {
            Sys.sleep(1)  # Wait 1 sec
            res <- is.WordStarted()
	    if (res) break
	}
	if (res) cat("Now Word is started and ready to get DDE commands!\n")
	tk2dde.exec("Winword", "System", "{\[Insert \"My text from R.\"\]}",
	    async = TRUE)
    }
}


### Control Matlab ###
## Start Matlab and then...
tk2dde.exec("Matlab", "Engine", "s = ones(5);")
## Then in Matlab, type s


### Manipulating Progman to create and delete shortcuts ###
tk2dde.exec("progman", "progman", "{\[CreateGroup(Bogus)\]}")
tk2dde.exec("progman", "progman", "{\[AddItem(notepad.exe,BogusPadLink)\]}")
tk2dde.exec("progman", "progman", "{\[ShowGroup(Bogus,0)\]}")
tk2dde.exec("progman", "progman", "{\[ShowGroup(Bogus,1)\]}")
## And delete it...
tk2dde.exec("progman", "progman", "{\[DeleteItem(BogusPadLink)\]}")
tk2dde.exec("progman", "progman", "{\[DeleteGroup(Bogus)\]}")
## Rem: the same can be done with tcom, if installed:
##.Tcl("package require tcom")
##.Tcl("set sh [::tcom::ref createobject {WScript.Shell}]")
##.Tcl("set lnk [$sh CreateShortcut {c:\\\\temp\\\\boguspad.lnk}]")
##.Tcl("$lnk TargetPath {\"notepad.exe\"}")
##.Tcl("$lnk WorkingDirectory {c:\\\\temp}")
##.Tcl("$lnk Arguments Tutorial.txt")
##.Tcl("$lnk Save")


### Controlling Internet Explorer ###
## Start Internet Explorer, then...
tk2dde.exec("iexplore", "WWW_OpenURL", "{http://www.r-project.org/}")
## It works, but return an error in R???
## This is similar to the browseURL() in package util (just for the demo!)
HelpIndex <- file.path(R.home(), "doc", "html", "index.html")
tk2dde.exec("iexplore", "WWW_ShowFile", paste("{", HelpIndex, "}", sep = ""))
## Info on the current opened window
tk2dde.request("iexplore", "WWW_GetWindowInfo", "1")


### Controlling Windows explorer ###
tk2dde.exec("Folders", "AppProperties",
    "{\[ViewFolder(\"C:\\\",\"C:\\\",5)\]}")
## ... or you can also try 'ExplodeFolder'
## Search in folder
tk2dde.exec("Folders", "AppProperties", "{\[FindFolder(\"\",\"C:\\\")\]}")
}
}

\keyword{ utilities }
\keyword{ IO }

\concept{ Interprocess communication, DDE }
