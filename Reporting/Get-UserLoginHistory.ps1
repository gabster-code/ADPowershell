# Function to get user login history
function Get-UserLoginHistory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username,
        [int]$Days = 30,
        [string]$OutputPath = "C:\Reports\UserLoginHistory.csv"
    )
    
    $StartDate = (Get-Date).AddDays(-$Days)
    $DCs = Get-ADDomainController -Filter *
    
    $LoginEvents = foreach ($DC in $DCs.Name) {
        Get-WinEvent -ComputerName $DC -FilterHashtable @{
            LogName = 'Security'
            ID = 4624
            StartTime = $StartDate
        } -ErrorAction SilentlyContinue |
        Where-Object { $_.Properties[5].Value -eq $Username } |
        Select-Object @{Name='Time';Expression={$_.TimeCreated}},
            @{Name='DC';Expression={$DC}},
            @{Name='IPAddress';Expression={$_.Properties[18].Value}},
            @{Name='LogonType';Expression={$_.Properties[8].Value}}
    }
    
    $LoginEvents | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}