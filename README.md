# CoreePower.Config


Copy and paste to cmd or powershell (Set the excution policy to bypass to run the commands)

```
powershell.exe -ExecutionPolicy Bypass -Command "& {Install-Module -Name CoreePower.Config -Scope CurrentUser -Force; Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass}"
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