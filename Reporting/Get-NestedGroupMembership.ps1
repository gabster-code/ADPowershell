# Function to get nested group memberships
function Get-NestedGroupMembership {
    param (
        [Parameter(Mandatory=$true)]
        [string]$GroupName,
        [string]$OutputPath = "C:\Reports\NestedGroups.csv"
    )
    
    function Get-NestedMembers {
        param (
            [string]$Group,
            [int]$Level = 0
        )
        
        $Members = Get-ADGroupMember -Identity $Group
        foreach ($Member in $Members) {
            if ($Member.objectClass -eq "group") {
                [PSCustomObject]@{
                    ParentGroup = $Group
                    MemberName = $Member.Name
                    Type = "Group"
                    Level = $Level
                }
                Get-NestedMembers -Group $Member.Name -Level ($Level + 1)
            } else {
                [PSCustomObject]@{
                    ParentGroup = $Group
                    MemberName = $Member.Name
                    Type = "User"
                    Level = $Level
                }
            }
        }
    }
    
    $NestedMembers = Get-NestedMembers -Group $GroupName
    $NestedMembers | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}