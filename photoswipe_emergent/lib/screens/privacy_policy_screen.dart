import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';

/// Privacy Policy Screen
/// Full legal privacy policy for the app
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: AppTheme.headerTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLastUpdated(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildSection(
              'Introduction',
              'PhotoSwipe ("we", "our", or "us") is committed to protecting your privacy. '
                  'This Privacy Policy explains how we handle your information when you use our '
                  'mobile application PhotoSwipe (the "App").',
            ),
            _buildSection(
              'Information We Do NOT Collect',
              'PhotoSwipe is designed with your privacy as our top priority. We want to be '
                  'completely transparent:\n\n'
                  '• We do NOT collect, store, or transmit your photos\n'
                  '• We do NOT collect personal information\n'
                  '• We do NOT use analytics or tracking services\n'
                  '• We do NOT share any data with third parties\n'
                  '• We do NOT have user accounts or registration\n'
                  '• We do NOT access your contacts, location, or other device data',
            ),
            _buildSection(
              'How the App Works',
              'PhotoSwipe operates entirely on your device:\n\n'
                  '• The App requests permission to access your photo library\n'
                  '• Photos are displayed locally on your device for review\n'
                  '• When you swipe left, photos are marked for deletion locally\n'
                  '• When you confirm deletion, the App uses your device\'s native photo '
                  'deletion function\n'
                  '• All processing happens on YOUR device - nothing leaves your phone',
            ),
            _buildSection(
              'Photo Library Access',
              'The App requires access to your photo library to function. This permission '
                  'is used solely to:\n\n'
                  '• Display your photos for review\n'
                  '• Delete photos you choose to remove\n\n'
                  'On iOS 14 and later, you can choose to grant "Limited Access" which allows '
                  'you to select specific photos the App can access.',
            ),
            _buildSection(
              'Local Storage',
              'The App stores minimal data locally on your device:\n\n'
                  '• Your preference settings\n'
                  '• Session progress (so you can resume where you left off)\n'
                  '• A temporary list of photos marked for deletion (DumpBox)\n\n'
                  'This data never leaves your device and is deleted when you uninstall the App.',
            ),
            _buildSection(
              'Data Security',
              'Since we don\'t collect or transmit any data, there is no data to secure '
                  'on our servers. Your photos and information remain entirely on your device, '
                  'protected by your device\'s security features (passcode, Face ID, etc.).',
            ),
            _buildSection(
              'Children\'s Privacy',
              'The App does not collect personal information from anyone, including children. '
                  'We do not knowingly target or market to children under 13 years of age.',
            ),
            _buildSection(
              'Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of '
                  'any changes by posting the new Privacy Policy within the App. You are advised '
                  'to review this Privacy Policy periodically for any changes.',
            ),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at:\n\n'
                  'Email: PCI.INC1@gmail.com\n'
                  'Company: Priceless Concepts LLC',
            ),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Text(
        'Last Updated: December 2025',
        style: AppTheme.caption.copyWith(
          color: AppTheme.textMuted,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.h3.copyWith(
              color: AppTheme.accentPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            content,
            style: AppTheme.body.copyWith(
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
