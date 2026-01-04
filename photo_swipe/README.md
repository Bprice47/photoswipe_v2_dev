# PhotoSwipe - Flutter Project

A Tinder-style gallery cleaner app. Swipe right to keep, swipe left to delete.

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. Clone or copy this project to your local machine

2. Navigate to the project directory:
   ```bash
   cd photo_swipe
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   ```

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # App configuration
├── config/
│   ├── theme.dart           # Dark theme, colors
│   ├── constants.dart       # App-wide constants
│   └── routes.dart          # Navigation routes
├── models/
│   ├── photo_model.dart     # Photo data model
│   └── session_model.dart   # Session state model
├── providers/
│   ├── photo_provider.dart  # Photo state management
│   ├── dumpbox_provider.dart # DumpBox state
│   └── session_provider.dart # Session management
├── screens/
│   ├── welcome_screen.dart  # Privacy disclaimer
│   ├── permission_screen.dart # Photo access request
│   ├── category_screen.dart # Main menu
│   ├── date_range_screen.dart # Date filter
│   ├── swipe_screen.dart    # Main swiping interface
│   └── dumpbox_screen.dart  # Review deleted photos
└── widgets/
    ├── app_logo.dart        # App logo widget
    ├── privacy_card.dart    # Privacy disclaimer card
    ├── category_tile.dart   # Category option tile
    ├── date_picker_button.dart # Date selection button
    ├── dumpbox_badge.dart   # DumpBox count badge
    ├── custom_checkbox.dart # Custom checkboxes
    └── confirmation_dialog.dart # Delete confirmation
```

## Build Phases

- [x] Phase 1: Foundation (Theme, Constants, Routes)
- [x] Phase 2: Welcome Screen
- [ ] Phase 3: Permission Service + Screen
- [ ] Phase 4: Category Screen (DONE - UI only)
- [ ] Phase 5: Date Range Screen (DONE - UI only)
- [ ] Phase 6: Photo Service (actual gallery loading)
- [ ] Phase 7: Swipe Screen + Card animations
- [ ] Phase 8: DumpBox Screen (DONE - UI only)
- [ ] Phase 9: Delete Flow (actual deletion)
- [ ] Phase 10: Session Resume

## iOS Configuration

The `ios/Runner/Info.plist` includes:
- `NSPhotoLibraryUsageDescription` - Photo library access
- `NSPhotoLibraryAddUsageDescription` - Save photos permission  
- `PHPhotoLibraryPreventAutomaticLimitedAccessAlert` - Handle limited access manually

## Android Configuration

The `android/app/src/main/AndroidManifest.xml` includes:
- `READ_EXTERNAL_STORAGE` (Android 12 and below)
- `READ_MEDIA_IMAGES` (Android 13+)
- `READ_MEDIA_VIDEO` (Android 13+)

## Design Specs

See `/app/memory/PRD.md` for complete design specifications including:
- Color palette
- Typography
- Screen layouts
- User flow diagrams

## License

Private - All rights reserved
