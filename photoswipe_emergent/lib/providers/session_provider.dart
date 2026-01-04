import 'package:flutter/foundation.dart';
import '../models/session_model.dart';
import '../config/constants.dart';

/// Provider for managing session state (resume functionality)
class SessionProvider extends ChangeNotifier {
  SessionModel? _currentSession;
  SessionModel? _lastSession;
  bool _isLoading = false;

  // Getters
  SessionModel? get currentSession => _currentSession;
  SessionModel? get lastSession => _lastSession;
  bool get isLoading => _isLoading;
  bool get hasLastSession => _lastSession != null;

  /// Create a new session
  void startNewSession({
    required FilterType filterType,
    DateTime? startDate,
    DateTime? endDate,
    required int totalPhotos,
  }) {
    _currentSession = SessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filterType: filterType,
      startDate: startDate,
      endDate: endDate,
      totalPhotos: totalPhotos,
      reviewedCount: 0,
      deletedCount: 0,
      createdAt: DateTime.now(),
      lastAccessedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update session progress
  void updateProgress({int? reviewed, int? deleted}) {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        reviewedCount: reviewed ?? _currentSession!.reviewedCount,
        deletedCount: deleted ?? _currentSession!.deletedCount,
        lastAccessedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  /// Save current session (when app closes or user exits)
  Future<void> saveSession() async {
    if (_currentSession != null) {
      _lastSession = _currentSession;
      // TODO: Persist to local storage in Phase 10
      notifyListeners();
    }
  }

  /// Load last session from storage
  Future<void> loadLastSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from local storage in Phase 10
      await Future.delayed(const Duration(milliseconds: 500));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resume last session
  void resumeLastSession() {
    if (_lastSession != null) {
      _currentSession = _lastSession!.copyWith(
        lastAccessedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  /// End current session
  void endSession() {
    _currentSession = null;
    notifyListeners();
  }
}
