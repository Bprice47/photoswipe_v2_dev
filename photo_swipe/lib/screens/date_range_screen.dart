import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/date_picker_button.dart';

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

  /// Show date picker dialog
  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (_startDate ?? DateTime.now()) 
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentPrimary,
              onPrimary: AppTheme.textPrimary,
              surface: AppTheme.backgroundCard,
              onSurface: AppTheme.textPrimary,
            ),
            dialogBackgroundColor: AppTheme.backgroundCard,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
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
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Filter by Date',
                style: AppTheme.h2,
              ),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              // Instructions
              Text(
                'You can choose:',
                style: AppTheme.body,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _buildInstruction('Start date only (from that date onward)'),
              _buildInstruction('End date only (up to that date)'),
              _buildInstruction('Both start and end (between the two)'),
              
              const SizedBox(height: AppTheme.spacingXl),
              
              // Start Date Button
              DatePickerButton(
                label: 'Start Date',
                date: _startDate,
                onTap: () => _selectDate(true),
              ),
              
              const SizedBox(height: AppTheme.spacingMd),
              
              // End Date Button
              DatePickerButton(
                label: 'End Date',
                date: _endDate,
                onTap: () => _selectDate(false),
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

  /// Build instruction bullet point
  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppTheme.spacingSm,
        bottom: AppTheme.spacingXs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              text,
              style: AppTheme.caption,
            ),
          ),
        ],
      ),
    );
  }
}
