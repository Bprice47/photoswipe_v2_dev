import 'dart:typed_data';

/// Model representing a photo from the device gallery
class PhotoModel {
  final String id;
  final String? localPath;
  final DateTime createDate;
  final DateTime modifyDate;
  final int width;
  final int height;
  final PhotoType type;
  final int? duration; // For videos, in seconds
  Uint8List? thumbnail;
  Uint8List? fullImage;
  
  // UI State
  bool isSelected;
  bool isInDumpBox;

  PhotoModel({
    required this.id,
    this.localPath,
    required this.createDate,
    required this.modifyDate,
    this.width = 0,
    this.height = 0,
    this.type = PhotoType.image,
    this.duration,
    this.thumbnail,
    this.fullImage,
    this.isSelected = false,
    this.isInDumpBox = false,
  });

  /// Create a copy with updated fields
  PhotoModel copyWith({
    String? id,
    String? localPath,
    DateTime? createDate,
    DateTime? modifyDate,
    int? width,
    int? height,
    PhotoType? type,
    int? duration,
    Uint8List? thumbnail,
    Uint8List? fullImage,
    bool? isSelected,
    bool? isInDumpBox,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      createDate: createDate ?? this.createDate,
      modifyDate: modifyDate ?? this.modifyDate,
      width: width ?? this.width,
      height: height ?? this.height,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      thumbnail: thumbnail ?? this.thumbnail,
      fullImage: fullImage ?? this.fullImage,
      isSelected: isSelected ?? this.isSelected,
      isInDumpBox: isInDumpBox ?? this.isInDumpBox,
    );
  }

  /// Get aspect ratio
  double get aspectRatio => height > 0 ? width / height : 1.0;

  /// Check if this is a video
  bool get isVideo => type == PhotoType.video;

  /// Get formatted duration string (for videos)
  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Type of media asset
enum PhotoType {
  image,
  video,
}
