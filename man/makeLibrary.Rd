% Generated by roxygen2 (4.0.1): do not edit by hand
\name{makeLibrary}
\alias{makeLibrary}
\title{Downloads packages from CRAN to specified path and creates repository or library.}
\usage{
makeLibrary(pkgs, path, type = "source")
}
\arguments{
\item{pkgs}{Character vector of packages to download}

\item{type}{Passed to \code{\link{download.packages}}}

\item{path}{Destination download path}
}
\description{
Given a list of packages, downloads to a specified destination folder, then creates PACKAGES
file.
}
\details{
The function \code{makeLibrary} downloads the packages into a single folder, i.e. similar to a
library on a machine.

Uses \code{\link{download.packages}} and \code{\link[tools]{write_PACKAGES}}
}
\keyword{internal}

