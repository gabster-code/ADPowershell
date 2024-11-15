# Function to analyze password complexity compliance
function Get-PasswordComplexityReport {
    param (
        [string]$OutputPath = "C:\Reports\PasswordComplexity"
    )
    
    $PasswordPolicy = Get-ADDefaultDomainPasswordPolicy
    $DomainUsers = Get-ADUser -Filter * -Properties PasswordLastSet, PasswordNotRequired, 
        PasswordNeverExpires, Title, Department |
    Select-Object Name, SamAccountName, Title, Department, PasswordLastSet, 
        PasswordNotRequired, PasswordNeverExpires
    
    $Report = [PSCustomObject]@{
        MinPasswordLength = $PasswordPolicy.MinPasswordLength
        PasswordHistoryCount = $PasswordPolicy.PasswordHistoryCount
        MaxPasswordAge = $PasswordPolicy.MaxPasswordAge
        MinPasswordAge = $PasswordPolicy.MinPasswordAge
        ComplexityEnabled = $PasswordPolicy.ComplexityEnabled
        TotalUsers = $DomainUsers.Count
        UsersPasswordNeverExpires = ($DomainUsers | Where-Object { $_.PasswordNeverExpires }).Count
        UsersPasswordNotRequired = ($DomainUsers | Where-Object { $_.PasswordNotRequired }).Count
    }
    
    # Export both reports with different names
    $Report | Export-Csv -Path "$OutputPath`_Policy.csv" -NoTypeInformation
    $DomainUsers | Export-Csv -Path "$OutputPath`_UserDetails.csv" -NoTypeInformation
    Write-Host "Reports exported to $OutputPath`_Policy.csv and $OutputPath`_UserDetails.csv"
}