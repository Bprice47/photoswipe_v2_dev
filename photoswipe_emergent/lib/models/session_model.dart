import '../config/constants.dart';

/// Model representing a review session
class SessionModel {
  final String id;
  final FilterType filterType;
  final DateTime? startDate;
  final DateTime? endDate;
  final int totalPhotos;
  final int reviewedCount;
  final int deletedCount;
  final DateTime createdAt;
  final DateTime lastAccessedAt;
  final List<String> reviewedPhotoIds;
  final List<String> dumpBoxIds;

  SessionModel({
    required this.id,
    required this.filterType,
    this.startDate,
    this.endDate,
    required this.totalPhotos,
    this.reviewedCount = 0,
    this.deletedCount = 0,
    required this.createdAt,
    required this.lastAccessedAt,
    this.reviewedPhotoIds = const [],
    this.dumpBoxIds = const [],
  });

  /// Get remaining photos count
  int get remainingCount => totalPhotos - reviewedCount;

  /// Get progress percentage
  double get progressPercentage => 
      totalPhotos > 0 ? reviewedCount / totalPhotos : 0.0;

  /// Check if session is complete
  bool get isComplete => reviewedCount >= totalPhotos;

  /// Create a copy with updated fields
  SessionModel copyWith({
    String? id,
    FilterType? filterType,
    DateTime? startDate,
    DateTime? endDate,
    int? totalPhotos,
    int? reviewedCount,
    int? deletedCount,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    List<String>? reviewedPhotoIds,
    List<String>? dumpBoxIds,
  }) {
    return SessionModel(
      id: id ?? this.id,
      filterType: filterType ?? this.filterType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPhotos: totalPhotos ?? this.totalPhotos,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      deletedCount: deletedCount ?? this.deletedCount,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      reviewedPhotoIds: reviewedPhotoIds ?? this.reviewedPhotoIds,
      dumpBoxIds: dumpBoxIds ?? this.dumpBoxIds,
    );
  }

  /// Get filter type display name
  String get filterDisplayName {
    switch (filterType) {
      case FilterType.mostRecent:
        return AppConstants.categoryMostRecent;
      case FilterType.allPhotos:
        return AppConstants.categoryAllPhotos;
      case FilterType.oldest:
        return AppConstants.categoryOldest;
      case FilterType.videos:
        return AppConstants.categoryVideos;
      case FilterType.dateRange:
        return AppConstants.categoryDateRange;
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filterType': filterType.index,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'totalPhotos': totalPhotos,
      'reviewedCount': reviewedCount,
      'deletedCount': deletedCount,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
      'reviewedPhotoIds': reviewedPhotoIds,
      'dumpBoxIds': dumpBoxIds,
    };
  }

  /// Create from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      filterType: FilterType.values[json['filterType'] as int],
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'] as String) 
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : null,
      totalPhotos: json['totalPhotos'] as int,
      reviewedCount: json['reviewedCount'] as int? ?? 0,
      deletedCount: json['deletedCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
      reviewedPhotoIds: List<String>.from(json['reviewedPhotoIds'] ?? []),
      dumpBoxIds: List<String>.from(json['dumpBoxIds'] ?? []),
    );
  }
}
