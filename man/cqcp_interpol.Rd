% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cqcp_filter.R
\name{cqcp_interpol}
\alias{cqcp_interpol}
\title{Interpolation}
\usage{
cqcp_interpol(x, maxLength = 1)
}
\arguments{
\item{x}{A numeric vector}

\item{maxLength}{Allowed length of the gap to interpolate, default is 1.}
}
\value{
vector
}
\description{
This function takes a numerical vector x and fills NaNs with linearly
interpolated values. The allowed length of the gap, i.e., the number of
consecutive NaNs to be interpolated and replaced, is smaller or equal
maxLength. Internally called by cqcp_o1.
}
