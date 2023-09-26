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
