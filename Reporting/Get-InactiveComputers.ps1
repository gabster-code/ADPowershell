# Function to get inactive computers
function Get-InactiveComputers {
    param (
        [int]$DaysInactive = 90,
        [string]$OutputPath = "C:\Reports\InactiveComputers.csv"
    )
    
    $InactiveDate = (Get-Date).AddDays(-$DaysInactive)
    
    $Computers = Get-ADComputer -Filter {
        LastLogonTimeStamp -lt $InactiveDate -and Enabled -eq $true
    } -Properties LastLogonTimeStamp, OperatingSystem, IPv4Address, Created |
    Select-Object Name, OperatingSystem,
        @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}},
        IPv4Address, Created
    
    $Computers | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}