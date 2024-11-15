# Function to clean up disabled user accounts
# Note: This will remove the disabled users immediately. Use within reason and proper processing. 
function Remove-DisabledUsers {
    param (
        [int]$DaysDisabled = 180,
        [switch]$WhatIf
    )
    
    $DisabledDate = (Get-Date).AddDays(-$DaysDisabled)
    
    $Users = Get-ADUser -Filter {
        Enabled -eq $false -and Modified -lt $DisabledDate
    } -Properties Modified
    
    foreach ($User in $Users) {
        if ($WhatIf) {
            Write-Host "Would remove user: $($User.SamAccountName)"
        } else {
            Remove-ADUser -Identity $User.SamAccountName -Confirm:$false
            Write-Host "Removed user: $($User.SamAccountName)"
        }
    }
}