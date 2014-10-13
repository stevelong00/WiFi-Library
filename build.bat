@echo on

set config=%1
if "%config%" == "" (
    set config=Release
)

set version=1.0.0
if not "%PackageVersion%" == "" (
    set version=%PackageVersion%
)
if not "%GitVersion.ClassicVersion%" == "" (
    REM override version number with the one provided by git
    set version=%GitVersion.ClassicVersion%
	echo Version set to %version%
    REM patch assemblyinfo with this version number
    REM call %GitVersion% /updateAssemblyInfo "properties\assemblyinfo.cs"
    REM call %GitVersion% /output buildserver /updateAssemblyInfo true
)

REM AssemblyInfoUtil.exe -set:%version% "C:\Program Files\MyProject1\AssemblyInfo.cs"

set nuget=
if "%nuget%" == "" (
     set nuget=nuget
)


REM ;AssemblyVersion="%version%";AssemblyFileVersion="%version%"
%WINDIR%\Microsoft.NET\Framework\v4.0.30319\msbuild ManagedWifi.msbuild /p:Configuration="%config%";VersionNumber="%version%" /m /v:M /fl /flp:LogFile=msbuild.log;Verbosity=diag /nr:false
 
mkdir Build
mkdir Build\lib
mkdir Build\lib\net20
 
%nuget% pack "ManagedWifi.nuspec" -NoPackageAnalysis -verbosity detailed -o Build -Version %version% -p Configuration="%config%"
