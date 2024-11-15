# Function to get expired passwords and export to CSV
function Get-ExpiredPasswords {
    param (
        [string]$OutputPath = "C:\Reports\ExpiredPasswords.csv"
    )
    
    $Users = Get-ADUser -Filter {Enabled -eq $true -and PasswordExpired -eq $true} `
    -Properties PasswordLastSet, PasswordExpired, EmailAddress, Department |
    Select-Object Name, SamAccountName, EmailAddress, Department, PasswordLastSet
    
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}