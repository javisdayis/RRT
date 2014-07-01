% Generated by roxygen2 (4.0.1): do not edit by hand
\name{rrt_install}
\alias{rrt_install}
\title{Install packages within an RRT repository.}
\usage{
rrt_install(repo = getwd(), verbose = TRUE)
}
\arguments{
\item{repo}{A repository path. This is the path to the root of your RRT repository. By default,
we use the current working directory via \code{getwd()}.}

\item{verbose}{Print messages. Default: TRUE.}
}
\description{
Installs packages to your local repository. Performs some checks to make sure your repo is a
RRT repository, and the rrt dir exists with your repository, then installs packages not already
installed. See Details for more info.
}
\details{
Think of \code{rrt_install} as though \code{install.packages} was broken into two
steps: download, then install. \link{rrt_init} and \link{rrt_refresh} both download packages
from MRAN, CRAN, Github, or other locations, while \code{rrt_install} only installs packages
already downloaded. However, if source packages downloaded by \link{rrt_init} and
\link{rrt_refresh} don't work, \code{rrt_install} downloads the binary version from CRAN and
attempts to install that.
}
\examples{
\dontrun{
rrt_install(repo="~/testrepo")
}
}
\seealso{
\link{rrt_init}, \link{rrt_refresh}
}
