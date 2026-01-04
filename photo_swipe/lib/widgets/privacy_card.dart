import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';

/// Privacy & Disclaimer Card
/// Shows privacy policy points on the welcome screen
class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header
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
    );
  }

  /// Build a single privacy point bullet
  Widget _buildPrivacyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
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
          // Text
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
