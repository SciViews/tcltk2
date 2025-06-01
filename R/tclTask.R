#' Schedule and manage delayed tasks
#'
#' Tcl allows fo scheduling execution of code on the next event loop or after a
#' given time (`after` Tcl command). `tclTaskXxx()` functions use it to schedule
#' execution of R code with much control from within R (central management of
#' scheduled tasks, possibility to define redoable tasks, use of S3 objects to
#' keep track of tasks information. The `tclAfterXxx()` functions are low-level
#' access to the Tcl `after` command.
#'
#' @param wait Time in ms to delay the task (take care: approximate value,
#' depends on when event loops are triggered). Using a value lower or equal to
#' zero, the task is scheduled on the next event loop.
#' @param fun Name of the R function to run (you may not supply arguments to
#' this function, otherwise it is not scheduled properly; take care of scoping,
#' since a copy of the function will be run from within Tcl).
#' @param expr An expression to run after 'wait'.
#' @param id The R identifier of the task to schedule, if this id contains `#`,
#' then, it is replaced by next available number, but you cannot schedule more
#' than a thousand tasks with the same name (the system will give up well
#' before, anyway). If `NULL` in [tclTaskGet()], retrieve the list of all
#' existing tasks.
#' @param all If `id = NULL`, `all = TRUE` indicate to list all tasks, including
#' hidden ones (with id starting with a dot).
#' @param redo Should the task be rescheduled n times, indefinitely
#' (`redo = TRUE`) or not (`redo = FALSE`, default, or a value <= 0).
#' @param task A Tcl task timer, or its name in Tcl (in the form of
#' 'after#xxx').
#' @param x A 'tclTask' object.
#' @param ... Further argument to the `print()` method.
#'
#' @return
#' The `tclAfterXxx()` functions return a 'tclObj' with the result of the
#' corresponding Tcl function. [tclAfter()] returns the created Tcl timer in
#' this object. If 'task' does not exists, [tclAfterInfo()] returns `NULL`.
#'
#' [tclTaskGet()] returns a 'tclTask' object, a list of such objects, or `NULL`
#' if not found.
#'
#' The four remaining `tclTaskXxx()` functions return invisibly `TRUE` if the
#' process is done successfully, `FALSE` otherwise.
#' [tclTaskRun()] forces running a task now, even if it is scheduled later.
#'
#' @export
#' @rdname tclTask
#' @author Philippe Grosjean
#' @seealso [tclFun()], [base::addTaskCallback()], [base::Sys.sleep()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' # Run just once, after 1 sec
#' test <- function () cat("==== Hello from Tcl! ====\n")
#' tclTaskSchedule(1000, test())
#' Sys.sleep(2)
#'
#' # Run ten times a task with a specified id
#' test2 <- function () cat("==== Hello again from Tcl! ====\n")
#' tclTaskSchedule(1000, test2(), id = "test2", redo = 10)
#' Sys.sleep(1)
#'
#' # Run a function with arguments (will be evaluated in global environment)
#' test3 <- function (txt) cat(txt, "\n")
#' msg <- "==== First message ===="
#' tclTaskSchedule(1000, test3(msg), id = "test3", redo = TRUE)
#' Sys.sleep(2)
#' msg <- "==== Second message ===="
#' Sys.sleep(2)
#'
#' # Get info on pending tasks
#' tclTaskGet() # List all (non hidden) tasks
#' tclTaskGet("test2")
#' # List all active Tcl timers
#' tclAfterInfo()
#'
#' # Change a task (run 'test3' only once more, after 60 sec)
#' tclTaskChange("test3", wait = 60000, redo = 1)
#' Sys.sleep(1)
#' # ... but don't wait so long and force running 'test3' right now
#' tclTaskRun("test3")
#'
#' Sys.sleep(3)
#' # finally, delete all pending tasks
#' tclTaskDelete(NULL)
#' }
tclAfter <- function(wait, fun) {
  # This is the basic Tcl command, do prefer tclTaskSchedule()!
  wait <- as.integer(wait)[1]
  if (wait <= 0) wait <- "idle"  # Schedule task on next event loop
  # Check fun
  if (!is.function(fun))
    stop("'fun' must be a function")
  # Install a new Tcl timer
  tcl("after", wait, fun)
}

