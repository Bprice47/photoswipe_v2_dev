# PhotoSwipe Complete Codebase & Build Failure Analysis

## 🚨 THE PROBLEM - iOS Build Failure

**The app WON'T BUILD.** This is NOT a runtime/photo loading issue - the native iOS code from the `photo_manager` Flutter plugin fails to compile in Xcode.

### Error Screenshot Analysis
- **Build Status:** 1 Error, 15 Warnings
- **Primary Error:** `Command PhaseScriptExecution failed with a nonzero exit code`
- **Root Cause:** The `photo_manager` plugin (version 3.8.3) uses deprecated iOS APIs:
  - `CC_MD5` - deprecated in iOS 13.0
  - `keyWindow` - deprecated in iOS 13.0  
  - `openURL:` - deprecated in iOS 10.0
- **File with issue:** `/Users/benjaminprice/.pub-cache/hosted/pub.dev/photo_manager-3.8.3/...` (native Objective-C code)

### What This Means
Your Dart code is **perfect**. The problem is inside the `photo_manager` package's native iOS implementation - code written by the plugin authors, not you.

---

## 📱 APP OVERVIEW

**PhotoSwipe** - A Tinder-style photo gallery cleaner for iOS & Android

### Core Features
- Swipe LEFT → Delete (photo goes to "DumpBox")
- Swipe RIGHT → Keep photo
- DumpBox → Review before permanent deletion
- Filter by: Most Recent, Oldest, Videos, Date Range, Resume Session
- Privacy-first: All processing on-device

### Tech Stack
- **Framework:** Flutter 3.0+
- **Platforms:** iOS 14+, Android
- **Key Plugin:** `photo_manager: ^3.0.0` (the problematic one)
- **State Management:** Provider
- **Storage:** Hive + SharedPreferences

---

## 📦 DEPENDENCIES (pubspec.yaml)

```yaml
name: photoswipe_emergent
description: A Tinder-style gallery cleaner app. Swipe right to keep, swipe left to delete.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  photo_manager: ^3.0.0          # ← THE PROBLEM PLUGIN
  permission_handler: ^11.3.0
  google_fonts: ^6.1.0
  flutter_card_swiper: ^7.0.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.18.1
  uuid: ^4.2.2
  path_provider: ^2.1.2
  flutter_launcher_icons: ^0.14.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.8

flutter:
  uses-material-design: true

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
  remove_alpha_ios: true
```

---

## 🍎 iOS CONFIGURATION

### ios/Podfile
```ruby
platform :ios, '14.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist..."
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found..."
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

### ios/Runner/Info.plist (Permissions)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>PhotoSwipe</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>PhotoSwipe</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
    </array>
    
    <!-- Photo Library Permissions (iOS 14+) -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>PhotoSwipe needs access to your photo library to help you review and delete photos.</string>
    
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>PhotoSwipe needs permission to save photos you want to keep.</string>
    
    <!-- Prevent automatic limited access alert (we handle it manually) -->
    <key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key>
    <true/>
    
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    <key>CADisableMinimumFrameDurationOnPhone</key>
    <true/>
</dict>
</plist>
```

---

## 📁 PROJECT STRUCTURE

```
photoswipe_emergent/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── constants.dart
│   │   ├── routes.dart
│   │   └── theme.dart
│   ├── models/
│   │   ├── photo_model.dart
│   │   └── session_model.dart
│   ├── services/
│   │   ├── permission_service.dart
│   │   ├── photo_service.dart
│   │   └── storage_service.dart
│   ├── providers/
│   │   ├── photo_provider.dart
│   │   ├── dumpbox_provider.dart
│   │   └── session_provider.dart
│   ├── screens/
│   │   ├── welcome_screen.dart
│   │   ├── permission_screen.dart
│   │   ├── category_screen.dart
│   │   ├── date_range_screen.dart
│   │   ├── swipe_screen.dart
│   │   └── dumpbox_screen.dart
│   └── widgets/
│       ├── app_logo.dart
│       ├── privacy_card.dart
│       ├── category_tile.dart
│       ├── swipe_card.dart
│       ├── dumpbox_badge.dart
│       ├── confirmation_dialog.dart
│       └── custom_checkbox.dart
├── ios/
│   ├── Podfile
│   └── Runner/
│       └── Info.plist
└── android/
```

---

## 🎯 COMPLETE DART CODE

### lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'providers/photo_provider.dart';
import 'providers/dumpbox_provider.dart';
import 'providers/session_provider.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await StorageService.instance.init();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => DumpBoxProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: const PhotoSwipeApp(),
    ),
  );
}
```

### lib/app.dart
```dart
import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'screens/welcome_screen.dart';

class PhotoSwipeApp extends StatelessWidget {
  const PhotoSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoSwipe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const WelcomeScreen(),
    );
  }
}
```

### lib/config/constants.dart
```dart
class AppConstants {
  AppConstants._();

