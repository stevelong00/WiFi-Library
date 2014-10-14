@echo on

set config=%1
if "%config%" == "" (
    set config=Release
)

set version=0.0.0.0
if not "%PackageVersion%" == "" (
    set version=%PackageVersion%
)
if not "%GitVersion.ClassicVersion%" == "" (
    REM override version number with the one provided by git
    set version=%GitVersion.ClassicVersion%
)

set nuget=
if "%nuget%" == "" (
     set nuget=nuget
)

%WINDIR%\Microsoft.NET\Framework\v4.0.30319\msbuild WifiLibrary.msbuild /p:Configuration="%config%";VersionNumber=%version% /m /v:M /clp:Verbosity=n /nr:false
 
mkdir Build
mkdir Build\lib
mkdir Build\lib\net20
 
%nuget% pack "WifiLibrary.nuspec" -NoPackageAnalysis -verbosity detailed -o Build -Version %version% -p Configuration="%config%"
