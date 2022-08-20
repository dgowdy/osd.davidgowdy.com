#================================================
#   OSDCloud Task Sequence
#   Windows 10 21H2 Pro en-us Volume
#   No Autopilot
#   No Office Deployment Tool
#================================================
#   PreOS
#   Install and Import OSD Module
#================================================
Install-Module OSD -Force
Import-Module OSD -Force
#================================================
#   [OS] Start-OSDCloud with Params
#================================================
$Params = @{
    OSBuild = "21H2"
    OSEdition = "Pro"
    OSLanguage = "en-us"
    OSLicense = "Volume"
    SkipAutopilot = $true
    SkipODT = $true
}
Start-OSDCloud @Params
#================================================
#   WinPE PostOS Sample
#   OOBEDeploy Offline Staging
#================================================
$Params = @{
    Autopilot = $false
    AddNetFX3 = $true
    RemoveAppx = $true
    UpdateDrivers = $true
    UpdateWindows = $true
}
Start-OOBEDeploy @Params
#================================================
#   WinPE PostOS
#   Set OOBEDeploy CMD.ps1
#================================================
$SetCommand = @'
@echo off

:: Set the PowerShell Execution Policy
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force

:: Add PowerShell Scripts to the Path
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts

:: Open and Minimize a PowerShell instance just in case
start PowerShell -NoL -W Mi

:: Install the latest OSD Module
start "Install-Module OSD" /wait PowerShell -NoL -C Install-Module OSD -Force -Verbose

:: Start-OOBEDeploy
:: There are multiple example lines. Make sure only one is uncommented
:: The next line assumes that you have a configuration saved in C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json
start "Start-OOBEDeploy" PowerShell -NoL -C Start-OOBEDeploy
:: The next line assumes that you do not have a configuration saved in or want to ensure that these are applied
REM start "Start-OOBEDeploy" PowerShell -NoL -C Start-OOBEDeploy -AddNetFX3 -UpdateDrivers -UpdateWindows

exit
'@
$SetCommand | Out-File -FilePath "C:\Windows\OOBEDeploy.cmd" -Encoding ascii -Force
#================================================
#   PostOS
#   Restart-Computer
#================================================
Restart-Computer
