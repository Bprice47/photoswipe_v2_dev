import 'package:flutter/foundation.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

/// Provider for managing the DumpBox (photos marked for deletion)
class DumpBoxProvider extends ChangeNotifier {
  final List<PhotoModel> _dumpBoxPhotos = [];
  final Set<String> _selectedIds = {};
  bool _isSubscriber = false; // Placeholder flag for subscription status

  // Getters
  List<PhotoModel> get photos => _dumpBoxPhotos;
  int get count => _dumpBoxPhotos.length;
  Set<String> get selectedIds => _selectedIds;
  int get selectedCount => _selectedIds.length;
  bool get hasPhotos => _dumpBoxPhotos.isNotEmpty;
  bool get allSelected => _selectedIds.length == _dumpBoxPhotos.length;
  bool get isSubscriber => _isSubscriber;
  bool get isFull => _dumpBoxPhotos.length >= AppConstants.maxDumpBoxPhotos;
  int get remainingSlots => AppConstants.maxDumpBoxPhotos - _dumpBoxPhotos.length;

  /// Set subscriber status (placeholder for future implementation)
  void setSubscriberStatus(bool status) {
    _isSubscriber = status;
    notifyListeners();
  }

  /// Add a photo to DumpBox (swiped left)
  /// Returns true if added, false if dumpbox is full
  bool addPhoto(PhotoModel photo) {
    if (_dumpBoxPhotos.any((p) => p.id == photo.id)) {
      return true; // Already exists
    }
    
    if (isFull) {
      return false; // Dumpbox is full
    }
    
    _dumpBoxPhotos.add(photo);
    _selectedIds.add(photo.id); // Auto-select new additions
    notifyListeners();
    return true;
  }

  /// Remove a photo from DumpBox (restored)
  void removePhoto(String photoId) {
    _dumpBoxPhotos.removeWhere((p) => p.id == photoId);
    _selectedIds.remove(photoId);
    notifyListeners();
  }

  /// Remove the last added photo (for Undo functionality)
  void removeLastPhoto() {
    if (_dumpBoxPhotos.isNotEmpty) {
      final lastPhoto = _dumpBoxPhotos.removeLast();
      _selectedIds.remove(lastPhoto.id);
      notifyListeners();
    }
  }

  /// Toggle selection of a photo
  void toggleSelection(String photoId) {
    if (_selectedIds.contains(photoId)) {
      _selectedIds.remove(photoId);
    } else {
      _selectedIds.add(photoId);
    }
    notifyListeners();
  }

  /// Select all photos
  void selectAll() {
    _selectedIds.clear();
    for (var photo in _dumpBoxPhotos) {
      _selectedIds.add(photo.id);
    }
    notifyListeners();
  }

  /// Clear all selections
  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  /// Get selected photos
  List<PhotoModel> getSelectedPhotos() {
    return _dumpBoxPhotos.where((p) => _selectedIds.contains(p.id)).toList();
  }

  /// Remove selected photos (after deletion confirmation)
  void removeSelected() {
    _dumpBoxPhotos.removeWhere((p) => _selectedIds.contains(p.id));
    _selectedIds.clear();
    notifyListeners();
  }

  /// Restore all photos (clear DumpBox)
  void restoreAll() {
    _dumpBoxPhotos.clear();
    _selectedIds.clear();
    notifyListeners();
  }

  /// Keep selected photos (remove from DumpBox, keep in library)
  void keepSelected() {
    _dumpBoxPhotos.removeWhere((p) => _selectedIds.contains(p.id));
    _selectedIds.clear();
    notifyListeners();
  }
}
