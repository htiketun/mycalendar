# Temporary Icon Placeholder

Since I cannot generate actual PNG files, please follow these steps to create your app icon:

## Quick Steps:

1. **Convert the SVG**: Use an online SVG to PNG converter to convert `icon.svg` to `icon.png` at 1024x1024 resolution
2. **Alternative**: Use any image editor to create a 1024x1024 purple calendar icon
3. **Save as**: `assets/icon/icon.png`

## Online Tools:

-   SVG to PNG: https://convertio.co/svg-png/
-   Icon Generator: https://icon.kitchen/
-   Simple Design: Use Canva with a purple background and white calendar symbol

## Once you have the PNG file:

1. Place it in `assets/icon/icon.png`
2. Run: `flutter pub get`
3. Run: `flutter pub run flutter_launcher_icons:main`

This will automatically generate all the required app icon sizes for Android, iOS, Web, and Desktop.
