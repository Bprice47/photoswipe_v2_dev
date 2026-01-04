import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Confirmation Dialog Widget
/// Used for delete confirmation before permanent deletion
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? note;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.note,
    required this.cancelText,
    required this.confirmText,
    this.confirmColor = AppTheme.deleteColor,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundModal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: AppTheme.h3,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            // Message
            Text(
              message,
              style: AppTheme.bodySecondary,
              textAlign: TextAlign.center,
            ),
            
            // Note (if provided)
            if (note != null) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                note!,
                style: AppTheme.caption,
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: Text(
                      cancelText,
                      style: AppTheme.button.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
                
                // Confirm Button
                Expanded(
                  child: TextButton(
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: AppTheme.button.copyWith(
                        color: confirmColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
