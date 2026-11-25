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

#import data
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
      "created_department = '311 City Services'", #Data was entered by 311 services
      "AND created_date >= '2026-01-01T00:00:00'", #Created first 6 months of 2026
      "AND created_date < '2026-06-02T00:00:00'", 
      "AND closed_date >= '2026-01-01T00:00:00'", 
      "AND closed_date < '2026-06-02T00:00:00'", #Closed first 6 months of 2026
      "AND community_area IS NOT NULL" #No null values in this column
    ),
    "$limit" = 10000
  )
)
stop_for_status(response)

data <- fromJSON(content(response, "text", encoding = "UTF-8"))

#clean data
data <- data[, !names(data) %in% c(
  "sr_short_code", #no need for this column
  "electrivity_grid", #no need for this column
  "parent_sr_number" #no need for this column
)]

#Evaluating data quality and fairness
table(data$community_area) #community area #28 is an outlier with 4942 service requests
table(data$sr_type) #311 information only call is by far the most popular

