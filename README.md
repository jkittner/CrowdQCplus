# CrowdQC+

This R package performs a quality control (QC) and filters suspicious data from citizen weather stations (CWS). It is based on the package ['CrowdQC'](http://dx.doi.org/10.14279/depositonce-6740.3) but offers several additions, improvements, and bug fixes. Both packages were originally designed for and tested with air-temperature data but should also work with other near-normally distributed data. It is not designed for precipitation data.

CrowdQC+ is a statistically-based QC that identifies individual possibly faulty observations by comparing them to a large crowd of other observations. It does not need reference meteorological observations to be applied. The main idea of CrowdQC+ is that there is trustworthy information in the crowd, which can be used to check and remove individual values during the QC. Yet, there is no guarantee that all faulty observations are filtered by the QC.

A detailed description of the functionalities and an evaluation of the performance of the QC can be found in this open-access journal article: [CrowdQC+ – A quality-control for crowdsourced air-temperature observations enabling world-wide urban climate applications. Frontiers in Environmental Science](https://doi.org/10.3389/fenvs.2021.720747).<br>
It is recommended that you read the article before you start working with CrowdQC+ to understand its capabilities and limitations.

## Dependencies
CrowdQC+ requires an R version >= 3.5.0 to work.

It also requires the following packages: 
- data.table
- robustbase
- lubridate
- sp
- raster
- rgdal

Make sure to have these installed (and 'data.table' needs to be loaded) before running CrowdQC+.

When installing 'rgdal' package on a Linux system, you might run into issues. Try running 
```
sudo apt-get install gdal-bin proj-bin libgdal-dev libproj-dev
```

first and then again installing rgdal in R with 
```
install.packages("rgdal")
```

For 'older' Linux versions this could also work: 
```
install.packages("rgdal", configure.args = c(rgdal = "--with-proj_api=proj_api.h"))
```

## Installation of the package

**Option 1:**

Directly pull the code from this repository into your programming environment, using the [devtools](https://devtools.r-lib.org/) package:

```
install.packages("devtools")
devtools::install_github("dafenner/CrowdQCplus")
```

**Option 2:**

Download the [zip-file](https://github.com/dafenner/CrowdQCplus/archive/refs/heads/master.zip) from this repository, save it locally, and install it in your programming environment using the [devtools](https://devtools.r-lib.org/) package:
```
install.packages("devtools")
devtools::install_local(<PATH_TO_THE_ZIP_FILE>)
```

**Option 3:**

Download the latest release of CrowdQC+ as a `.tar.gz` file ([list of releases](https://github.com/dafenner/CrowdQCplus/releases)), save it locally, and install it in your programming environment:
```
install.packages(<PATH_TO_THE_tar.gz_FILE>, repos = NULL, type ="source")
```

Once installed, load CrowdQC+ (and data.table) via

```
library(data.table)
library(CrowdQCplus)
```

## Using CrowdQC+
### Data
Data should be represented as a [data.table](https://CRAN.R-project.org/package=data.table) with the following required columns:

`p_id`: Unique ID of each station. Data format: Integer or character<br>
`time`: Time. Keep in mind time zones! Data format: POSIX.ct<br>
`ta`: Air-temperature values (or other near-normally distributed variable). Data format: Numeric/double<br>
`lon`: Longitude of the station. Data format: Numeric/double<br>
`lat`: Latitude of the station. Data format: Numeric/double<br>

Optionally, the user can provide elevation information per station (column `z`), as to perform a height correction in some of the QC levels.
Any other column can be present, but is quietly ignored by CrowdQC+.

This is how an input data table with hourly data of a month should be organised (values completely nonsense and made up):
| p_id | time | ta | lon | lat | z |
| -----| ---- | -- | --- | --- | - |
| 1 | 2021-01-01 00:00 | 7.5 | 12.6789 | 40.5432 | 45 |
| 1 | 2021-01-01 01:00 | 7.3 | 12.6789 | 40.5432 | 45 |
| 1 | 2021-01-01 02:00 | 7.0 | 12.6789 | 40.5432 | 45 |
| 1 | ... | ... | 12.6789 | 40.5432 | 45 |
| 1 | 2021-01-31 23:00 | 16.4 | 12.6789 | 40.5432 | 45 |
| 2 | 2021-01-01 00:00 | 8.1 | 12.6543 | 40.5678 | 48 |
| 2 | 2021-01-01 01:00 | 7.9 | 12.6543 | 40.5678 | 48 |
| 2 | 2021-01-01 02:00 | 7.5 | 12.6543 | 40.5678 | 48 |
| 2 | ... | ... | 12.6543 | 40.5678 | 48 |
| 2 | 2021-01-31 23:00 | 15.3 | 12.6543 | 40.5678 | 48 |
| ... | ... | ... | ... | ... | ... |
| 1896 | 2021-01-01 00:00 | 6.9 | 12.1234 | 40.5666 | 39 |
| 1896 | 2021-01-01 01:00 | 6.8 | 12.1234 | 40.5666 | 39 |
| 1896 | 2021-01-01 02:00 | 6.4 | 12.1234 | 40.5666 | 39 |
| 1896 | ... | ... | 12.1234 | 40.5666 | 39 |
| 1896 | 2021-01-31 23:00 | 17.0 | 12.1234 | 40.5666 | 39 |


### Functionalities
The QC consists of five main QC levels (m1-m5) and four optional levels (o1-o4). Each QC level can be called individually or the complete QC can be applied (`cqcp_qcCWS()`). <br>
Beside the actual QC functions, several helper functions are available to, e.g., add elevation information to each station (`cqcp_add_dem_height()`), check the data.table for compliance with CrowdQC+ (`cqcp_check_input()`), preparation of input data (`cqcp_padding()`) and output simple statistics an data availability after application of the QC (`cqcp_output_statistics()`).

A detailed description of each QC level can be found in the R help and in the corresponding journal article (see details below).

### Example workflow
A basic example workflow with CrowdQC+ could look like this (after installation of the package, see above):
```
# Load libraries
library(data.table)
library(CrowdQCplus)

# Data & input check
data <- <YOUR_CWS_DATA>
ok <- cqcp_check_input(data)

# Perform complete QC
if(ok) {
   data_qc <- cqcp_qcCWS(data) # QC   
   n_data_qc <- cqcp_output_statistics(data_qc) # output statistics
}
```

## How to contribute?
If you are using CrowdQC+ and have ideas how to make it better, improve its performance, resolve errors, please create [issues](https://github.com/dafenner/CrowdQCplus/issues).

## How to obtain CWS data?
To crowdsource CWS data different data providers with application programming interfaces (API) exist, each with advantages and disadvantages, e.g.:
- [Netatmo](https://www.netatmo.com/): [Netatmo Connect API](https://dev.netatmo.com/)
- [Synoptic](https://synopticdata.com/): [Mesonet API](https://developers.synopticdata.com/mesonet/)
- [Weather Observations Website (WOW)](https://www.wow.metoffice.gov.uk/): [WOW API](https://mowowprod.portal.azure-api.net/)

## Reference
Please reference the following open-access journal article when using CrowdQC+:

Fenner, D., Bechtel, B., Demuzere, M., Kittner, J. and Meier, F. (2021): CrowdQC+ – A quality-control for crowdsourced air-temperature observations enabling world-wide urban climate applications. Frontiers in Environmental Science 9: 720747. DOI: [10.3389/fenvs.2021.720747](https://doi.org/10.3389/fenvs.2021.720747).

## Licence
CrowdQC+ is distributed under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0.en.html).

