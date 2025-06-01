#' A series of methods applicable to tk2widget or tk2cfglist objects
#'
#' Tk2widgets can be used as tcltk widgets, but they propose also an
#' object-oriented interaction through these different methods.
#'
#' @param x A tk2widget object.
#' @param ... A series of named arguments corresponding to parameters and values
#' to use for the configuration for `tk2cfglist()`, or reserved arguments for
#' future use for the other function (not used yet).
#' @param value A value to assign to the object's method.
#'
#' @return
#' Depends on the function. The `is.xxx()` function return `TRUE` or `FALSE` if
#' the object is of the right class or not. The assignations form return the
#' assigned value. The direct form return the item.
#'
#' @export
#' @rdname tk2methods
#' @author Philippe Grosjean
#' @seealso [tk2button()], [tk2tip()]
#' @keywords utilities
is.tk2widget <- function(x)
  return(inherits(x, "tk2widget"))

#' @exportS3Method
#' @rdname tk2methods
print.tk2widget <- function(x, ...) {
  if (disabled(x)) txt <- " (disabled)" else txt <- ""
  cat("A tk2widget of class '", class(x)[1], "'", txt, "\n", sep = "")
  cat("State: ", state(x), "\n", sep = "")
  cursize <- size(x)
  if (cursize > 0)
    cat("Size: ", cursize, "\n", sep = "")
  val <- value(x)
  if (!is.null(val)) {
    cat("Value:\n")
    print(value(x))
  }
  invisible(x)
}

#' @export
#' @rdname tk2methods
tk2cfglist <- function(...) {
  res <- list(...)
  class(res) <- c("tk2cfglist", class(res))
  res
}

#' @exportS3Method
#' @rdname tk2methods
print.tk2cfglist <- function(x, ...) {
  if (!length(x)) {
    cat("An empty tk2widget cfglist\n")
  } else {
    cat("A tk2widget cfglist with:\n\n")
    print(unclass(x))
  }
  invisible(x)
}

#' @export
#' @rdname tk2methods
state <- function(x, ...)
  UseMethod("state")

#' @exportS3Method
#' @rdname tk2methods
state.tk2widget <- function(x, ...) {
  if (any(grepl("-state ", as.character(tkconfigure(x))))) {
    as.character(tkcget(x, "-state", ...))
  } else {
    "normal"
  }
}

# TODO: a state.tk2listbox, because there is no state property defined for it!

#' @export
#' @rdname tk2methods
label <- function(x, ...)
  UseMethod("label")

#' @exportS3Method
#' @rdname tk2methods
label.tk2widget <- function(x, ...)
  x$env$label

#' @export
#' @rdname tk2methods
`label<-` <- function(x, value)
  UseMethod("label<-")

#' @export
#' @rdname tk2methods
`label<-.tk2widget` <- function(x, value) {
  x$env$label <- as.character(value)[1]
  x
}

#' @export
#' @rdname tk2methods
tag <- function(x, ...)
  UseMethod("tag")

#' @exportS3Method
#' @rdname tk2methods
tag.tk2widget <- function(x, ...)
  x$env$tag

#' @export
#' @rdname tk2methods
`tag<-` <- function(x, value)
  UseMethod("tag<-")

#' @export
#' @rdname tk2methods
`tag<-.tk2widget` <- function(x, value) {
  x$env$tag <- value
  x
}

#' @export
#' @rdname tk2methods
disabled <- function(x, ...)
  UseMethod("disabled")

#' @exportS3Method
#' @rdname tk2methods
disabled.tk2widget <- function(x, ...)
  (state(x) == "disabled")

#' @export
#' @rdname tk2methods
`disabled<-` <- function(x, value)
  UseMethod("disabled<-")

#' @export
#' @rdname tk2methods
`disabled<-.tk2widget` <- function(x, value) {
  if (isTRUE(value)) state <- "disabled" else state <- "normal"
  tkconfigure(x, state = state)
  x
}

#' @export
#' @rdname tk2methods
values <- function(x, ...)
  UseMethod("values")

