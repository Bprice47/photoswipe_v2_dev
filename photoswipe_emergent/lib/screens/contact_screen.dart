import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme.dart';
import '../config/routes.dart';

/// Contact/Support Screen
/// Shows contact information and support options
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String supportEmail = 'PCI.INC1@gmail.com';
  static const String companyName = 'Priceless Concepts LLC';

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
          'Contact Support',
          style: AppTheme.headerTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spacingLg),

            // Support Icon
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent,
                size: 64,
                color: AppTheme.accentPrimary,
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            Text(
              'Need Help?',
              style: AppTheme.h2,
            ),
            const SizedBox(height: AppTheme.spacingSm),

            Text(
              'We\'re here to help! Reach out to us with any questions, '
              'feedback, or issues.',
              style: AppTheme.bodySecondary,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Email Contact Card
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: supportEmail,
              onTap: () => _copyToClipboard(context, supportEmail),
              actionIcon: Icons.copy,
              actionLabel: 'Tap to copy',
            ),

            const SizedBox(height: AppTheme.spacingMd),

            // Company Info Card
            _buildInfoCard(
              icon: Icons.business_outlined,
              title: 'Company',
              content: companyName,
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // FAQ Section
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
                    'Common Questions',
                    style: AppTheme.h3,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildFAQItem(
                    'Can I recover deleted photos?',
                    'On iOS, deleted photos go to "Recently Deleted" for 30 days. '
                        'After that, they cannot be recovered.',
                  ),
                  _buildFAQItem(
                    'Is my data safe?',
                    'Absolutely! PhotoSwipe works 100% offline. Your photos never '
                        'leave your device.',
                  ),
                  _buildFAQItem(
                    'Why do I need to accept the disclaimer each time?',
                    'For your protection. We want to ensure you understand that '
                        'deleted photos cannot be recovered.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Response Time Note
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.borderColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      'We typically respond within 24-48 hours',
                      style: AppTheme.caption,
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

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData actionIcon,
    required String actionLabel,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: AppTheme.accentPrimary.withOpacity(0.3),
          ),
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
                size: 28,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.accentPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(
                  actionIcon,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  actionLabel,
                  style: AppTheme.small.copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
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
              color: AppTheme.backgroundCardAlt,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              color: AppTheme.textSecondary,
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

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTheme.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            answer,
            style: AppTheme.caption.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email copied to clipboard'),
        backgroundColor: AppTheme.backgroundCardAlt,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
