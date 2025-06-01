#' Use DDE (Dynamic Data Exchange) under Windows
#'
#' DDE is the first Microsoft's attempt to make an inter-application mechanism.
#' It is now superseeded by (D)Com, but it is still available (although declared
#' as unsupported). Being simpler than Com, DDE is interesting for simple tasks.
#' Applications like Word or Excel provide services one can access through DDE
#' (see examples). This code if left for backward compatibility, and also, just
#' in case you will find some use of it. But for new projects in general, you
#' should not use this any more.
#'
#' @param topic The 'topic' to reach or expose. A DDE server is accessed as
#' service'|'topic'. In the case of [tk2dde()], a non null topic activates
#' the DDE server, and a null topic deactivate it.
#' @param service The name of the service to reach. In `tk2dde.services`, if
#' both service and topic are empty, the list of all available DDE service is
#' returned, otherwise, only available topics for a given service are listed.
#' @param command A string with the command to run in the external application
#' (syntax depends on the server).
#' @param async Is a command run asynchroneously (returns immediately, before
#' the command is processed), or not?
#' @param item The concerned item (usually a variable name, a range in a
#' worksheet, etc...).
#' @param data The new value for the item.
#' @param binary Should the return be treated as binary data or not?
#'
#' @note
#' This is only available under Windows. Trying to use these functions under
#' other platforms raises an error. Under Windows, R is automatically configured
#' as a DDE server with name 'TclEval|SciViewsR' when this package is loaded.
#'
#' @export
#' @rdname tk2dde
#' @author Philippe Grosjean
#' @seealso [tk2reg.get()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' # Examples of DDE - Windows only
#'
#' ### Examples using wish ###
#' # Start a Wish84 console side-by-side with R.
#' # (to get wish, you need to install ActiveTcl from
#' # http://www.activestate.com/Products/ActiveTcl/)
#' # Once it is done, start 'Wish84' from the start menu)
#' # Register the Wish console as a DDE server, that is, type in it
#' # (% is the Tcl prompt, do not type it!):
#' # % package require dde
#' # % dde servername wish
#'
#' ### In R:
#' tk2dde("R") # Return 0 if succeed
#' tk2dde.services()
#' # Evaluate some string in wish
#' tk2dde.exec("TclEval", "wish", "{puts {Hello World!}}")
#' # Give a value to a variable in wish
#' tk2dde.poke("TclEval", "wish", "myvar", "{This is a string!}")
#' # Note that you must surround strings with curly braces in Tcl!
#' tk2dde.poke("TclEval", "wish", "mynumvar", c(34.56, 78.9))
#'
#' # In wish, check that vars exist and have correct value
#' # % puts $myvar
#' # % puts $mynumvar
#'
#' # Get the value of one variable from wish into R
#' tk2dde.request("TclEval", "wish", "myvar")
#' tk2dde.request("TclEval", "wish", "mynumvar")
#' # Note that you do not know here if it is a string, a number, or so...
#' # You have to know and convert yourself!
#'
#' # Now, the other way: execute a R function from wish
#' # You first need to register a R function for callback
#' # (For the moment, only functions without arguments are supported!)
#' doDDE <- function() cat("DDE execute!")	# A simple function
#' tclFun(doDDE)
#' # And in wish
#' # % dde execute TclEval R doDDE
#'
#' # Once you have defined a variable using tclVar, you can get or change it
#' # from the dde server. However, tclVar gives cryptic names like ::RTcl1.
#' # So we prefer to use tclVarName()
#' myvar2 <- tclVarName("myvar2", "this is a test...")
#' tclvalue(myvar2) # This is the way we access to this variable in R
#'
#' # In wish you get the value and change it:
#' # % dde request TclEval R myvar2
#' # Again, dde poke does not work and must be replaced by an execute command
#' # This does not work (???)
#' # % dde poke TclEval R myvar2 {yes! and it works...}
#' # ... but this is fine
#' # % dde execute TclEval R {set myvar2 {yes! and it works...}}
#'
#' # And in R...
#' tclvalue(myvar2)
#'
#' ### DDE at the command line with execdde.exe ###
#' # You can also change the value of a variable, or run a command in R from
#' # the command line using execdde.exe:
#' # - Download execdde.exe from http://www.sciviews.org/SciViews-R/execdde.zip
#' # - Unzip it and copy 'execdde.exe' somewhere in your path,
#' # - Start a DOS window
#' # - Enter the following commands ('>' is the prompt, do not type it):
#' # > execdde -s TclEval -t R -c doDDE > NUL
#' # > if errorlevel 1 echo An error occurs... branch accordingly in your batch!
#' # > execdde -s TclEval -t R -c "set myvar2 'ok from execdde'" > NUL
#'
#' # And in R:
#' tclvalue(myvar2)
#' # Note: thanks to separate event loops, it works also when R calculates...
#'
#' ### Manipulating Microsoft Excel ###
#' # Start Excel with a blank workbook, then...
#'
#' # Change values in Excel from R:
#' tk2dde.poke("Excel", "Sheet1", "R1C1:R2C1", c("5.7", "6.34"))   # Some data
#' tk2dde.poke("Excel", "Sheet1", "R3C1", "= A1 + A2")             # A formula
#'
#' # Read values in Excel (note that results of formulas are returned)
#' Res <- tk2dde.request("Excel", "Sheet1", "R1C1:R3C1")
#' Res
#' as.numeric(Res)
#'
#' }
tk2dde <- function(topic = NULL) {
  # Initialize a tcltk dde server with name 'TclEval|topic'
  .tk2dde.require()

  # If topic is NULL, just get my server name
  if (is.null(topic))
    return(tclvalue(.Tcl("dde servername {}")))

  # Otherwise topic must be character
  topic <- topic[1]
  if (!is.character(topic) || topic == "")
    stop("'topic' must be a non null character string!")

  # Verify if I am not already registered under this topic
  if (tclvalue(.Tcl("dde servername {}")) == topic)
    return(0)  # OK

  # Check that this server name does not exist yet
  if (length(grep(paste("[{]TclEval ", topic, "[}]", sep = ""),
    as.character(.Tcl("dde services TclEval {}")))) > 0)
    return(1)  # This server name already exists => return 1 and don't set!

  # Register me as a dde server with this topic name
  .Tcl(paste("dde servername", topic))
  # Check that the server is set correctly
  # (if not, return 2 to warn that a problem occurred)
  if (tclvalue(.Tcl("dde servername {}")) == topic) {
    return(0)
  } else {
    return(2)
  }
}

