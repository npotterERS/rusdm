
test_that("usdm_GET() obtains a proper request", {
  params <- list(aoi = "conus", startdate = "1/1/2023", enddate = "12/31/2024", statisticsType = 1)
  r <- usdm_GET(params, api_path = paste0("USStatistics", "/", "GetDroughtSeverityStatisticsByArea"))

  params <- list(aoi = "18", startdate = "1/1/2023", enddate = "12/31/2024", statisticsType = 1, hucLevel = 2)
  r <- usdm_GET(params, api_path = paste0("HUCStatistics", "/", "GetDroughtSeverityStatisticsByArea"))

  params <- list(aoi = "AZ", startdate = "1/1/2023", enddate = "12/31/2024",
                 dx = "1", minimumweeks=1)
  r <- usdm_GET(params, api_path = "ConsecutiveNonConsecutiveStatistics/GetConsecutiveWeeksCounty")

})

test_that("usdm_area()", {
  d <- usdm_area(area = "USStatistics", aoi = "conus", startdate = "1/1/2023", enddate = "12/31/2024")
  d <- rusdm::usdm_area(area = "HUCStatistics", aoi = 1:2,
                        startdate = "1/1/2023", enddate = "12/31/2023", huc_level = "2")
})

test_that("usdm_area()", {
  d <- rusdm::usdm_area(area = "HUCStatistics", aoi = 1:2,
                        startdate = "1/1/2023", enddate = "12/31/2023", huc_level = "2")
})

test_that("usdm_week()", {
  d <- usdm_weeks(startdate = "1/1/2000", enddate = "12/31/2024",
                  dx = "2", minimumweeks = 4, consecutive = FALSE)

})
