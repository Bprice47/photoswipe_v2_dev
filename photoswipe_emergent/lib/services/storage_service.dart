import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/session_model.dart';

/// Service for local storage operations
/// Handles session persistence, preferences, and DumpBox state
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;

  /// Initialize storage (call at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ============== TERMS ACCEPTANCE ==============

  /// Check if user has accepted terms
  Future<bool> hasAcceptedTerms() async {
    final p = await prefs;
    return p.getBool(AppConstants.keyHasAcceptedTerms) ?? false;
  }

  /// Save terms acceptance
  Future<void> setTermsAccepted(bool accepted) async {
    final p = await prefs;
    await p.setBool(AppConstants.keyHasAcceptedTerms, accepted);
  }

  // ============== PERMISSION STATE ==============

  /// Check if permission has been granted before
  Future<bool> hasGrantedPermission() async {
    final p = await prefs;
    return p.getBool(AppConstants.keyHasGrantedPermission) ?? false;
  }

  /// Save permission granted state
  Future<void> setPermissionGranted(bool granted) async {
    final p = await prefs;
    await p.setBool(AppConstants.keyHasGrantedPermission, granted);
  }

  // ============== SESSION MANAGEMENT ==============

  /// Save current session
  Future<void> saveSession(SessionModel session) async {
    final p = await prefs;
    final jsonString = jsonEncode(session.toJson());
    await p.setString(AppConstants.keyLastSessionId, jsonString);
    debugPrint('Session saved: ${session.id}');
  }

  /// Load last session
  Future<SessionModel?> loadLastSession() async {
    try {
      final p = await prefs;
      final jsonString = p.getString(AppConstants.keyLastSessionId);
      
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SessionModel.fromJson(json);
    } catch (e) {
      debugPrint('Error loading session: $e');
      return null;
    }
  }

  /// Clear last session
  Future<void> clearSession() async {
    final p = await prefs;
    await p.remove(AppConstants.keyLastSessionId);
  }

  // ============== DUMPBOX ==============

  /// Save DumpBox photo IDs
  Future<void> saveDumpBoxIds(List<String> ids) async {
    final p = await prefs;
    await p.setStringList(AppConstants.keyDumpBoxIds, ids);
  }

  /// Load DumpBox photo IDs
  Future<List<String>> loadDumpBoxIds() async {
    final p = await prefs;
    return p.getStringList(AppConstants.keyDumpBoxIds) ?? [];
  }

  /// Clear DumpBox
  Future<void> clearDumpBox() async {
    final p = await prefs;
    await p.remove(AppConstants.keyDumpBoxIds);
  }

  /// Add photo ID to DumpBox
  Future<void> addToDumpBox(String photoId) async {
    final ids = await loadDumpBoxIds();
    if (!ids.contains(photoId)) {
      ids.add(photoId);
      await saveDumpBoxIds(ids);
    }
  }

  /// Remove photo ID from DumpBox
  Future<void> removeFromDumpBox(String photoId) async {
    final ids = await loadDumpBoxIds();
    ids.remove(photoId);
    await saveDumpBoxIds(ids);
  }

  // ============== CLEAR ALL ==============

  /// Clear all stored data (for testing/reset)
  Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }
}
