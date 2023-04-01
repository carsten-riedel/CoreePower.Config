<#
    CoreePower.Config root module
#>


# Import the module, but note that function names must either use a non-verb name or an approved verb prefix, otherwise a warning will be displayed. 
Import-Module -Name CoreePower.Lib -MinimumVersion 0.0.0.14

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



