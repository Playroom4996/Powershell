# Load Active Directory Module
Import-Module ActiveDirectory

# Get user information
$firstName = Read-Host "Enter the first name of the user"
$lastName = Read-Host "Enter the last name of the user"

# Convert the first character of first name to lower case and concatenate with the lowercase last name
$firstInitial = $firstName.Substring(0,1).ToLower()  # Extracts the first character and converts it to lower case
$lastNameLower = $lastName.ToLower()  # Converts the whole last name to lower case

$userPrincipalName = "$firstInitial$lastNameLower@test.lan"
$samAccountName = "$firstInitial$lastNameLower"

# Set a default password
$defaultPassword = "Password@1"
$securePassword = ConvertTo-SecureString $defaultPassword -AsPlainText -Force

# Create the new user in the "Users" container
New-ADUser -Name "$firstName $lastName" -GivenName "$firstName" -Surname "$lastName" -SamAccountName $samAccountName -UserPrincipalName $userPrincipalName -AccountPassword $securePassword -Path "CN=Users,DC=test,DC=lan" -Enabled $true

Write-Host "User $samAccountName has been successfully created and added to the Users container."
