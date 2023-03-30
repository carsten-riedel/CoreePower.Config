# CoreePower.Config


This command updates your PowerShell PackageProvider and PowerShellGet to get the latest updates from the PowerShell gallery and installs CoreePower.Config from the same gallery. The goal is to get CoreePower.Config running on your system. To run the command, copy and paste it into your cmd or PowerShell. It also sets the ExecutionPolicy of the current user to bypass to prevent PowerShell from blocking the script.
Note that this command assumes that you have PowerShell 5.0 or later installed on your system.

```
powershell.exe -ExecutionPolicy Bypass -Command "& { Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null ; Install-Module PowerShellGet -AllowClobber -Force -Scope CurrentUser | Out-Null  ; Install-Module -Name CoreePower.Config -Scope CurrentUser -Force | Out-Null ; Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass }"
```


## Commands

### CoreePower.Publish-Module -Path "$Path" 
### cppm -Path "$Path"
<br>

#### Example
```
cppm -Path "C:\base\github.com\carsten-riedel\CoreePower.Config\src\CoreePower.Config"
```

This function publishes a PowerShell module to the PowerShell Gallery using the Publish-Module cmdlet, after performing validation checks to ensure that the module directory contains only one .psd1 and one .psm1 file, that the parent directory name, .psd1 filename, and .psm1 filename are all identical, and that a .key file containing the NuGet API key is present in the module directory. If any validation check fails, the function displays an error or warning message and returns without publishing the module.

Function parameters:

$Path: The path to the directory containing the PowerShell module to be published. This parameter is mandatory and must be provided as a string.