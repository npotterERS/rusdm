<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->
<table class="table">
<thead>
<tr class="header">
<th align="left">
rnassqs
</th>
<th align="left">
Usage
</th>
<th align="left">
Release
</th>
<th align="left">
Development
</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td rowspan="5">
</td>
<td align="left">
<a href="https://choosealicense.com/licenses/mit/"><img src="https://img.shields.io/github/license/mashape/apistatus.svg" alt="License"></a>
</td>
<td align="left">
</td>
<td align="left">
<a href="https://github.com/potterzot/rusdm/commits/master"><img src="https://img.shields.io/badge/last%20change-2024--03--06-brightgreen.svg" alt="Last Change"></a>
</td>
</tr>
<tr class="even">
<td align="left">
</td>
<td align="left">
</td>
<td align="left">
[![R-CMD-check](https://github.com/potterzot/rusdm/workflows/R-CMD-check/badge.svg)](https://github.com/potterzot/rusdm/actions)
</td>
</tr>
<tr class="odd">
<td align="left">
</td>
<td align="left">
</td>
<td align="left">
<a href="https://travis-ci.org/potterzot/rusdm"><img src="https://travis-ci.org/potterzot/rusdm.svg?branch=master" alt="Build Status"></a>
</td>
</tr>
<tr class="even">
<td align="left">
</td>
<td align="left">
<a href="https://orcid.org/0000-0002-3410-3732"><img src="https://img.shields.io/badge/ORCiD-0000--0002--3410--3732-green.svg" alt="ORCID"></a>
</td>
<td align="left">
<a href="https://app.codecov.io/gh/potterzot/rusdm"><img src="https://app.codecov.io/gh/potterzot/rusdm/branch/master/graph/badge.svg" alt="Coverage Status"></a>
</td>
</tr>
<tr class="even">
<td align="left">
</td>
<td align="left">
</td>
<td align="left">
<a href="https://www.repostatus.org/#wip"><img src="https://www.repostatus.org/badges/latest/wip.svg" alt="Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public." /></a>
</td>
</tr>
<tr class="odd">
<td align="left">
</td>
<td align="left">
</td>
<td align="left">
<a href="https://lifecycle.r-lib.org/articles/stages.html#experimental"><img src="https://img.shields.io/badge/lifecycle-experimental-orange.svg" alt="Project Status: Experimental." /></a>
</td>
</tr>
</tbody>
</table>

<br>

**This product is not endorsed by the U.S. Drought Monitor**

## rusdm (R US Drought Monitor)

`rusdm` allows users to access the U.S. Drought Monitor’s data through
their API.

## Installing

Install the package via `devtools`:

``` r
    # Via devtools
    library(devtools)
    devtools::install_github('potterzot/rusdm')
```

## Usage

There are several query functions based on the statistics that you are
interested in. These are:

- `usdm_area()`: Get the area under each drought classification.
- `usdm_areapercent()`: Get the percent of area under each drought
  classification.
- `usdm_population()`: Get the population under each drought
  classification.
- `usdm_populationpercent()`: Get the percent of population under each
  drought classiciation.
- `usdm_dsci()`: Get drought severity and coverage index (DSCI).
- `usdm_weeks()`: Get the consecutive or non-consecutive weeks at or
  above a drought classificaiton.

For example, to get the percent of area in each drought classification
for the contiguous US:

``` r
    library(rusdm)

    usdm_areapercent(area = "National", aoi = "conus", startdate = "1/1/2023", enddate = "12/31/2023")
```

The `area` parameter sets the regional level to query. In addition to
`National`, users can query by `USDA Climate Hubs`, `Counties`,
`States`, `Hydrologic Units (HUCs)`, `Tribal Areas` or other regions.
See `usdm_areas` for a list of possible options.

The `aoi` parameter sets the specific area to query. Appropriate values
vary according to area, but if `area` is `States` or `Counties`, then
`aoi` should be the 2-digit or 5-digit fips code. The 2-letter state
abbreviation can also be used to query all counties in the state. See
the [USDM API
documentation](https://droughtmonitor.unl.edu/DmData/DataDownload/WebServiceInfo.aspx)
for more information.

### Examples

``` r
    # Get the area under each drought classification for all counties in Colorado for 2023
    usdm_area(area = "Counties", aoi = "CO", startdate = "1/1/2023", enddate = "12/31/2023")
```

``` r
    # Get all weeks with a drought classification of at least 2 for all counties and years since 2000
    usdm_weeks(startdate = "1/1/2000", enddate = "12/31/2023", 
               dx = "2", minimumweeks = 1, consecutive = FALSE)
```

``` r
    # Get area in each drought category by HUC6 within HUC2 = 17 for 2000
    rusdm::usdm_population(area = "HUCStatistics", aoi = "17",
                           startdate = "1/1/2000", enddate = "12/31/2000", 
                           hucLevel = "6")
```

## Contributing

Contributions are more than welcome, and there are several ways to
contribute:

- Examples: More examples are always helpful. If you use `rusdm` to
  query data from the US Drought Monitor and would like to contribute
  your query, consider submitting a pull request adding your query as a
  file in
  [inst/examples/](https://github.com/potterzot/rusdm/tree/main/inst/examples).
- File an issue: If there is functionality you’d like to see added or
  something that is confusing, consider [creating an
  issue](https://github.com/potterzot/rusdm/issues/new). The best issue
  contains an example of the problem or feature. Consider the excellent
  package [reprex](https://github.com/tidyverse/reprex) in creating a
  reproducible example.
- Contributing documentation: Clarifying and expanding the documentation
  is always appreciated, especially if you find an area that is lacking
  and would like to improve it. `rusdm` uses roxygen2, which means the
  documentation is at the top of each function definition. Please submit
  any improvements as a pull request.
- Contributing code: if you see something that needs improving and you’d
  like to make the changes, contributed code is very welcome. Begin by
  filing a new issue to discuss the proposed change, and then submit a
  pull request to address the issue. `rusdm` follows the style outlined
  in Hadley Wickham’s [R
  Packages](https://r-pkgs.org/code.html#code-style). Following this
  style makes the pull request and review go more smoothly.

## Alternatives

Download the data via the [U.S. Drought Monitor web
interface](https://droughtmonitor.unl.edu/Data.aspx).
