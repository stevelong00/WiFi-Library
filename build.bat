@echo Off

set config=%1
if "%config%" == "" (
    set config=Release
)

set version=1.0.0
if not "%PackageVersion%" == "" (
     set version=%PackageVersion%
)

set nuget=
if "%nuget%" == "" (
     set nuget=nuget
)

# override version number with the one provided by git
call %GitVersion% /updateassemblyinfo 
 
%WINDIR%\Microsoft.NET\Framework\v4.0.30319\msbuild ManagedWifi.sln /p:Configuration="%config%" /m /v:M /fl /flp:LogFile=msbuild.log;Verbosity=diag /nr:false
 
mkdir Build
mkdir Build\lib
mkdir Build\lib\net20
 
%nuget% pack "ManagedWifi.nuspec" -NoPackageAnalysis -verbosity detailed -o Build -Version %version% -p Configuration="%config%"
