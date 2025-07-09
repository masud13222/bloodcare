import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserTypeToggleWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const UserTypeToggleWidget({
    Key? key,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ব্যবহারকারীর ধরন',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleOption(
                  title: 'রক্তদাতা',
                  subtitle: 'রক্ত দান করতে চাই',
                  icon: 'favorite',
                  value: 'রক্তদাতা',
                  isSelected: selectedType == 'রক্তদাতা',
                ),
              ),
              Container(
                width: 1,
                height: 8.h,
                color: AppTheme.lightTheme.dividerColor,
              ),
              Expanded(
                child: _buildToggleOption(
                  title: 'রক্ত গ্রহীতা',
                  subtitle: 'রক্ত প্রয়োজন',
                  icon: 'local_hospital',
                  value: 'রক্ত গ্রহীতা',
                  isSelected: selectedType == 'রক্ত গ্রহীতা',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required String icon,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.dividerColor,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isSelected
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getTextSecondary(true),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
