import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/app_logo.dart';

/// About Screen
/// Shows app information and credits
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About',
          style: AppTheme.headerTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spacingXl),

            // App Logo and Info
            const AppLogo(size: 100),
            const SizedBox(height: AppTheme.spacingLg),

            Text(
              AppConstants.appName,
              style: AppTheme.h1,
            ),
            const SizedBox(height: AppTheme.spacingXs),

            Text(
              'Version ${AppConstants.appVersion}',
              style: AppTheme.caption,
            ),
            const SizedBox(height: AppTheme.spacingSm),

            Text(
              AppConstants.appTagline,
              style: AppTheme.bodySecondary,
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Info Cards
            _buildInfoCard(
              icon: Icons.business,
              title: 'Developer',
              content: 'Priceless Concepts LLC',
            ),

            const SizedBox(height: AppTheme.spacingMd),

            _buildInfoCard(
              icon: Icons.copyright,
              title: 'Copyright',
              content: '© 2025 Priceless Concepts LLC\nAll rights reserved',
            ),

            const SizedBox(height: AppTheme.spacingMd),

            _buildInfoCard(
              icon: Icons.build_outlined,
              title: 'Built With',
              content: 'Flutter & Dart\nMade with ❤️',
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Features List
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: AppTheme.h3,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildFeatureItem('Swipe to organize photos'),
                  _buildFeatureItem('Review before deleting'),
                  _buildFeatureItem('Resume sessions'),
                  _buildFeatureItem('Filter by date'),
                  _buildFeatureItem(
                      '100% private - no data leaves your device'),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Footer
            Text(
              'Thank you for using PhotoSwipe!',
              style: AppTheme.caption.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              color: AppTheme.accentPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: AppTheme.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.keepColor,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            text,
            style: AppTheme.body.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
