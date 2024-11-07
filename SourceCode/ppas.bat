@echo off
SET THEFILE=C:\Users\Aaron\Desktop\Facultad\Material\2°año\2do año(1er cuat)\SINTAX Y SEMAN\TRABAJO FINAL\TPF.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.2.2\bin\i386-win32\ld.exe -b pei-i386 -m i386pe  --gc-sections    --entry=_mainCRTStartup    -o "C:\Users\Aaron\Desktop\Facultad\Material\2°año\2do año(1er cuat)\SINTAX Y SEMAN\TRABAJO FINAL\TPF.exe" "C:\Users\Aaron\Desktop\Facultad\Material\2°año\2do año(1er cuat)\SINTAX Y SEMAN\TRABAJO FINAL\link5196.res"
if errorlevel 1 goto linkend
C:\lazarus\fpc\3.2.2\bin\i386-win32\postw32.exe --subsystem console --input "C:\Users\Aaron\Desktop\Facultad\Material\2°año\2do año(1er cuat)\SINTAX Y SEMAN\TRABAJO FINAL\TPF.exe" --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
