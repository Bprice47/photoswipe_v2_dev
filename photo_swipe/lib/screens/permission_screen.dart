import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/app_logo.dart';

/// Screen 2: Permission Screen - Photo Access Required
/// Requests photo library access from user
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _isRequesting = false;

  /// Request photo library permission
  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);

    try {
      // TODO: Implement actual permission request in Phase 3
      // For now, simulate and navigate
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        AppRoutes.navigateAndClear(context, AppRoutes.category);
      }
    } catch (e) {
      setState(() => _isRequesting = false);
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Logo
              const AppLogo(size: 100, showShadow: true),
              const SizedBox(height: AppTheme.spacingXl),
              
              // Title
              Text(
                'Photo Access',
                style: AppTheme.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                'Required',
                style: AppTheme.h2,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                ),
                child: Text(
                  AppConstants.permissionMessage,
                  style: AppTheme.bodySecondary,
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Grant Access Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isRequesting ? null : _requestPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPrimary,
                    foregroundColor: AppTheme.accentPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    elevation: 0,
                  ),
                  child: _isRequesting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.textPrimary,
                          ),
                        )
                      : Text(
                          AppConstants.buttonGrantAccess,
                          style: AppTheme.button.copyWith(
                            color: AppTheme.accentPink,
                          ),
                        ),
                ),
              ),
              
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
