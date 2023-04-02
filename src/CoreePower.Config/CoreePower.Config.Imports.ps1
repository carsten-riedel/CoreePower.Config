function Imports {
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName,
        [Parameter(Mandatory)]
        [string]$ModuleVersion
    )

    #Get module in the current session
    $ModuleAvailableInSession = Get-Module -Name $ModuleName | Where-Object {$_.Version -ge $ModuleVersion}

    if ($ModuleAvailableInSession) {
        return
    }
    else {
        $ModuleAvailableOnSystem = Get-Module -Name $ModuleName -ListAvailable | Where-Object {$_.Version -ge $ModuleVersion}
        
        if ($ModuleAvailableOnSystem) {
            Import-Module -Name $ModuleName -MinimumVersion $ModuleVersion
        } else {
            Install-Module -Name $ModuleName -RequiredVersion $ModuleVersion -Force
            Import-Module -Name $ModuleName -MinimumVersion $ModuleVersion
        }
    }
}

#Dont't forget to update RequiredModules in the .psd1 file
Imports -ModuleName "CoreePower.Lib" -ModuleVersion "0.0.0.15"