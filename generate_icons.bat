@echo off
echo Generating app icons...
echo.

echo Step 1: Installing dependencies...
flutter pub get

echo.
echo Step 2: Generating launcher icons...
echo Make sure you have placed your icon.png file in assets/icon/
pause

flutter pub run flutter_launcher_icons:main

echo.
echo Icon generation complete!
echo Your app icons have been generated for all platforms.
pause