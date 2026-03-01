import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

/// Provider for managing the photo list and swipe state
class PhotoProvider extends ChangeNotifier {
  List<PhotoModel> _photos = [];
  List<AssetEntity> _allAssets = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  FilterType _currentFilter = FilterType.mostRecent;
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalCount = 0;
  Set<String> _reviewedPhotoIds = {};

  // Getters
  List<PhotoModel> get photos => _photos;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FilterType get currentFilter => _currentFilter;
  int get remainingCount => _photos.length - _currentIndex;
  int get totalCount => _totalCount;
  Set<String> get reviewedPhotoIds => _reviewedPhotoIds;
  PhotoModel? get currentPhoto =>
      _currentIndex < _photos.length ? _photos[_currentIndex] : null;
  bool get hasPhotos => _photos.isNotEmpty && _currentIndex < _photos.length;

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
      if (_currentFilter == FilterType.oldest) {
        _allAssets.sort((a, b) => a.createDateTime.compareTo(b.createDateTime));
      } else {
        // Most recent (default)
        _allAssets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
      }

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

        // For Resume Session: skip already reviewed photos
        if (_currentFilter == FilterType.resume) {
          if (_reviewedPhotoIds.contains(asset.id)) {
            continue;
          }
        }

        filteredAssets.add(asset);
      }

      debugPrint('Filtered to ${filteredAssets.length} assets');

      // LIMIT TO MAX PHOTOS to prevent memory crash
      if (filteredAssets.length > AppConstants.maxPhotosToLoad) {
        debugPrint('Limiting from ${filteredAssets.length} to ${AppConstants.maxPhotosToLoad} photos');
        filteredAssets = filteredAssets.sublist(0, AppConstants.maxPhotosToLoad);
      }

      // Load thumbnails for first batch (for smooth UX)
      final int initialBatchSize = 10;
      List<PhotoModel> loadedPhotos = [];

      for (int i = 0; i < filteredAssets.length && i < initialBatchSize; i++) {
        final asset = filteredAssets[i];
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
      _loadRemainingPhotos(filteredAssets, initialBatchSize);
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
  void nextPhoto() {
    if (_currentIndex < _photos.length) {
      _currentIndex++;
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
