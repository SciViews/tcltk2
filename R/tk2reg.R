# TODO:
# - use a try for tk2reg.get()
# - Change double call for a try() for tk2reg.keys(), tk2reg.type()
#   and tk2reg.values()
# - Add "none to the type of supported formats?

### TODO: implement ::ico::getIconByName, ::ico::getFileIcon & ::ico::writeIcon
### TODO: gif files are acceptable too for tk2ico.set(), example:
### Image <- tclVar()
### tcl("image", "create", "photo", Image, file = "myfile.gif")
### tcl("wm", "iconphoto", tt, Image) instead of tk2ico.set

#' Manipulate the registry under Windows
#'
#' These functions access the Windows registry in a secure way (most errors
#' are handled gracefully), and ensures correct conversion back and forth
#' for atomic strings ('sz' and 'expand\\\\_') and numbers ('dword' and
#' 'dword\\\\_big\\\\_endian'), and for vectors of strings ('multi\\\\_sz').
#'
#' @param keyname The name of the key.
#' @param valuename A value in this key.
#' @param data The data to place in this value.
#' @param type The type of value in the registry. By default, it is 'sz', that
#' is, an atomic string.
#'
#' @return
#' Functions that should return registry value(s) or key(s) return them in a
#' character string, or they return `NA` if the key/value is not found in the
#' registry.
#'
#' [tk2reg.broadcast()], [tk2reg.delete()], [tk2reg.deletekey()],
#' [tk2reg.set()] and [tk2reg.setkey()] return `TRUE` in case of success and
#' `FALSE` otherwise.
#'
#' [tk2reg.get()] should handle correctly the types 'sz', 'expand\\\\_sz' and
#' multi\\\\_sz' (note that 'expand\\\\_sz' string is NOT expanded!), as well as
#' dword' and 'dword\\\\_big\\\\_endian' that are converted into numeric values.
#' Other types are not converted and the Tcl expression is returned ('objTcl'
#' class) untransformed.
#'
#' [tk2reg.set()] currently works with 'sz', 'expand\\\\_sz', 'multi\\\\_sz',
#' dword' and 'dword\\\\_big\\\\_endian' types. A couple of other types are
#' accepted by the function... but they are not tested ('binary', 'link',
#' resource\\\\_list').
#'
#' @note
#' For Windows only. These functions issue an error when they are called
#' under other platforms. Take care while manipulating the Windows registry!
#' You can easily lock the system completely, if you delete important items,
#' especially if you are logged as administrator on your computer. Make a backup
#' of your registry first before experimenting with these function!!!
#'
#' @export
#' @rdname tk2reg
#' @author Philippe Grosjean
#' @seealso [tk2dde.exec()], [tk2ico.create()]
#' @keywords utilities
#'
#' @examples
#' \dontrun{
#' # These cannot be run by examples() but should be OK when pasted
#' # into an interactive R session with the tcltk package loaded
#'
#' ### Examples of tk2reg - registry manipulation under Windows
#' # Rem: HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CLASSES_ROOT, HKEY_CURRENT_USER,
#' #      HKEY_CURRENT_CONFIG, HKEY_PERFORMANCE_DATA, HKEY_DYN_DATA
#' Rkey <- "HKEY_CURRENT_USER\\\\Software\\\\R-core\\\\R"   # The R key
#' Rkey <- paste(Rkey, "\\\\", R.version$major, ".", R.version$minor, sep = "")
#' Rsubkey <- paste(Rkey, "subkey", sep = "\\\\")        # A subkey
#'
#' # Get all subkeys for Software in the local machine
#' tk2reg.keys("HKEY_LOCAL_MACHINE\\\\Software")
#'
#' # Get all names in the R key
#' tk2reg.values(Rkey)
#'
#' # Get the path for the current R version
#' tk2reg.get(Rkey, "InstallPath")
#'
#' # Create a subkey (explore the registry with regedit.exe to see it)
#' tk2reg.setkey(Rsubkey)
#' # Add a couple of keys in it
#' tk2reg.set(Rsubkey, "test", "a key added in the registry!", type = "sz")
#' tk2reg.set(Rsubkey, "test exp", "\%SystemRoot\%\\\\system32", type = "expand_sz")
#' tk2reg.set(Rsubkey, "test multi", LETTERS[1:5], type = "multi_sz")
#' tk2reg.set(Rsubkey, "test dword", 1024, type = "dword")
#' tk2reg.set(Rsubkey, "test big end", 1024, type = "dword_big_endian")
#'
#' # Get the type of a value
#' tk2reg.type(Rsubkey, "test")
#' tk2reg.type(Rsubkey, "test exp")
#' tk2reg.type(Rsubkey, "test multi")
#' tk2reg.type(Rsubkey, "test dword")
#' tk2reg.type(Rsubkey, "test big end")
#'
#' # Get a value in a key
#' tk2reg.get(Rsubkey, "test")
#' tk2reg.get(Rsubkey, "test exp")
#' tk2reg.get(Rsubkey, "test multi")
#' tk2reg.get(Rsubkey, "test dword")
#' tk2reg.get(Rsubkey, "test big end")
#'
#' # Delete a name in a key (take care: dangerous!)
#' tk2reg.delete(Rsubkey, "test")
#' # Delete a whole key (take care: very dangerous!)
#' tk2reg.deletekey(Rsubkey)
#'
#' # An alternate way to get the path
#' tk2reg.get(paste("HKEY_LOCAL_MACHINE", "SYSTEM", "CurrentControlSet",
#'   "Control", "Session Manager", "Environment", sep = "\\\\"), "path")
#'
#' # Make sure that currently running apps are warned of your changes in the registry
#' tk2reg.broadcast()
#'
#' # Delete temporary variables
#' rm(list = c("Rkey", "Rsubkey"))
#' }
tk2reg.broadcast <- function() {
  # Used to warn running apps that something changes in the registry
  # Use this when you change an environment variable
  .tk2reg.require()
  res <- tclvalue(.Tcl("catch {registry broadcast \"Environment\"}"))
  (res == "0")  # "0" if OK, "1" otherwise
}

