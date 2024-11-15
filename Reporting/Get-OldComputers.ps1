# Function to get computers with old operating systems
function Get-OldOSComputers {
    param (
        [string]$OutputPath = "C:\Reports\OldOSComputers.csv"
    )
    
    $Computers = Get-ADComputer -Filter * -Properties OperatingSystem, OperatingSystemVersion, 
        LastLogonTimeStamp, IPv4Address, Created |
    Where-Object { $_.OperatingSystem -like "*Windows*" } |
    Select-Object Name, OperatingSystem, OperatingSystemVersion,
        @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}},
        IPv4Address, Created
    
    $Computers | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}