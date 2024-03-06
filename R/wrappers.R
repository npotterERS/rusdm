#' Get the area in different drought classifications.
#'
#'
#' @export
#'
#' @param ... arguments passed to [usdm()].
#' @return a data.frame or other response from the USDM API.
usdm_area <- function(...) {
  usdm(stat = "GetDroughtSeverityStatisticsByArea", ...)
}

#' Get the percent of area in different drought classifications.
#'
#'
#' @export
#'
#' @param ... arguments passed to [usdm()].
#' @return a data.frame or other response from the USDM API.
usdm_areapercent <- function(...) {
  usdm(stat = "GetDroughtSeverityStatisticsByAreaPercent", ...)
}

#' Get the population of area in different drought classifications.
#'
#'
#' @export
#'
#' @param ... arguments passed to [usdm()].
#' @return a data.frame or other response from the USDM API.
usdm_population <- function(...) {
  usdm(stat = "GetDroughtSeverityStatisticsByPopulation", ...)
}

#' Get the percent of population in different drought classifications.
#'
#'
#' @export
#'
#' @param ... arguments passed to [usdm()].
#' @return a data.frame or other response from the USDM API.
usdm_populationpercent <- function(...) {
  usdm(stat = "GetDroughtSeverityStatisticsByPopulationPercent", ...)
}

#' Get the DSCI in different drought classifications.
#'
#'
#' @export
#'
#' @param ... arguments passed to [usdm()].
#' @return a data.frame or other response from the USDM API.
usdm_dsci <- function(...) {
  usdm(stat = "GetDSCI", ...)
}

#' Get consecutive or non-consecutive weeks in a drought category.
#'
#' @export
#'
#' @param consecutive whether to query consecutive or non-consecutive weeks.
#' @param ... arguments passed to [usdm()].
#' @return a data.frame or other response from the USDM API.
usdm_weeks <- function(..., consecutive = TRUE) {
  stat <- ifelse(consecutive == TRUE,
                 "GetConsecutiveWeeksCounty",
                 "GetNonConsecutiveStatisticsCounty")

  usdm(area = "ConsecutiveNonConsecutiveStatistics", stat = stat, ...)
}

