#' Get USDM data
#'
#' This is the generic query function to get data using the US Drought Monitor's
#' api. There are five statistics for which to query drought classifications,
#' each of which has an associated function that wraps this function. For
#' the area in each drought classification, use [usdm_area()]. For the percent
#' of area, use [usdm_areapercent()]. For population and percent of population
#' use [usdm_population()] and [usdm_populationpercent()]. Use [usdm_dcsi()] for
#' the DSCI.
#'
#' @param area the area of data to query. See [usdm_areas].
#' @param stat the statistic to query. See [usdm_stats].
#' @param aoi Area of interest to query. This depends on the `area`, and is
#'   generally the ID number of the area of interest. If `area = National`,
#'   `conus` queries the contiguous U.S., `total` queries the total U.S., and
#'   `us` queries both. States are the two-digit FIPS code. Counties are the
#'   five-digit FIPS code, or the two-letter state abbreviation in order to get
#'   all counties in a state. See the [USDM API](https://droughtmonitor.unl.edu/DmData/DataDownload/WebServiceInfo.aspx)
#'   for details.
#' @param startdate the start date for the query, formatted as `M/D/YYYY`, e.g.
#'   "1/1/2012" or "12/31/2024".
#' @param enddate the end date for the query, formatted as `M/D/YYYY`, e.g.
#'   "1/1/2012" or "12/31/2024".
#' @param dx minimum drought level from 0 to 4, corresponding to drought categories D0-D4.
#' @param DxLevelThresholdFrom minimum drought threshold to be considered "drought", from 0-4.
#' @param DxLevelThresholdTo maximum drought threshold to be considered "drought", from 0-4.
#' @param minimumweeks minimum number of weeks to be considered a drought. Only
#'   applicable for [usdm_weeks()] or `area = ConsecutiveNonConsecutiveStatistics`.
#' @param hucLevel The watershed (HUC) resolution. Either 2, 4, 6, or 8. Only applies
#'   if `area = HUCStatistics`.
#' @param statisticsType either "traditional" or "categorical".
#' @param progress_bar whether to display a download progress bar.
#' @param format the format of data returned, either "CSV", "XML", or "JSON".
#' @return a data.frame or unparsed object.
#' @seealso wrappers [usdm_area()], [usdm_areapercent()], [usdm_population()],
#'   [usdm_populationpercent()], [usdm_dcsi()] for querying specific statistics.
usdm <- function(area, stat, aoi = NULL, startdate, enddate,
                 dx = NULL, DxLevelThresholdFrom = NULL,
                 DxLevelThresholdTo = NULL, minimumweeks=NULL,
                 hucLevel = NULL,
                 statisticsType = c("traditional", "categorical"),
                 progress_bar = TRUE,
                 format = "CSV") {
  statisticsType <- match.arg(statisticsType)
  statisticsType <- ifelse(statisticsType == "traditional", 1, 2)

  # Check parameter validity
  date_is_valid(startdate)
  date_is_valid(enddate)
  parameter_is_valid(area, usdm_areas)
  parameter_is_valid(stat, usdm_stats)

  api_path <- paste0(area, "/", stat)

  params <- list(startdate = startdate,
                 enddate = enddate,
                 dx = dx,
                 DxLevelThresholdFrom = DxLevelThresholdFrom,
                 DxLevelThresholdTo = DxLevelThresholdTo,
                 minimumweeks = minimumweeks,
                 statisticsType = statisticsType,
                 hucLevel = hucLevel)

  if(!is.null(dx)) { parameter_is_valid(dx, 0:4) }

  if(!is.null(hucLevel)) {
    parameter_is_valid(hucLevel, c(2,4,6,8))
    params[["hucLevel"]] <- hucLevel
  }

  params$aoi <- aoi
  res <- usdm_GET(params, api_path,
                  progress_bar = progress_bar,
                  format = format)
  x <- usdm_check(res)
  if("error" %in% class(x)) { stop() } else { usdm_parse(res) }
}


