import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../providers/photo_provider.dart';
import '../providers/dumpbox_provider.dart';
import '../widgets/dumpbox_badge.dart';
import '../widgets/swipe_card.dart';

/// Screen 5: Swipe Screen - Main Photo Review Interface
class SwipeScreen extends StatefulWidget {
  final Map<String, dynamic>? filterOptions;

  const SwipeScreen({super.key, this.filterOptions});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late CardSwiperController _swiperController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePhotos();
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  Future<void> _initializePhotos() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);

    // Always reset photos list and index when entering screen
    photoProvider.reset();

    // Initialize provider (load reviewed IDs)
    await photoProvider.init();

    // Set filter from arguments
    if (widget.filterOptions != null) {
      final filterType = widget.filterOptions!['filterType'] as FilterType?;
      final startDate = widget.filterOptions!['startDate'] as DateTime?;
      final endDate = widget.filterOptions!['endDate'] as DateTime?;

      if (filterType != null) {
        photoProvider.setFilter(
          type: filterType,
          startDate: startDate,
          endDate: endDate,
        );
      }
    }

    // Load photos (will use cached assets if available)
    await photoProvider.loadPhotos();
  }

  void _onSwipeLeft(
      PhotoProvider photoProvider, DumpBoxProvider dumpBoxProvider) {
    final currentPhoto = photoProvider.currentPhoto;
    if (currentPhoto != null) {
      dumpBoxProvider.addPhoto(currentPhoto);
    }
    _swiperController.swipe(CardSwiperDirection.left);
  }

  void _onSwipeRight(PhotoProvider photoProvider) {
    _swiperController.swipe(CardSwiperDirection.right);
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
    final dumpBoxProvider =
        Provider.of<DumpBoxProvider>(context, listen: false);

    if (direction == CardSwiperDirection.left) {
      // Swiped left - add to dumpbox (not marked as reviewed)
      final photo = photoProvider.photos[previousIndex];
      dumpBoxProvider.addPhoto(photo);
      photoProvider.swipeLeft();
    } else if (direction == CardSwiperDirection.right) {
      // Swiped right - keep photo and mark as reviewed
      photoProvider.swipeRight();
    }

    return true;
  }

  void _onUndo(DumpBoxProvider dumpBoxProvider) {
    _swiperController.undo();
    dumpBoxProvider.removeLastPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PhotoProvider, DumpBoxProvider>(
      builder: (context, photoProvider, dumpBoxProvider, child) {
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
              AppConstants.appName,
              style: AppTheme.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            actions: [
              DumpBoxBadge(
                count: dumpBoxProvider.count,
                onTap: () => AppRoutes.navigateTo(context, AppRoutes.dumpbox),
              ),
              const SizedBox(width: AppTheme.spacingSm),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                children: [
                  // Card Area
                  Expanded(
                    child: _buildCardArea(photoProvider, dumpBoxProvider),
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Progress Counter: "Photo X of Y (Z total)"
                  Column(
                    children: [
                      Text(
                        'Photo ${photoProvider.currentIndex + 1} of ${photoProvider.photos.length}',
                        style: AppTheme.body,
                      ),
                      Text(
                        '(${photoProvider.totalFilteredCount} total in library)',
                        style: AppTheme.caption,
                      ),
                      if (photoProvider.isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Loading more...',
                            style: TextStyle(
                              color: AppTheme.accentPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Action Buttons
                  _buildActionButtons(photoProvider, dumpBoxProvider),

                  const SizedBox(height: AppTheme.spacingMd),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardArea(
      PhotoProvider photoProvider, DumpBoxProvider dumpBoxProvider) {
    if (photoProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.accentPrimary),
            SizedBox(height: AppTheme.spacingMd),
            Text(
              'Loading photos...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    if (photoProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.deleteColor,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Error loading photos',
              style: AppTheme.h3,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              photoProvider.errorMessage!,
              style: AppTheme.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton(
              onPressed: () => photoProvider.loadPhotos(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!photoProvider.hasPhotos) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppTheme.keepColor,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              AppConstants.emptyStateTitle,
              style: AppTheme.h2,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              AppConstants.emptyStateMessage,
              style: AppTheme.bodySecondary,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton(
              onPressed: () => AppRoutes.goBack(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    // Card Swiper
    return CardSwiper(
      controller: _swiperController,
      cardsCount: photoProvider.photos.length,
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(0, 30),
      padding: EdgeInsets.zero,
      onSwipe: _onSwipe,
      onUndo: (previousIndex, currentIndex, direction) => true,
      allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
        horizontal: true,
      ),
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
        if (index >= photoProvider.photos.length) {
          return const SizedBox.shrink();
        }

        final photo = photoProvider.photos[index];

        return Stack(
          fit: StackFit.expand,
          children: [
            SwipeCard(
              photo: photo,
              onUndo: () => _onUndo(dumpBoxProvider),
            ),

            // Swipe overlay
            if (percentThresholdX != 0)
              SwipeOverlay(
                isLeft: percentThresholdX < 0,
                opacity: percentThresholdX.abs().clamp(0.0, 1.0).toDouble(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(
    PhotoProvider photoProvider,
    DumpBoxProvider dumpBoxProvider,
  ) {
    final hasPhotos = photoProvider.hasPhotos;

    return Row(
      children: [
        // Delete Button
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: hasPhotos
                  ? () => _onSwipeLeft(photoProvider, dumpBoxProvider)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasPhotos
                    ? AppTheme.deleteColor
                    : AppTheme.backgroundCardAlt,
                foregroundColor: AppTheme.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    AppConstants.buttonDelete,
                    style: AppTheme.button,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: AppTheme.spacingMd),

        // Keep Button
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: hasPhotos ? () => _onSwipeRight(photoProvider) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasPhotos ? AppTheme.keepColor : AppTheme.backgroundCardAlt,
                foregroundColor: AppTheme.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.buttonKeep,
                    style: AppTheme.button,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
