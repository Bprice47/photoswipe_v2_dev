import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../providers/dumpbox_provider.dart';
import '../models/photo_model.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_checkbox.dart';

/// DumpBox Screen - Review photos before deletion
class DumpBoxScreen extends StatefulWidget {
  const DumpBoxScreen({super.key});

  @override
  State<DumpBoxScreen> createState() => _DumpBoxScreenState();
}

class _DumpBoxScreenState extends State<DumpBoxScreen> {
  bool _isDeleting = false;

  Future<void> _deleteSelectedPhotos(DumpBoxProvider dumpBox) async {
    if (dumpBox.selectedCount == 0) return;

    setState(() => _isDeleting = true);

    try {
      final selectedPhotos = dumpBox.getSelectedPhotos();
      final photoIds = selectedPhotos.map((p) => p.id).toList();
      final deletedIds = await PhotoManager.editor.deleteWithIds(photoIds);

      for (final id in deletedIds) {
        dumpBox.removePhoto(id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${deletedIds.length} photos deleted'),
            backgroundColor: AppTheme.keepColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting photos: $e'),
            backgroundColor: AppTheme.deleteColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  void _showPhotoViewer(
      BuildContext context, PhotoModel photo, DumpBoxProvider dumpBox) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _PhotoViewerDialog(
        photo: photo,
        onDelete: () {
          Navigator.pop(context);
          dumpBox.removePhoto(photo.id);
          // Actually delete from device
          PhotoManager.editor.deleteWithIds([photo.id]);
        },
        onKeep: () {
          Navigator.pop(context);
          dumpBox.removePhoto(photo.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DumpBoxProvider>(
      builder: (context, dumpBox, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundMain,
          appBar: AppBar(
            backgroundColor: AppTheme.backgroundMain,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => AppRoutes.goBack(context),
            ),
            title: Text(
              'DumpBox (${dumpBox.count})',
              style: AppTheme.h3,
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: dumpBox.hasPhotos ? dumpBox.restoreAll : null,
                child: Text(
                  AppConstants.buttonRestoreAll,
                  style: AppTheme.button.copyWith(
                    color: dumpBox.hasPhotos
                        ? AppTheme.accentSecondary
                        : AppTheme.textDisabled,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Hint text
                if (dumpBox.hasPhotos)
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingSm),
                    child: Text(
                      'Tap photo to view full size',
                      style: AppTheme.caption,
                    ),
                  ),

                // Photo Grid
                Expanded(
                  child: dumpBox.hasPhotos
                      ? _buildPhotoGrid(context, dumpBox)
                      : _buildEmptyState(),
                ),

                // Bottom Actions
                if (dumpBox.hasPhotos) _buildBottomActions(context, dumpBox),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoGrid(BuildContext context, DumpBoxProvider dumpBox) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppTheme.spacingSm,
        mainAxisSpacing: AppTheme.spacingSm,
        childAspectRatio: 1,
      ),
      itemCount: dumpBox.photos.length,
      itemBuilder: (context, index) {
        final photo = dumpBox.photos[index];
        final isSelected = dumpBox.selectedIds.contains(photo.id);

        return GestureDetector(
          onTap: () => _showPhotoViewer(context, photo, dumpBox),
          onLongPress: () => dumpBox.toggleSelection(photo.id),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color:
                    isSelected ? AppTheme.selectedBorder : Colors.transparent,
                width: 3,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Photo
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCardAlt,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusSmall - 2),
                  ),
                  child: photo.thumbnail != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSmall - 2),
                          child: Image.memory(
                            photo.thumbnail!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image,
                          color: AppTheme.textMuted, size: 40),
                ),

                // Selection checkbox
                Positioned(
                  top: AppTheme.spacingXs,
                  right: AppTheme.spacingXs,
                  child: GestureDetector(
                    onTap: () => dumpBox.toggleSelection(photo.id),
                    child: CircularCheckbox(
                      value: isSelected,
                      onChanged: (_) => dumpBox.toggleSelection(photo.id),
                      size: 24,
                    ),
                  ),
                ),

                // Video indicator
                if (photo.isVideo)
                  Positioned(
                    bottom: AppTheme.spacingXs,
                    left: AppTheme.spacingXs,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.videocam,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            photo.formattedDuration,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 80, color: AppTheme.textMuted),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            AppConstants.emptyDumpBoxTitle,
            style: AppTheme.h3.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            child: Text(
              AppConstants.emptyDumpBoxMessage,
              style: AppTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, DumpBoxProvider dumpBox) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundMain,
        border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Select/Clear Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: dumpBox.selectedCount > 0
                  ? dumpBox.clearSelection
                  : dumpBox.selectAll,
              icon: Icon(
                  dumpBox.selectedCount > 0 ? Icons.deselect : Icons.select_all,
                  size: 20),
              label: Text(dumpBox.selectedCount > 0
                  ? AppConstants.buttonClearSelection
                  : 'Select All'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: const BorderSide(color: AppTheme.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Delete and Keep Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: (dumpBox.selectedCount > 0 && !_isDeleting)
                        ? () => _showDeleteConfirmation(context, dumpBox)
                        : null,
                    icon: _isDeleting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppTheme.textPrimary),
                          )
                        : const Icon(Icons.delete_outline, size: 20),
                    label: Text(
                        '${AppConstants.buttonDelete} (${dumpBox.selectedCount})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dumpBox.selectedCount > 0
                          ? AppTheme.deleteColorDark
                          : AppTheme.backgroundCardAlt,
                      foregroundColor: AppTheme.textPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusPill)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed:
                        dumpBox.selectedCount > 0 ? dumpBox.keepSelected : null,
                    icon: const Icon(Icons.download, size: 20),
                    label: Text(
                        '${AppConstants.buttonKeep} (${dumpBox.selectedCount})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dumpBox.selectedCount > 0
                          ? AppTheme.keepColorDark
                          : AppTheme.backgroundCardAlt,
                      foregroundColor: AppTheme.textPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusPill)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, DumpBoxProvider dumpBox) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete ${dumpBox.selectedCount} photos?',
        message: AppConstants.deleteConfirmMessage,
        note: AppConstants.deleteConfirmNote,
        cancelText: AppConstants.buttonCancel,
        confirmText: AppConstants.buttonDelete,
        confirmColor: AppTheme.deleteColor,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          _deleteSelectedPhotos(dumpBox);
        },
      ),
    );
  }
}

/// Full-screen photo viewer dialog
class _PhotoViewerDialog extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback onDelete;
  final VoidCallback onKeep;

  const _PhotoViewerDialog({
    required this.photo,
    required this.onDelete,
    required this.onKeep,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Photo
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                child: photo.thumbnail != null
                    ? Image.memory(
                        photo.thumbnail!,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        color: AppTheme.backgroundCard,
                        child: const Icon(Icons.image,
                            size: 100, color: AppTheme.textMuted),
                      ),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Delete button
              ElevatedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.deleteColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
              ),

              const SizedBox(width: AppTheme.spacingLg),

              // Keep button
              ElevatedButton.icon(
                onPressed: onKeep,
                icon: const Icon(Icons.favorite),
                label: const Text('Keep'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.keepColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }
}
