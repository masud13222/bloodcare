import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UnitsStepperWidget extends StatelessWidget {
  final int unitsNeeded;
  final Function(int) onUnitsChanged;

  const UnitsStepperWidget({
    Key? key,
    required this.unitsNeeded,
    required this.onUnitsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'রক্তের ব্যাগ সংখ্যা:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: unitsNeeded > 1
                    ? () => onUnitsChanged(unitsNeeded - 1)
                    : null,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: unitsNeeded > 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'remove',
                      color: unitsNeeded > 1
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                width: 15.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$unitsNeeded',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: unitsNeeded < 10
                    ? () => onUnitsChanged(unitsNeeded + 1)
                    : null,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: unitsNeeded < 10
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: unitsNeeded < 10
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 5.w,
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
}
