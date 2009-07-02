\name{tclTask}
\alias{tclTaskSchedule}
\alias{tclTaskRun}
\alias{tclTaskGet}
\alias{tclTaskChange}
\alias{tclTaskDelete}
\alias{tclAfter}
\alias{tclAfterCancel}
\alias{tclAfterInfo}

\title{ Schedule and manage delayed tasks }
\description{
  Tcl allows fo scheduling execution of code on the next event loop or after a
  given time (\code{after} Tcl command). \code{tclTaskXxx()} functions use it to
  schedule execution of R code with much control from within R (central
  management of scheduled tasks, possibility to define redoable tasks, use of S3
  objects to keep track of tasks information. The \code{tclAfterXxx()} functions
  are low-level access to the Tcl \code{after} command.
}

\usage{
# Convenient tclTask objects management
tclTaskSchedule(wait, expr, id = "task#", redo = FALSE)
tclTaskRun(id)
tclTaskGet(id = NULL, all = FALSE)
tclTaskChange(id, expr, wait, redo)
tclTaskDelete(id)

# Low-level Tcl functions
tclAfter(wait, fun)
tclAfterCancel(task)
tclAfterInfo(task = NULL)
}

\arguments{
  \item{wait}{ Time in ms to delay the task (take care: approximative value,
    depends on when event loops are triggered). Using a value lower or equal
	to zero, the task is scheduled on the next event loop. }
  \item{fun}{ Name of the R function to run (you may not supply arguments to
    this function, otherwise it is not scheduled properly; take care of
    scoping, since a copy of the function will be run from within Tcl). }
  \item{expr}{ An expression to run after 'wait'. }
  \item{id}{ The R identifier of the task to schedule, if this id contains
    \code{#}, then, it is replaced by next available number, but you cannot
	schedule more than a thousand tasks with the same name (the system will
	give up well before, anyway). If \code{NULL} in \code{tclTaskGet()},
	retrieve the list of all existing tasks. }
  \item{all}{ If \code{id = NULL}, \code{all = TRUE} indicate to list all tasks,
    including hidden ones (with id starting with a dot). }
  \item{redo}{ Should the task be rescheduled n times, indefinitely
    (\code{redo = TRUE}) or not (\code{redo = FALSE}, default, or a value <=
	0). }
  \item{task}{ A Tcl task timer, or its name in Tcl (in the form of 'after#xxx'). }
}

\value{
  The \code{tclAfterXxx()} functions return a 'tclObj' with the result of the
  corresponding Tcl function. \code{tclAfter()} returns the created Tcl timer in
  this object. If 'task' does not ecxists, \code{tclAfterInfo()} returns
  \code{NULL}.

  \code{tclTaskGet()} returns a 'tclTask' object, a list of such objects, or
  \code{NULL} if not found.

  The four remaining \code{tclTaskXxx()} functions return invisibly \code{TRUE}
  if the process is done successfully, \code{FALSE} otherwise.
  \code{tclTaskRun()} forces running a task now, even if it is scheduled later.
}

\author{ Philippe Grosjean }

\seealso{ \code{\link{tclFun}}, \code{\link[base]{addTaskCallback}},
 \code{\link[base]{Sys.sleep}} }	% Add update later!

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

# Run just once, after 1 sec
test <- function () cat("==== Hello from Tcl! ====\n")
tclTaskSchedule(1000, test())
Sys.sleep(2)

# Run ten times a task with a specified id
test2 <- function () cat("==== Hello again from Tcl! ====\n")
tclTaskSchedule(1000, test2(), id = "test2", redo = 10)
Sys.sleep(1)

# Run a function with arguments (will be evaluated in global environment)
test3 <- function (txt) cat(txt, "\n")
msg <- "==== First message ===="
tclTaskSchedule(1000, test3(msg), id = "test3", redo = TRUE)
Sys.sleep(2)
msg <- "==== Second message ===="
Sys.sleep(2)

# Get info on pending tasks
tclTaskGet() # List all (non hidden) tasks
tclTaskGet("test2")
# List all active Tcl timers
tclAfterInfo()

# Change a task (run 'test3' only once more, after 60 sec)
tclTaskChange("test3", wait = 60000, redo = 1)
Sys.sleep(1)
# ... but don't wait so long and force running 'test3' right now
tclTaskRun("test3")

Sys.sleep(3)
# finally, delete all pending tasks
tclTaskDelete(NULL)
}
}
\keyword{ utilities }
