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
  These functions are Windows-specific. They issue an error on other platforms.
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
  \item{keyname}{ the name of the key. }
  \item{valuename}{ a value in this key. }
  \item{data}{ the data to place in the value. }
  \item{type}{ the type of value in the registry. By default, it is 'sz', that
    is, an atomic string. }
}

\keyword{ utilities }

\concept{ Windows registry, keys, hives, permanent storage of configuration parameters }
