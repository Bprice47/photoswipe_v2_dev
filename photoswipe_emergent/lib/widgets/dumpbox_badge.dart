import 'package:flutter/material.dart';
import '../config/theme.dart';

/// DumpBox Badge Widget
/// Shows count of photos in DumpBox
class DumpBoxBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const DumpBoxBadge({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: AppTheme.accentSecondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          ),
          child: Text(
            'DumpBox ($count)',
            style: AppTheme.caption.copyWith(
              color: AppTheme.accentSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
