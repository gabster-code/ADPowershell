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
    Author = 'Kevin Jornacion'

    # Company or vendor of this module
    CompanyName = 'GabsterCode'

    # Copyright statement for this module
    Copyright = '(c) 2024 GabsterCode. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Active Directory management and reporting functions for user administration and maintenance.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @('ActiveDirectory')

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    # If you create more Functions, add it here. 
    FunctionsToExport = @(
        'Get-InactiveADUsers',
        'Get-ExpiredPasswords',
        'Remove-DisabledUsers',
        'Get-GroupMembershipReport',
        'Get-LockedAccounts',
        'New-ADUserFromTemplate'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module for module discovery
            Tags = @('ActiveDirectory', 'UserManagement', 'Reporting', 'Administration')

            # License for this module
            License = 'MIT'

            # Project site URL
            ProjectUri = 'https://github.com/gabster-code/ADPowershell'

            # ReleaseNotes of this module
            ReleaseNotes = @'
## 1.0.0
- Initial release
- Added core AD management functions
- Added reporting capabilities
'@
        }
    }
}