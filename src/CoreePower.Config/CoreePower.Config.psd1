@{
RootModule = 'CoreePower.Config.psm1'
ModuleVersion = '0.0.0.40'
GUID = 'e9f6459a-6b83-4967-a305-73eba1857637'
Author = 'Carsten Riedel'
CompanyName = 'Carsten Riedel'
Description = 'Powershell module for basic configuration'
FunctionsToExport = @('Update-PowerShellGet', 'Update-PowerShellGetUser', 'CoreePower.Publish-Module', 'AddPathEnviromentVariable', 'GroupAndSortPathEnviromentVariable', 'DeletePathEnviromentVariable', 'AddEnviromentVariable', 'DeleteEnviromentVariable', 'UpdateModuleVersion')
AliasesToExport = @('uppg', 'uppgu', 'cppm', 'addenvpath', 'groupsortenvpath', 'delenvpath', 'addenv', 'delenv', 'umv')
CmdletsToExport = '*'
Copyright = '(c) 2022 Carsten Riedel. All rights reserved.'
PrivateData = @{
    PSData = @{
        LicenseUri = 'https://www.powershellgallery.com/packages/CoreePower.Config/0.0.0.40/Content/LICENSE.txt'
        ProjectUri = 'https://github.com/carsten-riedel/CoreePower.Config'
        Tags = @('configuration', 'windows')
    }
}
RequiredModules = @(@{    ModuleVersion = '0.0.0.16'
    ModuleName = 'CoreePower.Lib'})
VariablesToExport = '*'
}
