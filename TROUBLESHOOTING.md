# Troubleshooting Guide

## Common Issues and Solutions

### 1. Build Failed on Windows with Arabic Path

**Problem**: Flutter build fails when project is in a directory with Arabic characters.

**Error Example**:
```
Custom build for 'D:\???? ??????\rahla_alawda_monopoly\build\windows\...' exited with code 1
```

**Solutions**:

#### Option A: Move Project (Recommended)
1. Copy the entire project folder to a path with only English characters:
   ```
   C:\Projects\rahla_alawda_monopoly\
   ```
2. Open command prompt in the new location
3. Run: `flutter clean && flutter pub get`
4. Run: `flutter run -d windows`

#### Option B: Use Web Version
1. Enable web support: `flutter config --enable-web`
2. Run in browser: `flutter run -d chrome`

#### Option C: Use Windows Subsystem for Linux (WSL)
1. Install WSL2 with Ubuntu
2. Install Flutter in WSL
3. Run the project from WSL environment

### 2. Dependencies Not Found

**Problem**: Package 'provider' not found or import errors.

**Solution**:
```bash
flutter clean
flutter pub get
flutter analyze
```

### 3. Custom Painter Not Rendering

**Problem**: Board appears blank or squares don't show.

**Check**:
- Ensure GameService is properly provided
- Verify board squares data is loaded
- Check canvas size is not zero

### 4. Arabic Text Not Displaying Correctly

**Problem**: Arabic text appears as boxes or reversed.

**Solutions**:
- Ensure system has Arabic fonts installed
- Add Arabic font to pubspec.yaml if needed
- Verify TextDirection.rtl is set

### 5. App Crashes on Startup

**Problem**: Application crashes immediately on launch.

**Debug Steps**:
1. Run with verbose logging: `flutter run -v`
2. Check for null safety issues
3. Verify all required dependencies are installed
4. Clean and rebuild: `flutter clean && flutter run`

## Performance Issues

### Slow Board Rendering
- CustomPainter redraws on every state change
- Consider optimizing `shouldRepaint` method
- Cache expensive calculations

### Memory Leaks
- Ensure controllers are disposed properly
- Check for unnecessary listeners

## Platform-Specific Issues

### Windows
- May require Visual Studio build tools
- Check Windows SDK is installed
- Ensure developer mode is enabled

### macOS
- Requires Xcode for desktop builds
- Enable desktop support: `flutter config --enable-macos-desktop`

### Linux
- Install required GTK development libraries
- Enable desktop support: `flutter config --enable-linux-desktop`

## Development Tips

### Hot Reload Not Working
```bash
flutter clean
flutter run
# Then use 'r' for hot reload
```

### Debugging State Issues
- Use Flutter Inspector
- Add debug prints in GameService
- Use Provider.of(context, listen: false) for debugging

### Testing on Different Devices
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

## Getting Help

1. **Flutter Documentation**: https://docs.flutter.dev/
2. **Provider Package**: https://pub.dev/packages/provider
3. **Flutter Desktop**: https://docs.flutter.dev/development/platform-integration/desktop
4. **Arabic Text Support**: https://docs.flutter.dev/development/accessibility-and-localization/internationalization

## Quick Commands Reference

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Run on different platforms
flutter run -d windows
flutter run -d chrome
flutter run -d macos
flutter run -d linux

# Enable platforms
flutter config --enable-web
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Build for release
flutter build windows
flutter build web
```

---

**Note**: If you continue to experience issues, try creating a new project in an English-only path and copying the `lib` folder contents. 