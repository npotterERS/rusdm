#' @export
usdm_areas <- list(
  `National` = "USStatistics",
  `USDA Climate Hubs` = "ClimateHubStatistics",
  `Regional Drought Early Warning Systems (RDEWS)` = "RegionalDroughtEarlyWarningSystemStatistics",
  `Consecutive Weeks` = "ConsecutiveNonConsecutiveStatistics",
  `Counties` = "CountyStatistics",
  `States` = "StateStatistics",
  `National Weather Service Weather Forecast Offices (WFOs)` = "WeatherForecastOfficeStatistics",
  `U.S. Army Corps of Engineers Districts` = "USACEDistrictStatistics",
  `U.S. Army Corps of Engineers Divisions` = "USACEDivisionStatistics",
  `U.S. Urban Areas` = "UrbanAreaStatistics",
  `River Forecast Centers` = "RiverForecastCenterStatistics",
  `Regional Climate Center Regions` = "RegionalClimateCenterStatistics",
  `National Weather Service Regions` = "NWSRegionStatistics",
  `Hydrologic Units (HUCs)` = "HUCStatistics",
  `FEMA Regions` = "FEMARegionStatistics",
  `Climate Divisions` = "ClimateDivisionStatistics",
  `Tribal Areas` = "TribalStatistics")

#' @export
usdm_stats <- list(
  `Area` = "GetDroughtSeverityStatisticsByArea",
  `Percent of Area` = "GetDroughtSeverityStatisticsByAreaPercent",
  `Population` = "GetDroughtSeverityStatisticsByPopulation",
  `Percent of Population` = "GetDroughtSeverityStatisticsByPopulationPercent",
  `DSCI` = "GetDSCI",
  `Consecutive Weeks` = "GetConsecutiveWeeksCounty",
  `NonConsecutive Weeks` = "GetNonConsecutiveStatisticsCounty"
)

#' @export
parameter_is_valid <- function(x, xlist) {
  x <- ifelse(x %in% names(xlist), xlist[[x]], x)
  if(!(x %in% xlist)) {
    stop(x,
         " is not a valid value. Please see `usdm_areas`",
         " or `usdm_stats` for a list of valid area or stat values.")
  }
}
date_is_valid <- function(x) {
  TRUE
}

char_to_num <- function(x) { as.numeric(gsub(",", "", x)) }