  static const String appName = 'PhotoSwipe';
  static const String appTagline = 'A Tinder-style gallery cleaner';
  static const String appVersion = '1.2.0';

  // Storage Keys
  static const String keyHasAcceptedTerms = 'has_accepted_terms';
  static const String keyHasGrantedPermission = 'has_granted_permission';
  static const String keyLastSessionId = 'last_session_id';
  static const String keyDumpBoxIds = 'dumpbox_ids';
  static const String keySessions = 'sessions';
  static const String keyReviewedPhotoIds = 'reviewed_photo_ids';

  // Photo Loading
  static const int photosPerPage = 500;
  static const int maxInitialPhotos = 50000;
  static const int thumbnailSize = 800;
  static const int highQualitySize = 800;

  // Swipe Settings
  static const double swipeThreshold = 100.0;
  static const double swipeVelocityThreshold = 300.0;
  static const double maxRotationAngle = 15.0;
  static const int cardsInStack = 3;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration swipeAnimationDuration = Duration(milliseconds: 400);

  // Privacy Disclaimer
  static const List<String> privacyPoints = [
    'We do NOT save, store, or use your photos for any reason',
    'We only access your photos so you can review and delete them',
    'All photo processing happens on YOUR device',
    'We are NOT liable for any photos you choose to delete',
    'Deletions are permanent and cannot be recovered',
    'On iOS, deleted photos remain in Recently Deleted for 30 days',
  ];

  // Permission Messages
  static const String permissionTitle = 'Photo Access Required';
  static const String permissionMessage =
      'PhotoSwipe needs access to your photo library to help you review and delete photos.';
  static const String permissionDeniedMessage =
      'Photo access was denied. Please enable it in Settings to use PhotoSwipe.';
  static const String permissionLimitedMessage =
      'You\'ve granted limited access. Tap here to select more photos or grant full access.';

  // Category Options
  static const String categoryMostRecent = 'Most Recent';
  static const String categoryMostRecentDesc = 'Start with newest photos';
  static const String categoryOldest = 'Oldest';
  static const String categoryOldestDesc = 'Start with oldest photos';
  static const String categoryVideos = 'Videos';
  static const String categoryVideosDesc = 'Review video files only';
  static const String categoryDateRange = 'Custom Date Range';
  static const String categoryDateRangeDesc = 'Pick start and end dates';
  static const String categoryResume = 'Resume Last Session';
  static const String categoryResumeDesc = 'Continue with unreviewed photos';

  // Empty States
  static const String emptyStateTitle = 'Good Job!';
  static const String emptyStateMessage = 'No more photos to review.';
  static const String emptyDumpBoxTitle = 'DumpBox is Empty';
  static const String emptyDumpBoxMessage =
      'Photos you swipe left will appear here for review before deletion.';

  // Confirmation Messages
  static const String deleteConfirmTitle = 'Delete photos?';
  static const String deleteConfirmMessage =
      'This will permanently delete these photos from your device.';
  static const String deleteConfirmNote =
      'On some devices they may first move to "Recently Deleted" for 30 days.';

  // Button Labels
  static const String buttonContinue = 'Continue';
  static const String buttonGrantAccess = 'Grant Access';
  static const String buttonStartReview = 'Start Review';
  static const String buttonDelete = 'Delete';
  static const String buttonKeep = 'Keep';
  static const String buttonCancel = 'Cancel';
  static const String buttonRestoreAll = 'Restore All';
  static const String buttonClearSelection = 'Clear Selection';
  static const String buttonDeleteSelected = 'Delete Selected';
  static const String buttonKeepSelected = 'Keep Selected';
  static const String buttonGoToSettings = 'Go to Settings';
}

enum FilterType {
  mostRecent,
  oldest,
  videos,
  dateRange,
  resume,
}

