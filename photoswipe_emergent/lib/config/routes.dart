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

/// App route names and navigation
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String welcome = '/';
  static const String permission = '/permission';
  static const String category = '/category';
  static const String dateRange = '/date-range';
  static const String swipe = '/swipe';
  static const String dumpbox = '/dumpbox';

  // Legal & Info routes
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String disclaimer = '/disclaimer';
  static const String about = '/about';
  static const String contact = '/contact';

  /// Generate routes based on settings
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
        // Arguments can include filter options
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(SwipeScreen(filterOptions: args), settings);

      case dumpbox:
        return _buildRoute(const DumpBoxScreen(), settings);

      // Legal & Info screens
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

  /// Build a route with standard transition
  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from right
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Navigate to a route (replacing current)
  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  static void navigateAndClear(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
