# Function to get inactive users and export to CSV
function Get-InactiveADUsers {
    param (
        [int]$DaysInactive = 90,
        [string]$OutputPath = "C:\Reports\InactiveUsers.csv"
    )
    
    $InactiveDate = (Get-Date).AddDays(-$DaysInactive)
    
    $Users = Get-ADUser -Filter {
        LastLogonTimeStamp -lt $InactiveDate -and Enabled -eq $true
    } -Properties LastLogonTimeStamp, EmailAddress, Department, Manager |
    Select-Object Name, SamAccountName, EmailAddress, Department, Manager,
    @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}}
    
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}