import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

/// Provider for managing the photo list and swipe state
class PhotoProvider extends ChangeNotifier {
  List<PhotoModel> _photos = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  FilterType _currentFilter = FilterType.mostRecent;
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalCount = 0;

  // Getters
  List<PhotoModel> get photos => _photos;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FilterType get currentFilter => _currentFilter;
  int get remainingCount => _photos.length - _currentIndex;
  int get totalCount => _totalCount;
  PhotoModel? get currentPhoto =>
      _currentIndex < _photos.length ? _photos[_currentIndex] : null;
  bool get hasPhotos => _photos.isNotEmpty && _currentIndex < _photos.length;

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
      // Get the appropriate request type
      RequestType requestType = RequestType.image;
      if (_currentFilter == FilterType.videos) {
        requestType = RequestType.video;
      } else if (_currentFilter != FilterType.videos) {
        requestType = RequestType.common;
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

      // Get the "Recent" album (usually first)
      final AssetPathEntity recentAlbum = albums.first;
      _totalCount = await recentAlbum.assetCountAsync;

      // Fetch photos
      final List<AssetEntity> assets = await recentAlbum.getAssetListPaged(
        page: 0,
        size: AppConstants.maxInitialPhotos,
      );

      // Convert to PhotoModel and load HIGH QUALITY thumbnails
      List<PhotoModel> loadedPhotos = [];

      for (final asset in assets) {
        // Apply date filters if set
        if (_startDate != null && asset.createDateTime.isBefore(_startDate!)) {
          continue;
        }
        if (_endDate != null && asset.createDateTime.isAfter(_endDate!)) {
          continue;
        }

        // Load HIGH QUALITY thumbnail (800x800 instead of 200x200)
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(800, 800),
          quality: 90,
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

      // Sort based on filter type
      if (_currentFilter == FilterType.oldest) {
        loadedPhotos.sort((a, b) => a.createDate.compareTo(b.createDate));
      } else {
        loadedPhotos.sort((a, b) => b.createDate.compareTo(a.createDate));
      }

      _photos = loadedPhotos;
      _isLoading = false;
      notifyListeners();

      debugPrint('Loaded ${_photos.length} photos');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading photos: $e');
    }
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

  /// Reset to beginning
  void reset() {
    _currentIndex = 0;
    _photos = [];
    _errorMessage = null;
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

  void swipeLeft() {
    nextPhoto();
  }

  void swipeRight() {
    nextPhoto();
  }
}
