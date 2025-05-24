@echo off

rem add environment path temporarily in command prompt

echo;

set CONFIG=config.ini
echo CONFIG = %CONFIG%

set SCRIPTS_DIR=%~dp0
echo SCRIPTS_DIR=%SCRIPTS_DIR%

set CURDIR=%CD%
echo CURDIR=%CURDIR%

if not exist %CONFIG% (
    echo Not exists '%CONFIG%' in current direcotry : %CURDIR% .
    echo Try 'scripts\mi-llb-export-header.bat'
    exit /b 1
)

@REM parse CONFIG
for /f "tokens=1,* delims==" %%a in ( %CONFIG% ) do (
    set %%a=%%b
)
echo PREFIX = %PREFIX%
echo LIBS   = %LIBS%

@REM create export.h and replace
for %%d in ( %LIBS% ) do (
    echo LIB = %%d

    if exist %%d (
        echo directory %%d exists.
        cd %%d
        call :create_export_header
        cd ../
    ) else (
        echo WARNING : directory %%d not exists!!
        echo ... Try 'scripts\mi-lib-clone.bat'
    )

    echo ======
)

exit /b 0
@REM End of Main Routine

@REM --- subroutine -----------------------------------

:create_export_header
    @REM setlocal..endlocal is for converting LowerCase into UpperCase 
    setlocal
    set LIB=%1 
    echo create_export_header %LIB%
    set CURDIR=%CD%
    echo CURDIR = %CURDIR%
    if not exist libinfo (
        echo WARNING : file libinfo not exists!!
        exit /b 0
    )
    @REM parse libinfo
    for /f "tokens=1,* delims==" %%a in ( libinfo ) do (
        set %%a=%%b
    )
    echo PROJNAME = %PROJNAME%
    echo VERSION = %VERSION%
    set PROJNAME_UNDERSCORE=%PROJNAME:-=_%
    echo PROJNAME_UNDERSCORE = %PROJNAME_UNDERSCORE%
    set EXPORT_HEADER=%CURDIR%\include\%PROJNAME_UNDERSCORE%\%PROJNAME_UNDERSCORE%_export.h
    echo EXPORT_HEADER = %EXPORT_HEADER%
    if exist %EXPORT_HEADER% (
        set EXPORT_HEADER_EXIST=y
    ) else (
        set EXPORT_HEADER_EXIST=n
    )
    echo EXPORT_HEADER_EXIST = %EXPORT_HEADER_EXIST%
    if %EXPORT_HEADER_EXIST%==y (
        echo %EXPORT_HEADER% already exists. Remove and regenerate it.
        @REM del %EXPORT_HEADER%
    )
    set PROJNAME_CAPITAL=%PROJNAME_UNDERSCORE%
    echo PROJNAME_CAPITAL = %PROJNAME_CAPITAL%
    for %%i in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do call set PROJNAME_CAPITAL=%%PROJNAME_CAPITAL:%%i=%%i%%
    echo PROJNAME_CAPITAL = %PROJNAME_CAPITAL%
    
    set TMPFILE=..\tmp_%PROJNAME_UNDERSCORE%_export.h
    type nul > %TMPFILE%
	echo /* %EXPORT_HEADER:\=/% */> %TMPFILE%
	echo /* This file was automatically generated. */>> %TMPFILE%    
    for /f "usebackq delims=" %%T in (`tzutil /g`) do set "TIMEUSERLOG=%date% %time% %%T by %USERNAME%"
	echo /* %TIMEUSERLOG% */>> %TMPFILE%
	echo #ifndef __%PROJNAME_CAPITAL%_EXPORT_H__>> %TMPFILE%
	echo #define __%PROJNAME_CAPITAL%_EXPORT_H__>> %TMPFILE%
	echo #include ^<zeda/zeda_compat.h^>>> %TMPFILE%
	echo #if defined(__WINDOWS__) ^&^& ^!defined(__CYGWIN__)>> %TMPFILE%
	echo # if defined(__%PROJNAME_CAPITAL%_BUILD_DLL__)>> %TMPFILE%
	echo #  define __%PROJNAME_CAPITAL%_EXPORT extern __declspec(dllexport)>> %TMPFILE%
	echo #  define __%PROJNAME_CAPITAL%_CLASS_EXPORT  __declspec(dllexport)>> %TMPFILE%
	echo # else>> %TMPFILE%
	echo #  define __%PROJNAME_CAPITAL%_EXPORT extern __declspec(dllimport)>> %TMPFILE%
	echo #  define __%PROJNAME_CAPITAL%_CLASS_EXPORT  __declspec(dllimport)>> %TMPFILE%
	echo # endif>> %TMPFILE%
	echo #else>> %TMPFILE%
	echo # define __%PROJNAME_CAPITAL%_EXPORT __EXPORT>> %TMPFILE%
	echo # define __%PROJNAME_CAPITAL%_CLASS_EXPORT>> %TMPFILE%
	echo #endif>> %TMPFILE%
	echo #define __%PROJNAME_CAPITAL%_VERSION %VERSION%>> %TMPFILE%
	echo #endif /* __%PROJNAME_CAPITAL%_EXPORT_H__ */>> %TMPFILE%
    @REM @replace cRLF -> LF
    powershell -NoProfile -Command "$utf8NoBom = New-Object System.Text.UTF8Encoding($false); $lines = Get-Content '%TMPFILE%'; $writer = New-Object System.IO.StreamWriter('%EXPORT_HEADER%', $false, $utf8NoBom); $writer.NewLine = \"`n\"; foreach ($line in $lines) { $writer.WriteLine($line) }; $writer.Close()"
    del %TMPFILE%
    endlocal

    exit /b 0