#' @export
#' @rdname tk2reg
tk2reg.delete <- function(keyname, valuename) {
  # Delete a registry value in a key (take care when using this!)
  .tk2reg.require()
  keyname <- as.character(keyname[1])
  valuename <- as.character(valuename[1])
  res <- tclvalue(.Tcl(paste("catch {registry delete {", keyname, "} {",
    valuename, "}}", sep = "")))  # return "0" if OK, "1" otherwise
  (res == "0")
}

#' @export
#' @rdname tk2reg
tk2reg.deletekey <- function(keyname) {
  # Completely delete a registry key (take care when using this!)
  .tk2reg.require()
  keyname <- as.character(keyname[1])
  res <- tclvalue(.Tcl(paste("catch {registry delete {", keyname, "}}",
    sep = "")))  # Return "0" if OK (even if already deleted) or "1"
  (res == "0")
}

#' @export
#' @rdname tk2reg
tk2reg.get <- function(keyname, valuename) {
  # Get the content of a key
  .tk2reg.require()
  keyname <- as.character(keyname[1])
  valuename <- as.character(valuename[1])
  # First get the type of this registry key
  Type <- tk2reg.type(keyname, valuename)
  if (is.na(Type))
    return(NA)  # The key does not exists
  # The key is found... retrieve its data
  res <- .Tcl(paste("registry get {", keyname, "} {",
    valuename, "}", sep = ""))
  # Convert according to its type...
  res <- switch(Type,
    sz = tclvalue(res),        # A single string
    expand_sz = tclvalue(res),    # This string is NOT expanded!
    multi_sz = as.character(res),  # A vector of strings
    dword = as.numeric(res),    # Numbers,... check very large numbers!
    dword_big_endian = as.numeric(res),  # Is this correct???
    res)  # Other types are probably not handled well!
  res
}

