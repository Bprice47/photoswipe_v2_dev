import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

/// Provider for managing the photo list and swipe state
class PhotoProvider extends ChangeNotifier {
  List<PhotoModel> _photos = [];
  List<AssetEntity> _allAssets = [];
  List<AssetEntity> _filteredAssets = []; // Store filtered assets for auto-load
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false; // For auto-load indicator
  String? _errorMessage;
  FilterType _currentFilter = FilterType.mostRecent;
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalCount = 0;
  int _currentBatchStart = 0; // Track which batch we're on
  Set<String> _reviewedPhotoIds = {};

  // Getters
  List<PhotoModel> get photos => _photos;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  FilterType get currentFilter => _currentFilter;
  int get remainingCount => _photos.length - _currentIndex;
  int get totalCount => _totalCount;
  int get totalFilteredCount => _filteredAssets.length; // Total available after filtering
  Set<String> get reviewedPhotoIds => _reviewedPhotoIds;
  PhotoModel? get currentPhoto =>
      _currentIndex < _photos.length ? _photos[_currentIndex] : null;
  bool get hasPhotos => _photos.isNotEmpty && _currentIndex < _photos.length;
  bool get hasMoreToLoad => _currentBatchStart + AppConstants.maxPhotosToLoad < _filteredAssets.length;

  /// Initialize - load reviewed photo IDs from storage
  Future<void> init() async {
    await _loadReviewedIds();
  }

