import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';

/// Disclaimer Screen
/// Shows the privacy disclaimer from the welcome screen
class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundMain,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.goBack(context),
        ),
        title: Text(
          'Disclaimer',
          style: AppTheme.headerTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Icon Header
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundCard,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: AppTheme.accentPrimary,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Title
            Center(
              child: Text(
                'Important Information',
                style: AppTheme.h2,
              ),
            ),

            const SizedBox(height: AppTheme.spacingSm),

            Center(
              child: Text(
                'Please read carefully before using PhotoSwipe',
                style: AppTheme.caption,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Privacy & Disclaimer Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: AppTheme.borderColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy & Disclaimer',
                    style: AppTheme.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Privacy Points
                  ...AppConstants.privacyPoints.map(
                    (point) => _buildPrivacyPoint(point),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Additional Warning
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.deleteColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.deleteColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppTheme.deleteColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deletion Warning',
                          style: AppTheme.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deleteColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          'Once photos are permanently deleted, they cannot be recovered. '
                          'Always ensure you have backups of important photos before using '
                          'this app.',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // iOS Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.accentPrimary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.phone_iphone,
                    color: AppTheme.accentPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'iOS Users',
                          style: AppTheme.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentPrimary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          'On iOS devices, deleted photos are first moved to the '
                          '"Recently Deleted" album where they remain for 30 days '
                          'before being permanently removed.',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              text,
              style: AppTheme.caption.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
