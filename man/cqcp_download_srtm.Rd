% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cqcp_helper.R
\name{cqcp_download_srtm}
\alias{cqcp_download_srtm}
\title{Download SRTM data using geodata package for bounding box of data.}
\usage{
cqcp_download_srtm(
  data,
  directory = NULL,
  outfile = NULL,
  overwrite = TRUE,
  crop = FALSE,
  ...
)
}
\arguments{
\item{data}{data.table/data.frame with at least columns 'lon' and 'lat'}

\item{directory}{Directory path to optionally store the SRTM data. If NULL,
downloaded data is stored in the current working directory.}

\item{outfile}{File path to save the SRTM raster as geotiff}

\item{overwrite}{Overwrite existing geotiff? Default is TRUE.}

\item{crop}{Crop raster/geotiff to data extent? Default is FALSE.}

\item{...}{Additional parameters supported by geodata::elevation_3s}
}
\value{
RasterLayer object with SRTM data
}
\description{
SRTM data is automatically downloaded and, in case of more than one SRTM tile, 
merged together as a mosaic.
The SRTM RasterLayer Object can be cropped to the geographical extent of 
the data (crop = TRUE).
SRTM source: https://srtm.csi.cgiar.org/
}
