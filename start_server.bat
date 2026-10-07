@echo off
cd /d "%~dp0"
title IYP Local Dev Server (Port 8765)
python dev_server.py
if errorlevel 1 (
    echo.
    echo Python not found in PATH or server crashed.
    pause
)
