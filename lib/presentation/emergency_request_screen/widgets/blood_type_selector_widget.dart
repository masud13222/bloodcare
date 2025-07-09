import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BloodTypeSelectorWidget extends StatelessWidget {
  final List<String> bloodTypes;
  final String? selectedBloodType;
  final Function(String) onBloodTypeSelected;

  const BloodTypeSelectorWidget({
    Key? key,
    required this.bloodTypes,
    required this.selectedBloodType,
    required this.onBloodTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: bloodTypes.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final bloodType = bloodTypes[index];
          final isSelected = selectedBloodType == bloodType;

          return GestureDetector(
            onTap: () => onBloodTypeSelected(bloodType),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  bloodType,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
