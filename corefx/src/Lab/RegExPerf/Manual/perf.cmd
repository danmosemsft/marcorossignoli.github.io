corerun ..\..\..\tools\csc.dll /noconfig /noconfig /optimize /r:System.Private.Corelib.dll /r:System.Runtime.dll /r:System.Runtime.Extensions.dll /r:System.Console.dll /r:System.Text.RegularExpressions.dll /r:System.Collections.dll /r:BenchmarkDotNet.dll /r:BenchmarkDotNet.Core.dll  /out:Program.dll Program.cs
PerfView.exe collect PerfViewData.etl /DotNetAllocSampled
corerun Program.dll 