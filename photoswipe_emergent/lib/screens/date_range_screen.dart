import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';

/// Screen 4: Date Range Screen
/// Allow user to filter photos by date range
class DateRangeScreen extends StatefulWidget {
  const DateRangeScreen({super.key});

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _oldestPhotoDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOldestPhotoDate();
  }

  /// Load the oldest photo date from the library
  Future<void> _loadOldestPhotoDate() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          orders: [OrderOption(type: OrderOptionType.createDate, asc: true)],
        ),
      );

      if (albums.isNotEmpty) {
        final oldestAlbum = albums.first;
        final assets = await oldestAlbum.getAssetListRange(start: 0, end: 1);
        if (assets.isNotEmpty) {
          setState(() {
            _oldestPhotoDate = assets.first.createDateTime;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading oldest photo: $e');
    }
    
    setState(() {
      _oldestPhotoDate = DateTime(2000);
      _isLoading = false;
    });
  }

  /// Show iOS-style wheel date picker
  void _selectDate(bool isStartDate) {
    DateTime initialDate;
    
    if (isStartDate) {
      // Start date defaults to oldest photo in library
      initialDate = _startDate ?? _oldestPhotoDate ?? DateTime(2000);
    } else {
      // End date defaults to the selected start date (so user scrolls forward)
      initialDate = _endDate ?? _startDate ?? DateTime.now();
    }

    // Make sure initialDate is within bounds
    if (initialDate.isBefore(DateTime(2000))) {
      initialDate = DateTime(2000);
    }
    if (initialDate.isAfter(DateTime.now())) {
      initialDate = DateTime.now();
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        DateTime tempDate = initialDate;
        return Container(
          height: 300,
          color: AppTheme.backgroundCard,
          child: Column(
            children: [
              // Header with Done button
              Container(
                height: 50,
                color: AppTheme.backgroundCardAlt,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      isStartDate ? 'Start Date' : 'End Date',
                      style: AppTheme.h3,
                    ),
                    CupertinoButton(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: AppTheme.accentPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isStartDate) {
                            _startDate = tempDate;
                            // Reset end date if it's before new start date
                            if (_endDate != null && _endDate!.isBefore(tempDate)) {
                              _endDate = null;
                            }
                          } else {
                            _endDate = tempDate;
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              // Date Picker Wheel
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Navigate to swipe screen with date filter
  void _startReview() {
    AppRoutes.navigateTo(
      context,
      AppRoutes.swipe,
      arguments: {
        'filterType': FilterType.dateRange,
        'startDate': _startDate,
        'endDate': _endDate,
      },
    );
  }

  /// Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Tap to select';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundMain,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.goBack(context),
        ),
        title: Text(
          'Select Date Range',
          style: AppTheme.headerTitle,
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Filter by Date',
                      style: AppTheme.h2,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingSm),
                    
                    // Subtitle with oldest photo info
                    Text(
                      _oldestPhotoDate != null 
                          ? 'Oldest photo: ${DateFormat('MMM d, yyyy').format(_oldestPhotoDate!)}'
                          : 'Photos will show oldest to newest',
                      style: AppTheme.caption,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXl),
                    
                    // Start Date Button
                    _buildDateButton(
                      label: 'Start Date',
                      hint: 'Starts at oldest photo',
                      date: _startDate,
                      onTap: () => _selectDate(true),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingMd),
                    
                    // End Date Button
                    _buildDateButton(
                      label: 'End Date',
                      hint: _startDate != null 
                          ? 'Starts at ${DateFormat('MMM d, yyyy').format(_startDate!)}'
                          : 'Select start date first',
                      date: _endDate,
                      onTap: () => _selectDate(false),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingMd),
                    
                    // Clear dates button
                    if (_startDate != null || _endDate != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _startDate = null;
                            _endDate = null;
                          });
                        },
                        child: Text(
                          'Clear Dates',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Start Review Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _startReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPrimary,
                          foregroundColor: AppTheme.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppConstants.buttonStartReview,
                          style: AppTheme.button,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingLg),
                  ],
                ),
              ),
      ),
    );
  }

  /// Build a date picker button
  Widget _buildDateButton({
    required String label,
    required String hint,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: date != null 
                ? AppTheme.accentPrimary.withOpacity(0.5)
                : AppTheme.textMuted.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: date != null ? AppTheme.accentPrimary : AppTheme.textMuted,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null ? _formatDate(date) : hint,
                    style: date != null ? AppTheme.body : AppTheme.bodySecondary,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
