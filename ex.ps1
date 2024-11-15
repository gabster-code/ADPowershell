# Function to get inactive users and export to CSV
function Get-InactiveADUsers {
    param (
        [int]$DaysInactive = 90,
        [string]$OutputPath = "C:\Reports\InactiveUsers.csv"
    )
    
    $InactiveDate = (Get-Date).AddDays(-$DaysInactive)
    
    $Users = Get-ADUser -Filter {
        LastLogonTimeStamp -lt $InactiveDate -and Enabled -eq $true
    } -Properties LastLogonTimeStamp, EmailAddress, Department, Manager |
    Select-Object Name, SamAccountName, EmailAddress, Department, Manager,
    @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}}
    
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}

# Function to get expired passwords and export to CSV
function Get-ExpiredPasswords {
    param (
        [string]$OutputPath = "C:\Reports\ExpiredPasswords.csv"
    )
    
    $Users = Get-ADUser -Filter {Enabled -eq $true -and PasswordExpired -eq $true} `
    -Properties PasswordLastSet, PasswordExpired, EmailAddress, Department |
    Select-Object Name, SamAccountName, EmailAddress, Department, PasswordLastSet
    
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}

# Function to clean up disabled user accounts (no change needed as it doesn't output files)
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

# Function to get group membership report
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

# Function to get locked out accounts
function Get-LockedAccounts {
    param (
        [string]$OutputPath = "C:\Reports\LockedAccounts.csv"
    )
    
    $LockedUsers = Search-ADAccount -LockedOut |
    Get-ADUser -Properties LastLogonTimeStamp, EmailAddress, Department, LockedOut |
    Select-Object Name, SamAccountName, EmailAddress, Department,
    @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}}
    
    $LockedUsers | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report exported to $OutputPath"
}

# Function to create new user from template (no change needed as it doesn't output files)
function New-ADUserFromTemplate {
    param (
        [Parameter(Mandatory=$true)]
        [string]$NewUserFirstName,
        
        [Parameter(Mandatory=$true)]
        [string]$NewUserLastName,
        
        [Parameter(Mandatory=$true)]
        [string]$TemplateUser,
        
        [Parameter(Mandatory=$true)]
        [string]$Password
    )
    
    try {
        # Get template user
        $Template = Get-ADUser $TemplateUser -Properties *
        
        # Generate username (firstname.lastname)
        $Username = "$($NewUserFirstName.ToLower()).$($NewUserLastName.ToLower())"
        
        # Create secure password
        $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        
        # Create new user
        New-ADUser -Name "$NewUserFirstName $NewUserLastName" `
            -GivenName $NewUserFirstName `
            -Surname $NewUserLastName `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$($Template.UserPrincipalName.Split('@')[1])" `
            -Path $Template.DistinguishedName.Substring($Template.DistinguishedName.IndexOf(',') + 1) `
            -Department $Template.Department `
            -Title $Template.Title `
            -Company $Template.Company `
            -Enabled $true `
            -AccountPassword $SecurePassword `
            -ChangePasswordAtLogon $true
        
        # Copy group memberships
        $Groups = Get-ADUser $TemplateUser -Properties MemberOf | Select-Object -ExpandProperty MemberOf
        foreach ($Group in $Groups) {
            Add-ADGroupMember -Identity $Group -Members $Username
        }
        
        Write-Host "User $Username created successfully with same groups as $TemplateUser"
    }
    catch {
        Write-Error "Error creating user: $_"
    }
}