import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/category_tile.dart';
import '../widgets/app_drawer.dart';

/// Screen 3: Category Screen - Main Menu
/// Let user choose how they want to review photos
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // 0 = Most Recent (skip reviewed), 1 = All Photos
  int _selectedPhotoMode = 0;

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Text(
          AppConstants.helpMostRecentVsAllTitle,
          style: AppTheme.h3,
        ),
        content: Text(
          AppConstants.helpMostRecentVsAll,
          style: AppTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(color: AppTheme.accentPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundMain,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Select Category',
          style: AppTheme.headerTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingLg),

              // Question
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                ),
                child: Text(
                  'What would you like to review?',
                  style: AppTheme.h2,
                ),
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Category Options
              Expanded(
                child: ListView(
                  children: [
                    // Segmented Toggle: Most Recent | All Photos with Help Icon
                    _buildPhotoModeSelector(),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Oldest
                    CategoryTile(
                      icon: Icons.history,
                      title: AppConstants.categoryOldest,
                      subtitle: AppConstants.categoryOldestDesc,
                      onTap: () => _navigateToSwipe(
                        context,
                        FilterType.oldest,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Videos
                    CategoryTile(
                      icon: Icons.videocam,
                      title: AppConstants.categoryVideos,
                      subtitle: AppConstants.categoryVideosDesc,
                      onTap: () => _navigateToSwipe(
                        context,
                        FilterType.videos,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Custom Date Range
                    CategoryTile(
                      icon: Icons.calendar_month,
                      title: AppConstants.categoryDateRange,
                      subtitle: AppConstants.categoryDateRangeDesc,
                      onTap: () => AppRoutes.navigateTo(
                        context,
                        AppRoutes.dateRange,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Resume Last Session
                    CategoryTile(
                      icon: Icons.play_circle_outline,
                      title: AppConstants.categoryResume,
                      subtitle: AppConstants.categoryResumeDesc,
                      onTap: () => _navigateToSwipe(
                        context,
                        FilterType.resume,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the segmented toggle for Most Recent / All Photos
  Widget _buildPhotoModeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCardAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          // Segmented toggle with help icon
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: AppTheme.accentPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),

                // Segmented Control
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundMain,
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    child: Row(
                      children: [
                        // Most Recent Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedPhotoMode = 0);
                              _navigateToSwipe(context, FilterType.mostRecent);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _selectedPhotoMode == 0
                                    ? AppTheme.accentPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                              ),
                              child: Center(
                                child: Text(
                                  'Most Recent',
                                  style: TextStyle(
                                    color: _selectedPhotoMode == 0
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // All Photos Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedPhotoMode = 1);
                              _navigateToSwipe(context, FilterType.allPhotos);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _selectedPhotoMode == 1
                                    ? AppTheme.accentPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                              ),
                              child: Center(
                                child: Text(
                                  'All Photos',
                                  style: TextStyle(
                                    color: _selectedPhotoMode == 1
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: AppTheme.spacingSm),

                // Help Icon
                GestureDetector(
                  onTap: _showHelpDialog,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.textMuted.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Subtitle below the toggle
          Padding(
            padding: const EdgeInsets.only(
              left: AppTheme.spacingMd + 48 + AppTheme.spacingMd,
              right: AppTheme.spacingMd,
              bottom: AppTheme.spacingMd,
            ),
            child: Text(
              _selectedPhotoMode == 0
                  ? AppConstants.categoryMostRecentDesc
                  : AppConstants.categoryAllPhotosDesc,
              style: AppTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to swipe screen with filter options
  void _navigateToSwipe(BuildContext context, FilterType filterType) {
    AppRoutes.navigateTo(
      context,
      AppRoutes.swipe,
      arguments: {
        'filterType': filterType,
      },
    );
  }
}
