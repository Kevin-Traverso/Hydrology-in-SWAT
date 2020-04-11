@echo off
./
cd ./Swat_model/.model_run/thread_1
swat.exe
if %errorlevel% == 0 exit 0
echo.
