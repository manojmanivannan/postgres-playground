@echo off
setlocal enabledelayedexpansion

rem Define the URL to download
set URL=https://data.lacity.org/api/views/2nrs-mtv8/rows.csv\?accessType\=DOWNLOAD

rem Windows Command Prompt command to download the file using curl
curl -o ./dataset/csv/crime_data.csv  "!URL!"

if !errorlevel! equ 0 (
  echo File downloaded successfully.
) else (
  echo File download failed.
)
