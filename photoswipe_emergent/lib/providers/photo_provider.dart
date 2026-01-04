import 'package:flutter/foundation.dart';
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

  // Getters
  List<PhotoModel> get photos => _photos;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FilterType get currentFilter => _currentFilter;
  int get remainingCount => _photos.length - _currentIndex;
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

  /// Load photos from gallery (to be implemented with photo_manager)
  Future<void> loadPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement actual photo loading with photo_manager
      // This will be done in Phase 6
      await Future.delayed(const Duration(seconds: 1));
      
      // Placeholder - will be replaced with actual implementation
      _photos = [];
      _currentIndex = 0;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Move to next photo (called after swipe)
  void nextPhoto() {
    if (_currentIndex < _photos.length - 1) {
      _currentIndex++;
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
    final endIndex = (_currentIndex + AppConstants.cardsInStack)
        .clamp(0, _photos.length);
    return _photos.sublist(_currentIndex, endIndex);
  }
}
