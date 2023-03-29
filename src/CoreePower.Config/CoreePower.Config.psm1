<#
    CoreePower.Config root module
#>

Import-Module -Name CoreePower.Lib -MinimumVersion 0.0.0.4

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

function CoreePower.Publish-Module {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [alias("cppm")]
    param(
         [string] $Path = ""
    )
    if ($Path -eq "")
    {
        CoreePower-Publish-Module
    }
    else {
        CoreePower-Publish-Module -Path "$Path"
    }
    
}



