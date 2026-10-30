@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ===================================================
echo     EV360 Market Analysis Web Application
echo ===================================================
echo.

:: Detect uv executable
set "UV_CMD=uv"
where uv >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "%USERPROFILE%\.local\bin\uv.exe" (
        set "UV_CMD=%USERPROFILE%\.local\bin\uv.exe"
    )
)

:: Ensure virtual environment exists
if not exist ".venv\Scripts\python.exe" (
    echo [1/3] Creating Python virtual environment...
    !UV_CMD! venv .venv 2>nul || python -m venv .venv
)

:: Ensure dependencies are installed
echo [2/3] Checking dependencies...
if not exist ".venv\Lib\site-packages\flask" (
    echo Installing Flask and requirements...
    !UV_CMD! pip install flask python-dotenv 2>nul || .venv\Scripts\python.exe -m pip install flask python-dotenv
)

echo.
echo [3/3] Starting web server...
echo ---------------------------------------------------
echo  Website URL : http://127.0.0.1:5000
echo  Press Ctrl+C to stop the server
echo ---------------------------------------------------
echo.

:: Automatically open browser after 2 seconds in background
start "" /b cmd /c "timeout /t 2 /nobreak >nul & start http://127.0.0.1:5000"

:: Start Flask app
.venv\Scripts\python.exe app.py
pause



