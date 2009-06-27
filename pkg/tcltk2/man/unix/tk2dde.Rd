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
\synopsis{
    tk2dde(topic = NULL)
    tk2dde.services(service = "", topic = "")
    tk2dde.exec(service, topic, command, async = FALSE)
    tk2dde.poke(service, topic, item, data)
    tk2dde.request(service, topic, item, binary = FALSE)
    .tk2dde.require()
}

\keyword{ utilities }
\keyword{ IO }
