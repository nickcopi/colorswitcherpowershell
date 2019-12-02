Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.Form")  
$workDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)";
. $workDir\colorswitcher.ps1