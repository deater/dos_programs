echo off
: looper
vmwcmas.exe
if errorlevel 9 goto end
if errorlevel 6 goto xmas96
if errorlevel 5 goto xmas94
if errorlevel 4 goto xmas93
if errorlevel 3 qbasic /run xmas92\ocayf.bas
if errorlevel 2 qbasic /run xmas91\silent.txt
if errorlevel 1 qbasic /run xmas90\christma.txt
GOTO looper
: xmas96
cd xmas96
xmas96
cd ..
GOTO looper
: xmas94
cd xmas94
CALL christ.bat
cd ..
GOTO looper
: xmas93
cd xmas93
christma.exe
cd ..
GOTO looper
: END
echo on

