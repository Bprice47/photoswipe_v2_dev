import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  bool get hasLastSession => _lastSession != null && !_lastSession!.isComplete;

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
    _saveSession();
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
      _saveSession();
    }
  }

  /// Increment reviewed count
  void incrementReviewed() {
    if (_currentSession != null) {
      updateProgress(reviewed: _currentSession!.reviewedCount + 1);
    }
  }

  /// Increment deleted count
  void incrementDeleted() {
    if (_currentSession != null) {
      updateProgress(deleted: _currentSession!.deletedCount + 1);
    }
  }

  /// Save current session to storage
  Future<void> _saveSession() async {
    if (_currentSession == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_currentSession!.toJson());
      await prefs.setString(AppConstants.keyLastSessionId, jsonString);
      _lastSession = _currentSession;
      debugPrint('Session saved: ${_currentSession!.id}');
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }

  /// Load last session from storage
  Future<void> loadLastSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(AppConstants.keyLastSessionId);

      if (jsonString != null && jsonString.isNotEmpty) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _lastSession = SessionModel.fromJson(json);
        debugPrint(
            'Session loaded: ${_lastSession!.id}, reviewed: ${_lastSession!.reviewedCount}/${_lastSession!.totalPhotos}');
      }
    } catch (e) {
      debugPrint('Error loading session: $e');
      _lastSession = null;
    } finally {
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

  /// Clear saved session
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyLastSessionId);
      _lastSession = null;
      _currentSession = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }
}
