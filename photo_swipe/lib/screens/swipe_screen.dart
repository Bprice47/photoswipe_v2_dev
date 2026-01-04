import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../providers/photo_provider.dart';
import '../providers/dumpbox_provider.dart';
import '../widgets/dumpbox_badge.dart';

/// Screen 5: Swipe Screen - Main Photo Review Interface
/// The core Tinder-style swiping functionality
class SwipeScreen extends StatefulWidget {
  final Map<String, dynamic>? filterOptions;

  const SwipeScreen({super.key, this.filterOptions});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load photos based on filter options in Phase 6
  }

  @override
  Widget build(BuildContext context) {
    final dumpBoxProvider = Provider.of<DumpBoxProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundMain,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Open drawer/menu
          },
        ),
        title: Text(
          AppConstants.appName,
          style: AppTheme.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          // DumpBox Badge
          DumpBoxBadge(
            count: dumpBoxProvider.count,
            onTap: () => AppRoutes.navigateTo(context, AppRoutes.dumpbox),
          ),
          const SizedBox(width: AppTheme.spacingSm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // Card Area (Placeholder for now)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCard,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 80,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          'Swipe Screen',
                          style: AppTheme.h3.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          'Photo cards will appear here\n(Phase 7)',
                          style: AppTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Remaining Count
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMd,
                ),
                child: Text(
                  '0 remaining',
                  style: AppTheme.body,
                ),
              ),
              
              // Action Buttons
              Row(
                children: [
                  // Delete Button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement swipe left action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.deleteColor,
                          foregroundColor: AppTheme.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusPill,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back),
                            const SizedBox(width: AppTheme.spacingSm),
                            Text(
                              AppConstants.buttonDelete,
                              style: AppTheme.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: AppTheme.spacingMd),
                  
                  // Keep Button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement swipe right action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.keepColor,
                          foregroundColor: AppTheme.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusPill,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.buttonKeep,
                              style: AppTheme.button,
                            ),
                            const SizedBox(width: AppTheme.spacingSm),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}
