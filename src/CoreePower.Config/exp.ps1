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



$obj = [PSCustomObject]@{
    Version  = '1.0.0'
    Name     = 'thing'
    Revision = 'c3a89cd20e19bb82f41e95e0806edc5b6cfd224e'
    Date     = '2016-12-09'
    Build    = '1234'
    Contents = @{
         "index.html" = "23dd7b993f40bb3ae8848fe104b3b767"
    }
    }
$towrite = ExportPowerShellCustomObjectWrapper -Prefix "@{" -Suffix "}" -InputObject $obj  -IndentLevel 0  -CustomOrder @("RootModule", "ModuleVersion", "GUID","Author","CompanyName","Description","FunctionsToExport","AliasesToExport")
Set-Content -Path "foo.psd1" -Value $towrite

$set = [PSCustomObject]$towrite
Write-Output $set.Name


$x = 1