enum SortOrder {
  ascending,
  descending,
}
```

### lib/config/routes.dart
```dart
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/permission_screen.dart';
import '../screens/category_screen.dart';
import '../screens/date_range_screen.dart';
import '../screens/swipe_screen.dart';
import '../screens/dumpbox_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_of_service_screen.dart';
import '../screens/disclaimer_screen.dart';
import '../screens/about_screen.dart';
import '../screens/contact_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String welcome = '/';
  static const String permission = '/permission';
  static const String category = '/category';
  static const String dateRange = '/date-range';
  static const String swipe = '/swipe';
  static const String dumpbox = '/dumpbox';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String disclaimer = '/disclaimer';
  static const String about = '/about';
  static const String contact = '/contact';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _buildRoute(const WelcomeScreen(), settings);
      case permission:
        return _buildRoute(const PermissionScreen(), settings);
      case category:
        return _buildRoute(const CategoryScreen(), settings);
      case dateRange:
        return _buildRoute(const DateRangeScreen(), settings);
      case swipe:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(SwipeScreen(filterOptions: args), settings);
      case dumpbox:
        return _buildRoute(const DumpBoxScreen(), settings);
      case privacyPolicy:
        return _buildRoute(const PrivacyPolicyScreen(), settings);
      case termsOfService:
        return _buildRoute(const TermsOfServiceScreen(), settings);
      case disclaimer:
        return _buildRoute(const DisclaimerScreen(), settings);
      case about:
        return _buildRoute(const AboutScreen(), settings);
      case contact:
        return _buildRoute(const ContactScreen(), settings);
      default:
        return _buildRoute(const WelcomeScreen(), settings);
    }
  }

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndClear(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
```

### lib/config/theme.dart
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color backgroundMain = Color(0xFF000000);
  static const Color backgroundCard = Color(0xFF1C1C1E);
  static const Color backgroundCardAlt = Color(0xFF2C2C2E);
  static const Color backgroundModal = Color(0xFF282828);
  static const Color accentPrimary = Color(0xFF2196F3);
  static const Color accentSecondary = Color(0xFFE91E63);
  static const Color accentPink = Color(0xFFE8B4CB);
  static const Color deleteColor = Color(0xFFE57373);
  static const Color deleteColorDark = Color(0xFFD32F2F);
  static const Color keepColor = Color(0xFF81C784);
  static const Color keepColorDark = Color(0xFF4CAF50);
  static const Color selectedBorder = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF888888);
  static const Color textDisabled = Color(0xFF666666);
  static const Color borderColor = Color(0xFF3C3C3E);
  static const Color dividerColor = Color(0xFF2C2C2E);
  static const Color checkmarkBg = Color(0xFF4CAF50);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusPill = 25.0;
  static const double radiusCircle = 50.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Text Styles
  static TextStyle get h1 => GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary);
  static TextStyle get h2 => GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary);
  static TextStyle get h3 => GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary);
  static TextStyle get body => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary);
  static TextStyle get bodySecondary => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textSecondary);
  static TextStyle get caption => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary);
  static TextStyle get small => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: textMuted);
  static TextStyle get button => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary);
  static TextStyle get headerTitle => GoogleFonts.libreBaskerville(fontSize: 18, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, color: textPrimary);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentPrimary,
      scaffoldBackgroundColor: backgroundMain,
      canvasColor: backgroundMain,
      cardColor: backgroundCard,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.dark(
        primary: accentPrimary,
        secondary: accentSecondary,
        surface: backgroundCard,
        error: deleteColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundMain,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headerTitle,
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusPill)),
          textStyle: button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusPill)),
          textStyle: button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accentPrimary, textStyle: button),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentPrimary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(textPrimary),
        side: const BorderSide(color: textPrimary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundModal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
        titleTextStyle: h3,
        contentTextStyle: bodySecondary,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLarge))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: backgroundCardAlt,
        contentTextStyle: body,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        behavior: SnackBarBehavior.floating,
      ),
      iconTheme: const IconThemeData(color: textPrimary, size: 24),
      textTheme: TextTheme(
        displayLarge: h1, displayMedium: h2, displaySmall: h3,
        headlineMedium: h2, headlineSmall: h3, titleLarge: h3,
        titleMedium: body, bodyLarge: body, bodyMedium: bodySecondary,
        bodySmall: caption, labelLarge: button,
      ),
    );
  }
}

extension AppColors on BuildContext {
  Color get primaryColor => AppTheme.accentPrimary;
  Color get backgroundColor => AppTheme.backgroundMain;
  Color get cardColor => AppTheme.backgroundCard;
  Color get deleteColor => AppTheme.deleteColor;
  Color get keepColor => AppTheme.keepColor;
}
```

### lib/models/photo_model.dart
```dart
import 'dart:typed_data';

class PhotoModel {
  final String id;
  final String? localPath;
  final DateTime createDate;
  final DateTime modifyDate;
  final int width;
  final int height;
  final PhotoType type;
  final int? duration;
  Uint8List? thumbnail;
  Uint8List? fullImage;
  bool isSelected;
  bool isInDumpBox;

  PhotoModel({
    required this.id,
    this.localPath,
    required this.createDate,
    required this.modifyDate,
    this.width = 0,
    this.height = 0,
    this.type = PhotoType.image,
    this.duration,
    this.thumbnail,
    this.fullImage,
    this.isSelected = false,
    this.isInDumpBox = false,
  });

  PhotoModel copyWith({
    String? id, String? localPath, DateTime? createDate, DateTime? modifyDate,
    int? width, int? height, PhotoType? type, int? duration,
    Uint8List? thumbnail, Uint8List? fullImage, bool? isSelected, bool? isInDumpBox,
  }) {
    return PhotoModel(
      id: id ?? this.id, localPath: localPath ?? this.localPath,
      createDate: createDate ?? this.createDate, modifyDate: modifyDate ?? this.modifyDate,
      width: width ?? this.width, height: height ?? this.height,
      type: type ?? this.type, duration: duration ?? this.duration,
      thumbnail: thumbnail ?? this.thumbnail, fullImage: fullImage ?? this.fullImage,
      isSelected: isSelected ?? this.isSelected, isInDumpBox: isInDumpBox ?? this.isInDumpBox,
    );
  }

  double get aspectRatio => height > 0 ? width / height : 1.0;
  bool get isVideo => type == PhotoType.video;
  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PhotoModel && runtimeType == other.runtimeType && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

enum PhotoType { image, video }
```

### lib/models/session_model.dart
```dart
import '../config/constants.dart';

class SessionModel {
  final String id;
  final FilterType filterType;
  final DateTime? startDate;
  final DateTime? endDate;
  final int totalPhotos;
  final int reviewedCount;
  final int deletedCount;
  final DateTime createdAt;
  final DateTime lastAccessedAt;
  final List<String> reviewedPhotoIds;
  final List<String> dumpBoxIds;

  SessionModel({
    required this.id, required this.filterType, this.startDate, this.endDate,
    required this.totalPhotos, this.reviewedCount = 0, this.deletedCount = 0,
    required this.createdAt, required this.lastAccessedAt,
    this.reviewedPhotoIds = const [], this.dumpBoxIds = const [],
  });

  int get remainingCount => totalPhotos - reviewedCount;
  double get progressPercentage => totalPhotos > 0 ? reviewedCount / totalPhotos : 0.0;
  bool get isComplete => reviewedCount >= totalPhotos;

  SessionModel copyWith({
    String? id, FilterType? filterType, DateTime? startDate, DateTime? endDate,
    int? totalPhotos, int? reviewedCount, int? deletedCount,
    DateTime? createdAt, DateTime? lastAccessedAt,
    List<String>? reviewedPhotoIds, List<String>? dumpBoxIds,
  }) {
    return SessionModel(
      id: id ?? this.id, filterType: filterType ?? this.filterType,
      startDate: startDate ?? this.startDate, endDate: endDate ?? this.endDate,
      totalPhotos: totalPhotos ?? this.totalPhotos, reviewedCount: reviewedCount ?? this.reviewedCount,
      deletedCount: deletedCount ?? this.deletedCount, createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      reviewedPhotoIds: reviewedPhotoIds ?? this.reviewedPhotoIds, dumpBoxIds: dumpBoxIds ?? this.dumpBoxIds,
    );
  }

  String get filterDisplayName {
    switch (filterType) {
      case FilterType.mostRecent: return AppConstants.categoryMostRecent;
      case FilterType.oldest: return AppConstants.categoryOldest;
      case FilterType.videos: return AppConstants.categoryVideos;
      case FilterType.dateRange: return AppConstants.categoryDateRange;
      case FilterType.resume: return AppConstants.categoryResume;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'filterType': filterType.index,
    'startDate': startDate?.toIso8601String(), 'endDate': endDate?.toIso8601String(),
    'totalPhotos': totalPhotos, 'reviewedCount': reviewedCount, 'deletedCount': deletedCount,
    'createdAt': createdAt.toIso8601String(), 'lastAccessedAt': lastAccessedAt.toIso8601String(),
    'reviewedPhotoIds': reviewedPhotoIds, 'dumpBoxIds': dumpBoxIds,
  };

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    id: json['id'] as String, filterType: FilterType.values[json['filterType'] as int],
    startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
    totalPhotos: json['totalPhotos'] as int, reviewedCount: json['reviewedCount'] as int? ?? 0,
    deletedCount: json['deletedCount'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
    reviewedPhotoIds: List<String>.from(json['reviewedPhotoIds'] ?? []),
    dumpBoxIds: List<String>.from(json['dumpBoxIds'] ?? []),
  );
}
```

### lib/services/photo_service.dart
```dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

class PhotoService {
  PhotoService._();
  static final PhotoService instance = PhotoService._();

  List<AssetPathEntity> _albums = [];
  List<AssetPathEntity> get albums => _albums;

  Future<List<AssetPathEntity>> loadAlbums() async {
    try {
      _albums = await PhotoManager.getAssetPathList(type: RequestType.common, hasAll: true);
      debugPrint('Loaded ${_albums.length} albums');
      return _albums;
    } catch (e) {
      debugPrint('Error loading albums: $e');
      return [];
    }
  }

  AssetPathEntity? getRecentAlbum() {
    if (_albums.isEmpty) return null;
    return _albums.first;
  }

  Future<List<PhotoModel>> loadPhotos({
    required AssetPathEntity album,
    int page = 0,
    int pageSize = AppConstants.photosPerPage,
    FilterType filterType = FilterType.mostRecent,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final List<AssetEntity> assets = await album.getAssetListPaged(page: page, size: pageSize);
      List<PhotoModel> photos = [];
      
      for (final asset in assets) {
        if (startDate != null && asset.createDateTime.isBefore(startDate)) continue;
        if (endDate != null && asset.createDateTime.isAfter(endDate)) continue;
        if (filterType == FilterType.videos && asset.type != AssetType.video) continue;

        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(AppConstants.thumbnailSize, AppConstants.thumbnailSize),
          quality: 80,
        );

        photos.add(PhotoModel(
          id: asset.id,
          localPath: null,
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type: asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));
      }

      if (filterType == FilterType.oldest) {
        photos.sort((a, b) => a.createDate.compareTo(b.createDate));
      } else {
        photos.sort((a, b) => b.createDate.compareTo(a.createDate));
      }

      debugPrint('Loaded ${photos.length} photos from page $page');
      return photos;
    } catch (e) {
      debugPrint('Error loading photos: $e');
      return [];
    }
  }

  Future<Uint8List?> loadFullImage(String assetId) async {
    try {
      final asset = await AssetEntity.fromId(assetId);
      if (asset == null) return null;
      final file = await asset.file;
      if (file == null) return null;
      return await file.readAsBytes();
    } catch (e) {
      debugPrint('Error loading full image: $e');
      return null;
    }
  }

  Future<Uint8List?> loadHighQualityThumbnail(String assetId) async {
    try {
      final asset = await AssetEntity.fromId(assetId);
      if (asset == null) return null;
      return await asset.thumbnailDataWithSize(
        const ThumbnailSize(AppConstants.highQualitySize, AppConstants.highQualitySize),
        quality: 90,
      );
    } catch (e) {
      debugPrint('Error loading HQ thumbnail: $e');
      return null;
    }
  }

  Future<List<String>> deletePhotos(List<String> photoIds) async {
    try {
      final result = await PhotoManager.editor.deleteWithIds(photoIds);
      debugPrint('Deleted ${result.length} photos');
      return result;
    } catch (e) {
      debugPrint('Error deleting photos: $e');
      return [];
    }
  }

  Future<int> getPhotoCount(AssetPathEntity album) async {
    return await album.assetCountAsync;
  }

  Future<int> getFilteredCount({
    FilterType filterType = FilterType.mostRecent,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final recentAlbum = getRecentAlbum();
      if (recentAlbum == null) return 0;
      if (filterType == FilterType.videos) {
        final videoAlbums = await PhotoManager.getAssetPathList(type: RequestType.video, hasAll: true);
        if (videoAlbums.isNotEmpty) return await videoAlbums.first.assetCountAsync;
        return 0;
      }
      return await recentAlbum.assetCountAsync;
    } catch (e) {
      debugPrint('Error getting filtered count: $e');
      return 0;
    }
  }
}
```

### lib/services/permission_service.dart
```dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

enum PhotoPermissionState { authorized, limited, denied, notDetermined, restricted, unknown }

class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  PhotoPermissionState _currentState = PhotoPermissionState.notDetermined;
  PhotoPermissionState get currentState => _currentState;
  bool get hasAccess => _currentState == PhotoPermissionState.authorized || _currentState == PhotoPermissionState.limited;
  bool get isLimited => _currentState == PhotoPermissionState.limited;

  Future<PhotoPermissionState> checkPermission() async {
    try {
      final PermissionState state = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(iosAccessLevel: IosAccessLevel.readWrite),
      );
      _currentState = _mapPermissionState(state);
      return _currentState;
    } catch (e) {
      debugPrint('Error checking permission: $e');
      _currentState = PhotoPermissionState.unknown;
      return _currentState;
    }
  }

  Future<PhotoPermissionState> requestPermission() async {
    try {
      final PermissionState state = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(iosAccessLevel: IosAccessLevel.readWrite),
      );
      _currentState = _mapPermissionState(state);
      debugPrint('Permission request result: $_currentState');
      return _currentState;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      _currentState = PhotoPermissionState.unknown;
      return _currentState;
    }
  }

  PhotoPermissionState _mapPermissionState(PermissionState state) {
    switch (state) {
      case PermissionState.authorized: return PhotoPermissionState.authorized;
      case PermissionState.limited: return PhotoPermissionState.limited;
      case PermissionState.denied: return PhotoPermissionState.denied;
      case PermissionState.notDetermined: return PhotoPermissionState.notDetermined;
      case PermissionState.restricted: return PhotoPermissionState.restricted;
      default: return PhotoPermissionState.unknown;
    }
  }

  Future<void> presentLimitedPhotoPicker() async {
    if (Platform.isIOS) {
      try {
        await PhotoManager.presentLimited();
        await checkPermission();
      } catch (e) {
        debugPrint('Error presenting limited picker: $e');
      }
    }
  }

  Future<bool> openAppSettings() async {
    try {
      return await ph.openAppSettings();
    } catch (e) {
      debugPrint('Error opening settings: $e');
      return false;
    }
  }

  String getStateDescription() {
    switch (_currentState) {
      case PhotoPermissionState.authorized: return 'Full access to photo library';
      case PhotoPermissionState.limited: return 'Limited access - only selected photos';
      case PhotoPermissionState.denied: return 'Access denied - please enable in Settings';
      case PhotoPermissionState.notDetermined: return 'Permission not yet requested';
      case PhotoPermissionState.restricted: return 'Access restricted by device policy';
      case PhotoPermissionState.unknown: return 'Unknown permission state';
    }
  }

  Future<bool> isFirstTimeRequest() async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(iosAccessLevel: IosAccessLevel.readWrite),
    );
    return state == PermissionState.notDetermined;
  }
}
```

### lib/services/storage_service.dart
```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/session_model.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();
  SharedPreferences? _prefs;

  Future<void> init() async { _prefs = await SharedPreferences.getInstance(); }
  Future<SharedPreferences> get prefs async { _prefs ??= await SharedPreferences.getInstance(); return _prefs!; }

  Future<bool> hasAcceptedTerms() async { final p = await prefs; return p.getBool(AppConstants.keyHasAcceptedTerms) ?? false; }
  Future<void> setTermsAccepted(bool accepted) async { final p = await prefs; await p.setBool(AppConstants.keyHasAcceptedTerms, accepted); }
  Future<bool> hasGrantedPermission() async { final p = await prefs; return p.getBool(AppConstants.keyHasGrantedPermission) ?? false; }
  Future<void> setPermissionGranted(bool granted) async { final p = await prefs; await p.setBool(AppConstants.keyHasGrantedPermission, granted); }

  Future<void> saveSession(SessionModel session) async {
    final p = await prefs;
    final jsonString = jsonEncode(session.toJson());
    await p.setString(AppConstants.keyLastSessionId, jsonString);
    debugPrint('Session saved: ${session.id}');
  }

  Future<SessionModel?> loadLastSession() async {
    try {
      final p = await prefs;
      final jsonString = p.getString(AppConstants.keyLastSessionId);
      if (jsonString == null || jsonString.isEmpty) return null;
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SessionModel.fromJson(json);
    } catch (e) {
      debugPrint('Error loading session: $e');
      return null;
    }
  }

  Future<void> clearSession() async { final p = await prefs; await p.remove(AppConstants.keyLastSessionId); }
  Future<void> saveDumpBoxIds(List<String> ids) async { final p = await prefs; await p.setStringList(AppConstants.keyDumpBoxIds, ids); }
  Future<List<String>> loadDumpBoxIds() async { final p = await prefs; return p.getStringList(AppConstants.keyDumpBoxIds) ?? []; }
  Future<void> clearDumpBox() async { final p = await prefs; await p.remove(AppConstants.keyDumpBoxIds); }

  Future<void> addToDumpBox(String photoId) async {
    final ids = await loadDumpBoxIds();
    if (!ids.contains(photoId)) { ids.add(photoId); await saveDumpBoxIds(ids); }
  }

  Future<void> removeFromDumpBox(String photoId) async {
    final ids = await loadDumpBoxIds();
    ids.remove(photoId);
    await saveDumpBoxIds(ids);
  }

  Future<void> clearAll() async { final p = await prefs; await p.clear(); }
}
```

### lib/providers/photo_provider.dart
```dart
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

class PhotoProvider extends ChangeNotifier {
  List<PhotoModel> _photos = [];
  List<AssetEntity> _allAssets = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  FilterType _currentFilter = FilterType.mostRecent;
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalCount = 0;
  Set<String> _reviewedPhotoIds = {};

  List<PhotoModel> get photos => _photos;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FilterType get currentFilter => _currentFilter;
  int get remainingCount => _photos.length - _currentIndex;
  int get totalCount => _totalCount;
  Set<String> get reviewedPhotoIds => _reviewedPhotoIds;
  PhotoModel? get currentPhoto => _currentIndex < _photos.length ? _photos[_currentIndex] : null;
  bool get hasPhotos => _photos.isNotEmpty && _currentIndex < _photos.length;

  Future<void> init() async { await _loadReviewedIds(); }

  Future<void> _loadReviewedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(AppConstants.keyReviewedPhotoIds) ?? [];
      _reviewedPhotoIds = ids.toSet();
      debugPrint('Loaded ${_reviewedPhotoIds.length} reviewed photo IDs');
    } catch (e) { debugPrint('Error loading reviewed IDs: $e'); }
  }

  Future<void> _saveReviewedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(AppConstants.keyReviewedPhotoIds, _reviewedPhotoIds.toList());
    } catch (e) { debugPrint('Error saving reviewed IDs: $e'); }
  }

  Future<void> markAsReviewed(String photoId) async {
    _reviewedPhotoIds.add(photoId);
    await _saveReviewedIds();
  }

  void setFilter({required FilterType type, DateTime? startDate, DateTime? endDate}) {
    _currentFilter = type;
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  Future<void> loadPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    _photos = [];
    _currentIndex = 0;
    notifyListeners();

    try {
      if (_reviewedPhotoIds.isEmpty) await _loadReviewedIds();

      RequestType requestType = RequestType.image;
      if (_currentFilter == FilterType.videos) {
        requestType = RequestType.video;
      } else {
        requestType = RequestType.common;
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: requestType, hasAll: true);
      if (albums.isEmpty) {
        _errorMessage = 'No photo albums found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final AssetPathEntity recentAlbum = albums.first;
      _totalCount = await recentAlbum.assetCountAsync;
      debugPrint('Total photos in library: $_totalCount');

      _allAssets = await recentAlbum.getAssetListRange(start: 0, end: _totalCount);
      debugPrint('Fetched ${_allAssets.length} asset references');

      if (_currentFilter == FilterType.oldest) {
        _allAssets.sort((a, b) => a.createDateTime.compareTo(b.createDateTime));
      } else {
        _allAssets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
      }

      List<AssetEntity> filteredAssets = [];
      for (final asset in _allAssets) {
        if (_startDate != null && asset.createDateTime.isBefore(_startDate!)) continue;
        if (_endDate != null && asset.createDateTime.isAfter(_endDate!)) continue;
        if (_currentFilter == FilterType.resume && _reviewedPhotoIds.contains(asset.id)) continue;
        filteredAssets.add(asset);
      }
      debugPrint('Filtered to ${filteredAssets.length} assets');

      final int initialBatchSize = 10;
      List<PhotoModel> loadedPhotos = [];

      for (int i = 0; i < filteredAssets.length && i < initialBatchSize; i++) {
        final asset = filteredAssets[i];
        final thumbnail = await asset.thumbnailDataWithSize(const ThumbnailSize(800, 800), quality: 85);
        loadedPhotos.add(PhotoModel(
          id: asset.id,
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type: asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));
      }

      _photos = loadedPhotos;
      _isLoading = false;
      notifyListeners();
      debugPrint('Initial batch loaded: ${_photos.length} photos');
      _loadRemainingPhotos(filteredAssets, initialBatchSize);
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading photos: $e');
    }
  }

  Future<void> _loadRemainingPhotos(List<AssetEntity> assets, int startIndex) async {
    for (int i = startIndex; i < assets.length; i++) {
      final asset = assets[i];
      try {
        final thumbnail = await asset.thumbnailDataWithSize(const ThumbnailSize(800, 800), quality: 85);
        _photos.add(PhotoModel(
          id: asset.id,
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type: asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));
        if (i % 20 == 0) { notifyListeners(); debugPrint('Loaded ${_photos.length} photos...'); }
      } catch (e) { debugPrint('Error loading photo $i: $e'); }
    }
    notifyListeners();
    debugPrint('Finished loading all ${_photos.length} photos');
  }

  void nextPhoto() { if (_currentIndex < _photos.length) { _currentIndex++; notifyListeners(); } }
  void undoPhoto() { if (_currentIndex > 0) { _currentIndex--; notifyListeners(); } }
  Future<void> swipeRight() async { if (currentPhoto != null) await markAsReviewed(currentPhoto!.id); nextPhoto(); }
  void swipeLeft() { nextPhoto(); }
  void reset() { _currentIndex = 0; _photos = []; _errorMessage = null; notifyListeners(); }
  Future<void> clearReviewedIds() async { _reviewedPhotoIds.clear(); await _saveReviewedIds(); notifyListeners(); }

  List<PhotoModel> getStackPhotos() {
    if (_photos.isEmpty) return [];
    final endIndex = (_currentIndex + AppConstants.cardsInStack).clamp(0, _photos.length);
    if (_currentIndex >= _photos.length) return [];
    return _photos.sublist(_currentIndex, endIndex);
  }
}
```

### lib/providers/dumpbox_provider.dart
```dart
import 'package:flutter/foundation.dart';
import '../models/photo_model.dart';

class DumpBoxProvider extends ChangeNotifier {
  final List<PhotoModel> _dumpBoxPhotos = [];
  final Set<String> _selectedIds = {};

  List<PhotoModel> get photos => _dumpBoxPhotos;
  int get count => _dumpBoxPhotos.length;
  Set<String> get selectedIds => _selectedIds;
  int get selectedCount => _selectedIds.length;
  bool get hasPhotos => _dumpBoxPhotos.isNotEmpty;
  bool get allSelected => _selectedIds.length == _dumpBoxPhotos.length;

  void addPhoto(PhotoModel photo) {
    if (!_dumpBoxPhotos.any((p) => p.id == photo.id)) {
      _dumpBoxPhotos.add(photo);
      _selectedIds.add(photo.id);
      notifyListeners();
    }
  }

  void removePhoto(String photoId) {
    _dumpBoxPhotos.removeWhere((p) => p.id == photoId);
    _selectedIds.remove(photoId);
    notifyListeners();
  }

  void removeLastPhoto() {
    if (_dumpBoxPhotos.isNotEmpty) {
      final lastPhoto = _dumpBoxPhotos.removeLast();
      _selectedIds.remove(lastPhoto.id);
      notifyListeners();
    }
  }

  void toggleSelection(String photoId) {
    if (_selectedIds.contains(photoId)) { _selectedIds.remove(photoId); }
    else { _selectedIds.add(photoId); }
    notifyListeners();
  }

  void selectAll() { _selectedIds.clear(); for (var photo in _dumpBoxPhotos) { _selectedIds.add(photo.id); } notifyListeners(); }
  void clearSelection() { _selectedIds.clear(); notifyListeners(); }
  List<PhotoModel> getSelectedPhotos() => _dumpBoxPhotos.where((p) => _selectedIds.contains(p.id)).toList();
  void removeSelected() { _dumpBoxPhotos.removeWhere((p) => _selectedIds.contains(p.id)); _selectedIds.clear(); notifyListeners(); }
  void restoreAll() { _dumpBoxPhotos.clear(); _selectedIds.clear(); notifyListeners(); }
  void keepSelected() { _dumpBoxPhotos.removeWhere((p) => _selectedIds.contains(p.id)); _selectedIds.clear(); notifyListeners(); }
}
```

### lib/providers/session_provider.dart
```dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/session_model.dart';
import '../config/constants.dart';

class SessionProvider extends ChangeNotifier {
  SessionModel? _currentSession;
  SessionModel? _lastSession;
  bool _isLoading = false;

  SessionModel? get currentSession => _currentSession;
  SessionModel? get lastSession => _lastSession;
  bool get isLoading => _isLoading;
  bool get hasLastSession => _lastSession != null && !_lastSession!.isComplete;

  void startNewSession({required FilterType filterType, DateTime? startDate, DateTime? endDate, required int totalPhotos}) {
    _currentSession = SessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filterType: filterType, startDate: startDate, endDate: endDate,
      totalPhotos: totalPhotos, reviewedCount: 0, deletedCount: 0,
      createdAt: DateTime.now(), lastAccessedAt: DateTime.now(),
    );
    notifyListeners();
    _saveSession();
  }

  void updateProgress({int? reviewed, int? deleted}) {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        reviewedCount: reviewed ?? _currentSession!.reviewedCount,
        deletedCount: deleted ?? _currentSession!.deletedCount,
        lastAccessedAt: DateTime.now(),
      );
      notifyListeners();
      _saveSession();
    }
  }

  void incrementReviewed() { if (_currentSession != null) updateProgress(reviewed: _currentSession!.reviewedCount + 1); }
  void incrementDeleted() { if (_currentSession != null) updateProgress(deleted: _currentSession!.deletedCount + 1); }

  Future<void> _saveSession() async {
    if (_currentSession == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_currentSession!.toJson());
      await prefs.setString(AppConstants.keyLastSessionId, jsonString);
      _lastSession = _currentSession;
      debugPrint('Session saved: ${_currentSession!.id}');
    } catch (e) { debugPrint('Error saving session: $e'); }
  }

  Future<void> loadLastSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(AppConstants.keyLastSessionId);
      if (jsonString != null && jsonString.isNotEmpty) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _lastSession = SessionModel.fromJson(json);
        debugPrint('Session loaded: ${_lastSession!.id}, reviewed: ${_lastSession!.reviewedCount}/${_lastSession!.totalPhotos}');
      }
    } catch (e) { debugPrint('Error loading session: $e'); _lastSession = null; }
    finally { _isLoading = false; notifyListeners(); }
  }

  void resumeLastSession() {
    if (_lastSession != null) {
      _currentSession = _lastSession!.copyWith(lastAccessedAt: DateTime.now());
      notifyListeners();
    }
  }

  void endSession() { _currentSession = null; notifyListeners(); }

  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyLastSessionId);
      _lastSession = null;
      _currentSession = null;
      notifyListeners();
    } catch (e) { debugPrint('Error clearing session: $e'); }
  }
}
```

---

## 🛠 SUGGESTED FIXES

### Option 1: Update photo_manager
```yaml
dependencies:
  photo_manager: ^3.2.0  # Check pub.dev for latest
```

### Option 2: Clean Build
```bash
cd photoswipe_emergent
flutter clean
rm -rf ios/Pods ios/Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/*
flutter pub get
cd ios && pod install --repo-update && cd ..
flutter build ios
```

### Option 3: Add Podfile workaround
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
```

### Option 4: Alternative plugin
If photo_manager continues failing, consider:
- Direct PHPhotoLibrary via platform channels
- Another gallery plugin

---

## ❓ KEY DEBUGGING QUESTIONS

1. Flutter version? (`flutter --version`)
2. iOS version on device?
3. Did it ever build successfully?
4. Output of `flutter doctor -v`?
5. Output of `pod outdated` in ios folder?

---

**END OF COMPLETE CODEBASE DOCUMENT**
