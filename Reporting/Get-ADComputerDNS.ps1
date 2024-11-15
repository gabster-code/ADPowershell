
# Function to get DNS records for AD computers
function Get-ADComputerDNS {
    param (
        [string]$OutputPath = "C:\Reports\ComputerDNS.csv"
    )
    
    $Computers = Get-ADComputer -Filter * -Properties DNSHostName, IPv4Address, 
        OperatingSystem, LastLogonTimeStamp |
    Where-Object { $_.DNSHostName } |
    ForEach-Object {
        $DNS = Resolve-DnsName -Name $_.DNSHostName -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            ComputerName = $_.Name
            DNSHostName = $_.DNSHostName
            IPv4Address = $_.IPv4Address
            DNSResolved = if ($DNS) { $true } else { $false }
            ResolvedIP = ($DNS | Where-Object { $_.Type -eq 'A' }).IPAddress
            OperatingSystem = $_.OperatingSystem
            LastLogon = [DateTime]::FromFileTime($_.LastLogonTimeStamp)
        }
    }
    
    $Computers | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}