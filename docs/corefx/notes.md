# marcorossignoli.github.io

## Build/Test
```
build -framework netfx
build -framework uap  
msbuild /t:rebuildandtest /v:m /p:TargetGroup=netfx <- launch this command under `...\tests` folder of solutions

// on unix create an alias to "dotnet msbuild" verb
alias msbuild="~/repos/corefx/.dotnet/dotnet msbuild"
marco@Ubuntu1404:~/repos/corefx/src/System.Diagnostics.Process/tests$ msbuild /t:rebuildandtest /v:m
// or use https://github.com/dotnet/corefx/pull/33974#issuecomment-446295789
corefx/eng/common/msbuild.sh


msbuild /v:m /t:RebuildAndTest "/p:XunitOptions=-trait MyTrait=MyTrait"  System.Runtime.Extensions.Tests.csproj
msbuild /v:m /t:RebuildAndTest "/p:XunitOptions=-method System.IO.Tests.PathTests.Try_GetTempPath_Default"  System.Runtime.Extensions.Tests.csproj  
msbuild /v:m /t:RebuildAndTest "/p:XunitOptions=-method *Impersonate_WindowsIdentity_Object_InvalidToken"  
msbuild /v:m /t:rebuildandtest /p:ConfigurationGroup=Release /p:xunitoptions="-method %2ATestAsyncOutputStream%2A" /p:outerloop=true

set DOTNET_MULTILEVEL_LOOKUP=0
```
Dev guide https://github.com/dotnet/corefx/blob/master/Documentation/project-docs/developer-guide.md  
Build Pivot https://github.com/dotnet/corefx/blob/6cb23ac20696ab314d2b28e95af40c8454bd7c0d/Documentation/coding-guidelines/project-guidelines.md#build-pivots  
MSBuild Command-Line Reference https://msdn.microsoft.com/en-us/library/ms164311.aspx  

