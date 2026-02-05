import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';

/// Terms of Service Screen
/// Full legal terms of service for the app
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
              '1. Acceptance of Terms',
              'By downloading, installing, or using PhotoSwipe ("the App"), you agree to be '
                  'bound by these Terms of Service ("Terms"). If you do not agree to these Terms, '
                  'do not use the App.\n\n'
                  'The App is operated by Priceless Concepts LLC ("we", "us", or "our").',
            ),
            _buildSection(
              '2. Description of Service',
              'PhotoSwipe is a photo gallery management application that allows users to:\n\n'
                  '• Review photos stored on their device\n'
                  '• Mark photos for deletion using a swipe interface\n'
                  '• Permanently delete selected photos from their device\n\n'
                  'The App operates entirely on your device and does not upload, store, or '
                  'transmit your photos to any external servers.',
            ),
            _buildSection(
              '3. User Responsibilities',
              'By using the App, you acknowledge and agree that:\n\n'
                  '• You are solely responsible for deciding which photos to delete\n'
                  '• You will review photos carefully before confirming deletion\n'
                  '• You understand that deleted photos may be permanently lost\n'
                  '• You will not use the App to delete photos belonging to others without permission\n'
                  '• You are at least 13 years of age',
            ),
            _buildSection(
              '4. Photo Deletion',
              'IMPORTANT: When you confirm deletion of photos through the App:\n\n'
                  '• Photos are deleted using your device\'s native deletion function\n'
                  '• On iOS, deleted photos may move to "Recently Deleted" for 30 days before permanent deletion\n'
                  '• On Android, deletion behavior may vary by device and Android version\n'
                  '• Once permanently deleted, photos CANNOT be recovered by us or anyone else\n'
                  '• We strongly recommend backing up important photos before using the App',
            ),
            _buildSection(
              '5. Disclaimer of Warranties',
              'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, '
                  'EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO:\n\n'
                  '• Warranties of merchantability\n'
                  '• Fitness for a particular purpose\n'
                  '• Non-infringement\n'
                  '• Accuracy or reliability\n\n'
                  'We do not warrant that the App will be uninterrupted, error-free, or free of '
                  'viruses or other harmful components.',
            ),
            _buildSection(
              '6. Limitation of Liability',
              'TO THE MAXIMUM EXTENT PERMITTED BY LAW, PRICELESS CONCEPTS LLC AND ITS '
                  'OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS SHALL NOT BE LIABLE FOR:\n\n'
                  '• Any lost or deleted photos, regardless of cause\n'
                  '• Any indirect, incidental, special, consequential, or punitive damages\n'
                  '• Any loss of data, revenue, profits, or goodwill\n'
                  '• Any damages arising from your use or inability to use the App\n\n'
                  'IN NO EVENT SHALL OUR TOTAL LIABILITY EXCEED THE AMOUNT YOU PAID FOR THE APP '
                  '(IF ANY).',
            ),
            _buildSection(
              '7. Indemnification',
              'You agree to indemnify, defend, and hold harmless Priceless Concepts LLC and '
                  'its affiliates from any claims, damages, losses, liabilities, and expenses '
                  '(including legal fees) arising from:\n\n'
                  '• Your use of the App\n'
                  '• Your violation of these Terms\n'
                  '• Your violation of any rights of another party',
            ),
            _buildSection(
              '8. Intellectual Property',
              'The App and its original content, features, and functionality are owned by '
                  'Priceless Concepts LLC and are protected by international copyright, trademark, '
                  'and other intellectual property laws.\n\n'
                  'You may not copy, modify, distribute, sell, or lease any part of the App without '
                  'our prior written consent.',
            ),
            _buildSection(
              '9. Updates and Changes',
              'We reserve the right to:\n\n'
                  '• Modify or discontinue the App at any time without notice\n'
                  '• Update these Terms at any time\n'
                  '• Change App features or functionality\n\n'
                  'Continued use of the App after changes constitutes acceptance of the new Terms.',
            ),
            _buildSection(
              '10. Governing Law',
              'These Terms shall be governed by and construed in accordance with the laws of '
                  'the United States, without regard to its conflict of law provisions.\n\n'
                  'Any disputes arising from these Terms or your use of the App shall be resolved '
                  'in the courts of competent jurisdiction.',
            ),
            _buildSection(
              '11. Contact Information',
              'For questions about these Terms, please contact us at:\n\n'
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
