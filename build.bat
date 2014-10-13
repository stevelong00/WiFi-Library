@echo Off

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
    REM patch assemblyinfo with this version number
    REM call %GitVersion% /updateAssemblyInfo "properties\assemblyinfo.cs"
    call %GitVersion% /output buildserver /updateAssemblyInfo "properties\assemblyinfo.cs"
)

set nuget=
if "%nuget%" == "" (
     set nuget=nuget
)


REM ;AssemblyVersion="%version%";AssemblyFileVersion="%version%"
%WINDIR%\Microsoft.NET\Framework\v4.0.30319\msbuild ManagedWifi.sln /p:Configuration="%config%" /m /v:M /fl /flp:LogFile=msbuild.log;Verbosity=diag /nr:false
 
mkdir Build
mkdir Build\lib
mkdir Build\lib\net20
 
%nuget% pack "ManagedWifi.nuspec" -NoPackageAnalysis -verbosity detailed -o Build -Version %version% -p Configuration="%config%"
