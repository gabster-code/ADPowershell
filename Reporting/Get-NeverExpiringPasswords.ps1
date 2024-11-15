# Function to get users with never expiring passwords
function Get-NeverExpiringPasswords {
    param (
        [string]$OutputPath = "C:\Reports\NeverExpiringPasswords.csv"
    )
    
    $Users = Get-ADUser -Filter { PasswordNeverExpires -eq $true -and Enabled -eq $true } `
    -Properties PasswordNeverExpires, PasswordLastSet, Title, Department, Manager |
    Select-Object Name, SamAccountName, Title, Department, Manager, PasswordLastSet
    
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}