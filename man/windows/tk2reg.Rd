\name{tk2reg}
\alias{tk2reg}
\alias{tk2reg.broadcast}
\alias{tk2reg.delete}
\alias{tk2reg.deletekey}
\alias{tk2reg.get}
\alias{tk2reg.keys}
\alias{tk2reg.set}
\alias{tk2reg.setkey}
\alias{tk2reg.type}
\alias{tk2reg.values}

\title{ Manipulate the registry under Windows }
\description{
  These functions access the Windows registry in a secure way (most errors
  are handled gracefully), and ensures correct conversion back and forth
  for atomic strings ('sz' and 'expand\_') and numbers ('dword' and
  'dword\_big\_endian'), and for vectors of strings ('multi\_sz').
}

\usage{
tk2reg.broadcast()
tk2reg.delete(keyname, valuename)
tk2reg.deletekey(keyname)
tk2reg.get(keyname, valuename)
tk2reg.keys(keyname)
tk2reg.set(keyname, valuename, data, type = c("sz", "expand_sz", "multi_sz",
    "dword", "dword_big_endian"))
tk2reg.setkey(keyname)
tk2reg.type(keyname, valuename)
tk2reg.values(keyname)
}

\arguments{
  \item{keyname}{ The name of the key. }
  \item{valuename}{ A value in this key. }
  \item{data}{ The data to place in the value. }
  \item{type}{ The type of value in the registry. By default, it is 'sz', that
     is, an atomic string. }
}

\value{
  Functions that should return registry value(s) or key(s) return them in a
  character string, or they return \code{NA} if the key/value is not found in
  the registry.

  \code{tk2reg.broadcast()}, \code{tk2reg.delete()}, \code{tk2reg.deletekey()}
  \code{tk2reg.set} and \code{tk2reg.setkey()} return \code{TRUE} in case of
  success and \code{FALSE} otherwise.

  \code{tk2reg.get()} should handle correctly the types 'sz', 'expand\_sz' and
  'multi\_sz' (note that 'expand\_sz' string is NOT expanded!), as well as
  'dword' and 'dword\_big\_endian' that are converted into numeric values. Other
  types are not converted and the Tcl expression is returned ('objTcl' class)
  untransformed.

  \code{tk2reg.set()} currently works with 'sz', 'expand\_sz', 'multi\_sz',
  'dword' and 'dword\_big\_endian' types. A couple of other types are accepted
  by the function... but they are not tested ('binary', 'link',
  'resource\_list'). 
}

\author{ Philippe Grosjean }

\note{ For Windows only. These functions issue an error when they are called
  under other platforms. Take care while manipulating the Windows registry!
  You can easily lock the system completely, if you delete important items,
  especially if you are logged as administrator on your computer. Make a backup
  of your registry first before experimenting with these function!!!
}

\seealso{ \code{\link{tk2dde}}, \code{\link{tk2ico}} }

\examples{
\dontrun{
## These cannot be run by examples() but should be OK when pasted
## into an interactive R session with the tcltk package loaded

## Examples of tk2reg - registry manipulation under Windows
# Rem: HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CLASSES_ROOT, HKEY_CURRENT_USER,
#      HKEY_CURRENT_CONFIG, HKEY_PERFORMANCE_DATA, HKEY_DYN_DATA
Rkey <- "HKEY_LOCAL_MACHINE\\\\Software\\\\R-core\\\\R"   # The R key
Rkey <- paste(RKkey, "\\\\", R.version$major, ".", R.version$minor, sep = "")
Rsubkey <- paste(Rkey, "subkey", sep = "\\\\")        # A subkey

# Get all subkeys for Software in the local machine
tk2reg.keys("HKEY_LOCAL_MACHINE\\\\Software")

# Get all names in the R key
tk2reg.values(Rkey)

# Get the path for the current R version
tk2reg.get(Rkey, "InstallPath")

# Create a subkey (explore the registry with regedit.exe to see it)
tk2reg.setkey(Rsubkey)
# Add a couple of keys in it
tk2reg.set(Rsubkey, "test", "a key added in the registry!", type = "sz")
tk2reg.set(Rsubkey, "test exp", "\%SystemRoot\%\\\\system32", type = "expand_sz")
tk2reg.set(Rsubkey, "test multi", LETTERS[1:5], type = "multi_sz")
tk2reg.set(Rsubkey, "test dword", 1024, type = "dword")
tk2reg.set(Rsubkey, "test big end", 1024, type = "dword_big_endian")

# Get the type of a value
tk2reg.type(Rsubkey, "test")
tk2reg.type(Rsubkey, "test exp")
tk2reg.type(Rsubkey, "test multi")
tk2reg.type(Rsubkey, "test dword")
tk2reg.type(Rsubkey, "test big end")

# Get a value in a key
tk2reg.get(Rsubkey, "test")
tk2reg.get(Rsubkey, "test exp")
tk2reg.get(Rsubkey, "test multi")
tk2reg.get(Rsubkey, "test dword")
tk2reg.get(Rsubkey, "test big end")

# Delete a name in a key (take care: dangerous!)
tk2reg.delete(Rsubkey, "test")
# Delete a whole key (take care: very dangerous!)
tk2reg.deletekey(Rsubkey)

# An alternate way to get the path
tk2reg.get(paste("HKEY_LOCAL_MACHINE", "SYSTEM", "CurrentControlSet",
	"Control", "Session Manager", "Environment", sep = "\\\\"), "path")

# Make sure that currently running apps are warned of your changes in the registry
tk2reg.broadcast()

# Delete temporary variables
rm(list = c("Rkey", "Rsubkey"))
}
}
\keyword{ utilities }
