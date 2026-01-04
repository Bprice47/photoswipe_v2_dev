import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Custom Checkbox with PhotoSwipe styling
/// Square outline that fills when checked
class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double size;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? AppTheme.accentPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: value ? AppTheme.accentPrimary : AppTheme.textPrimary,
            width: 2,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: size - 8,
                color: AppTheme.textPrimary,
              )
            : null,
      ),
    );
  }
}

/// Circular Checkbox for grid selection (DumpBox)
class CircularCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double size;

  const CircularCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? AppTheme.checkmarkBg : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? AppTheme.checkmarkBg : AppTheme.textPrimary,
            width: 2,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: size - 10,
                color: AppTheme.textPrimary,
              )
            : null,
      ),
    );
  }
}
