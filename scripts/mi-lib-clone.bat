@echo off

rem cloning required packages...

set CONFIG=config.ini
echo CONFIG = %CONFIG%

set SCRIPTS_DIR=%~dp0
echo SCRIPTS_DIR=%SCRIPTS_DIR%

set CURDIR=%CD%
echo CURDIR=%CURDIR%


if not exist %CONFIG% (
    echo Not exists '%CONFIG%' in current direcotry : %CURDIR% .
    echo Try 'scripts\mi-lib-clone.bat'
    exit /b 1
)


@REM parse CONFIG
for /f "tokens=1,* delims==" %%a in ( %CONFIG% ) do (
    set %%a=%%b
)
echo PREFIX = %PREFIX%
echo LIBS   = %LIBS%


@REM get LIB source
for %%d in ( %LIBS% ) do (
    echo LIB = %%d

    if not exist %%d (
        echo Not exists %%d directory.
        call :git_clone %%d
    ) else (
        echo %%d directory already exists.
        call :download_and_unzip %%d
    )
)



exit /b 0
@REM End of Main Routine

@REM --- subroutine -----------------------------------

:git_clone
    echo git_clone %LIB%
    set LIB=%1
    
    if "%LIB%"=="libxml2" (
        echo git.exe clone -b 2.9 https://gitlab.gnome.org/GNOME/libxml2.git %LIB%
        git.exe clone -b 2.9 https://gitlab.gnome.org/GNOME/libxml2.git %LIB%
    ) else (
        echo git.exe clone https://github.com/mi-lib/%LIB%.git
        git.exe clone https://github.com/mi-lib/%LIB%.git
    )
    
    exit /b 0


:download_and_unzip
    echo download_and_unzip %LIB%
    set LIB=%1
    
    if "%LIB%"=="libxml2" (
        set TAG=2.9
        set ZIP_FILENAME=%LIB%-%TAG%
        echo bitsadmin.exe /TRANSFER httpsdowload /download /priority foreground https://gitlab.gnome.org/GNOME/%LIB%/-/archive/2.9/%ZIP_FILENAME%.zip %CURDIR%\%ZIP_FILENAME%.zip
        bitsadmin.exe /TRANSFER httpsdowload /download /priority foreground https://gitlab.gnome.org/GNOME/%LIB%/-/archive/2.9/%ZIP_FILENAME%.zip %CURDIR%\%ZIP_FILENAME%.zip
    ) else (
        set BRANCH=main
        set ZIP_FILENAME=%LIB%-%BRANCH%
        echo bitsadmin.exe /TRANSFER httpsdowload /download /priority foreground https://github.com/mi-lib/%LIB%/archive/refs/heads/main.zip %CURDIR%\%ZIP_FILENAME%.zip
        bitsadmin.exe /TRANSFER httpsdowload /download /priority foreground https://github.com/mi-lib/%LIB%/archive/refs/heads/main.zip %CURDIR%\%ZIP_FILENAME%.zip
    )
    
    echo call powershell -command "Expand-Archive -Force %ZIP_FILENAME%.zip %CURDIR%"
    call powershell -command "Expand-Archive -Force %ZIP_FILENAME%.zip %CURDIR%"
    
    echo xcopy /Y/S/I %ZIP_FILENAME%\* %LIB%
    xcopy /Y/S/I %ZIP_FILENAME%\* %LIB%
    
    echo rmdir /s/q %ZIP_FILENAME%
    rmdir /s/q %ZIP_FILENAME%
    
    exit /b 0

