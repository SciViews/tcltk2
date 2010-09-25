\name{tk2dde}
\alias{tk2dde}
\alias{tk2dde.exec}
\alias{tk2dde.poke}
\alias{tk2dde.request}
\alias{tk2dde.services}
\alias{.tk2dde.require}

\title{ Use DDE (Dynamic Data Exchange) under Windows }
\description{
  These functions are Windows-specific. They issue an error under a different
  platform.
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

\keyword{ utilities }
\keyword{ IO }

\concept{ Interprocess communication, DDE }
