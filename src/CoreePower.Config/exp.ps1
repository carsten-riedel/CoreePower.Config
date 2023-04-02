# Define a PowerShell custom object
$obj = [PSCustomObject]@{

    #hashtable array
    RequiredModules = @(
        @{
            ModuleName = 'CoreePower.Lib'
            ModuleVersion = '0.0.0.14'
        }
    )

    #nested hashtable array
    PrivateData = @{
        PSData = @{
            Tags = 'configuration', 'windows'
            LicenseUri = 'https://www.powershellgallery.com/packages/CoreePower.Config/0.0.0.36/Content/LICENSE.txt'
            ProjectUri = 'https://github.com/carsten-riedel/CoreePower.Config'
        }
    }

    #simple plain strings
    RootModule = 'CoreePower.Config.psm1'
    ModuleVersion = '0.0.0.36'
    ModuleInt = 5

    #simple plain array of strings
    FunctionsToExport = @('Update-PowerShellGet', 'Update-PowerShellGetUser', 'CoreePower.Publish-Module', 'AddPathEnviromentVariable', 'GroupAndSortPathEnviromentVariable', 'DeletePathEnviromentVariable', 'AddEnviromentVariable', 'DeleteEnviromentVariable')
    CmdletsToExport = '*'
}







$x = 1