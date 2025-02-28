% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cqcp_helper.R
\name{cqcp_extract_raster_data}
\alias{cqcp_extract_raster_data}
\title{Extract raster value at given position(s) for a RasterLayer Object or geotiff
file.}
\usage{
cqcp_extract_raster_data(lon, lat, raster = NULL, file = NULL)
}
\arguments{
\item{lon}{Longitude values(s)}

\item{lat}{Latitude values(s)}

\item{raster}{RasterLayer object (cf. raster package)}

\item{file}{Path to a geotiff file}
}
\value{
extracted value(s) for given lon/lat
}
\description{
Extract raster value at given position(s) for a RasterLayer Object or geotiff
file.
}
