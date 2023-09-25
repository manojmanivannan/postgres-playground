#!/bin/bash

echo -e "Downloading Los Angeles crime data from data.gov"
curl -o ./dataset/csv/crime_data.csv https://data.lacity.org/api/views/2nrs-mtv8/rows.csv\?accessType\=DOWNLOAD

if [ $? -eq 0 ]
then
  echo "Download complete"
else
  echo "Download failed"
  exit 1
fi
