# PayFlow Splash Screen Setup Guide

## Overview
This guide explains how to set up the custom splash screen and generate the PayFlow logo PNG.

## What's Been Added

### 1. **Custom Flutter Splash Screen** ✅
- Location: `lib/core/widgets/splash_screen.dart`
- Features:
  - Animated PayFlow logo with flowing payment visualization
  - Smooth fade and scale animations
  - 3-second display duration with animated transitions
  - Shows "PayFlow" branding and "Smart Payment Solutions" tagline
  - Automatically routes to FirstLaunchScreen or HomeScreen

### 2. **Logo Files**
- **SVG**: `assets/payflow_logo.svg` - Vector format (scalable)
- **PNG**: `assets/payflow_logo.png` - Raster format (needed for native splash screen)

### 3. **Dependencies Updated**
- ✅ `vibration: ^1.11.0` - Updated from v1.9.0 (fixes Android compilation issues)
- ✅ `flutter_native_splash: ^2.4.0` - For native splash screen generation

## Setup Steps

### Step 1: Generate PNG from SVG
You need to convert the SVG logo to PNG format. Choose one method:

#### Option A: Using Python Script (Recommended)
```bash
cd C:\Users\Vishal\StudioProjects\payflow
pip install pillow
python generate_logo.py
```

#### Option B: Using Online Converter
1. Visit: https://www.online-convert.com/convert-to-png
2. Upload: `assets/payflow_logo.svg`
3. Set size to: 512x512 (or 1024x1024)
4. Download and save as: `assets/payflow_logo.png`

#### Option C: Using ImageMagick (Windows)
```bash
# Install ImageMagick via Chocolatey
choco install imagemagick

# Convert SVG to PNG
convert assets\payflow_logo.svg -background white -gravity center -extent 512x512 assets\payflow_logo.png
```

#### Option D: Using macOS/Linux
```bash
# macOS
brew install imagemagick
convert assets/payflow_logo.svg -background white -gravity center -extent 512x512 assets/payflow_logo.png

# Linux
sudo apt-get install imagemagick
convert assets/payflow_logo.svg -background white -gravity center -extent 512x512 assets/payflow_logo.png
```

### Step 2: Run Flutter Pub Get
```bash
cd C:\Users\Vishal\StudioProjects\payflow
flutter pub get
```

### Step 3: Generate Native Splash Screen
```bash
# Generate splash screen for Android and iOS
dart run flutter_native_splash:create

# Or use flutter pubspec method
flutter pub run flutter_native_splash:create
```

### Step 4: Build the App
```bash
# Clean previous builds
flutter clean

# Build APK
flutter build apk --release

# Or build app bundle
flutter build appbundle --release
```

## Troubleshooting

### PNG File Not Generated
If you see the error about missing `payflow_logo.png`:
1. Make sure ImageMagick or similar tool is installed
2. The SVG file is at `assets/payflow_logo.svg`
3. Try the online converter method as fallback
4. Ensure PNG is saved as exactly `assets/payflow_logo.png`

### Vibration Package Compilation Error
If you still see vibration package errors:
```bash
flutter pub upgrade vibration
flutter clean
flutter pub get
flutter build apk --release
```

### Splash Screen Not Showing
1. Verify `assets/payflow_logo.png` exists
2. Clear app data and reinstall
3. Check that `pubspec.yaml` has the flutter_native_splash config
4. Run: `flutter pub run flutter_native_splash:create`

## Logo Design Details

The PayFlow logo features:
- **Color**: Google Blue (#1A73E8) - matches app theme
- **Icon**: Rupee symbol (₹) representing payment
- **Theme**: Flowing waves representing the "flow" of payments
- **Style**: Modern, minimalist fintech aesthetic
- **Typography**: Clean sans-serif "PayFlow" text

## Testing the Splash Screen

1. **First App Launch**: 
   - Splash screen displays for 3 seconds
   - Then redirects to Profile setup (first-time user)

2. **Subsequent Launches**:
   - Splash screen displays for 3 seconds
   - Then navigates to Home screen

3. **Manual Testing**:
   ```bash
   flutter run
   # You'll see the splash screen animation
   ```

## Customization

To modify the splash screen:

### Change Display Duration
Edit `lib/core/widgets/splash_screen.dart`:
```dart
Future.delayed(const Duration(seconds: 3), () {  // Change 3 to desired seconds
```

### Change Colors
Update the `Container` background color:
```dart
color: AppColors.googleBlue.withOpacity(0.1),  // Adjust opacity or color
```

### Change Animation Speed
```dart
late AnimationController _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),  // Adjust timing
      vsync: this,
    );
```

### Change Text
```dart
Text(
  'PayFlow',  // Change app name
  style: ...
),
```

## Files Modified/Created

✅ **Created**:
- `lib/core/widgets/splash_screen.dart` - Custom splash screen widget
- `assets/payflow_logo.svg` - SVG logo file
- `generate_logo.py` - Python helper script

✅ **Modified**:
- `pubspec.yaml` - Added flutter_native_splash config, updated vibration
- `lib/main.dart` - Integrated splash screen into app flow

## Next Steps

1. Generate the PNG logo (follow Step 1 above)
2. Run `flutter pub get`
3. Run `flutter pub run flutter_native_splash:create`
4. Build and test: `flutter run`

The app now has a professional splash screen with animated PayFlow branding! 🎉

## Support

If you encounter issues:
1. Check that `assets/payflow_logo.png` exists (512x512 minimum)
2. Run `flutter clean && flutter pub get`
3. Delete build directory: `rm -rf build/`
4. Rebuild: `flutter build apk --release`
