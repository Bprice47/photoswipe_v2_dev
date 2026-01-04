import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../providers/dumpbox_provider.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_checkbox.dart';

/// Screen 6 & 7: DumpBox Screen
/// Review photos marked for deletion before permanent removal
class DumpBoxScreen extends StatelessWidget {
  const DumpBoxScreen({super.key});

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

  /// Build the photo grid
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
          onTap: () => dumpBox.toggleSelection(photo.id),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: isSelected
                    ? AppTheme.selectedBorder
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Photo placeholder
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCardAlt,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall - 2),
                  ),
                  child: photo.thumbnail != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall - 2,
                          ),
                          child: Image.memory(
                            photo.thumbnail!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.image,
                          color: AppTheme.textMuted,
                          size: 40,
                        ),
                ),
                
                // Selection checkbox
                Positioned(
                  top: AppTheme.spacingXs,
                  right: AppTheme.spacingXs,
                  child: CircularCheckbox(
                    value: isSelected,
                    onChanged: (_) => dumpBox.toggleSelection(photo.id),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            AppConstants.emptyDumpBoxTitle,
            style: AppTheme.h3.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingXl,
            ),
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

  /// Build bottom action buttons
  Widget _buildBottomActions(BuildContext context, DumpBoxProvider dumpBox) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMain,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Clear Selection Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: dumpBox.selectedCount > 0
                  ? dumpBox.clearSelection
                  : dumpBox.selectAll,
              icon: Icon(
                dumpBox.selectedCount > 0
                    ? Icons.deselect
                    : Icons.select_all,
                size: 20,
              ),
              label: Text(
                dumpBox.selectedCount > 0
                    ? AppConstants.buttonClearSelection
                    : 'Select All',
              ),
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
              // Delete Selected
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: dumpBox.selectedCount > 0
                        ? () => _showDeleteConfirmation(context, dumpBox)
                        : null,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(
                      '${AppConstants.buttonDelete} (${dumpBox.selectedCount})',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dumpBox.selectedCount > 0
                          ? AppTheme.deleteColorDark
                          : AppTheme.backgroundCardAlt,
                      foregroundColor: AppTheme.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingMd),
              
              // Keep Selected
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: dumpBox.selectedCount > 0
                        ? dumpBox.keepSelected
                        : null,
                    icon: const Icon(Icons.download, size: 20),
                    label: Text(
                      '${AppConstants.buttonKeep} (${dumpBox.selectedCount})',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dumpBox.selectedCount > 0
                          ? AppTheme.keepColorDark
                          : AppTheme.backgroundCardAlt,
                      foregroundColor: AppTheme.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      ),
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

  /// Show delete confirmation dialog
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
          // TODO: Implement actual photo deletion in Phase 9
          dumpBox.removeSelected();
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dumpBox.selectedCount} photos deleted'),
              backgroundColor: AppTheme.backgroundCardAlt,
            ),
          );
        },
      ),
    );
  }
}
