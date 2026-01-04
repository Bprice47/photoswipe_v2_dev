import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../services/storage_service.dart';
import '../services/permission_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/privacy_card.dart';
import '../widgets/custom_checkbox.dart';

/// Screen 1: Welcome Screen with Privacy & Disclaimer
/// First screen shown to new users
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _storageService = StorageService.instance;
  final _permissionService = PermissionService.instance;
  
  bool _hasAgreed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  /// Check if user has already accepted terms and has permission
  Future<void> _checkInitialState() async {
    final hasAccepted = await _storageService.hasAcceptedTerms();
    
    if (hasAccepted && mounted) {
      // Check if we already have permission
      final permState = await _permissionService.checkPermission();
      
      if (_permissionService.hasAccess) {
        // Skip straight to category if everything is set
        AppRoutes.navigateAndClear(context, AppRoutes.category);
      } else {
        // Go to permission screen
        AppRoutes.navigateAndClear(context, AppRoutes.permission);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  /// Handle continue button press
  Future<void> _onContinue() async {
    if (!_hasAgreed) return;

    // Save acceptance
    await _storageService.setTermsAccepted(true);

    if (mounted) {
      AppRoutes.navigateTo(context, AppRoutes.permission);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundMain,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.accentPrimary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingMd,
          ),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Logo
              const AppLogo(size: 80),
              const SizedBox(height: AppTheme.spacingLg),
              
              // Welcome Text
              Text(
                'Welcome to',
                style: AppTheme.body.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                AppConstants.appName,
                style: AppTheme.h1,
              ),
              
              const SizedBox(height: AppTheme.spacingXl),
              
              // Privacy Card
              const PrivacyCard(),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              // Agreement Checkbox
              _buildAgreementRow(),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              // Continue Button
              _buildContinueButton(),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the agreement checkbox row
  Widget _buildAgreementRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: () => setState(() => _hasAgreed = !_hasAgreed),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Row(
          children: [
            CustomCheckbox(
              value: _hasAgreed,
              onChanged: (value) => setState(() => _hasAgreed = value ?? false),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Text(
                'I understand and agree to these terms',
                style: AppTheme.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the continue button
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _hasAgreed ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _hasAgreed 
              ? AppTheme.accentPrimary 
              : AppTheme.backgroundCardAlt,
          foregroundColor: _hasAgreed 
              ? AppTheme.textPrimary 
              : AppTheme.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          ),
          elevation: 0,
        ),
        child: Text(
          AppConstants.buttonContinue,
          style: AppTheme.button.copyWith(
            color: _hasAgreed 
                ? AppTheme.textPrimary 
                : AppTheme.textDisabled,
          ),
        ),
      ),
    );
  }
}
