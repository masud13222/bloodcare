import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UrgencyLevelPickerWidget extends StatelessWidget {
  final List<String> urgencyLevels;
  final String selectedUrgency;
  final Function(String) onUrgencySelected;

  const UrgencyLevelPickerWidget({
    Key? key,
    required this.urgencyLevels,
    required this.selectedUrgency,
    required this.onUrgencySelected,
  }) : super(key: key);

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'অতি জরুরি':
        return AppTheme.lightTheme.colorScheme.error;
      case 'জরুরি':
        return AppTheme.getWarningColor(true);
      case 'সাধারণ':
        return AppTheme.getSuccessColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: urgencyLevels.map((urgency) {
        final isSelected = selectedUrgency == urgency;
        final urgencyColor = _getUrgencyColor(urgency);

        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: GestureDetector(
            onTap: () => onUrgencySelected(urgency),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? urgencyColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: isSelected
                      ? urgencyColor
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: urgencyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      urgency,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? urgencyColor
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isSelected)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: urgencyColor,
                      size: 5.w,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
