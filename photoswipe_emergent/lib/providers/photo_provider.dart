import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

/// Provider for managing the photo list and swipe state
class PhotoProvider extends ChangeNotifier {
  List<PhotoModel> _photos = [];
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
  bool get hasMoreToLoad => _currentBatchStart + AppConstants.maxPhotosToLoad < _totalCount;

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
  /// PAGINATED: Only fetches what we need, not the entire library
  Future<void> loadPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    _photos = [];
    _currentIndex = 0;
    _currentBatchStart = 0;
    notifyListeners();

    try {
      // Make sure reviewed IDs are loaded
      if (_reviewedPhotoIds.isEmpty) {
        await _loadReviewedIds();
      }

      // Determine if this is a videos-only filter
      final bool isVideoFilter = _currentFilter == FilterType.videos;
      
      // Get the appropriate request type
      RequestType requestType = isVideoFilter ? RequestType.video : RequestType.common;

      // Get all albums
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: requestType,
        hasAll: true,
      );

      if (albums.isEmpty) {
        _errorMessage = isVideoFilter ? 'No videos found' : 'No photo albums found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get the "Recent" album (usually first, contains all)
      final AssetPathEntity recentAlbum = albums.first;
      _totalCount = await recentAlbum.assetCountAsync;
      
      debugPrint('Total ${isVideoFilter ? "videos" : "photos"} in library: $_totalCount');

      // Determine sort order based on filter
      final bool oldestFirst = _currentFilter == FilterType.oldest || 
                               _currentFilter == FilterType.dateRange;
      
      // Determine if we should skip reviewed photos
      final bool skipReviewed = _currentFilter != FilterType.allPhotos && 
                                _currentFilter != FilterType.dateRange &&
                                _currentFilter != FilterType.oldest;

      // PAGINATED FETCH: Load photos in small batches until we have enough
      List<AssetEntity> validAssets = [];
      int fetchStart = oldestFirst ? _totalCount - 1 : 0;
      int fetchBatchSize = 200; // Fetch 200 at a time to filter
      int totalFetched = 0;
      
      while (validAssets.length < AppConstants.maxPhotosToLoad && totalFetched < _totalCount) {
        int start, end;
        
        if (oldestFirst) {
          // For oldest first, we need to fetch from the end
          end = _totalCount - totalFetched;
          start = (end - fetchBatchSize).clamp(0, end);
        } else {
          // For newest first, fetch from the beginning
          start = totalFetched;
          end = (start + fetchBatchSize).clamp(0, _totalCount);
        }
        
        if (start >= end) break;
        
        debugPrint('Fetching batch: $start to $end');
        
        final batchAssets = await recentAlbum.getAssetListRange(
          start: start,
          end: end,
        );
        
        totalFetched += batchAssets.length;
        
        // Filter this batch
        for (final asset in batchAssets) {
          // Apply date filters if set
          if (_startDate != null && asset.createDateTime.isBefore(_startDate!)) {
            continue;
          }
          if (_endDate != null && asset.createDateTime.isAfter(_endDate!)) {
            continue;
          }

          // Skip reviewed photos if needed
          if (skipReviewed && _reviewedPhotoIds.contains(asset.id)) {
            continue;
          }

          validAssets.add(asset);
          
          // Stop if we have enough
          if (validAssets.length >= AppConstants.maxPhotosToLoad) {
            break;
          }
        }
      }
      
      // Sort the valid assets
      if (oldestFirst) {
        validAssets.sort((a, b) => a.createDateTime.compareTo(b.createDateTime));
      } else {
        validAssets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
      }

      debugPrint('Found ${validAssets.length} valid assets after filtering');

      // Store for later use
      _filteredAssets = validAssets;

      if (validAssets.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load thumbnails for first batch (for smooth UX)
      final int initialBatchSize = 10;
      List<PhotoModel> loadedPhotos = [];

      for (int i = 0; i < validAssets.length && i < initialBatchSize; i++) {
        final asset = validAssets[i];
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(400, 400),
          quality: 70,
        );

        loadedPhotos.add(PhotoModel(
          id: asset.id,
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type: asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));
      }

      _photos = loadedPhotos;
      _isLoading = false;
      notifyListeners();

      debugPrint('Initial batch loaded: ${_photos.length} photos');

      // Load remaining thumbnails in background
      _loadRemainingPhotos(validAssets, initialBatchSize);
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
          const ThumbnailSize(400, 400),  // Smaller = faster
          quality: 70,  // Lower quality = faster
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

        // Update UI every 5 photos (faster feedback)
        if (i % 5 == 0) {
          notifyListeners();
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
      
      // Auto-load when near threshold and more batches available
      if (remainingCount <= AppConstants.autoLoadThreshold && hasMoreToLoad && !_isLoadingMore) {
        debugPrint('Auto-load triggered! Remaining: $remainingCount');
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
            const ThumbnailSize(400, 400),  // Smaller = faster
            quality: 70,  // Lower quality = faster
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
          
          // Update UI every 5 photos (faster feedback)
          if (i % 5 == 0) {
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
  
  /// Full reset (same as reset since we no longer cache all assets)
  void fullReset() {
    reset();
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
