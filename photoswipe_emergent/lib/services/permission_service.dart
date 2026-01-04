import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Permission states for the app
enum PhotoPermissionState {
  /// Full access to all photos
  authorized,
  
  /// iOS 14+: User selected specific photos only
  limited,
  
  /// Permission denied - user must go to Settings
  denied,
  
  /// Permission not yet requested
  notDetermined,
  
  /// Restricted by parental controls or MDM
  restricted,
  
  /// Unknown state
  unknown,
}

/// Service for handling photo library permissions
/// Supports iOS 14+ granular permissions (Full vs Limited access)
class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  /// Current permission state
  PhotoPermissionState _currentState = PhotoPermissionState.notDetermined;
  PhotoPermissionState get currentState => _currentState;

  /// Check if we have any form of access (full or limited)
  bool get hasAccess => 
      _currentState == PhotoPermissionState.authorized ||
      _currentState == PhotoPermissionState.limited;

  /// Check if access is limited (iOS 14+)
  bool get isLimited => _currentState == PhotoPermissionState.limited;

  /// Check current permission status without requesting
  Future<PhotoPermissionState> checkPermission() async {
    try {
      final PermissionState state = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(
          iosAccessLevel: IosAccessLevel.readWrite,
        ),
      );
      
      _currentState = _mapPermissionState(state);
      return _currentState;
    } catch (e) {
      debugPrint('Error checking permission: $e');
      _currentState = PhotoPermissionState.unknown;
      return _currentState;
    }
  }

  /// Request photo library permission
  /// Returns the resulting permission state
  Future<PhotoPermissionState> requestPermission() async {
    try {
      // Request permission with read/write access
      final PermissionState state = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(
          iosAccessLevel: IosAccessLevel.readWrite,
        ),
      );
      
      _currentState = _mapPermissionState(state);
      
      debugPrint('Permission request result: $_currentState');
      return _currentState;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      _currentState = PhotoPermissionState.unknown;
      return _currentState;
    }
  }

  /// Map photo_manager PermissionState to our PhotoPermissionState
  PhotoPermissionState _mapPermissionState(PermissionState state) {
    switch (state) {
      case PermissionState.authorized:
        return PhotoPermissionState.authorized;
      case PermissionState.limited:
        return PhotoPermissionState.limited;
      case PermissionState.denied:
        return PhotoPermissionState.denied;
      case PermissionState.notDetermined:
        return PhotoPermissionState.notDetermined;
      case PermissionState.restricted:
        return PhotoPermissionState.restricted;
      default:
        return PhotoPermissionState.unknown;
    }
  }

  /// iOS 14+: Present the limited photo library picker
  /// Allows user to select additional photos or change to full access
  Future<void> presentLimitedPhotoPicker() async {
    if (Platform.isIOS) {
      try {
        await PhotoManager.presentLimited();
        // Re-check permission after picker closes
        await checkPermission();
      } catch (e) {
        debugPrint('Error presenting limited picker: $e');
      }
    }
  }

  /// Open app settings so user can change permissions
  Future<bool> openAppSettings() async {
    try {
      return await ph.openAppSettings();
    } catch (e) {
      debugPrint('Error opening settings: $e');
      return false;
    }
  }

  /// Get a human-readable description of current permission state
  String getStateDescription() {
    switch (_currentState) {
      case PhotoPermissionState.authorized:
        return 'Full access to photo library';
      case PhotoPermissionState.limited:
        return 'Limited access - only selected photos';
      case PhotoPermissionState.denied:
        return 'Access denied - please enable in Settings';
      case PhotoPermissionState.notDetermined:
        return 'Permission not yet requested';
      case PhotoPermissionState.restricted:
        return 'Access restricted by device policy';
      case PhotoPermissionState.unknown:
        return 'Unknown permission state';
    }
  }

  /// Check if this is the first time asking for permission
  Future<bool> isFirstTimeRequest() async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
      ),
    );
    return state == PermissionState.notDetermined;
  }
}
