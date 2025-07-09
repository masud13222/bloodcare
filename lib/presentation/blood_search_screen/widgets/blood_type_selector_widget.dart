import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BloodTypeSelectorWidget extends StatelessWidget {
  final String selectedBloodType;
  final Function(String) onBloodTypeSelected;

  const BloodTypeSelectorWidget({
    Key? key,
    required this.selectedBloodType,
    required this.onBloodTypeSelected,
  }) : super(key: key);

  final List<Map<String, String>> bloodTypes = const [
    {"type": "A+", "label": "এ পজিটিভ"},
    {"type": "A-", "label": "এ নেগেটিভ"},
    {"type": "B+", "label": "বি পজিটিভ"},
    {"type": "B-", "label": "বি নেগেটিভ"},
    {"type": "AB+", "label": "এবি পজিটিভ"},
    {"type": "AB-", "label": "এবি নেগেটিভ"},
    {"type": "O+", "label": "ও পজিটিভ"},
    {"type": "O-", "label": "ও নেগেটিভ"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রক্তের গ্রুপ নির্বাচন করুন',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 1.h,
            childAspectRatio: 1.2,
          ),
          itemCount: bloodTypes.length,
          itemBuilder: (context, index) {
            final bloodType = bloodTypes[index];
            final isSelected = selectedBloodType == bloodType["type"];

            return GestureDetector(
              onTap: () {
                onBloodTypeSelected(isSelected ? '' : bloodType["type"]!);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected)
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 16,
                      ),
                    if (isSelected) SizedBox(height: 0.5.h),
                    Text(
                      bloodType["type"]!,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      bloodType["label"]!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        fontSize: 8.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
