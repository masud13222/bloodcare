import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BloodTypeSelectorWidget extends StatelessWidget {
  final String selectedBloodType;
  final Function(String) onChanged;

  const BloodTypeSelectorWidget({
    Key? key,
    required this.selectedBloodType,
    required this.onChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> bloodTypes = const [
    {"bengali": "এ+", "english": "A+"},
    {"bengali": "এ-", "english": "A-"},
    {"bengali": "বি+", "english": "B+"},
    {"bengali": "বি-", "english": "B-"},
    {"bengali": "এবি+", "english": "AB+"},
    {"bengali": "এবি-", "english": "AB-"},
    {"bengali": "ও+", "english": "O+"},
    {"bengali": "ও-", "english": "O-"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রক্তের গ্রুপ *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 2.w,
            childAspectRatio: 1.2,
          ),
          itemCount: bloodTypes.length,
          itemBuilder: (context, index) {
            final bloodType = bloodTypes[index];
            final isSelected = selectedBloodType == bloodType["english"];

            return GestureDetector(
              onTap: () => onChanged(bloodType["english"] as String),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'water_drop',
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      bloodType["bengali"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      bloodType["english"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppTheme.getTextSecondary(true),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (selectedBloodType.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'রক্তের গ্রুপ নির্বাচন করুন',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