#' @export
#' @rdname tclTask
tclAfterCancel <- function(task) {
  # Cancel a Tcl timer (no effect if the timer does not exist)
  tcl("after", "cancel", as.character(task)[1])
}

#' @export
#' @rdname tclTask
tclAfterInfo <- function(task = NULL) {
  # Get info about a Tcl timer, or list all current ones (using task = NULL)
  if (is.null(task)) {
    return(tcl("after", "info"))
  } else {
    # First check that task exists
    task <- as.character(task)[1]
    ok <- tclvalue(.Tcl(paste("catch {after info ", task, "}", sep = "")))
    if (ok == 0) {
      return(tcl("after", "info", task))
    } else return(NULL)
  }
}

#' @export
#' @rdname tclTask
print.tclTask <- function(x, ...) {
  # Look when the task is run
  if (x$wait == "idle") {
    cat("tclTask '", x$id, "' scheduled on next event loop\n", sep = "")
  } else {
    cat("tclTask '", x$id, "' scheduled after ", x$wait, " ms ", sep = "")
    # Determine how much is remaining
    rem <- x$started + x$wait - proc.time()["elapsed"] * 1000
    if (rem <= 0) {
      cat("(elapsed)\n")
    } else {
      cat("(", as.integer(rem), " remaining)\n", sep = "")
    }
  }
  # Look if it is rescheduled
  if (isTRUE(x$redo)) {
    cat("Rescheduled forever\n")
  } else if (x$redo == FALSE || x$redo <= 0) {
    cat("Not rescheduled\n")
  } else if (x$redo == 1) {
    cat("Rescheduled once\n")
  } else {
    cat("Rescheduled", x$redo, "times\n")
  }
  # Print the command to be executed
  cat("runs:\n")
  print(x$expr)
  invisible(x)
}

#' @export
#' @rdname tclTask
tclTaskSchedule <- function(wait, expr, id = "task#", redo = FALSE) {
  # Schedule a task to be executed after 'wait' ms
  # If 'wait' is <= 0, schedule for execution on the next event loop
  # Id is the task name to use (if the task already exists, it is deleted
  # and replaced by the new definition)

  wait <- as.integer(wait)[1]
  if (wait <= 0) wait <- "idle"  # Schedule task on next event loop

  Tasks <- .getTclTasks()
  TNames <- ls(Tasks, all.names = TRUE)

  id <- as.character(id)[1]
  # If 'id' contains '#', replace it by a number (first one available)
  # but don't allow more than 1000 tasks with same name (to avoid bad
  # situations with buggy code like infinite loops or so)
  if (grepl("#", id)) {
    for (i in 1:1000) {
      Id <- sub("#", i, id)
      if (!Id %in% TNames) break
    }
    if (Id %in% TNames)
      stop("Too many tclTasks!")
  } else {
    # Delete the task if it already exists
    if (id %in% TNames) tclTaskDelete(id)
    Id <- id
  }

  if (!isTRUE(redo)) {
    redo <- as.integer(redo)[1]
    if (redo <= 0) redo <- FALSE
  }

  # Schedule the task, but don't run expr directly, but through tclTaskRun()
  # Note: if I use tcl("after", wait, tclTaskRun(Id), R is blocked until the
  # task is done. Here, I must provide the name of a function without args)
  task <- .makeTclTask(id = Id, wait = wait)

  # Create a tclTask object containing all info about this task
  res <- list(task = task, id = Id, expr = substitute(expr),
    started = proc.time()["elapsed"] * 1000, wait = wait,
    redo = redo)
  class(res) <- c("tclTask", class(res))

  # Add this task to the list
  Tasks[[Id]] <- res

  invisible(res)
}