Single test msbuild /p:XunitMethodName https://github.com/dotnet/corefx/wiki/Build-and-run-tests#run-and-debug-single-test-in-command-line  
trait dotnet test https://github.com/Microsoft/vstest-docs/blob/master/docs/filter.md  
```
dotnet test --filter TraitName=TraitValue
```
Debugging NETFX tests in Visual Studio https://github.com/dotnet/corefx/blob/a7f6f470cb2c4cdaafdc3ad85e2520992a8db265/Documentation/building/windows-instructions.md#debugging-netfx-tests-in-visual-studio  
[MsBuild Command line for switches](https://msdn.microsoft.com/en-us/library/ms164311.aspx)  
[XUnit method with msbuild](https://github.com/dotnet/buildtools/blob/master/Documentation/test-targets-usage.md#run-a-single-xunit-method)   
[Test on Nano server](https://github.com/dotnet/corefx/pull/33645#issuecomment-442546012)  
## Viewing jit dumps coreclr 
https://github.com/dotnet/coreclr/blob/master/Documentation/building/viewing-jit-dumps.md  
If you don't find what method jit try this trick https://github.com/dotnet/corefx/issues/35219#issuecomment-463689480  
For System.Private.CoreLib
```
set COMPlus_TieredCompilation_Test_OptimizeTier0=1
set COMPlus_ReadyToRun=0
set COMPlus_JitDiffableDasm=1  
set COMPlus_JitDisasm=TryInsert <- Dictionary sample
set COMPlus_JitDisasm=Dictionary`2:.ctor <- Constructor
set COMPlus_JitDisasm=.ctor <- Constructor
```


## Available Outerloop
New Azure pipeline commands https://github.com/dotnet/corefx/issues/35121#issuecomment-462849658  
```
/azp run corefx-ci
/azp run corefx-outerloop-linux
/azp run corefx-outerloop-osx
/azp run corefx-outerloop-windows

Also, to run all the above, you can just do:
/azp run

@dotnet-bot test Outerloop Windows x64 Debug Build
@dotnet-bot test Outerloop Linux x64 Debug Build
@dotnet-bot test Outerloop NETFX x86 Debug Build
@dotnet-bot test Outerloop UWP CoreCLR x64 Debug Build
@dotnet-bot test Outerloop Linux x64 Release Build please
@dotnet-bot test Outerloop Windows x86 Release Build please

@dotnet-bot help // to get all available tests
```

## Coverage

Workflow https://github.com/dotnet/corefx/issues/23588#issuecomment-394055817

On CoreClr repo:
```
build -release -skipTests -- /p:DebugType=pdbonly
build -release -skipTests -windowsmscorlib -- /p:DebugType=pdbonly
```

The second step is important to get IL only of CoreLib on the folder that is going to be used in the CoreCLROverridePath, but as mentioned can be done in other ways.

On CoreFx repo:
```
build -- /p:CoreCLROverridePath=C:\s\coreclr\bin\Product\Windows_NT.x64.Release
build-tests -skipTests -- /p:CoreCLROverridePath=C:\s\coreclr\bin\Product\Windows_NT.x64.Release
cd src\System.Collections\tests
msbuild /t:RebuildAndTest /p:Coverage=True /p:CodeCoverageAssemblies="System.Private.CoreLib"
```

## Benchmarking/Profiling

https://github.com/dotnet/corefx/blob/master/Documentation/project-docs/benchmarking.md  

Adam Sitnik  
https://github.com/dotnet/corefxlab/pull/2369#issuecomment-399122942  
https://github.com/dotnet/coreclr/pull/22832#issuecomment-471991845  

Andrey Akinshin https://github.com/dotnet/corefx/pull/32389#issuecomment-424642336  
Viktor Hofer https://github.com/dotnet/corefx/pull/30632#issuecomment-399778513  
corefx guide(my [PR](https://github.com/dotnet/coreclr/pull/18524#issuecomment-398237008)) https://github.com/dotnet/corefx/blob/master/Documentation/project-docs/performance-tests.md  

Performance repo https://github.com/dotnet/performance  
https://github.com/dotnet/performance/tree/master/src/tools/ResultsComparer Comparer  

Run benchmarks multi corerun.exe
```
.\scripts\benchmarks_ci.py --frameworks netcoreapp3.0 --filter *.Perf_Dictionary.* --corerun D:\git\corefxupstream\artifacts\bin\testhost\netcoreapp-Windows_NT-Release-x64\shared\Microsoft.NETCore.App\9.9.9\CoreRun.exe D:\git\corefx\artifacts\bin\testhost\netcoreapp-Windows_NT-Release-x64\shared\Microsoft.NETCore.App\9.9.9\CoreRun.exe --bdn-arguments="--join"
```

Stephen's way to profile allocation https://github.com/dotnet/corefx/pull/36056#issuecomment-476671769  

## Extras

* Find string on source
```
  cmd -> findstr /n /s /c:"!Directory.Exists("  *.cs  
  bash -> git grep -n 'JsonDataContractCriticalHelper' | grep -v tests | cut -d: -f1,2 
```

* dotnet core repos https://github.com/dotnet/core/blob/master/Documentation/core-repos.md
* area owner https://github.com/dotnet/corefx/blob/master/Documentation/project-docs/issue-guide.md#areas
* [MSBuild-Tips-&-Tricks.md](https://github.com/Microsoft/msbuild/blob/b657647d2e6f4ed20ce6cb3201a55ee02f09c062/documentation/wiki/MSBuild-Tips-%26-Tricks.md)
* dotnet core release csv/json https://github.com/dotnet/core/tree/master/release-notes
* dotnet core SDKs https://github.com/dotnet/core-sdk#installers-and-binaries  
* platform-compat https://github.com/dotnet/platform-compat  
* DOTNET_MULTILEVEL_LOOKUP https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet?tabs=netcore21  
* Recognize uap fail leg on tests https://github.com/dotnet/corefx/pull/33645#issuecomment-447518192  
* Dogfooding .NET core app sample https://github.com/dotnet/coreclr/issues/21559#issuecomment-447976642  
* C# meetings https://github.com/dotnet/csharplang/tree/master/meetings  