#' @exportS3Method
#' @rdname tk2methods
values.tk2widget <- function(x, ...)
  NULL # Default value, for widgets that do not support this!

#' @exportS3Method
#' @rdname tk2methods
values.tk2listbox <- function(x, ...)
  as.character(tkget(x, 0, "end"))

#' @export
#' @rdname tk2methods
`values<-` <- function(x, value)
  UseMethod("values<-")

#' @export
#' @rdname tk2methods
`values<-.tk2widget` <- function(x, value)
  stop("This tk2widget does not seem to support values")

#' @export
#' @rdname tk2methods
`values<-.tk2listbox` <- function(x, value) {
  # Save current selection
  cursel <- selection(x)
  tclServiceMode(FALSE)
  on.exit(tclServiceMode(TRUE))
  isDisabled <- disabled(x)
  on.exit(disabled(x) <- isDisabled, add = TRUE)
  if (isDisabled)
    disabled(x) <- FALSE
  # Change items (no attempt to match them -possible future improvement!-)
  tkdelete(x, 0, "end")
  for (item in as.character(value))
    tkinsert(x, "end", item)
  # Try to reapply selection
  for (sel in cursel)
    tkselection.set(x, sel - 1)
  x
}

#' @export
#' @rdname tk2methods
value <- function(x, ...)
  UseMethod("value")

#' @exportS3Method
#' @rdname tk2methods
value.tk2widget <- function(x, ...)
  NULL # Default value is NULL for tk2widgets

#' @exportS3Method
#' @rdname tk2methods
value.tk2listbox <- function(x, ...)
  values(x)[selection(x)]

#' @export
#' @rdname tk2methods
`value<-` <- function(x, value)
  UseMethod("value<-")

#' @export
#' @rdname tk2methods
`value<-.tk2widget` <- function(x, value)
  stop("This tk2widget does not seem to support setting its value")

#' @export
#' @rdname tk2methods
`value<-.tk2listbox` <- function(x, value) {
  items <- items(x)
  if (length(items) > 0)
    selection(x) <- (1:length(items))[items %in% value]
  x
}

#' @export
#' @rdname tk2methods
selection <- function(x, ...)
  UseMethod("selection")

#' @exportS3Method
#' @rdname tk2methods
selection.tk2widget <- function(x, ...)
  NULL # For tk2widgets that do not support selection

#' @exportS3Method
#' @rdname tk2methods
selection.tk2listbox <- function(x, ...)
  (as.integer(tkcurselection(x)) + 1)

#' @export
#' @rdname tk2methods
`selection<-` <- function(x, value)
  UseMethod("selection<-")

#' @export
#' @rdname tk2methods
`selection<-.tk2widget` <- function(x, value)
  stop("This tk2widget does not seem to support setting its selection")

#' @export
#' @rdname tk2methods
`selection<-.tk2listbox` <- function(x, value) {
  # Prepare
  tclServiceMode(FALSE)
  on.exit(tclServiceMode(TRUE))
  isDisabled <- disabled(x)
  on.exit(disabled(x) <- isDisabled, add = TRUE)
  if (isDisabled) disabled(x) <- FALSE
  # Clear selection only
  if (is.null(value) || length(value) < 1) {
    tkselection.clear(x, 0, "end")
    return(x)
  }
  # Check data
  value <- sort(as.integer(round(value)))
  if (value[1] < 1)
    stop("Selections must be indices > 0")
  if (value[length(value)] > size(x)) return(x)
  # Change selection
  tkselection.clear(x, 0, "end")
  if (tclvalue(tkcget(x, "-selectmode")) == "single" && length(value) > 1) {
    warning("Single selection mode... only lowest selection used")
    tkselection.set(x, value[1] - 1)
  } else {
    for (sel in value)
      tkselection.set(x, sel - 1)
  }
  if (!isDisabled) tksee(x, value[1] - 1)
  x
}

#' @export
#' @rdname tk2methods
#' @param index The zero-based index of the item to make visible.
visibleItem <- function(x, index, ...)
  UseMethod("visibleItem")

