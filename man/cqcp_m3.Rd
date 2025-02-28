% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cqcp_filter.R
\name{cqcp_m3}
\alias{cqcp_m3}
\title{Main QC step m3}
\usage{
cqcp_m3(data, cutOff = 0.2, complete = FALSE, duration = NULL, quiet = FALSE)
}
\arguments{
\item{data}{data.table object as returned by cqcp_m2}

\item{cutOff}{Value above which data are flagged with FALSE, 0 < cutOff < 1.
Default is 0.2, i.e., 20 percent of data.}

\item{complete}{Set to TRUE to use the complete data set for the filter 
(priority over 'duration').}

\item{duration}{A fixed duration to be used (cf. lubridate duration documentation).
This can be, e.g., '10 days'.}

\item{quiet}{Suppress messages by CrowdQC+. Default: FALSE}
}
\value{
data.table
}
\description{
Flag values with FALSE if more than cutOff percent values are removed during
m2. This is done since it is assumed that if too many individual
values are flagged FALSE in m2, the station is too suspicious to be kept.
Default is to apply m3 per month, but can be changed to use the complete data
set (e.g. for short data sets, 'complete = T'), or some other fixed duration 
(e.g. 'duration = "10 days"').
}
