import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/app_logo.dart';
import '../widgets/privacy_card.dart';
import '../widgets/custom_checkbox.dart';

/// Screen 1: Welcome Screen - Shows EVERY time for legal protection
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _hasAgreed = false;

  void _onContinue() {
    if (!_hasAgreed) return;
    // Go to permission screen to request photo access
    AppRoutes.navigateTo(context, AppRoutes.permission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spacingMd),

              // Logo
              const AppLogo(size: 60),
              const SizedBox(height: AppTheme.spacingMd),

              // Welcome Text
              Text(
                'Welcome to',
                style: AppTheme.body.copyWith(color: AppTheme.textSecondary),
              ),
              Text(AppConstants.appName, style: AppTheme.h2),

              const SizedBox(height: AppTheme.spacingMd),

              // Privacy Card
              const Expanded(child: PrivacyCard()),

              const SizedBox(height: AppTheme.spacingSm),

              // Agreement Checkbox
              _buildAgreementRow(),

              const SizedBox(height: AppTheme.spacingSm),

              // Continue Button
              _buildContinueButton(),

              const SizedBox(height: AppTheme.spacingSm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementRow() {
    return GestureDetector(
      onTap: () => setState(() => _hasAgreed = !_hasAgreed),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            CustomCheckbox(
              value: _hasAgreed,
              onChanged: (value) => setState(() => _hasAgreed = value ?? false),
              size: 22,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Text(
                'I understand and agree to these terms',
                style: AppTheme.caption.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _hasAgreed ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _hasAgreed ? AppTheme.accentPrimary : AppTheme.backgroundCardAlt,
          foregroundColor:
              _hasAgreed ? AppTheme.textPrimary : AppTheme.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          ),
          elevation: 0,
        ),
        child: Text(
          AppConstants.buttonContinue,
          style: AppTheme.button.copyWith(
            color: _hasAgreed ? AppTheme.textPrimary : AppTheme.textDisabled,
          ),
        ),
      ),
    );
  }
}