#' Send a query to the US Drought Monitor API.
#'
#' @param params a named list of parameters composed of `aoi`, `startdate`,
#'   `enddate`, `statisticsType`, and `hucLevel`, which are set by the
#'   corresponding parameters in [usdm()].
#' @param api_path (char) api path set by <`area`/`stat`> in [usdm()].
#' @param progress_bar whether to display a download progress bar.
#' @param format the format of data returned, either "CSV", "XML", or "JSON".
#' @return an httr response object.
usdm_GET <- function(params,
                     api_path,
                     progress_bar = TRUE,
                     format = c("CSV", "JSON", "XML")) {
  format <- match.arg(format)
  if(format == "CSV") format <- "text/csv"
  #  url <- "https://usdmdataservices.unl.edu/api/[area]/[statistics type]?aoi=[aoi]&startdate=[start date]&enddate=[end date]&statisticsType=[statistics type]&hucLevel=[huc]"
  url <- paste0("https://usdmdataservices.unl.edu/api/", api_path)

  query <- params

  if(progress_bar) {
    resp <- httr::GET(url, query = query, httr::accept(format), httr::progress())
  } else {
    resp <- httr::GET(url, query = query, httr::accept(format))
  }
}


#' Check a query response.
#'
#' @param response a [httr::GET()] request result returned from the API.
#' @return nothing if check is passed, or an informative error if not passed.
usdm_check <- function(response) {
  if(response$status_code < 400) {
    return(TRUE) #all good!
  }
  # else if(response$status_code == 413) {
  #   stop("Request was too large. NASS requires that an API call ",
  #        "returns a maximum of 50,000 records. Consider subsetting ",
  #        "your request by geography or year to reduce the size of ",
  #        "your query.", call. = FALSE)
  # }
  else {
    return(response)
    # stop("HTTP Failure: ",
    #      response$status_code,
    #      "\n",
    #      jsonlite::fromJSON(httr::content(response,
    #                                       as = "text",
    #                                       type = "text/json",
    #                                       encoding = "UTF-8")),
    #      call. = FALSE)
  }
}



#' Parse a query from the US Drought Monitor API.
#'
#' @param req a request made by [httr::GET()].
#' @param as_numeric convert dates and numerics from character to date and
#'   numeric format.
#' @param as whether to parse the request as a data.frame, list, or plain text.
#' @param ... additional parameters for [read.csv()] or
#'   [jsonlite::parse_json()].
#' @return a data.frame, list, or plain text object.
usdm_parse <- function(req,
                       as_numeric = TRUE,
                       as = c("data.frame", "list", "text"),
                       ...) {
  as = match.arg(as)

  type <- req$headers[['content-type']]
  resp <- httr::content(req, as = "text", encoding = "UTF-8")

  # process the data depending on returned data type
  if(as == "text") {
    ret <- resp
  } else if(type %in% c("application/json", "application/json; charset=UTF-8")) {
    # format == JSON
    # Handle error where response is truncated if too long (only happens)
    # when making a call to the "get_param_values" api_path for 'domaincat_desc'
    ret <- tryCatch(jsonlite::fromJSON(resp),
                    error = function(e) {
                      stop("JSON is malformed. This is a problem with ",
                           "the USDM API, not the rusdm ",
                           "package. \n",
                           e) })
    if("data" %in% names(ret)) ret <- ret$data

  } else if(type %in% c("application/xml", "application/xml; charset=UTF-8")) {
    # format == XML
    stop("XML not yet implemented. Use format = 'JSON' or format = ",
         "'CSV' instead.")
  } else if(type %in% c("text/csv", "text/csv; charset=UTF-8")) {
    # format == CSV
    ret <- read.csv(text = resp, sep = ",", header = TRUE,
                    colClasses = "character", ...)
    names(ret)[which(names(ret) == "CV....")] <- "CV (%)"
  } else {
    stop("Response is not in the expected json, xml, or csv format. ",
         "Use `as = 'text'` to see the unparsed response data, or ",
         "modify your parameters to include `format = 'json'` to ",
         "make the request in json.")
  }

  if(as_numeric & as == "data.frame") {
    date_vars <- c("ValidStart", "ValidEnd", "StartDate", "EndDate")
    for(dv in date_vars) {
      if(dv %in% names(ret)) ret[[dv]] <- as.Date(ret[[dv]], format = "%Y-%m-%d")
    }
    if("MapDate" %in% names(ret)) ret[["MapDate"]] <- as.Date(ret[["MapDate"]], format = "%Y%m%d")
    if("StatisticFormatID" %in% names(ret)) {
      ret$StatisticFormatID <- factor(ret$StatisticFormatID,
                                      levels = c(1,2),
                                      labels = c("traditional", "categorical"))
    }

    num_vars <- c("None", "D0", "D1", "D2", "D3", "D4", "ConsecutiveWeeks")
    for(v in num_vars) {
      if(v %in% names(ret)) ret[[v]] <- char_to_num(ret[[v]])
    }
  }

  ret
}

