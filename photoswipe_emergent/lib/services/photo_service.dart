import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import '../models/photo_model.dart';
import '../config/constants.dart';

/// Service for loading and managing photos from the device gallery
class PhotoService {
  PhotoService._();
  static final PhotoService instance = PhotoService._();

  /// Cached list of asset paths (albums)
  List<AssetPathEntity> _albums = [];
  
  /// Get all albums
  List<AssetPathEntity> get albums => _albums;

  /// Load albums from device
  Future<List<AssetPathEntity>> loadAlbums() async {
    try {
      _albums = await PhotoManager.getAssetPathList(
        type: RequestType.common, // Both images and videos
        hasAll: true,
      );
      
      debugPrint('Loaded ${_albums.length} albums');
      return _albums;
    } catch (e) {
      debugPrint('Error loading albums: $e');
      return [];
    }
  }

  /// Get the "Recent" album (usually the first one)
  AssetPathEntity? getRecentAlbum() {
    if (_albums.isEmpty) return null;
    return _albums.first;
  }

  /// Load photos from an album with pagination
  /// 
  /// [album] - The album to load from
  /// [page] - Page number (0-indexed)
  /// [pageSize] - Number of photos per page
  /// [filterType] - How to filter/sort the photos
  Future<List<PhotoModel>> loadPhotos({
    required AssetPathEntity album,
    int page = 0,
    int pageSize = AppConstants.photosPerPage,
    FilterType filterType = FilterType.mostRecent,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Get assets from album
      final List<AssetEntity> assets = await album.getAssetListPaged(
        page: page,
        size: pageSize,
      );

      // Convert to PhotoModel and apply filters
      List<PhotoModel> photos = [];
      
      for (final asset in assets) {
        // Apply date filter if specified
        if (startDate != null && asset.createDateTime.isBefore(startDate)) {
          continue;
        }
        if (endDate != null && asset.createDateTime.isAfter(endDate)) {
          continue;
        }

        // Apply video filter if specified
        if (filterType == FilterType.videos && asset.type != AssetType.video) {
          continue;
        }

        // Load thumbnail
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(AppConstants.thumbnailSize, AppConstants.thumbnailSize),
          quality: 80,
        );

        photos.add(PhotoModel(
          id: asset.id,
          localPath: null, // Will load on demand
          createDate: asset.createDateTime,
          modifyDate: asset.modifiedDateTime,
          width: asset.width,
          height: asset.height,
          type: asset.type == AssetType.video ? PhotoType.video : PhotoType.image,
          duration: asset.type == AssetType.video ? asset.duration : null,
          thumbnail: thumbnail,
        ));
      }

      // Sort based on filter type
      if (filterType == FilterType.oldest) {
        photos.sort((a, b) => a.createDate.compareTo(b.createDate));
      } else {
        // Most recent (default)
        photos.sort((a, b) => b.createDate.compareTo(a.createDate));
      }

      debugPrint('Loaded ${photos.length} photos from page $page');
      return photos;
    } catch (e) {
      debugPrint('Error loading photos: $e');
      return [];
    }
  }

  /// Load a single photo's full resolution image
  Future<Uint8List?> loadFullImage(String assetId) async {
    try {
      final asset = await AssetEntity.fromId(assetId);
      if (asset == null) return null;

      final file = await asset.file;
      if (file == null) return null;

      return await file.readAsBytes();
    } catch (e) {
      debugPrint('Error loading full image: $e');
      return null;
    }
  }

  /// Load a high quality thumbnail for swipe view
  Future<Uint8List?> loadHighQualityThumbnail(String assetId) async {
    try {
      final asset = await AssetEntity.fromId(assetId);
      if (asset == null) return null;

      return await asset.thumbnailDataWithSize(
        const ThumbnailSize(
          AppConstants.highQualitySize,
          AppConstants.highQualitySize,
        ),
        quality: 90,
      );
    } catch (e) {
      debugPrint('Error loading HQ thumbnail: $e');
      return null;
    }
  }

  /// Delete photos by their IDs
  /// Returns list of IDs that were successfully deleted
  Future<List<String>> deletePhotos(List<String> photoIds) async {
    try {
      // PhotoManager.editor.deleteWithIds triggers the iOS system confirmation dialog
      final result = await PhotoManager.editor.deleteWithIds(photoIds);
      
      debugPrint('Deleted ${result.length} photos');
      return result;
    } catch (e) {
      debugPrint('Error deleting photos: $e');
      return [];
    }
  }

  /// Get total photo count from an album
  Future<int> getPhotoCount(AssetPathEntity album) async {
    return await album.assetCountAsync;
  }

  /// Get total count for specific filter
  Future<int> getFilteredCount({
    FilterType filterType = FilterType.mostRecent,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final recentAlbum = getRecentAlbum();
      if (recentAlbum == null) return 0;

      if (filterType == FilterType.videos) {
        // Get video-only album
        final videoAlbums = await PhotoManager.getAssetPathList(
          type: RequestType.video,
          hasAll: true,
        );
        if (videoAlbums.isNotEmpty) {
          return await videoAlbums.first.assetCountAsync;
        }
        return 0;
      }

      // For date filters, we'd need to count manually
      // For now, return total count
      return await recentAlbum.assetCountAsync;
    } catch (e) {
      debugPrint('Error getting filtered count: $e');
      return 0;
    }
  }
}
