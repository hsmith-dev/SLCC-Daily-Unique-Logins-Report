<#
# Author: Harrison Smith - hsmit154@slcc.edu (Lab Aide, AI & Robotics Instructor for Verizon Innovative Learning)
# Author: Tyson Potter - tpotte20@slcc.edu (Lab Aide)
# If you need any other scripts please reach out to one of our emails.
# Date Created: February 28, 2024
 
# DESCRIPTION
# This is a PowerShell script intended for use at 
# Salt Lake Community College which takes in a CSV file 
# containing login DateTimes and Usernames, this will 
# export a CSV file with the counts for each day of unique
# logins and a total number of unique logins a month

# STEPS TO RUN
# 1. Download the 'daily-unique-user-report.ps1' to your desktop.
# 2. Right the script and choose "Run with PowerShell".
# 3. Select the CSV file you would like to analyze and choose "Open".
# 4. A new dialogue box will pop open, asking you where you would like to
#   save and name the file. This file will be exported as a CSV file.
# 5. Open the CSV file you saved, and filter the data as needed.

# VIEWING THE RESULT
# Inside the CSV file you will find:
#   - the Unique Logins for each day
#   - the Sum of the Unique each day for the month.
#
# You may need to "Sort & Filter" the columns to order the days of the month.
# You may also need to expand the column to show the complete data.
#>
 
# Prompt the user to select a CSV file
Add-Type -AssemblyName System.Windows.Forms
$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
$openFileDialog.Filter = 'CSV files (*.csv)|*.csv'
$dialogResult = $openFileDialog.ShowDialog()
 
# Check if the user selected a file
if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
    $csvPath = $openFileDialog.FileName
 
    # Read the CSV file
    $csvData = Import-Csv -Path $csvPath
 
    # Initialize a hashtable for daily unique users and monthly totals
    $dailyUsers = @{}
    $monthlyTotals = @{}
 
    foreach ($row in $csvData) {
        # Try to extract and parse the date part of "Launch Time"
        $dateString = $row.'Launch Time'.Split(' ')[0]
 
        if ([string]::IsNullOrWhiteSpace($dateString)) {
            Write-Output "Skipping row with empty 'Launch Time'"
            continue
        }
 
        try {
            # Attempt to parse the date without specifying an exact format
            $date = [datetime]::Parse($dateString, [Globalization.CultureInfo]::InvariantCulture)
            $dateKey = $date.ToString('yyyy-MM-dd')
            $monthKey = $date.ToString('yyyy-MM')
 
            # Update daily unique users
            if (-not $dailyUsers.ContainsKey($dateKey)) {
                $dailyUsers[$dateKey] = New-Object System.Collections.Generic.HashSet[string]
            }
            $result = $dailyUsers[$dateKey].Add($row.'Associated User')
 
            # Update monthly totals
            if ($result) { # Only increment if a new user was added for the day
                if (-not $monthlyTotals.ContainsKey($monthKey)) {
                    $monthlyTotals[$monthKey] = 0
                }
                $monthlyTotals[$monthKey]++
            }
        } catch {
            Write-Output "Error parsing date for 'Launch Time' value: $dateString"
        }
    }
 
    # Prepare data for CSV export
    $csvDataForExport = @()
 
    # Add daily counts to the export data
    foreach ($dateKey in $dailyUsers.Keys) {
        $csvDataForExport += [PSCustomObject]@{
            Date = $dateKey
            "Unique Users" = $dailyUsers[$dateKey].Count
            Type = "Daily"
        }
    }
 
    # Add monthly totals to the export data
    foreach ($monthKey in $monthlyTotals.Keys) {
        $csvDataForExport += [PSCustomObject]@{
            Date = $monthKey
            "Unique Users" = $monthlyTotals[$monthKey]
            Type = "Monthly"
        }
    }
 
    # Use SaveFileDialog to ask user for export file name
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $saveFileDialog.Filter = 'CSV files (*.csv)|*.csv'
    $saveFileDialog.FileName = "unique-users-monthly-report.csv" # Default file name
    $saveDialogResult = $saveFileDialog.ShowDialog()
 
    if ($saveDialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        $exportPath = $saveFileDialog.FileName
 
        # Export to CSV
        $csvDataForExport | Export-Csv -Path $exportPath -NoTypeInformation -Force
        Write-Output "Exported to '$exportPath'"
    } else {
        Write-Output "Export cancelled."
    }
} else {
    Write-Output "No file was selected."
}