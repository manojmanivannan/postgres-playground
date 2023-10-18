@echo off
setlocal enabledelayedexpansion

if not exist dataset\csv\crime_data.csv (
	rem Windows Command Prompt command to download the file using curl
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://data.lacity.org/api/views/2nrs-mtv8/rows.csv\?accessType\=DOWNLOAD', 'dataset\csv\crime_data.csv')"
	if !errorlevel! equ 0 (
		echo Crime data downloaded successfully.
	) else (
		echo Crime data download failed.
	)
) else (
	echo "crime_data.csv already exists"
)

if not exist dataset\csv\athlete_events.csv (
	rem Windows Command Prompt command to download the file using curl
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://techtfq.com/s/Olympics_data.zip', 'dataset\csv\Olympics_data.zip')"
	if !errorlevel! equ 0 (
		echo Olympics data downloaded successfully.
		powershell -Command "Expand-Archive 'dataset\csv\Olympics_data.zip' 'dataset\csv'"
	) else (
		echo Olympics data download failed.
	)
) else (
	echo "athlete_events.csv already exists"
)

if not exist dataset\csv\scrabble_games.csv (
	rem Windows Command Prompt command to download the file using curl
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://media.githubusercontent.com/media/fivethirtyeight/data/master/scrabble-games/scrabble_games.csv', 'dataset\csv\scrabble_games.csv')"
	if !errorlevel! equ 0 (
		echo scrabble data downloaded successfully.
	) else (
		echo scrabble data download failed.
	)
) else (
	echo "scrabble_games.csv already exists"
)