#' @exportS3Method
#' @rdname tk2methods
visibleItem.tk2widget <- function(x, index, ...)
  stop("This tk2widget does not seems to support the visibleItem method")

#' @exportS3Method
#' @rdname tk2methods
visibleItem.tk2listbox <- function(x, index, ...) {
  # Index must be a positive integer
  index <- as.integer(round(index))
  if (is.null(index) || length(index) < 1 || index[1] < 1)
    stop("index must be a postive integer")
  tksee(x, index[1] - 1) # Because Tcl uses 0-based indices
  return(NULL)
}

#' @export
#' @rdname tk2methods
size <- function(x, ...)
  UseMethod("size")

#' @exportS3Method
#' @rdname tk2methods
size.tk2widget <- function(x, ...)
  0L # By default, a tk2widget has values of zero size (NULL)

#' @exportS3Method
#' @rdname tk2methods
size.tk2listbox <- function(x, ...)
  as.integer(tksize(x))

#' @export
#' @rdname tk2methods
config <- function(x, ...)
  UseMethod("config")

#' @exportS3Method
#' @rdname tk2methods
#' @param cfglist a list containing one or more named items, with the name
#'   being a Tcl/Tk property and items being the new value for the property.
config.tk2widget <- function(x, cfglist, ...) {
  # Compile a list of arguments
  args <- list(...)
  if (!missing(cfglist))
    args <- .mergeList(as.list(cfglist, args))

  # Prepare an empty object
  res <- list()
  class(res) <- c("tk2cfglist", class(res))

  # No arguments provided... query a sublist of parameters
  if (length(args) == 0) {
    # Return the complete config (but not the data!)
    params <- tk2configList(x)
    if (!length(params))
      return(res)
  } else {
    # Separate named (set) from unnamed (query only) arguments
    params <- names(args)
    if (is.null(params)) {# No named arguments, only queries
      params <- as.character(args)
    } else {
      # For those named arguments, change the config
      res <- (config(x) <- args[params != ""])
      # ... and query the others
      params <- as.character(args[params == ""])
    }
  }

  # Retrieve values for the queries
  if (length(params)) {
    for (i in 1:length(params)) {
      p <- tclvalue(tkcget(x, paste("-", params[i], sep = "")))
      if (!is.null(p) && p != "")
        res[[params[i]]] <- p
    }
  }
  res
}

#' @exportS3Method
#' @rdname tk2methods
config.tk2label <- function(x, cfglist, ...) {
  # wrap is special here... => how to deal with it???
  # TODO...
  config.tk2widget(x, cfglist, ...)
}

# TODO: config.tk2listbox()

#' @export
#' @rdname tk2methods
`config<-` <- function(x, value)
  UseMethod("config<-")

#' @export
#' @rdname tk2methods
`config<-.tk2widget` <- function(x, value) {
  # The default function deleguates to tkconfigure, except for a few things
  value <- .configStd(x, value)
  value$widget <- x
  do.call(tkconfigure, value)
  x
}

#' @export
#' @rdname tk2methods
`config<-.tk2label` <- function(x, value) {
  # Standard treatment
  value <- .configStd(x, value)

  if (!is.null(value$wrap)) {
    # wrap is not a ttk option but we use it here for convenience
    wrap <- value$wrap
    value$wrap <- NULL
  } else wrap <- NULL

  # For the other parameters, apply tkconfigure() with them
  value$widget <- x
  do.call(tkconfigure, value)

  # Do we still have to apply wrap?
  width <- abs(as.integer(tclvalue(tkcget(x, "-width"))))
  if (!is.null(wrap)) {
    if (isTRUE(wrap)) wraplength <- .wraplength(x, width) else wraplength <- 0
    tkconfigure(x, wraplength = wraplength)
  }
  # Reapply width to get correct text wrapping (bug in ttk::label?)
  if (length(width))
    tkconfigure(x, width = width)
  x
}

# TODO: `config<-.tk2listbox`