#' @export
#' @rdname tk2dde
tk2dde.exec <- function(service, topic, command, async = FALSE) {
  # Execute a command in the 'service|topic' dde server
  .tk2dde.require()

  if (!is.character(service) || !is.character(topic) || !is.character(command))
    stop("'service', 'topic' and 'command' must be character strings!")
  if (async[1] == TRUE) async <- "-async" else async <- ""

  # Execute the command in a try(), to nicely catch the error
  # class is "try-error" if an error occurs, otherwise, returns ""
  res <- (try(tclvalue(.Tcl(paste("dde execute ", async, " ",
    as.character(service[1]), " ", as.character(topic[1]), " ",
    as.character(command[1]), sep = "")))))
  res
}

#' @export
#' @rdname tk2dde
tk2dde.poke <- function(service, topic, item, data) {
  # Set a value (data) to 'item' in the 'service|topic' dde server's app
  .tk2dde.require()

  if (!is.character(service) || !is.character(topic))
    stop("'service' and 'topic' must be character strings!")
  if (!is.character(item))
    stop("'item' must be character strings!")
  # In Tcl, if 'data' is a character string, enclose it in curly braces
  data <- paste("{", paste(as.character(data), collapse = "\n"), "}", sep = "")

  # For some reasons, dde poke does not seem to work with a TclEval serve...
  # use dde execute instead
  if (service == "TclEval") {
    Cmd <- paste("{set ", as.character(item[1]), " ", data, "}", sep = "")
    # This would not work with all kind of data!!!
    # Also, if it is a vector, matrix, or array, it does not work properly!
    return(tk2dde.exec(service, topic, Cmd, async = TRUE))
  }

  # Poke the data within a try(), to nicely catch the error
  # class is "try-error" if an error occurs, otherwise, returns ""
  res <- (try(as.character(.Tcl(paste("dde poke", as.character(service[1]),
    as.character(topic[1]), as.character(item[1]), data)))))
  res
}

#' @export
#' @rdname tk2dde
tk2dde.request <- function(service, topic, item, binary = FALSE) {
  # Get the value for 'item' in 'service|topic' dde server
  .tk2dde.require()

  if (!is.character(service) || !is.character(topic))
    stop("'service' and 'topic' must be character strings!")
  if (!is.character(item))
    stop("'item' must be character strings!")
  if (binary[1] == TRUE) binary <- "-binary" else binary <- ""

  # Request the value in a try(), to nicely catch the error
  # class is "try-error" if an error occurs, otherwise, returns ""
  res <- (try(as.character(.Tcl(paste("dde request ", binary, " ",
    as.character(service[1]), " ", as.character(topic[1]), " ",
    as.character(item[1]), sep = "")))))
  res
}

#' @export
#' @rdname tk2dde
tk2dde.services <- function(service = "", topic = "") {
  # List the 'service|topic' dde currently available
  .tk2dde.require()

  # Check arguments
  if (!is.character(service) || !is.character(topic))
    stop("'service' and 'topic' must be character strings!")
  service <- as.character(service[1])
  if (service == "")
    service <- "{}"  # This is an empty string in Tcl
  topic <- as.character(topic[1])
  if (topic == "")
    topic <- "{}"    # This is an empty string in Tcl

  # Get the list of all 'service|topic' dde servers currently running
  as.character(.Tcl(paste("dde services", service, topic)))
}

.tk2dde.require <- function() {
  if (.Platform$OS.type != "windows")
    stop("This is a Windows-specific function!")
  # Make sure tcl/tk dde is operational
  if (!capabilities("tcltk"))
    stop("This version of R cannot use Tcl/Tk!")
  res <- tclRequire("dde", warn = TRUE)
  if (inherits(res, "tclObj"))
    res <- tclvalue(res)
  if (res[1] == FALSE)
    stop("Unable to find the 'dde' Tcl/tk package!")
  res  # The package version number
}
