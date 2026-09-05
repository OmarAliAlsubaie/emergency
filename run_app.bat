@echo off
chcp 65001 > nul
title Saudi Ready 911
echo ============================================================
echo           SAUDI READY 911 - EMERGENCY SIMULATOR
echo ============================================================
echo.
echo Launching Saudi Ready on Chrome (Audio Enabled)...
cd /d "%~dp0"
flutter run -d chrome --web-browser-flag "--autoplay-policy=no-user-gesture-required"
pause



