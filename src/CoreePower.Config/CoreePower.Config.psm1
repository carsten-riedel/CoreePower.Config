<#
    CoreePower.Config root module
#>

<#
To facilitate PowerShell script debugging, module imports should be handled in a separate 'CoreePower.Config.Imports.ps1' file. 
This is generally not necessary, as the module dependency is usually specified in the RequiredModules 
section of the manifest. However, in cases where the module dependency is not executed, cause of using it with VS Code 
there are issues with outdated or missing modules during debugging, importing modules in a separate file can help 
ensure that the latest version of the module is available for debugging purposes.
Please add the dot source of . "$PSScriptRoot\CoreePower.Config.Imports.ps1" to every .ps1 file.
#>

. "$PSScriptRoot\CoreePower.Config.EnviromentVariable.ps1"


function Update-PowerShellGet{
    [alias("uppg")]
    param()
    Coree.Update-PowerShellGet
}

function Update-PowerShellGetUser{
    [alias("uppgu")]
    param()
    Coree.Update-PowerShellGetUser
}





