# Import the Active Directory module
Import-Module ActiveDirectory

# Define the time period for inactivity (180 days)
$inactivityPeriod = (Get-Date).AddDays(-180)

# Retrieve all computers that have not logged in since the specified period
$inactiveLaptops = Get-ADComputer -Filter {LastLogonDate -lt $inactivityPeriod} -Property LastLogonDate | Select-Object Name, @{Name="LastLogonDaysAgo"; Expression={((Get-Date) - $_.LastLogonDate).Days}}

# Retrieve all users that have not logged in since the specified period
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $inactivityPeriod -and Enabled -eq $true} -Property LastLogonDate | Select-Object SamAccountName, Name, @{Name="LastLogonDaysAgo"; Expression={((Get-Date) - $_.LastLogonDate).Days}}

# Output the results
Write-Host "Inactive Laptops:"
$inactiveLaptops | Format-Table -AutoSize
$inactiveLaptops | Export-Csv -Path "InactiveLaptops.csv" -NoTypeInformation

Write-Host "`nInactive Users:"
$inactiveUsers | Format-Table -AutoSize
$inactiveUsers | Export-Csv -Path "InactiveUsers.csv" -NoTypeInformation
