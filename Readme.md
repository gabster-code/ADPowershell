# Welcome, nerds!

## This is a free resource for useful AD Powershell Scripts

Feel free to play around with it, modify to your needs and whatnot. Just clone this repo and run on your servers.

### Note:

Some of this feels basic. It probably is, until you notice that you get the same f\*\*\*ing requests everyday(if unfortunate) that you just have to automate it in some way to save yourself from insanity.

That is the purpose why I have these and I just know having these in any IT person's arsenal will be of great help.

---

## Table of Contents

- [File Structure](#file-structure)
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Functions](#functions)
  - [Get-InactiveADUsers](#get-inactiveadusers)
  - [Get-ExpiredPasswords](#get-expiredpasswords)
  - [Remove-DisabledUsers](#remove-disabledusers)
  - [Get-GroupMembershipReport](#get-groupmembershipreport)
  - [Get-LockedAccounts](#get-lockedaccounts)
  - [New-ADUserFromTemplate](#new-aduserfromtemplate)
  - [Get-OldOSComputers](#get-oldoscomputers)
  - [Get-EmptySecurityGroups](#get-emptysecuritygroups)
  - [Get-NeverExpiringPasswords](#get-neverexpiringpasswords)
  - [Get-PasswordComplexityReport](#get-passwordcomplexityreport)
  - [Get-InactiveComputers](#get-inactivecomputers)
  - [Get-GPOLinkReport](#get-gpolinkreport)
  - [Get-NestedGroupMembership](#get-nestedgroupmembership)
  - [Get-UserLoginHistory](#get-userloginhistory)
  - [Get-ADComputerDNS](#get-adcomputerdns)
  - [Get-ADPermissionsReport](#get-adpermissionsreport)

## Overview

This script collection provides essential tools for Active Directory administration, focusing on user management, reporting, and maintenance tasks. Each function is designed to handle specific AD management scenarios, from identifying inactive users to creating new users based on templates.

## Prerequisites

- Windows PowerShell 5.1 or later
- Active Directory PowerShell module (Import-Module ActiveDirectory)
- Appropriate AD permissions to execute these commands
- Write access to the output directory (default: C:\Reports)

## File Structure

(This is a suggestion rather than a "right way" to do things)
The scripts should be organized using the following structure and naming conventions:

```
AD-Management/
│
├── Reporting/
│   ├── Get-InactiveADUsers.ps1
│   ├── Get-ExpiredPasswords.ps1
│   ├── Get-GroupMembershipReport.ps1
│   ├── Get-LockedAccounts.ps1
│   ├── Get-OldOSComputers.ps1
│   ├── Get-EmptySecurityGroups.ps1
│   ├── Get-NeverExpiringPasswords.ps1
│   ├── Get-PasswordComplexityReport.ps1
│   ├── Get-InactiveComputers.ps1
│   ├── Get-GPOLinkReport.ps1
│   ├── Get-NestedGroupMembership.ps1
│   ├── Get-UserLoginHistory.ps1
│   ├── Get-ADComputerDNS.ps1
│   └── Get-ADPermissionsReport.ps1
│
├── Management/
│   ├── Remove-DisabledUsers.ps1
│   └── New-ADUserFromTemplate.ps1
│
├── ADFunctions.psm1      # Combined module file
├── ADFunctions.psd1      # Module manifest
└── README.md             # This documentation
```

### Naming Conventions

1. **Individual Script Files (.ps1)**:

   - Use Pascal Case (e.g., `Get-InactiveADUsers.ps1`)
   - Start with the verb that describes the action
   - Follow PowerShell approved verbs (Get, Set, Remove, New, etc.)
   - End with a descriptive noun that explains the object being manipulated
   - Each file should contain a single function matching its filename

2. **Module Files**:

   - Main module: `ADFunctions.psm1`
   - Manifest: `ADFunctions.psd1`

3. **Directory Structure**:
   - Use clear, descriptive folder names
   - Separate reporting functions from management functions
   - Use PascalCase for folder names

## Module Files

### ADFunctions.psm1

The main module file automatically imports all functions and makes them available when the module is loaded.

```powershell
#Requires -Version 5.1
#Requires -Modules ActiveDirectory

<#
.SYNOPSIS
    Active Directory Management Functions Module
.DESCRIPTION
    Collection of PowerShell functions for Active Directory user management,
    reporting, and maintenance tasks.
.NOTES
    Version:        1.0.0
    Author:         [Your Name]
    Creation Date:  [Date]
    Purpose/Change: Initial module creation
#>

# Get public and private function definition files
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Reporting\*.ps1, `
                           $PSScriptRoot\Management\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($import in $Public) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}

# Export all public functions
Export-ModuleMember -Function $Public.BaseName
```

### ADFunctions.psd1

The module manifest contains metadata and configuration information for the module.

```powershell
@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'ADFunctions.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID = '[Generate a new GUID]'  # Use New-Guid to generate

    # Author of this module
    Author = '[Your Name]'

    # Company or vendor of this module
    CompanyName = '[Your Company]'

    # Copyright statement for this module
    Copyright = '(c) [Year] [Your Name/Company]. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Active Directory management and reporting functions for user administration and maintenance.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @('ActiveDirectory')

    # Functions to export from this module
    FunctionsToExport = @(
        'Get-InactiveADUsers',
        'Get-ExpiredPasswords',
        'Remove-DisabledUsers',
        'Get-GroupMembershipReport',
        'Get-LockedAccounts',
        'New-ADUserFromTemplate'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module for module discovery
            Tags = @('ActiveDirectory', 'UserManagement', 'Reporting', 'Administration')
            License = 'MIT'
        }
    }
}
```

### Module Installation and Setup

1. Generate a new GUID for the module:

```powershell
New-Guid | clip  # This copies a new GUID to your clipboard
```

2. Update the placeholders in both .psd1 and .psm1 files:

- [Your Name]
- [Your Company]
- [Year]
- [Generate a new GUID]
- ProjectUri (if applicable)

3. Install the module:

```powershell
# Copy to PowerShell modules directory
Copy-Item -Path ".\AD-Management" -Destination "$($env:PSModulePath.Split(';')[0])" -Recurse

# Import the module
Import-Module ADFunctions
```

4. Verify installation:

```powershell
Get-Module ADFunctions
```

### Usage Options

You can either:

1. Use individual scripts:

```powershell
# Load individual function
. .\Reporting\Get-InactiveADUsers.ps1
```

2. Import the entire module:

```powershell
# Import the module
Import-Module .\ADFunctions.psm1
```

## Functions

### Get-InactiveADUsers

Identifies and reports on inactive AD users based on their last logon timestamp.

#### Usage

```powershell
Get-InactiveADUsers -DaysInactive 90 -OutputPath "C:\Reports\InactiveUsers.csv"
```

#### Parameters

- `DaysInactive` (Optional): Number of days of inactivity (Default: 90)
- `OutputPath` (Optional): Path for the CSV report (Default: C:\Reports\InactiveUsers.csv)

#### Sample Output

```csv
Name,SamAccountName,EmailAddress,Department,Manager,LastLogon
John Doe,jdoe,john.doe@company.com,IT,Jane Smith,2024-01-15 09:30:45
```

### Get-ExpiredPasswords

Generates a report of users with expired passwords.

#### Usage

```powershell
Get-ExpiredPasswords -OutputPath "C:\Reports\ExpiredPasswords.csv"
```

#### Parameters

- `OutputPath` (Optional): Path for the CSV report (Default: C:\Reports\ExpiredPasswords.csv)

#### Sample Output

```csv
Name,SamAccountName,EmailAddress,Department,PasswordLastSet
Jane Smith,jsmith,jane.smith@company.com,HR,2023-11-15 14:22:33
```

### Remove-DisabledUsers

Removes disabled user accounts that have been inactive for a specified period.

#### Usage

```powershell
# Test mode (WhatIf)
Remove-DisabledUsers -DaysDisabled 180 -WhatIf

# Active removal
Remove-DisabledUsers -DaysDisabled 180
```

#### Parameters

- `DaysDisabled` (Optional): Number of days since account was disabled (Default: 180)
- `WhatIf` (Switch): Run in test mode without making changes

#### Output Example

```
Would remove user: former.employee
Removed user: former.employee
```

### Get-GroupMembershipReport

Generates a detailed report of group membership, including user details.

#### Usage

```powershell
Get-GroupMembershipReport -GroupName "IT-Staff" -OutputPath "C:\Reports\IT-Staff-Members.csv"
```

#### Parameters

- `GroupName` (Required): Name of the AD group to report on
- `OutputPath` (Optional): Path for the CSV report (Default: C:\Reports\GroupMembership.csv)

#### Sample Output

```csv
Name,SamAccountName,Email,Department,Title,GroupName
Alice Johnson,ajohnson,alice.johnson@company.com,IT,Systems Engineer,IT-Staff
```

### Get-LockedAccounts

Reports on currently locked user accounts.

#### Usage

```powershell
Get-LockedAccounts -OutputPath "C:\Reports\LockedAccounts.csv"
```

#### Parameters

- `OutputPath` (Optional): Path for the CSV report (Default: C:\Reports\LockedAccounts.csv)

#### Sample Output

```csv
Name,SamAccountName,EmailAddress,Department,LastLogon
Bob Wilson,bwilson,bob.wilson@company.com,Sales,2024-02-15 08:45:22
```

### New-ADUserFromTemplate

Creates a new AD user based on an existing user's properties and group memberships.

#### Usage

```powershell
New-ADUserFromTemplate -NewUserFirstName "Sarah" -NewUserLastName "Johnson" -TemplateUser "jsmith" -Password "ComplexPass123!"
```

#### Parameters

- `NewUserFirstName` (Required): First name of the new user
- `NewUserLastName` (Required): Last name of the new user
- `TemplateUser` (Required): Username of the template user
- `Password` (Required): Initial password for the new user

#### Output Example

```
User sarah.johnson created successfully with same groups as jsmith
```

### Get-OldOSComputers

Generates a report of all Windows computers in the domain with their operating system information.

```powershell
Get-OldOSComputers -OutputPath "C:\Reports\OldOSComputers.csv"
```

**Output columns:** Name, OperatingSystem, OperatingSystemVersion, LastLogon, IPv4Address, Created

### Get-EmptySecurityGroups

Identifies security groups with no members.

```powershell
Get-EmptySecurityGroups -OutputPath "C:\Reports\EmptyGroups.csv"
```

**Output columns:** Name, GroupCategory, GroupScope, Description, Created, Modified

### Get-NeverExpiringPasswords

Lists users with passwords set to never expire.

```powershell
Get-NeverExpiringPasswords -OutputPath "C:\Reports\NeverExpiringPasswords.csv"
```

**Output columns:** Name, SamAccountName, Title, Department, Manager, PasswordLastSet

### Get-PasswordComplexityReport

Analyzes password policy compliance across the domain. Generates two CSV files:

- Policy report: Domain password policy settings
- User details: Individual user password settings

```powershell
Get-PasswordComplexityReport -OutputPath "C:\Reports\PasswordComplexity"
# Creates PasswordComplexity_Policy.csv and PasswordComplexity_UserDetails.csv
```

**Policy output includes:** MinPasswordLength, PasswordHistoryCount, MaxPasswordAge, MinPasswordAge, ComplexityEnabled, TotalUsers, UsersPasswordNeverExpires, UsersPasswordNotRequired

### Get-InactiveComputers

Lists computers that haven't logged in for a specified number of days.

```powershell
Get-InactiveComputers -DaysInactive 90 -OutputPath "C:\Reports\InactiveComputers.csv"
```

**Output columns:** Name, OperatingSystem, LastLogon, IPv4Address, Created

### Get-GPOLinkReport

Analyzes Group Policy Object links across all OUs.

```powershell
Get-GPOLinkReport -OutputPath "C:\Reports\GPOLinks.csv"
```

**Output columns:** OUName, OUDN, GPOName, Enabled, Enforced, Order

### Get-NestedGroupMembership

Discovers nested group memberships for a specified group.

```powershell
Get-NestedGroupMembership -GroupName "Domain Admins" -OutputPath "C:\Reports\NestedGroups.csv"
```

**Output columns:** ParentGroup, MemberName, Type, Level

### Get-UserLoginHistory

Retrieves login history for a specific user across all domain controllers.

```powershell
Get-UserLoginHistory -Username "john.doe" -Days 30 -OutputPath "C:\Reports\UserLoginHistory.csv"
```

**Output columns:** Time, DC, IPAddress, LogonType

### Get-ADComputerDNS

Verifies DNS records for all AD computers.

```powershell
Get-ADComputerDNS -OutputPath "C:\Reports\ComputerDNS.csv"
```

**Output columns:** ComputerName, DNSHostName, IPv4Address, DNSResolved, ResolvedIP, OperatingSystem, LastLogon

### Get-ADPermissionsReport

Analyzes Active Directory permissions at the domain level.

```powershell
Get-ADPermissionsReport -OutputPath "C:\Reports\ADPermissions.csv"
```

**Output columns:** IdentityReference, AccessControlType, ActiveDirectoryRights, InheritanceType, ObjectType, InheritedObjectType, IsInherited

## Best Practices

1. Always test scripts with `-WhatIf` when available before running them in production
2. Regularly check output paths for report accumulation
3. Review generated reports promptly for security compliance
4. Keep credentials secure and never hardcode them in scripts
5. Maintain proper AD permissions for script execution

## Error Handling

The scripts include basic error handling and will output error messages when:

- Required AD module is not available
- Insufficient permissions
- Invalid parameters
- Network connectivity issues
- File system access problems

## Notes

- All CSV reports use Unicode encoding and include headers
- Timestamps are converted to readable datetime format
- Group membership copying is recursive
- Password complexity must meet domain requirements
- Default report location is C:\Reports - ensure this directory exists

## Security Considerations

1. Run these scripts with appropriate AD administrative privileges
2. Protect output CSV files as they contain sensitive information
3. Review removed users before permanent deletion
4. Monitor script execution logs
5. Regularly audit group membership reports

## Contributing

Feel free to submit issues and enhancement requests through your organization's standard processes.
