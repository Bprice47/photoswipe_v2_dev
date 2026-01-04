import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/category_tile.dart';

/// Screen 3: Category Screen - Main Menu
/// Let user choose how they want to review photos
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundMain,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                    // Most Recent
                    CategoryTile(
                      icon: Icons.access_time,
                      title: AppConstants.categoryMostRecent,
                      subtitle: AppConstants.categoryMostRecentDesc,
                      onTap: () => _navigateToSwipe(
                        context,
                        FilterType.mostRecent,
                      ),
                    ),
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
