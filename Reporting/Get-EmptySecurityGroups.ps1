
# Function to get empty security groups
function Get-EmptySecurityGroups {
    param (
        [string]$OutputPath = "C:\Reports\EmptyGroups.csv"
    )
    
    $EmptyGroups = Get-ADGroup -Filter * -Properties Members, Description, Created, Modified |
    Where-Object { $_.Members.Count -eq 0 } |
    Select-Object Name, GroupCategory, GroupScope, Description, Created, Modified
    
    $EmptyGroups | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}