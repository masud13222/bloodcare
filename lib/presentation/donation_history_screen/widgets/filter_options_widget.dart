import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterOptionsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterApplied;
  final Map<String, dynamic> currentFilters;

  const FilterOptionsWidget({
    Key? key,
    required this.onFilterApplied,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  final List<String> _statusOptions = ['সব', 'সফল', 'বাতিল', 'পেন্ডিং'];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    if (_filters['dateRange'] != null) {
      _selectedDateRange = _filters['dateRange'] as DateTimeRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ফিল্টার অপশন',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  'সাফ করুন',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Date Range Filter
          _buildDateRangeFilter(),
          SizedBox(height: 3.h),

          // Blood Type Filter
          _buildBloodTypeFilter(),
          SizedBox(height: 3.h),

          // Status Filter
          _buildStatusFilter(),
          SizedBox(height: 4.h),

          // Apply and Cancel buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('বাতিল'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('প্রয়োগ করুন'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'তারিখ রেঞ্জ',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: _selectDateRange,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateRange != null
                      ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                      : 'তারিখ নির্বাচন করুন',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _selectedDateRange != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBloodTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রক্তের গ্রুপ',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: ['সব', ..._bloodTypes].map((bloodType) {
            final isSelected = _filters['bloodType'] == bloodType ||
                (_filters['bloodType'] == null && bloodType == 'সব');

            return FilterChip(
              label: Text(bloodType),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['bloodType'] =
                      selected && bloodType != 'সব' ? bloodType : null;
                });
              },
              selectedColor: AppTheme.lightTheme.primaryColor.withAlpha(51),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'অবস্থা',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _statusOptions.map((status) {
            final isSelected = _filters['status'] == status ||
                (_filters['status'] == null && status == 'সব');

            return FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['status'] =
                      selected && status != 'সব' ? status : null;
                });
              },
              selectedColor: AppTheme.lightTheme.primaryColor.withAlpha(51),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filters['dateRange'] = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onFilterApplied(_filters);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
