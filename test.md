# Active Directory Management Scripts

A collection of PowerShell functions for managing and reporting on Active Directory users, groups, and accounts.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Functions](#functions)
  - [Get-InactiveADUsers](#get-inactiveadusers)
  - [Get-ExpiredPasswords](#get-expiredpasswords)
  - [Remove-DisabledUsers](#remove-disabledusers)
  - [Get-GroupMembershipReport](#get-groupmembershipreport)
  - [Get-LockedAccounts](#get-lockedaccounts)
  - [New-ADUserFromTemplate](#new-aduserfromtemplate)

## Overview

This script collection provides essential tools for Active Directory administration, focusing on user management, reporting, and maintenance tasks. Each function is designed to handle specific AD management scenarios, from identifying inactive users to creating new users based on templates.

## Prerequisites

- Windows PowerShell 5.1 or later
- Active Directory PowerShell module
- Appropriate AD permissions to execute these commands
- Write access to the output directory (default: C:\Reports)

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
