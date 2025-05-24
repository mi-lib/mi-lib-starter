@echo off

rem add environment path temporarily in command prompt

echo;

echo CURRENT_ABS_PATH=%~dp0
set CURRENT_ABS_PATH=%~dp0

echo LIB_ABS_PATH=%CURRENT_ABS_PATH%..\build\lib
set LIB_ABS_PATH=%CURRENT_ABS_PATH%..\build\lib

echo;

@REM echo dir %LIB_ABS_PATH%\
@REM dir %LIB_ABS_PATH%\

echo set PATH=%PATH%;%LIB_ABS_PATH%
set PATH=%PATH%;%LIB_ABS_PATH%

echo;
