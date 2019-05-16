@echo off

:: BatchGotAdmin
REM From - https://sites.google.com/site/eneerge/scripts/batchgotadmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

mkdir c:\meshcentral
cd c:\meshcentral

echo Downloading NodeJS
powershell -command "(New-Object System.Net.WebClient).DownloadFile('https://nodejs.org/dist/v10.15.3/node-v10.15.3-x64.msi', 'node-v10.15.3-

x64.msi')"

echo Installing NodeJS
msiexec.exe /i node-v10.15.3-x64.msi /qn /l* node-install-log.txt

call "C:\Program Files\nodejs\nodevars.bat"

echo Using NPM to install Requirements and MeshCentral
call npm install @davedoesdev/fido2-lib
call npm install meshcentral

echo.
echo.
echo ################################
echo.
echo 	     Install Finished
echo.
echo ################################

echo.
echo To Run:
echo.
echo node c:\meshcentral\node_modules\meshcentral\meshcentral.js --wanonly --cert yoursitename.com
echo.

pause

