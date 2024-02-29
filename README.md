# SLCC-Unique-Logins-Report
### Authors
- Harrison Smith, can be reached at harrison@hsmith.dev or hsmit154@slcc.edu
- Tyson Potter, can be reached at tpotte20@slcc.edu

### Description
This is a PowerShell script intended for use at Salt Lake Community College which takes in a CSV file containing login DateTimes and Usernames, this will export a CSV file with the counts for each day of unique logins and a total number of unique logins a month.

## Download the script
First download the [daily-unique-user-report.ps1](https://github.com/hsmith-dev/Unique-Logins-Report/blob/main/daily-unique-user-report.ps1).

## Run the script
Then right click the file, and choose `Run with Powershell`.

### Select the CSV file you would like to run a report on
The script will then prompt you to select a CSV file in the formatting provided from this [sample file](https://github.com/hsmith-dev/Unique-Logins-Report/blob/main/Data.csv).
Please select the CSV file you are wanting to run this report on. It will save this report on the Desktop labeled `unique-users-monthly-report.csv`.

### Save the CSV Report File
The script will then prompt you to select a location and name of the results of the report. The layout will match the [Results.csv](https://github.com/hsmith-dev/Unique-Logins-Report/blob/main/Results.csv).

## Viewing the report in Excel
The report will then be viewable in Excel and will display the report generated from the sample `Data.csv` file.

### Setup filter
To order the dates select the top cells, choose `Sort & Filter` then choose `Filter`.

### Filter the data
You can then choose the new dropdown arrow next to the `Date` cell and see all the options to filter the data.
Choosing `Sort Newest to Oldest` will display the data with the monthly unique login total at the top.
