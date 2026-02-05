import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PhotoSwipe App Theme
/// Dark theme with blue accents, matching the original design
class AppTheme {
  AppTheme._();

  // ============== COLORS ==============

  /// Primary Colors
  static const Color backgroundMain = Color(0xFF000000); // Pure Black
  static const Color backgroundCard = Color(0xFF1C1C1E); // Dark Gray
  static const Color backgroundCardAlt = Color(0xFF2C2C2E); // Slightly lighter
  static const Color backgroundModal = Color(0xFF282828); // Modal background

  /// Accent Colors
  static const Color accentPrimary = Color(0xFF2196F3); // Bright Blue
  static const Color accentSecondary =
      Color(0xFFE91E63); // Pink/Magenta (DumpBox badge)
  static const Color accentPink = Color(0xFFE8B4CB); // Light Pink (button text)

  /// Action Colors
  static const Color deleteColor = Color(0xFFE57373); // Red/Coral for delete
  static const Color deleteColorDark = Color(0xFFD32F2F); // Darker red
  static const Color keepColor = Color(0xFF81C784); // Green for keep
  static const Color keepColorDark = Color(0xFF4CAF50); // Darker green
  static const Color selectedBorder =
      Color(0xFF4CAF50); // Green selection border

  /// Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB0B0B0); // Light Gray
  static const Color textMuted = Color(0xFF888888); // Muted Gray
  static const Color textDisabled = Color(0xFF666666); // Disabled Gray

  /// UI Element Colors
  static const Color borderColor = Color(0xFF3C3C3E); // Subtle gray border
  static const Color dividerColor = Color(0xFF2C2C2E); // Divider
  static const Color checkmarkBg =
      Color(0xFF4CAF50); // Green checkmark background

  // ============== SPACING ==============

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ============== BORDER RADIUS ==============

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusPill = 25.0;
  static const double radiusCircle = 50.0;

  // ============== ANIMATION DURATIONS ==============

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============== TEXT STYLES ==============

  /// Heading 1 - App Title (28sp, Bold)
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  /// Heading 2 - Screen Title (24sp, Bold)
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  /// Heading 3 - Card Title (18sp, Bold)
  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  /// Body Text (16sp, Regular)
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      );

  /// Body Secondary (16sp, Regular, Gray)
  static TextStyle get bodySecondary => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  /// Caption (14sp, Regular)
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  /// Small Text (12sp)
  static TextStyle get small => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMuted,
      );

  /// Button Text (16sp, SemiBold)
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  /// Header Title - Italic Style (18sp)
  static TextStyle get headerTitle => GoogleFonts.libreBaskerville(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: textPrimary,
      );

  // ============== THEME DATA ==============

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Colors
      primaryColor: accentPrimary,
      scaffoldBackgroundColor: backgroundMain,
      canvasColor: backgroundMain,
      cardColor: backgroundCard,
      dividerColor: dividerColor,

      // Color Scheme
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

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundMain,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headerTitle,
        iconTheme: const IconThemeData(color: textPrimary),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          textStyle: button,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          textStyle: button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPrimary,
          textStyle: button,
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(textPrimary),
        side: const BorderSide(color: textPrimary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundModal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: h3,
        contentTextStyle: bodySecondary,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusLarge),
          ),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: backgroundCardAlt,
        contentTextStyle: body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: h1,
        displayMedium: h2,
        displaySmall: h3,
        headlineMedium: h2,
        headlineSmall: h3,
        titleLarge: h3,
        titleMedium: body,
        bodyLarge: body,
        bodyMedium: bodySecondary,
        bodySmall: caption,
        labelLarge: button,
      ),
    );
  }
}

/// Extension for easy color access
extension AppColors on BuildContext {
  Color get primaryColor => AppTheme.accentPrimary;
  Color get backgroundColor => AppTheme.backgroundMain;
  Color get cardColor => AppTheme.backgroundCard;
  Color get deleteColor => AppTheme.deleteColor;
  Color get keepColor => AppTheme.keepColor;
}
