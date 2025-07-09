import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortOptionsWidget({
    Key? key,
    required this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  final List<Map<String, String>> sortOptions = const [
    {
      "value": "distance",
      "label": "দূরত্ব অনুযায়ী",
      "icon": "near_me",
    },
    {
      "value": "lastActive",
      "label": "সর্বশেষ সক্রিয়",
      "icon": "access_time",
    },
    {
      "value": "donationHistory",
      "label": "দানের ইতিহাস",
      "icon": "history",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  'সাজানোর বিকল্প',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
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

          // Sort Options
          ListView.builder(
            shrinkWrap: true,
            itemCount: sortOptions.length,
            itemBuilder: (context, index) {
              final option = sortOptions[index];
              final isSelected = currentSort == option["value"];

              return ListTile(
                leading: CustomIconWidget(
                  iconName: option["icon"]!,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                  size: 24,
                ),
                title: Text(
                  option["label"]!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      )
                    : null,
                onTap: () => onSortChanged(option["value"]!),
              );
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
