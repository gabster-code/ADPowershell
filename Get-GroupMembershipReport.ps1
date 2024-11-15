function Get-GroupMembershipReport {
    param (
        [string]$GroupName,
        [string]$OutputPath = "C:\Reports\GroupMembership.csv"
    )
    
    $Members = Get-ADGroupMember -Identity $GroupName -Recursive |
    ForEach-Object {
        $User = Get-ADUser $_ -Properties EmailAddress, Department, Title
        [PSCustomObject]@{
            Name = $User.Name
            SamAccountName = $User.SamAccountName
            Email = $User.EmailAddress
            Department = $User.Department
            Title = $User.Title
            GroupName = $GroupName
        }
    }
    
    $Members | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}