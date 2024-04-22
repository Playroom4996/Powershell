# Load Active Directory Module
Import-Module ActiveDirectory

# Specify the user's SAM account name
$samAccountName = Read-Host "Enter the SAM account name of the user whose password you want to reset"

# Specify the new password
$newPassword = "Password@1" | ConvertTo-SecureString -AsPlainText -Force

# Specify the confirmation password
$confirmPassword = $newPassword

# Check if both entered passwords match (optional)
#if ($newPassword -ceq $confirmPassword) {
try {
    # Attempt to reset the user's password and enforce password change at next logon
    Set-ADAccountPassword -Identity $samAccountName -NewPassword $newPassword -Reset -PassThru |
        Set-ADUser -ChangePasswordAtLogon $true
    Write-Host "Password reset successfully for user: $samAccountName. User will be prompted to change the password upon next login."
}
catch {
    Write-Error "Failed to reset password: $_"
}
#}
#else {
#    Write-Host "Passwords do not match. Please retry the operation."
#}
