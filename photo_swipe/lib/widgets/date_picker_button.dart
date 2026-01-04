import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

/// Date Picker Button Widget
/// Pill-shaped button for selecting dates
class DatePickerButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const DatePickerButton({
    super.key,
    required this.label,
    this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final displayText = date != null ? dateFormat.format(date!) : 'Not set';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingMd,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            border: Border.all(
              color: AppTheme.borderColor,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: AppTheme.h3,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                displayText,
                style: AppTheme.bodySecondary.copyWith(
                  color: date != null 
                      ? AppTheme.textSecondary 
                      : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
