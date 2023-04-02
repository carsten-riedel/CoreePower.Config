@{
    RootModule = 'CoreePower.Config.psm1'
    ModuleVersion = '0.0.0.50'
    GUID = 'e9f6459a-6b83-4967-a305-73eba1857637'
    Author = 'Carsten Riedel'
    CompanyName = 'Carsten Riedel'
    Description = 'Powershell module for basic configuration'
    FunctionsToExport =
        'PublishModule',
        'AddPathEnviromentVariable',
        'GroupAndSortPathEnviromentVariable',
        'DeletePathEnviromentVariable',
        'AddEnviromentVariable',
        'DeleteEnviromentVariable',
        'UpdateModuleVersion',
        'CreateModule'
    AliasesToExport =
        'pm',
        'addenvpath',
        'groupsortenvpath',
        'delenvpath',
        'addenv',
        'delenv',
        'umv',
        'crm'
    CmdletsToExport = '*'
    Copyright = '(c) 2022 Carsten Riedel. All rights reserved.'
    PrivateData = @{PSData = @{
            LicenseUri = 'https://www.powershellgallery.com/packages/CoreePower.Config/0.0.0.50/Content/LICENSE.txt'
            Tags =
                'configuration',
                'windows'
            ProjectUri = 'https://github.com/carsten-riedel/CoreePower.Config'
        }}
    RequiredModules = ,@{
        ModuleName = 'CoreePower.Lib'
        ModuleVersion = '0.0.0.20'
    }
    VariablesToExport = '*'
}
