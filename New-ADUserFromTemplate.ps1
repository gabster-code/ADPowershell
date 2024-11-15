# Function to create new user from template 
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