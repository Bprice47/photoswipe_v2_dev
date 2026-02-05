import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/photo_model.dart';

/// Swipeable photo card widget
class SwipeCard extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback? onUndo;

  const SwipeCard({
    super.key,
    required this.photo,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo
            _buildPhoto(),

            // Undo button - center top
            if (onUndo != null)
              Positioned(
                top: AppTheme.spacingSm,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onUndo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.undo,
                            color: AppTheme.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingXs),
                          Text(
                            'Undo',
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Video indicator
            if (photo.isVideo)
              Positioned(
                bottom: AppTheme.spacingMd,
                left: AppTheme.spacingMd,
                child: _buildVideoIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (photo.thumbnail != null) {
      return Image.memory(
        photo.thumbnail!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.backgroundCardAlt,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 80,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }

  Widget _buildVideoIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.videocam,
            color: AppTheme.textPrimary,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Text(
            photo.formattedDuration,
            style: AppTheme.small.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Swipe overlay indicator (shows DELETE or KEEP)
class SwipeOverlay extends StatelessWidget {
  final bool isLeft;
  final double opacity;

  const SwipeOverlay({
    super.key,
    required this.isLeft,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (isLeft ? AppTheme.deleteColor : AppTheme.keepColor)
            .withOpacity(opacity * 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Center(
        child: Icon(
          isLeft ? Icons.delete : Icons.favorite,
          size: 80,
          color: AppTheme.textPrimary.withOpacity(opacity),
        ),
      ),
    );
  }
}
