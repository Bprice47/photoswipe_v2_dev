import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/photo_model.dart';

/// Swipeable photo card widget
class SwipeCard extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback? onExpand;
  final VoidCallback? onRotateLeft;
  final VoidCallback? onRotateRight;
  final VoidCallback? onClose;

  const SwipeCard({
    super.key,
    required this.photo,
    this.onExpand,
    this.onRotateLeft,
    this.onRotateRight,
    this.onClose,
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

            // Top controls
            Positioned(
              top: AppTheme.spacingSm,
              left: AppTheme.spacingSm,
              right: AppTheme.spacingSm,
              child: _buildTopControls(),
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

  Widget _buildTopControls() {
    return Row(
      children: [
        // Rotate left
        _buildControlButton(
          icon: Icons.rotate_left,
          onTap: onRotateLeft,
        ),
        const SizedBox(width: AppTheme.spacingSm),

        // Expand
        _buildControlButton(
          icon: Icons.fullscreen,
          onTap: onExpand,
        ),

        const Spacer(),

        // Close/Skip
        _buildControlButton(
          icon: Icons.close,
          onTap: onClose,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(
          icon,
          color: AppTheme.textPrimary,
          size: 24,
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
  final bool isLeft; // true = delete (red), false = keep (green)
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
