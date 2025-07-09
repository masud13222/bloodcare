import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  String availabilityFilter = 'all';
  String lastDonationFilter = 'all';
  double distanceRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'উন্নত ফিল্টার',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Availability Filter
                  _buildFilterSection(
                    title: 'উপলব্ধতার অবস্থা',
                    child: Column(
                      children: [
                        _buildRadioOption(
                          title: 'সকল দাতা',
                          value: 'all',
                          groupValue: availabilityFilter,
                          onChanged: (value) {
                            setState(() {
                              availabilityFilter = value!;
                            });
                          },
                        ),
                        _buildRadioOption(
                          title: 'শুধু উপলব্ধ',
                          value: 'available',
                          groupValue: availabilityFilter,
                          onChanged: (value) {
                            setState(() {
                              availabilityFilter = value!;
                            });
                          },
                        ),
                        _buildRadioOption(
                          title: 'শুধু অনুপলব্ধ',
                          value: 'unavailable',
                          groupValue: availabilityFilter,
                          onChanged: (value) {
                            setState(() {
                              availabilityFilter = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Last Donation Filter
                  _buildFilterSection(
                    title: 'শেষ রক্তদানের সময়',
                    child: Column(
                      children: [
                        _buildRadioOption(
                          title: 'সকল দাতা',
                          value: 'all',
                          groupValue: lastDonationFilter,
                          onChanged: (value) {
                            setState(() {
                              lastDonationFilter = value!;
                            });
                          },
                        ),
                        _buildRadioOption(
                          title: 'গত ৩ মাসে',
                          value: '3months',
                          groupValue: lastDonationFilter,
                          onChanged: (value) {
                            setState(() {
                              lastDonationFilter = value!;
                            });
                          },
                        ),
                        _buildRadioOption(
                          title: 'গত ৬ মাসে',
                          value: '6months',
                          groupValue: lastDonationFilter,
                          onChanged: (value) {
                            setState(() {
                              lastDonationFilter = value!;
                            });
                          },
                        ),
                        _buildRadioOption(
                          title: '১ বছরের বেশি',
                          value: '1year',
                          groupValue: lastDonationFilter,
                          onChanged: (value) {
                            setState(() {
                              lastDonationFilter = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Distance Filter
                  _buildFilterSection(
                    title: 'দূরত্বের পরিসর',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '১ কিমি',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            Text(
                              '${distanceRadius.toInt()} কিমি',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '৫০ কিমি',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Slider(
                          value: distanceRadius,
                          min: 1.0,
                          max: 50.0,
                          divisions: 49,
                          onChanged: (value) {
                            setState(() {
                              distanceRadius = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        availabilityFilter = 'all';
                        lastDonationFilter = 'all';
                        distanceRadius = 10.0;
                      });
                    },
                    child: Text('রিসেট'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters({
                        'availability': availabilityFilter,
                        'lastDonation': lastDonationFilter,
                        'distance': distanceRadius,
                      });
                    },
                    child: Text('প্রয়োগ করুন'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
