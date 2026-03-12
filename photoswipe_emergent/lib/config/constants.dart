/// App-wide constants for PhotoSwipe
class AppConstants {
  AppConstants._();

  // ============== APP INFO ==============

  static const String appName = 'PhotoSwipe';
  static const String appTagline = 'A Tinder-style gallery cleaner';
  static const String appVersion = '1.2.0';

  // ============== STORAGE KEYS ==============

  static const String keyHasAcceptedTerms = 'has_accepted_terms';
  static const String keyHasGrantedPermission = 'has_granted_permission';
  static const String keyLastSessionId = 'last_session_id';
  static const String keyDumpBoxIds = 'dumpbox_ids';
  static const String keySessions = 'sessions';
  static const String keyReviewedPhotoIds = 'reviewed_photo_ids';

  // ============== PHOTO LOADING ==============

  /// Number of photos to load per page
  static const int photosPerPage = 500;

  /// Maximum photos to load per batch (20 for testing, 100 for production)
  static const int maxPhotosToLoad = 20;

  /// When to trigger auto-load (load next batch when this many photos remain)
  static const int autoLoadThreshold = 5;

  /// Thumbnail size for swipe cards
  static const int thumbnailSize = 800;

  /// High quality thumbnail for swipe view
  static const int highQualitySize = 800;

  // ============== SWIPE SETTINGS ==============

  /// Minimum swipe distance to trigger action (in pixels)
  static const double swipeThreshold = 100.0;

  /// Swipe velocity threshold
  static const double swipeVelocityThreshold = 300.0;

  /// Card rotation angle when swiping (in degrees)
  static const double maxRotationAngle = 15.0;

  /// Number of cards visible in stack
  static const int cardsInStack = 3;

  // ============== ANIMATION DURATIONS ==============

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration swipeAnimationDuration = Duration(milliseconds: 400);

  // ============== PRIVACY DISCLAIMER ==============

  static const List<String> privacyPoints = [
    'We do NOT save, store, or use your photos for any reason',
    'We only access your photos so you can review and delete them',
    'All photo processing happens on YOUR device',
    'We are NOT liable for any photos you choose to delete',
    'Deletions are permanent and cannot be recovered',
    'On iOS, deleted photos remain in Recently Deleted for 30 days',
  ];

  // ============== PERMISSION MESSAGES ==============

  static const String permissionTitle = 'Photo Access Required';
  static const String permissionMessage =
      'PhotoSwipe needs access to your photo library to help you review and delete photos.';
  static const String permissionDeniedMessage =
      'Photo access was denied. Please enable it in Settings to use PhotoSwipe.';
  static const String permissionLimitedMessage =
      'You\'ve granted limited access. Tap here to select more photos or grant full access.';

  // ============== CATEGORY OPTIONS ==============

  static const String categoryMostRecent = 'Most Recent';
  static const String categoryMostRecentDesc = 'Only unreviewed photos';

  static const String categoryAllPhotos = 'All Photos';
  static const String categoryAllPhotosDesc = 'Review everything again';

  static const String categoryOldest = 'Oldest';
  static const String categoryOldestDesc = 'Start with oldest photos';

  static const String categoryVideos = 'Videos';
  static const String categoryVideosDesc = 'Review video files only';

  static const String categoryDateRange = 'Custom Date Range';
  static const String categoryDateRangeDesc = 'Pick start and end dates';

  static const String categoryResume = 'Resume Last Session';
  static const String categoryResumeDesc = 'Continue with unreviewed photos';

  // ============== DUMPBOX SETTINGS ==============

  /// Maximum photos in dumpbox before requiring review
  static const int maxDumpBoxPhotos = 30;

  // ============== HELP TEXT ==============

  static const String helpMostRecentVsAllTitle = 'What\'s the difference?';
  static const String helpMostRecentVsAll = '''
Most Recent: Shows only photos you haven\'t swiped yet. Perfect for cleaning new photos without re-reviewing old ones.

All Photos: Shows your entire library, including photos you\'ve already kept. Great for a fresh start or re-reviewing saved photos.

Note: Deleted photos are permanently removed and won\'t appear in either option.''';

  // ============== EMPTY STATES ==============

  static const String emptyStateTitle = 'Good Job!';
  static const String emptyStateMessage = 'No more photos to review.';
  static const String emptyDumpBoxTitle = 'DumpBox is Empty';
  static const String emptyDumpBoxMessage =
      'Photos you swipe left will appear here for review before deletion.';

  // ============== CONFIRMATION MESSAGES ==============

  static const String deleteConfirmTitle = 'Delete photos?';
  static const String deleteConfirmMessage =
      'This will permanently delete these photos from your device.';
  static const String deleteConfirmNote =
      'On some devices they may first move to "Recently Deleted" for 30 days.';

  // ============== BUTTON LABELS ==============

  static const String buttonContinue = 'Continue';
  static const String buttonGrantAccess = 'Grant Access';
  static const String buttonStartReview = 'Start Review';
  static const String buttonDelete = 'Delete';
  static const String buttonKeep = 'Keep';
  static const String buttonCancel = 'Cancel';
  static const String buttonRestoreAll = 'Restore All';
  static const String buttonClearSelection = 'Clear Selection';
  static const String buttonDeleteSelected = 'Delete Selected';
  static const String buttonKeepSelected = 'Keep Selected';
  static const String buttonGoToSettings = 'Go to Settings';
}

/// Filter types for photo loading
enum FilterType {
  mostRecent,    // Skip reviewed photos, newest first
  oldest,        // Skip reviewed photos, oldest first
  videos,        // Skip reviewed videos, newest first
  dateRange,     // Custom date range, oldest first (start date forward)
  resume,        // Continue from where user left off
  allPhotos,     // Show ALL photos (including reviewed) - ADDED AT END
}

/// Sort order for photos
enum SortOrder {
  ascending,
  descending,
}
