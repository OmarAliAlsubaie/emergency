@echo off
title Saudi Ready 911 - جاهز السعودية
chcp 65001 > nul
echo ============================================================
echo           🇸🇦 جاهز السعودية - SAUDI READY 911 🇸🇦
echo           تطبيق المحاكاة والجاهزية للطوارئ - 100%% Offline
echo ============================================================
echo.
echo جاري بدء تشغيل التطبيق على متصفح Chrome...
cd /d "%~dp0"
flutter run -d chrome
pause
