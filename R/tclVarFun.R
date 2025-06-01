# TODO:
# - Add a catch {} in tclFun and handle it
# - A tclFunDispose() function to delete the Tcl equivalent of a function
# - Add a try construct in tclVarExists and tclVarFind
# - better manage catch{} in tclVarName


#' Manipulate R variables and functions from tcl and back
#'
#' These functions are intended to provide a better "duality" between the name
#' of variables in both R and tcl, including for function calls. It is possible
#' to define a variable with the same name in R and tcl (the content is
#' identical, but copied and coerced in the two respective environments). It is
#' also possible to get the value of a tcl variable from R, and to call a R
#' function from within tcl. These features are provided in the tcltk package,
#' but Tcl variable usually have different internal names as R equivalents.
#'
#' @param names Transform names so that they are valid for variables in Tcl.
#' @param unique Should these names be unique in the vector?
#' @param f An R function. currently, do no support functions with arguments.
#' @param name The name of a variable.
#' @param value The value to place in a variable.
#' @param pattern A pattern to search for.
#' @param init Initial value to use when creating the variable.
#' @param keep.existing If the tcl variable already exist, should we keep its
#' content?
#'
#' @details
#' These functions are similar to [tcltk::tclVar()] from package tcltk, except
#' for the following change: here, it is possible to propose a name for the
#' created tcl variable, or to set or retrieve the content of a tcl variable
#' that is not mirrored in R.
#'
#' @return
#' Most of these functions return a 'tclVar' object.
#' @author Philippe Grosjean
#' @seealso [tk2edit()], [tcltk::tclVar()]
#' @keywords utilities
#' @export
#' @rdname tclVarFun
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' # Tcl functions and variables manipulation
#' tclVarExists("tcl_version")
#' tclVarExists("probably_non_existant")
#' tclVarFind("tcl*")
#'
#' # Using tclVarName() and tclGetValue()...
#' # intented for better match between R and Tcl variables
#' Test <- tclVarName("Test", "this is a test!")
#' # Now 'Test' exist both in R and in Tcl... In R, you need to use
#' tclvalue(Test) # to retrieve its content
#' # If a variable already exists in Tcl, its content is preserved using
#' # keep.existing = TRUE
#'
#' # Create a variable in Tcl and assign "just a test..." to it
#' tclSetValue("A_Variable", "just to test...")
#' # Create the dual variable with same name
#' A_Variable <- tclVarName("A_Variable", "something else?")
#' tclvalue(A_Variable) # Content of the variable is not changed!
#'
#' # If you want to retrieve the content of a Tcl variable,
#' # but do not want to create a reference to it in R, use:
#'
#4 # Create a Tcl variable, not visible from R
#' tclSetValue("Another_Variable", 1:5)
#' tclGetValue("Another_Variable") # Get its content in R (no conversion!)
#' tclSetValue("Another_Variable", paste("Am I", c("happy", "sad"), "?"))
#' tclGetValue("Another_Variable") # Get its content in R (no conversion!)
#' }
makeTclNames <- function(names, unique = FALSE) {
  # Make valid Tcl variable names (allow_ = TRUE by default in R >= 2.0.0)
  names <- make.names(names, unique = unique)
  # There is a problem if the variable starts with a dot => prepend it with 'X'
  .names <- grep("^\\.", names)
  names[.names] <- paste("X", names[.names], sep = "")
  # Although it is accepted, there could be problems with variable names
  # containing dots, so, replace them with '_'
  gsub("\\.", "_", names)
}

