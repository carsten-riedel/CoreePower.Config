
. "$PSScriptRoot\CoreePower.Config.Imports.ps1"

function Coree.Update-PowerShellGet {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]   
    param()

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -Force
    Install-Module PowerShellGet -AllowClobber -Force
}

function Coree.Update-PowerShellGetUser {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]   
    param()

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
    Install-Module PowerShellGet -AllowClobber -Force -Scope CurrentUser | Out-Null
}

function PublishModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("pm")]   
    param(
        [string] $Path = ""
    )

    if ($Path -eq "")
    {
        $loc = Get-Location
        $Path = $loc.Path
    }

    $Path = $Path.TrimEnd('\')

    $LastDirectory = Split-Path -Path $Path -Leaf
    $psd1BaseName = Get-ChildItem -Path $Path | Where-Object { $_.Extension -eq ".psd1" } | Select-Object BaseName
    $psm1BaseName = Get-ChildItem -Path $Path | Where-Object { $_.Extension -eq ".psm1" } | Select-Object BaseName

    if($psd1BaseName.Count -eq 0)
    {
        Write-Error "Error: no powerShell module manifest files found. Please ensure that there is one .psd1 file in the directory and try again."
        return
    }

    if($psm1BaseName.Count -eq 0)
    {
        Write-Error "Error: no root module files found. Please ensure that there is one .psm1 file in the directory and try again."
        return
    }

    if($psd1BaseName.Count -gt 1)
    {
        Write-Error "Error: multiple module definition files found. Please ensure that there is only one .psd1 file in the directory and try again."
        return
    }

    if($psm1BaseName.Count -gt 1)
    {
        Write-Error "Error: multiple module definition files found. Please ensure that there is only one .psm1 file in the directory and try again."
        return
    }

    if($LastDirectory -eq $psd1BaseName -and $psd1BaseName -eq $psm1BaseName)
    {
        Write-Error "Error: The parent directory name, .psd1 filename, and .psm1 filename must all be identical. Please ensure that all three names match and try again."
        return
    }


    $keyFileFullName = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.Name -eq ".key" } | Select-Object FullName
    if($null -eq $keyFileFullName)
    {
        Write-Error  "Error: A .key file containing the NuGet API key is missing from the publish directory. Please add the file and try again."
        return
    }

    $gitignoreFullName = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.Name -eq ".gitignore" } | Select-Object FullName
    if($null -eq $gitignoreFullName)
    {
        Write-Warning  "Warning: A .gitignore file is not present, the NuGet API key may be exposed in the publish directory. Please include a .gitignore file with ignore statements for the key to prevent unauthorized access."
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $PackageProviderModule = Get-InstalledModule -Name PackageManagement -MinimumVersion 1.4.8.1 -ErrorAction SilentlyContinue
    $PowerShellGetModule = Get-InstalledModule -Name PowerShellGet -MinimumVersion 2.2.5 -ErrorAction SilentlyContinue

    if (!$PackageProviderModule -or !$PowerShellGetModule) {
        # Either or both modules are missing or have a lower version, so install/update them
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
        Install-Module PowerShellGet -AllowClobber -Force -Scope CurrentUser | Out-Null
        Write-Error  "Error: The PackageManagement or PowerShellGet modules were outdated in the user scope and have been updated. Please close and reopen your PowerShell session and try again."
        return
    }

    [string]$NuGetAPIKey = Get-Content -Path "$($keyFileFullName.FullName)"

    Publish-Module -Path "$Path" -NuGetApiKey "$NuGetAPIKey" -Repository "PSGallery" -Verbose

}

<#
.SYNOPSIS
Adds a new directory path to the system's environment variable PATH.

.PARAMETER Path
Specifies the new directory path to add.

.PARAMETER Scope
Specifies the scope where the new path will be added. This can be one of the following values: "CurrentUser" or "LocalMachine". The default value is "CurrentUser".

.NOTES
This function has an alias "addenvpath" for ease of use.

.EXAMPLE
The following example adds the directory "C:\NewDirectory" to the PATH environment variable for the current user:
AddToPathEnvironmentVariable -Path "C:\NewDirectory"

#>
function AddPathEnviromentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("addenvpath")]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Scope]$Scope = [Scope]::CurrentUser
    )

    # Check if the current process can execute in the desired scope
    if (-not(CanExecuteInDesiredScope -Scope $Scope))
    {
        return
    }
    
    if ($Scope -eq [Scope]::CurrentUser) {
        $USERPATHS = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::User)
        $NEW = "$USERPATHS;$Path"
        [System.Environment]::SetEnvironmentVariable("PATH",$NEW,[System.EnvironmentVariableTarget]::User)
    }
    elseif ($Scope -eq [Scope]::LocalMachine) {
        $MACHINEPATHS = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::Machine)
        $NEW = "$MACHINEPATHS;$Path"
        [System.Environment]::SetEnvironmentVariable("PATH",$NEW,[System.EnvironmentVariableTarget]::Machine)
    }
}

