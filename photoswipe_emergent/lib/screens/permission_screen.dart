import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../services/permission_service.dart';
import '../widgets/app_logo.dart';

/// Screen 2: Permission Screen - Photo Access Required
/// Requests photo library access from user with iOS 14+ support
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> with WidgetsBindingObserver {
  final _permissionService = PermissionService.instance;
  bool _isRequesting = false;
  PhotoPermissionState _permissionState = PhotoPermissionState.notDetermined;
  bool _returnedFromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkCurrentPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called when app resumes from background (e.g., returning from Settings)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _returnedFromSettings) {
      _returnedFromSettings = false;
      _checkCurrentPermission();
    }
  }

  /// Check current permission status
  Future<void> _checkCurrentPermission() async {
    final state = await _permissionService.checkPermission();
    
    if (mounted) {
      setState(() => _permissionState = state);
      
      // If already authorized or limited, navigate to category screen
      if (_permissionService.hasAccess) {
        _navigateToCategory();
      }
    }
  }

  /// Request photo library permission
  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);

    try {
      final state = await _permissionService.requestPermission();
      
      if (mounted) {
        setState(() {
          _permissionState = state;
          _isRequesting = false;
        });

        if (_permissionService.hasAccess) {
          _navigateToCategory();
        } else if (state == PhotoPermissionState.denied) {
          _showDeniedDialog();
        } else if (state == PhotoPermissionState.restricted) {
          _showRestrictedDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRequesting = false);
        _showErrorSnackbar('Error requesting permission: $e');
      }
    }
  }

  /// Navigate to category screen
  void _navigateToCategory() {
    AppRoutes.navigateAndClear(context, AppRoutes.category);
  }

  /// Show dialog when permission is denied
  void _showDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundModal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          'Permission Required',
          style: AppTheme.h3,
        ),
        content: Text(
          AppConstants.permissionDeniedMessage,
          style: AppTheme.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.button.copyWith(color: AppTheme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openSettings();
            },
            child: Text(
              AppConstants.buttonGoToSettings,
              style: AppTheme.button.copyWith(color: AppTheme.accentPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when permission is restricted
  void _showRestrictedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundModal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          'Access Restricted',
          style: AppTheme.h3,
        ),
        content: Text(
          'Photo access is restricted on this device. This may be due to parental controls or device management policies.',
          style: AppTheme.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: AppTheme.button.copyWith(color: AppTheme.accentPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// Open app settings
  Future<void> _openSettings() async {
    _returnedFromSettings = true;
    await _permissionService.openAppSettings();
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.deleteColor,
      ),
    );
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
              
              // Main Action Button
              _buildActionButton(),
              
              // Limited Access Info (if applicable)
              if (_permissionState == PhotoPermissionState.limited)
                _buildLimitedAccessInfo(),
              
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the main action button based on current state
  Widget _buildActionButton() {
    String buttonText;
    VoidCallback? onPressed;

    switch (_permissionState) {
      case PhotoPermissionState.notDetermined:
      case PhotoPermissionState.unknown:
        buttonText = AppConstants.buttonGrantAccess;
        onPressed = _isRequesting ? null : _requestPermission;
        break;
      case PhotoPermissionState.denied:
        buttonText = AppConstants.buttonGoToSettings;
        onPressed = _openSettings;
        break;
      case PhotoPermissionState.restricted:
        buttonText = 'Access Restricted';
        onPressed = null;
        break;
      case PhotoPermissionState.authorized:
      case PhotoPermissionState.limited:
        buttonText = 'Continue';
        onPressed = _navigateToCategory;
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null 
              ? AppTheme.accentPrimary 
              : AppTheme.backgroundCardAlt,
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
                buttonText,
                style: AppTheme.button.copyWith(
                  color: onPressed != null 
                      ? AppTheme.accentPink 
                      : AppTheme.textDisabled,
                ),
              ),
      ),
    );
  }

  /// Build limited access info banner (iOS 14+)
  Widget _buildLimitedAccessInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacingLg),
      child: GestureDetector(
        onTap: () => _permissionService.presentLimitedPhotoPicker(),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.accentPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: AppTheme.accentPrimary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.accentPrimary,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limited Access',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.accentPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap to select more photos or grant full access',
                      style: AppTheme.small.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.accentPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