#' @export
#' @rdname tk2reg
tk2reg.keys <- function(keyname) {
  # Get a list of all subkeys in a key
  .tk2reg.require()
  keyname <- as.character(keyname[1])
  # First check if the command succeeds
  res <- tclvalue(.Tcl(paste("catch {registry keys {", keyname, "}}",
    sep = "")))  # Return "0" if OK, "1" otherwise
  if (res != "0")
    return(NA)  # Indicate that keyname is probably inexistant
  # Now run the command unprotected
  as.character(.Tcl(paste("registry keys {", keyname, "}", sep = "")))
}

#' @export
#' @rdname tk2reg
tk2reg.set <- function(keyname, valuename, data,
type = c("sz", "expand_sz", "multi_sz", "dword", "dword_big_endian")) {
  # Set a registry key value
  .tk2reg.require()
  keyname <- as.character(keyname[1])
  valuename <- as.character(valuename[1])
  data <- as.character(data)
  if (length(data) > 1)  # Collapse into one string, using {} as separators
    data <- paste(data, collapse = "\n")
  type <- type[1]
  if (!(type %in% c("sz", "expand_sz", "multi_sz", "dword", "dword_big_endian",
    "binary", "link", "resource_list", "none")))
    stop("Unrecognized 'type'!")
  res <- tclvalue(.Tcl(paste("catch {registry set {", keyname, "} {",
    valuename, "} {", data, "} {", type, "}}" , sep = "")))
  (res == "0")  # Because "0" if OK, and "1" otherwise
}

#' @export
#' @rdname tk2reg
tk2reg.setkey <- function(keyname) {
  # Set a registry key
  keyname <- as.character(keyname[1])
  .tk2reg.require()
  res <- tclvalue(.Tcl(paste("catch {registry set {", keyname, "}}",
    sep = "")))  # Return "0" if OK, "1" otherwise
  (res == "0")
}

#' @export
#' @rdname tk2reg
tk2reg.type <- function(keyname, valuename) {
  # Get the type of a key...
  .tk2reg.require()
  keyname <- as.character(keyname[1])
  valuename <- as.character(valuename[1])
  # First test it to see if the command succeeds (i.e., if the key exists)
  res <- tclvalue(.Tcl(paste("catch {registry type {", keyname, "} {",
    valuename, "}}", sep = "")))  # return "0" if OK, "1" otherwise
  if (res != "0")
    return(NA)  # The key is probably missing
  # Run the command unprotected now
  tclvalue(.Tcl(paste("registry type {", keyname, "} {", valuename, "}", sep = "")))
}

#' @export
#' @rdname tk2reg
tk2reg.values <- function(keyname) {
  # Get a list of all values in a key
  keyname <- as.character(keyname[1])
  .tk2reg.require()
  # First check if the command succeeds
  res <- tclvalue(.Tcl(paste("catch {registry values {", keyname, "}}",
    sep = "")))  # Returns "0" if OK, "1" otherwise
  if (res != "0")
    return(NA)  # The key probably does not exist!
  # We issue the command now without protection
  as.character(.Tcl(paste("registry values {", keyname, "}", sep = "")))
}

.tk2reg.require <- function() {
  # Make sure tcl/tk registry is operational
  if (.Platform$OS.type != "windows")
    stop("This is a Windows-specific function!")
  if (!capabilities("tcltk"))
    stop("This version of R cannot use Tcl/Tk!")
  # This should be installed by default with the tcltk package under Windows
  res <- tclRequire("registry", warn = TRUE)
  if (inherits(res, "tclObj"))
    res <- tclvalue(res)
  if (res[1] == FALSE)
    stop("Unable to find the 'registry' Tcl/tk package!")
  res  # The package version number
}
