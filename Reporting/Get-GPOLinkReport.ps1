# Function to analyze Group Policy links
function Get-GPOLinkReport {
    param (
        [string]$OutputPath = "C:\Reports\GPOLinks.csv"
    )
    
    $AllOUs = Get-ADOrganizationalUnit -Filter *
    $GPOLinks = foreach ($OU in $AllOUs) {
        $LinkedGPOs = Get-GPInheritance -Target $OU.DistinguishedName
        foreach ($GPO in $LinkedGPOs.GpoLinks) {
            [PSCustomObject]@{
                OUName = $OU.Name
                OUDN = $OU.DistinguishedName
                GPOName = $GPO.DisplayName
                Enabled = $GPO.Enabled
                Enforced = $GPO.Enforced
                Order = $GPO.Order
            }
        }
    }
    
    $GPOLinks | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}