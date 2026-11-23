install.packages(c("httr", "jsonlite"))

#Libraries
library(httr)
library(jsonlite)
library(dbplyr)
library(tidyverse)
library(readr)
library(tidygeocoder)
library(leaflet)
library(sf)
library(ggplot2)


dataset_id <- "v6vf-nfxy"
url <- paste0(
  "https://data.cityofchicago.org/resource/",
  dataset_id,
  ".json"
)

response <- GET(
  url,
  query = list(
    "$where" = paste(
      "created_department = '311 City Services'",
      "AND created_date >= '2026-01-01T00:00:00'",
      "AND created_date < '2026-06-02T00:00:00'",
      "AND closed_date >= '2026-01-01T00:00:00'",
      "AND closed_date < '2026-06-02T00:00:00'",
      "AND community_area IS NOT NULL"
    ),
    "$limit" = 10000
  )
)
stop_for_status(response)

data <- fromJSON(content(response, "text", encoding = "UTF-8"))


