# Function to get locked out accounts
function Get-LockedAccounts {
    param (
        [string]$OutputPath = "C:\Reports\LockedAccounts.csv"
    )
    
    $LockedUsers = Search-ADAccount -LockedOut |
    Get-ADUser -Properties LastLogonTimeStamp, EmailAddress, Department, LockedOut |
    Select-Object Name, SamAccountName, EmailAddress, Department,
    @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}}
    
    $LockedUsers | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}