#' @export
#' @rdname tclTask
tclTaskRun <- function(id) {
  # Execute the code associated with a given task and detemine if the task
  # should be rescheduled again (repeat argument)
  id <- as.character(id)[1]

  Tasks <- .getTclTasks()
  Task <- Tasks[[id]]
  if (is.null(Task)) {
    warning("tclTask '", id, "' is not found")
    return(invisible(FALSE))
  }
  # Make sure to indicate that we run it once
  if (!is.logical(Task$redo)) {
    Task$redo <- Task$redo - 1
    if (Task$redo < 1) Task$redo <- FALSE
  }
  # Update the original object too
  Tasks[[id]] <- Task

  # Run the code associate with this task
  eval(Task$expr, envir = .GlobalEnv)

  # Should we delete this task (if repeat is FALSE), or reschedule it?
  # Note, we read Task again, in case fun() would have changed something there!
  Task <- Tasks[[id]]
  # Make sure the tcl timer is destroyed (in case tclTaskRun() is
  # triggered otherwise)
  tclTaskDelete(id)
  if (Task$redo) {
    # Reschedule the task
    Task$task <- .makeTclTask(id = id, wait = Task$wait)
    # and update information in .tclTasks
    Tasks[[id]] <- Task
  }
  invisible(TRUE)
}

#' @export
#' @rdname tclTask
tclTaskGet <- function(id = NULL, all = FALSE) {
  # If id is NULL, list all scheduled tasks, otherwise, give info about a
  # particular scheduled task
  if (is.null(id)) {
    return(ls(.getTclTasks(), all.names = all))
  } else {
    ## Get the data associated with a scheduled task
    return(.getTclTasks()[[id]])
  }
}

#' @export
#' @rdname tclTask
tclTaskChange <- function(id, expr, wait, redo) {
  # Change a characteristic of a scheduled task
  # Is there something to change?
  if (missing(expr) && missing(wait) && missing(redo))
    return(invisible(FALSE))
  # Get task and change it
  Tasks <- .getTclTasks()
  Task <- Tasks[[id]]
  if (is.null(Task)) {
    warning("tclTask '", id, "' is not found")
    return(invisible(FALSE))
  }
  if (!missing(expr)) Task$expr <- substitute(expr)
  if (!missing(wait )) {
    wait <- as.integer(wait)[1]
    if (wait <= 0) wait <- "idle"  # Schedule task on next event loop
    Task$wait <- wait
  }
  if (!missing(redo)) {
    if (!isTRUE(redo)) {
      redo <- as.integer(redo)[1]
      if (redo <= 0) redo <- FALSE
    }
    Task$redo <- redo
  }
  # Delete the task and recreate it with the new parameters
  tclTaskDelete(id)
  Task$task <- .makeTclTask(id = id, wait = Task$wait)

  # Update Tasks
  Tasks[[id]] <- Task

  invisible(TRUE)
}

#' @export
#' @rdname tclTask
tclTaskDelete <- function(id) {
  Tasks <- .getTclTasks()
  # Remove a previously scheduled task (if id s NULL, then, remove all tasks)
  if (is.null(id)) {
    # Delete all current tasks
    for (Task in ls(Tasks, all.names = TRUE))
      tclAfterCancel(Tasks[[Task]]$task)
    # Eliminate .tclTasks environment from SciViews:TempEnv
    rm(list = ".tclTasks", envir = .TempEnv())
  } else {
    # Delete only one task
    Task <- Tasks[[id]]
    if (!is.null(Task)) {# The task exists
      tclAfterCancel(Task$task)
      rm(list = id, envir = Tasks)
    }
  }
}

.getTclTasks <- function() {
  # Retrieve references to all scheduled tasks
  res <- .getTemp(".tclTasks", default = NULL)
  if (is.null(res)) {
    res <- new.env(parent = .TempEnv())
    .assignTemp(".tclTasks", res)
  }
  res
}

.makeTclTask <- function(id, wait) {
  run <- function()
    eval(parse(text = paste('tclTaskRun("', id, '")', sep = "")))
  tclAfter(wait, run)
}