  /// Load reviewed photo IDs from storage
  Future<void> _loadReviewedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(AppConstants.keyReviewedPhotoIds) ?? [];
      _reviewedPhotoIds = ids.toSet();
      debugPrint('Loaded ${_reviewedPhotoIds.length} reviewed photo IDs');
    } catch (e) {
      debugPrint('Error loading reviewed IDs: $e');
    }
  }

  /// Save reviewed photo IDs to storage
  Future<void> _saveReviewedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        AppConstants.keyReviewedPhotoIds,
        _reviewedPhotoIds.toList(),
      );
    } catch (e) {
      debugPrint('Error saving reviewed IDs: $e');
    }
  }

  /// Mark a photo as reviewed (swiped right = kept)
  Future<void> markAsReviewed(String photoId) async {
    _reviewedPhotoIds.add(photoId);
    await _saveReviewedIds();
  }

  /// Set filter options before loading photos
  void setFilter({
    required FilterType type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _currentFilter = type;
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  /// Load photos from gallery using photo_manager
  Future<void> loadPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    _photos = [];
    _currentIndex = 0;
    notifyListeners();

    try {
      // Make sure reviewed IDs are loaded
      if (_reviewedPhotoIds.isEmpty) {
        await _loadReviewedIds();
      }

      // Get the appropriate request type
      RequestType requestType = RequestType.image;
      if (_currentFilter == FilterType.videos) {
        requestType = RequestType.video;
      } else {
        requestType = RequestType.common; // Both images and videos
      }

      // Get all albums
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: requestType,
        hasAll: true,
      );

      if (albums.isEmpty) {
        _errorMessage = 'No photo albums found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get the "Recent" album (usually first, contains all)
      final AssetPathEntity recentAlbum = albums.first;
      _totalCount = await recentAlbum.assetCountAsync;

      debugPrint('Total photos in library: $_totalCount');

      // Fetch ALL photo references (fast - no thumbnails yet)
      _allAssets = await recentAlbum.getAssetListRange(
        start: 0,
        end: _totalCount,
      );

      debugPrint('Fetched ${_allAssets.length} asset references');

      // Sort based on filter type FIRST
      // Custom date range sorts oldest first (start date forward)
      if (_currentFilter == FilterType.oldest || _currentFilter == FilterType.dateRange) {
        _allAssets.sort((a, b) => a.createDateTime.compareTo(b.createDateTime));
      } else {
        // Most recent, allPhotos, videos, resume (default - newest first)
        _allAssets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
      }

      // Determine if we should skip reviewed photos
      // allPhotos and dateRange show everything; others skip reviewed
      bool skipReviewed = _currentFilter != FilterType.allPhotos && 
                          _currentFilter != FilterType.dateRange;

      // Filter assets based on criteria
      List<AssetEntity> filteredAssets = [];

      for (final asset in _allAssets) {
        // Apply date filters if set
        if (_startDate != null && asset.createDateTime.isBefore(_startDate!)) {
          continue;
        }
        if (_endDate != null && asset.createDateTime.isAfter(_endDate!)) {
          continue;
        }

        // Skip reviewed photos for mostRecent, oldest, videos, resume
        if (skipReviewed && _reviewedPhotoIds.contains(asset.id)) {
          continue;
        }

        filteredAssets.add(asset);
      }

      debugPrint('Filtered to ${filteredAssets.length} assets');

      // Store filtered assets for auto-load functionality
      _filteredAssets = filteredAssets;
      _currentBatchStart = 0;

      // Get current batch (first 1000 or less)
      List<AssetEntity> currentBatch = filteredAssets.length > AppConstants.maxPhotosToLoad
          ? filteredAssets.sublist(0, AppConstants.maxPhotosToLoad)
          : filteredAssets;

      debugPrint('Loading batch of ${currentBatch.length} photos (${filteredAssets.length} total available)');

      // Load thumbnails for first batch (for smooth UX)
      final int initialBatchSize = 10;
      List<PhotoModel> loadedPhotos = [];

      for (int i = 0; i < currentBatch.length && i < initialBatchSize; i++) {
        final asset = currentBatch[i];
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(800, 800),
          quality: 85,
        );

        loadedPhotos.add(PhotoModel(
          id: asset.id,
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type:
              asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));
      }

      _photos = loadedPhotos;
      _isLoading = false;
      notifyListeners();

      debugPrint('Initial batch loaded: ${_photos.length} photos');

      // Load remaining thumbnails in background
      _loadRemainingPhotos(currentBatch, initialBatchSize);
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading photos: $e');
    }
  }

  /// Load remaining photos in background
  Future<void> _loadRemainingPhotos(
      List<AssetEntity> assets, int startIndex) async {
    for (int i = startIndex; i < assets.length; i++) {
      final asset = assets[i];

      try {
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(800, 800),
          quality: 85,
        );

        _photos.add(PhotoModel(
          id: asset.id,
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type:
              asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));

        // Update UI every 20 photos
        if (i % 20 == 0) {
          notifyListeners();
          debugPrint('Loaded ${_photos.length} photos...');
        }
      } catch (e) {
        debugPrint('Error loading photo $i: $e');
      }
    }

    notifyListeners();
    debugPrint('Finished loading all ${_photos.length} photos');
  }

  /// Move to next photo (called after swipe)
  /// Triggers auto-load when approaching the end of current batch
  void nextPhoto() {
    if (_currentIndex < _photos.length) {
      _currentIndex++;
      notifyListeners();
      
      // Auto-load when 100 photos remaining and more batches available
      if (remainingCount <= 100 && hasMoreToLoad && !_isLoadingMore) {
        _loadNextBatch();
      }
    }
  }

  /// Load next batch of photos automatically
  Future<void> _loadNextBatch() async {
    if (_isLoadingMore || !hasMoreToLoad) return;
    
    _isLoadingMore = true;
    notifyListeners();
    
    try {
      _currentBatchStart += AppConstants.maxPhotosToLoad;
      
      int endIndex = _currentBatchStart + AppConstants.maxPhotosToLoad;
      if (endIndex > _filteredAssets.length) {
        endIndex = _filteredAssets.length;
      }
      
      List<AssetEntity> nextBatch = _filteredAssets.sublist(_currentBatchStart, endIndex);
      
      debugPrint('Auto-loading next batch: ${nextBatch.length} photos (starting at $_currentBatchStart)');
      
      for (int i = 0; i < nextBatch.length; i++) {
        final asset = nextBatch[i];
        
        try {
          final thumbnail = await asset.thumbnailDataWithSize(
            const ThumbnailSize(800, 800),
            quality: 85,
          );
          
          _photos.add(PhotoModel(
            id: asset.id,
            createDate: asset.createDateTime,
            modifyDate: asset.modifiedDateTime,
            width: asset.width,
            height: asset.height,
            type: asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
            duration: asset.type == AssetType.video ? asset.duration : null,
            thumbnail: thumbnail,
          ));
          
          // Update UI every 20 photos
          if (i % 20 == 0) {
            notifyListeners();
          }
        } catch (e) {
          debugPrint('Error loading photo in next batch: $e');
        }
      }
      
      _isLoadingMore = false;
      notifyListeners();
      debugPrint('Auto-load complete. Total photos now: ${_photos.length}');
    } catch (e) {
      debugPrint('Error loading next batch: $e');
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Undo - go back to previous photo
  void undoPhoto() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// Swipe right - keep photo and mark as reviewed
  Future<void> swipeRight() async {
    if (currentPhoto != null) {
      await markAsReviewed(currentPhoto!.id);
    }
    nextPhoto();
  }

  /// Swipe left - goes to dumpbox AND mark as reviewed
  Future<void> swipeLeft() async {
    if (currentPhoto != null) {
      await markAsReviewed(currentPhoto!.id);
    }
    nextPhoto();
  }

  /// Reset to beginning
  void reset() {
    _currentIndex = 0;
    _photos = [];
    _filteredAssets = [];
    _currentBatchStart = 0;
    _isLoadingMore = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all reviewed IDs (for testing/reset)
  Future<void> clearReviewedIds() async {
    _reviewedPhotoIds.clear();
    await _saveReviewedIds();
    notifyListeners();
  }

  /// Get photos for stack display (current + next few)
  List<PhotoModel> getStackPhotos() {
    if (_photos.isEmpty) return [];
    final endIndex =
        (_currentIndex + AppConstants.cardsInStack).clamp(0, _photos.length);
    if (_currentIndex >= _photos.length) return [];
    return _photos.sublist(_currentIndex, endIndex);
  }
}
