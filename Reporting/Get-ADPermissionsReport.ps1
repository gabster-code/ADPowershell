# Function to analyze AD permissions
function Get-ADPermissionsReport {
    param (
        [string]$OutputPath = "C:\Reports\ADPermissions.csv"
    )
    
    $Domain = Get-ADDomain
    $Acl = Get-Acl "AD:$($Domain.DistinguishedName)"
    
    $Permissions = foreach ($Access in $Acl.Access) {
        [PSCustomObject]@{
            IdentityReference = $Access.IdentityReference
            AccessControlType = $Access.AccessControlType
            ActiveDirectoryRights = $Access.ActiveDirectoryRights
            InheritanceType = $Access.InheritanceType
            ObjectType = $Access.ObjectType
            InheritedObjectType = $Access.InheritedObjectType
            IsInherited = $Access.IsInherited
        }
    }
    
    $Permissions | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}