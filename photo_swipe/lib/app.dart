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
      
      // Apply dark theme
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      
      // Named routes
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRoutes.generateRoute,
      
      // Fallback home
      home: const WelcomeScreen(),
    );
  }
}