<#
.SYNOPSIS
Groups and sorts the directories in the system's environment variable PATH for a specified scope.

.PARAMETER Scope
Specifies the scope to group and sort directories. This can be one of the following values: "CurrentUser" or "LocalMachine". The default value is "CurrentUser".

.NOTES
This function has an alias "groupsortenvpath" for ease of use.

.EXAMPLE
The following example groups and sorts the directories in the PATH environment variable for the local machine:
GroupAndSortPathEnvironmentVariable -Scope LocalMachine

#>
function GroupAndSortPathEnviromentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("groupsortenvpath")]
    param(
        [Scope]$Scope = [Scope]::CurrentUser
    )

    # Check if the current process can execute in the desired scope
    if (-not(CanExecuteInDesiredScope -Scope $Scope))
    {
        return
    }

    if ($Scope -eq [Scope]::CurrentUser) {
        $USERPATHSARRAY = @()
        $USERPATHSARRAY = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::User) -split ';'
        $USERPATHSARRAY = $USERPATHSARRAY | Group-Object | Select-object -Property Name | Sort-Object -Property Name
        $USERPATHSARRAYSTRING = $USERPATHSARRAY.Name  -join ';'
        [System.Environment]::SetEnvironmentVariable("PATH",$USERPATHSARRAYSTRING,[System.EnvironmentVariableTarget]::User)
    }
    elseif ($Scope -eq [Scope]::LocalMachine) {
        $MachinePATHSARRAY = @()
        $MachinePATHSARRAY = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::Machine) -split ';'
        $MachinePATHSARRAY = $MachinePATHSARRAY | Group-Object | Select-object -Property Name | Sort-Object -Property Name
        $MachinePATHSARRAYSTRING = $MachinePATHSARRAY.Name  -join ';'
        [System.Environment]::SetEnvironmentVariable("PATH",$MachinePATHSARRAYSTRING,[System.EnvironmentVariableTarget]::Machine)
    }
}

<#
.SYNOPSIS
Removes a directory path from the system's environment variable PATH for a specified scope.

.PARAMETER Path
Specifies the directory path to remove from the PATH environment variable.

.PARAMETER Scope
Specifies the scope where the path will be removed. This can be one of the following values: "CurrentUser" or "LocalMachine". The default value is "CurrentUser".

.NOTES
This function has an alias "delenvpath" for ease of use.

.EXAMPLE
The following example removes the directory "C:\OldDirectory" from the PATH environment variable for the current user:
DeletePathEnvironmentVariable -Path "C:\OldDirectory"

#>
function DeletePathEnviromentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("delenvpath")]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Scope]$Scope = [Scope]::CurrentUser
    )
    
    # Check if the current process can execute in the desired scope
    if (-not(CanExecuteInDesiredScope -Scope $Scope))
    {
        return
    }

    if ($Scope -eq [Scope]::CurrentUser) {
        $UserPathArrayNew = @()
        $UserPathArray = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::User) -split ';'
        foreach ($item in $UserPathArray)
        {
            if ($Path -notlike $item)
            {
                $UserPathArrayNew += $item
            }
        }
        $UserPathArrayNewString = $UserPathArrayNew  -join ';'
        [System.Environment]::SetEnvironmentVariable("PATH",$UserPathArrayNewString,[System.EnvironmentVariableTarget]::User)
    }
    elseif ($Scope -eq [Scope]::LocalMachine) {
        $MachinePathArrayNew = @()
        $MachinePathArray = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::Machine) -split ';'
        foreach ($item in $MachinePathArray)
        {
            if ($Path -notlike $item)
            {
                $MachinePathArrayNew += $item
            }
        }
        $MachinePathArrayNewString = $MachinePathArrayNew  -join ';'
        [System.Environment]::SetEnvironmentVariable("PATH",$MachinePathArrayNewString,[System.EnvironmentVariableTarget]::Machine)
    }
}

<#
.SYNOPSIS
Adds a new environment variable to the current user's environment or the local machine's environment.

.DESCRIPTION
Adds a new environment variable with the specified name and value to either the current user's environment or the local machine's environment. Uses the SetEnvironmentVariable method of the System.Environment class. If the scope is not specified, the function adds the variable to the current user's environment.

.PARAMETER Name
The name of the environment variable to add.

.PARAMETER Value
The value of the environment variable to add.