### TODO: change this to use closure functions instead!!!
#' @export
#' @rdname tclVarFun
tclFun <- function(f, name = deparse(substitute(f))) {
  # Register a simple R function (without arguments) as a callback in Tcl,
  # and give it the same name under Tcl)
  # Indeed, .Tcl.callback(f) does the job... but it gives criptic names
  # like R_call 0x13c7168

  # Check that 'f' is a function with no arguments (cannot handle them yet)
  if (!is.function(f)) stop("'f' must be a function!")
  if (!is.null(formals(f))) stop("The function used cannot (yet) have arguments!")
  # Make sure the name of the function is valid
  if (!is.character(name)) stop("'name' must be a character string!") else
  name <- make.names(name[1])

  res <- .Tcl.callback(f)
  # Make sure this is correct (R_call XXXXXXXX)
  if (length(grep("R_call ", res) > 0)) {
    # Create a proc with the same name in Tcl
    .Tcl(paste("proc ", name, " {} {", res, "}", sep = ""))
  }
  # Rem: if you delete the R 'f' function, the Tcl 'f' function still works!
  # You have to explicitly delete the Tcl function

  # Return the R_call XXXXXXXX string, as .Tcl.callback() does
  res
}

#' @export
#' @rdname tclVarFun
tclGetValue <- function(name) {
  # Get the value stored in a plain Tcl variable
  if (!is.character(name))
    stop("'name' must be a character!")
  name <- makeTclNames(name[1]) # The usual name conversion

  # Create a temporary dual variable with tclVar() (name does not mather)
  Temp <- tclVar(init = "")

  # Copy the content of the var of interest to it
  res <- tclvalue(.Tcl(paste("catch {set ", as.character(Temp), " $", name,
    "}", sep = "")))  # Return "0" if OK, "1" otherwise
  if (res != "0")
    stop(gettextf("Error when getting the value in the '%s' Tcl variable",
      name))

  # Get the content of the temporary variable
  tclvalue(Temp) # (Temp will be destroyed when the function exits)
}

#' @export
#' @rdname tclVarFun
tclSetValue <- function(name, value) {
  # This is the opposite of tclGetValue() and it is a wrapper
  # for 'set name value' Tcl command
  if (!is.character(name))
    stop("'name' must be a character!")
  name <- makeTclNames(name[1]) # The usual name conversion

  # Create a temporary dual variable with tclVar() (name does not mather)
  Temp <- tclVar(init = value)

  # Copy the content of this variable to the tcl variable 'name'
  res <- tclvalue(.Tcl(paste("catch {set ", name, " $", as.character(Temp),
    "}", sep = "")))
  if (res != "0")
    stop(gettextf("Error when changing the value of the '%s' Tcl variable",
      name))

  # (Temp is destroyed when the function exits)
  invisible(name)  # Return the name of the Tcl variable invisibly
}

#' @export
#' @rdname tclVarFun
tclVarExists <- function(name)
  as.integer(tcl("info", "exists", name)) == 1

#' @export
#' @rdname tclVarFun
tclVarFind <- function(pattern)
  as.character(tcl("info", "vars", pattern))

#' @export
#' @rdname tclVarFun
tclVarName <- function(name, init = "", keep.existing = TRUE) {
  # tclVar gives names like ::RtclX automatically...
  # We need to define names ourselve. This is what tclVarName does
  # If keep existing == TRUE and the variable is already defined, then
  # we keep its content, instead of initializing it with "init"
  if (!is.character(name))
    stop("'name' must be a character!")
  name <- makeTclNames(name[1])  # Make sure the name is correct

  # Temporary save potential content of the Tcl variable elsewhere
  # (catch in case the variable does not exist)
  if (isTRUE(keep.existing))
    .Tcl(paste("catch {set ZZZTempRvariable $", name, "}", sep = ""))

  # Create the new dual Tcl-R variable
  l <- list(env = new.env())
  assign(name, NULL, envir = l$env)
  reg.finalizer(l$env, function(env) tcl("unset", ls(env)))
  class(l) <- "tclVar"
  tclvalue(l) <- init

  # Possibly restore the content of the variable, if keep.existing == TRUE
  if (isTRUE(keep.existing)) {
    .Tcl(paste("catch {set", name, "$ZZZTempRvariable}"))
    # Remove the temporary variable
    .Tcl("unset -nocomplain ZZZTempRvariable")
  }
  l
}
