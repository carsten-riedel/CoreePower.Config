<#
    CoreePower.Config root module
#>

. "$PSScriptRoot\CoreePower.Config.ps1"

function ConfigDump{
    [alias("dmp")]
    param()
    Dump-String
}

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

function CoreePower.Publish-Module{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("cppm")]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path
    )
    CoreePower-Publish-Module -Path "$Path"
}



