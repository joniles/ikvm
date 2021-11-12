@echo off

set CONFIGURATION=Release
set TARGETFRAMEWORK=netcoreapp3.1

set SNK_FILE=c:\ikvm\ikvm.snk
rem https://docs.microsoft.com/en-us/dotnet/standard/assembly/create-signed-friend
set SNK_PUBLIC_KEY=0024000004800000940000000602000000240000525341310004000001000100d56fa8640620333f3c1f6f8966f85627903252e6cf8132f85755b121d69945cefcc287c02d2b7eb9306bf00187dafc11dc386e02babdae5c1425d7b157fff42b63e7f0610497ca57bab593ac1ae6ebe82397414ecfa5c4056fc1e9551a246d6b06d1d3cf6d5898dbd910665b086aee57b1d88a3b3b23280617ec41961e2fd8d5

set BUILDFLAGS=--nologo --no-dependencies -c %CONFIGURATION% -f %TARGETFRAMEWORK%

dotnet build %BUILDFLAGS% tools\updbaseaddresses\updbaseaddresses.csproj
dotnet build %BUILDFLAGS% tools\depcheck\depcheck.csproj
dotnet build %BUILDFLAGS% tools\pubkey\pubkey.csproj
dotnet build %BUILDFLAGS% tools\SourceLicenseAnalyzer\SourceLicenseAnalyzer.csproj
dotnet build %BUILDFLAGS% reflect\IKVM.Reflection.csproj
dotnet build %BUILDFLAGS% ikvmstub\ikvmstub.csproj
dotnet build %BUILDFLAGS% runtime\DummyLibrary\DummyLibrary.csproj
dotnet build %BUILDFLAGS% runtime\IKVM.Runtime.FirstPass\IKVM.Runtime.FirstPass.csproj
dotnet build %BUILDFLAGS% awt\IKVM.AWT.WinForms.FirstPass\IKVM.AWT.WinForms.FirstPass.csproj
dotnet build %BUILDFLAGS% ikvmc\ikvmc.csproj
dotnet build %BUILDFLAGS% openjdk\openjdk.csproj
dotnet build %BUILDFLAGS% runtime\IKVM.Runtime.JNI\IKVM.Runtime.JNI.csproj
rem Remove first-pass runtime binaries.
rem Build fails if there is IKVM.Runtime.dll
del /F /Q bin\%CONFIGURATION%\%TARGETFRAMEWORK%\IKVM.Runtime.dll bin\%CONFIGURATION%\%TARGETFRAMEWORK%\IKVM.Runtime.deps.json bin\%CONFIGURATION%\%TARGETFRAMEWORK%\IKVM.Runtime.xml bin\%CONFIGURATION%\%TARGETFRAMEWORK%\IKVM.Runtime.pdb
dotnet build %BUILDFLAGS% runtime\IKVM.Runtime\IKVM.Runtime.csproj
dotnet build %BUILDFLAGS% openjdk\openjdk.tools.csproj
rem Remove first-pass awt binaries.
rem Build fails if there is IKVM.AWT.WinForms.dll
del /F /Q bin\%CONFIGURATION%\%TARGETFRAMEWORK%\IKVM.AWT.WinForms.*
dotnet build %BUILDFLAGS% awt\IKVM.AWT.WinForms\IKVM.AWT.WinForms.csproj

rem dotnet build %BUILDFLAGS% tools\implib\implib.csproj
rem dotnet build %BUILDFLAGS% ikvm\ikvm.csproj
rem dotnet build %BUILDFLAGS% jvm\jvm.csproj

dotnet publish --no-build -f %TARGETFRAMEWORK% ikvmc\ikvmc.csproj
dotnet publish --no-build -f %TARGETFRAMEWORK% ikvmstub\ikvmstub.csproj
