#!/bin/bash

if ! [ -f ./dataset/csv/crime_data.csv ]
then
	echo -e "Downloading Los Angeles crime data from data.gov"
	curl -s -o ./dataset/csv/crime_data.csv https://data.lacity.org/api/views/2nrs-mtv8/rows.csv\?accessType\=DOWNLOAD

	if [ $? -eq 0 ]
	then
		echo "Download complete"
	else
		echo "Download failed"
		exit 1
	fi
else
	echo -e "crime data already exists"
fi

if ! [ -f ./dataset/csv/athlete_events.csv ]
then
	echo -e "Downloading Olympics history data from techtfq.com"
	wget -o ./dataset/csv/Olympics_data.zip https://techtfq.com/s/Olympics_data.zip

	if [ $? -eq 0 ]
	then
		echo "Download complete"
		unzip -o -d ./dataset/csv/ ./dataset/csv/Olympics_data.zip
	else
		echo "Download failed"
		exit 1
	fi
else
	echo -e "Olympics data already exists"
fi
