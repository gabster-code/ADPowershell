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
    Author:         Kevin "Gab" Jornacion
    Creation Date:  11/15/2024 (I just made this easier for everyone haha)
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