.PARAMETER Scope
The scope of the environment variable. The value can be either CurrentUser or LocalMachine. Default is CurrentUser.

.EXAMPLE
AddEnvironmentVariable -Name "MY_VARIABLE" -Value "my_value"
Adds a new environment variable named MY_VARIABLE with the value my_value to the current user's environment.

.EXAMPLE
AddEnvironmentVariable -Name "MY_VARIABLE" -Value "my_value" -Scope LocalMachine
Adds a new environment variable named MY_VARIABLE with the value my_value to the local machine's environment.

.NOTES
Requires administrative privileges to modify the local machine's environment variables. If the current process does not have the required permissions, the function will not execute.

#>
function AddEnviromentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("addenv")]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Value,
        [Scope]$Scope = [Scope]::CurrentUser
    )

    # Check if the current process can execute in the desired scope
    if (-not(CanExecuteInDesiredScope -Scope $Scope))
    {
        return
    }

    if ($Scope -eq [Scope]::CurrentUser) {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::User)
    }
    elseif ($Scope -eq [Scope]::LocalMachine) {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Machine)
    }
}

<#
.SYNOPSIS
Deletes an environment variable from the current user's environment or the local machine's environment.

.DESCRIPTION
Deletes the environment variable with the specified name from either the current user's environment or the local machine's environment. Uses the SetEnvironmentVariable method of the System.Environment class with a null value to delete the variable. If the scope is not specified, the function deletes the variable from the current user's environment.

.PARAMETER Name
The name of the environment variable to delete.

.PARAMETER Scope
The scope of the environment variable. The value can be either CurrentUser or LocalMachine. Default is CurrentUser.

.EXAMPLE
DeleteEnvironmentVariable -Name "MY_VARIABLE"
Deletes the environment variable named MY_VARIABLE from the current user's environment.

.EXAMPLE
DeleteEnvironmentVariable -Name "MY_VARIABLE" -Scope LocalMachine
Deletes the environment variable named MY_VARIABLE from the local machine's environment.

.NOTES
Requires administrative privileges to delete environment variables from the local machine's environment. If the current process does not have the required permissions, the function will not execute.

#>
function DeleteEnviromentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("delenv")]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Scope]$Scope = [Scope]::CurrentUser
    )

    # Check if the current process can execute in the desired scope
    if (-not(CanExecuteInDesiredScope -Scope $Scope))
    {
        return
    }

    if ($Scope -eq [Scope]::CurrentUser) {
        [System.Environment]::SetEnvironmentVariable($Name, $null, [System.EnvironmentVariableTarget]::User)
    }
    elseif ($Scope -eq [Scope]::LocalMachine) {
        [System.Environment]::SetEnvironmentVariable($Name, $null, [System.EnvironmentVariableTarget]::Machine)
    }
}


function UpdateModuleVersion {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("umv")]
    param(
        [string] $Path = ""
    )

    if ($Path -eq "")
    {
        $loc = Get-Location
        $Path = $loc.Path
    }

    $Path = $Path.TrimEnd('\')

    $psd1BaseName = Get-ChildItem -Path $Path | Where-Object { $_.Extension -eq ".psd1" } | Select-Object FullName

    if($psd1BaseName.Count -eq 0)
    {
        Write-Error "Error: no powerShell module manifest files found. Please ensure that there is one .psd1 file in the directory and try again."
        return
    }

    if($psd1BaseName.Count -gt 1)
    {
        Write-Error "Error: multiple module definition files found. Please ensure that there is only one .psd1 file in the directory and try again."
        return
    }

    $fileContent = Get-Content -Path "$($psd1BaseName.FullName)" -Raw
    $index = $fileContent.IndexOf("@{")
    if($index -ne -1){
        $fileContent = $fileContent.Substring(0, $index) + $fileContent.Substring($index + 2)
    }
    $index = $fileContent.LastIndexOf("}")
    if($index -ne -1){
        $fileContent = $fileContent.Substring(0, $index) + $fileContent.Substring($index + 2)
    }

    $Data  = Invoke-Expression "[PSCustomObject]@{$fileContent}"

    $ver = [Version]$Data.ModuleVersion
    $newver = [Version]::new($ver.Major, $ver.Minor, $ver.Build, ($ver.Revision + 1))
    $Data.ModuleVersion = [string]$newver
    $Data.PrivateData.PSData.LicenseUri = $Data.PrivateData.PSData.LicenseUri.Replace($ver, $newver)
    
    $towrite = ConvertToExpression -InputObject $Data
    $towrite = $towrite -replace "^\[pscustomobject\]", ""

    if (-not($null -eq $towrite))
    {
        # Write the string to a file
        Set-Content -Path "$($psd1BaseName.FullName)" -Value $towrite
    }
}
